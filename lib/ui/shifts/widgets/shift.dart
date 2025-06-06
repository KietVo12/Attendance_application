import 'package:flutter/material.dart';
import 'package:play_ground_app/ui/shifts/view_models/shifts_view_model.dart';

class ShiftsWidget extends StatelessWidget {
  const ShiftsWidget({super.key, required ShiftViewModel shiftViewModel}) : _shiftViewModel = shiftViewModel;
  
  final ShiftViewModel _shiftViewModel;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh Sách Lớp Học"),
      ),
      body: Column(
        children: [
          ListenableBuilder(
            listenable: _shiftViewModel, 
            builder: (context, child) {
              if(_shiftViewModel.onError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Có lỗi trong quá trình truy vẫn dữ liệu", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    action: SnackBarAction(
                      label: "Show Error", 
                      onPressed: () {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Text("Error"),
                            content: Text(_shiftViewModel.exception.toString(), style: TextStyle(color: Colors.red)),
                          );
                        },
                        barrierDismissible: true,
                        );
                      }
                    )
                  )
                );
              }
              return Text("");
            }
          ),
          FutureBuilder(
            future: _shiftViewModel.shifts, 
            builder: (context, snapshot) {
              if(snapshot.hasData && snapshot.data != null) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text("Ca")),
                        DataColumn(label: Text("Thời gian")),
                      ],
                      rows: snapshot.data!.map((shift) {
                        return DataRow(
                          cells: [
                            DataCell(Text(shift.name)),
                            DataCell(Text("${shift.startTo} Đến ${shift.endAt}"))
                          ]
                        );
                      }).toList()
                    ),
                  )
                );
              }
              return CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }
  
}