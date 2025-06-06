import 'package:flutter/material.dart';
import 'package:play_ground_app/data/models/shift.dart';
import 'package:play_ground_app/injection_container.dart';
import 'package:play_ground_app/ui/shifts/view_models/shifts_view_model.dart';
import 'package:play_ground_app/utils/success_dialog.dart';
import 'package:time_range_picker/time_range_picker.dart';

class ShiftCreateFormWidget extends StatefulWidget {
  const ShiftCreateFormWidget({super.key});

  @override
  State<ShiftCreateFormWidget> createState() => _ShiftCreateFormWidgetState();
}

class _ShiftCreateFormWidgetState extends State<ShiftCreateFormWidget> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  final TextEditingController _shiftNameEditingController = TextEditingController();
  final TextEditingController _startToEndEditingController = TextEditingController();
  final ShiftViewModel _shiftViewModel = locator<ShiftViewModel>();

  Future<void> _showTimePicker() async {
    TimeRange timeRange = await showTimeRangePicker(context: context);

    setState(() {
      _startToEndEditingController.text = "${timeRange.startTime.hour}:${timeRange.startTime.minute == 0 ? "00" : timeRange.startTime.minute}-${timeRange.endTime.hour}:${timeRange.endTime.minute == 0 ? "00" : timeRange.endTime.minute}";
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tạo Ca Dạy"),
      ),
      body: Column(
        children: [
          Form(
            key: _formState,
            child: Column(
              children: [
                TextFormField(
                  controller: _shiftNameEditingController,
                  decoration: InputDecoration(
                    labelText: "Tên Ca",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _startToEndEditingController,
                    decoration: InputDecoration(
                      labelText: "Thời gian bắt đầu và kết thúc",
                      prefixIcon: Icon(Icons.access_time),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)
                      )
                    ),
                    onTap: _showTimePicker,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String shiftName = _shiftNameEditingController.text;
                    List<String> shiftTimeRange = _startToEndEditingController.text.split("-");
                    String startTo = shiftTimeRange[0];
                    String endAt = shiftTimeRange[1];
                    Shift shift = Shift.create(shiftName, startTo, endAt);
                    await _shiftViewModel.submit(shift);
                    if(_shiftViewModel.success) {
                      showAnimatedSuccessDialog(context);
                    }
                    if(_shiftViewModel.onError) {
                      showAnimatedFailureDialog(context, _shiftViewModel.exception.toString());
                    }
                  }, 
                  child: Text("Tạo Mới")
                ),
              ],
            )
          )
        ],
      )
    );
  }
}