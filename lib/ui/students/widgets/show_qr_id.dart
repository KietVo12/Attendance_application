import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StudentQrId extends StatelessWidget {
  const StudentQrId({super.key, required this.studentId});
  final String studentId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        children: [
          Center(child: Text("Mã Điểm Danh", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),),
          Center(
            child: QrImageView(
              data: studentId,
              version: QrVersions.auto,
              size: 200,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: false).pop();
            },
            child: Text("Tiếp Tục Đăng Kí")
            ),

        ],
      )
    );
  }
  
}