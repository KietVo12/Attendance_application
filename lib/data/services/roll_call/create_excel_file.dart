import 'dart:io';
import 'package:play_ground_app/data/models/student.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class CreateExcelFile {
  static Future<void> createExcelFile(List<Student> students, String title) async {
    final Workbook workbook = Workbook();
    final Worksheet worksheet = workbook.worksheets[0];
    worksheet.name = "Trang 1";

    worksheet.getRangeByName("A1").setText("STT");
    worksheet.getRangeByName("B1").setText("Họ Và Tên");
    worksheet.getRangeByName("C1").setText("Số Điện Thoại");
    
    int dataLength = students.length;
    for(int row = 2; row <= dataLength + 1; row++) {
        worksheet.getRangeByName("A$row").setValue(row - 1);
        worksheet.getRangeByName("B$row").setValue(students[row - 2].name);
        worksheet.getRangeByName("C$row").setValue(students[row - 2].phoneNumber);
    } 

    final List<int> bytes = workbook.saveAsStream();
    String? path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/${title.replaceAll(' ', '').toUpperCase()}.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true, mode: FileMode.write);
    OpenFile.open(fileName);
  }
}