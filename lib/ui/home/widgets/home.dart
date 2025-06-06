import 'package:flutter/material.dart';
import 'package:play_ground_app/injection_container.dart';
import 'package:play_ground_app/ui/courses/widgets/create_course_form.dart';
import 'package:play_ground_app/ui/home/widgets/logout_btn.dart';
import 'package:play_ground_app/ui/roll_call/widgets/roll_call_show.dart';
import 'package:play_ground_app/ui/shifts/widgets/shift_create_form.dart';
import 'package:play_ground_app/ui/students/widgets/student_create_form.dart';
import 'package:play_ground_app/ui/teach_calendar/widgets/create_teach_caledar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _buildItem(
    BuildContext context,
    String label,
    String subtitle,
    Widget page,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => page,
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trang Chủ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 20),
              _buildItem(
                context,
                'Đăng Kí Thông Tin Học Sinh',
                'Người Dùng Cung Cấp Thông Tin Cơ Bản Của Học Sinh',
                locator<StudentCreateFormWidgets>(),
                Icons.person_add,
              ),
              _buildItem(
                context,
                'Tạo Khoá Học Mới',
                'Người Dùng Cung Cấp Thông Tin Cơ Bản Về Môn Học Năm Học',
                locator<CreateCourseFormWidget>(),
                Icons.menu_book,
              ),
              _buildItem(
                context,
                'Tạo Ca Dạy',
                'Tạo Tên Dễ Nhớ Thời Gian Bắt Đầu Và Kết Thúc Ca Dạy',
                locator<ShiftCreateFormWidget>(),
                Icons.av_timer,
              ),
              _buildItem(
                context,
                'Tạo Lịch Dạy',
                'Lịch Dạy Bao Gồm Môn Học Và Ca Dạy Thời Gian Được Tính Vào Thời Gian Người Dùng Tạo Lịch Dạy',
                locator<CreateTeachCalendarWidget>(),
                Icons.calendar_today,
              ),
              _buildItem(
                context,
                'Danh Sách Điểm Danh',
                'Xem Danh Sách Điểm Danh Hỗ Trợ Xuất File Excel',
                locator<RollCallShow>(),
                Icons.list_alt,
              ),
              LogoutBtn(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
