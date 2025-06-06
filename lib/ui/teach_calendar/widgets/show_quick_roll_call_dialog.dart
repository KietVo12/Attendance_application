import 'package:flutter/material.dart';
import 'package:play_ground_app/ui/roll_call/widgets/roll_call_qr_scanner.dart';

Future<void> showQuickRollCallDialog(BuildContext context, String teachCalendarId) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: Text("Lịch Dạy Thành Công"),
        content: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RollCallQRScanner(teachCalendarId: teachCalendarId,)));
          }, 
          child: Text("Điểm Danh Nhanh Ngay Tại Đây")
        ),
      );
    }
  );
}