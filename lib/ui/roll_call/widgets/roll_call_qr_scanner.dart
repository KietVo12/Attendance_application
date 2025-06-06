import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:play_ground_app/data/models/roll_call.dart';
import 'package:play_ground_app/injection_container.dart';
import 'package:play_ground_app/ui/roll_call/view_models/roll_call_view_model.dart';

class RollCallQRScanner extends StatefulWidget {
  RollCallQRScanner({super.key, String? teachCalendarId}) : _teachCalendarId = teachCalendarId;

  final String? _teachCalendarId;
  final RollCallViewModel _teachViewModel = locator<RollCallViewModel>();

  @override
  RollCallQRScannerState createState() => RollCallQRScannerState();
}

class RollCallQRScannerState extends State<RollCallQRScanner>{
  MobileScannerController cameraController = MobileScannerController(
    detectionTimeoutMs: 400
  );

  Set<String> scanned = {};
  void showSuccessfullSnackBar(String codeScanned) {
    final snackBar = SnackBar(
      content: Text("Điểm Danh Thành Công", style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void showUnsuccessfullSnackBar(String error) {
    final snackBar = SnackBar(
      content: Text("Điểm Danh Thất Bại: $error", style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  final AudioPlayer player = AudioPlayer();
  Future<void> emitSound() async {
    String path = "audio/confirmation_sound.mp3";
    await player.play(AssetSource(path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Scan Mã Điểm Danh'),
          actions: [
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state) {
                    case TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors.grey);
                    case TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.yellow);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.toggleTorch(),
            ),
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.cameraFacingState,
                builder: (context, state, child) {
                  switch (state) {
                    case CameraFacing.front:
                      return const Icon(Icons.camera_front);
                    case CameraFacing.back:
                      return const Icon(Icons.camera_rear);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.switchCamera(),
            ),
          ],
        ),
        body: MobileScanner(
          // fit: BoxFit.contain,
          controller: cameraController,
          onDetect: (capture) async {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              if(barcode.rawValue != null && !scanned.contains(barcode.rawValue)) {
                scanned.add(barcode.rawValue!); 
                RollCall rollCall = RollCall.create(widget._teachCalendarId, barcode.rawValue);
                await widget._teachViewModel.submit(rollCall);
                if(widget._teachViewModel.success == true) {
                  showSuccessfullSnackBar(barcode.rawValue!);
                  emitSound();
                }
                else {
                  showUnsuccessfullSnackBar(widget._teachViewModel.exception.toString());
                }
              }
            }
          },
        ),
    );
  }  
}
