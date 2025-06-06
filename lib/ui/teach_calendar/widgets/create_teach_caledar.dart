import 'package:flutter/material.dart';
import 'package:play_ground_app/data/models/course.dart';
import 'package:play_ground_app/data/models/course_shift.dart';
import 'package:play_ground_app/data/models/shift.dart';
import 'package:play_ground_app/injection_container.dart';
import 'package:play_ground_app/ui/courses/view_models/courses_view_model.dart';
import 'package:play_ground_app/ui/courses/widgets/create_course_form.dart';
import 'package:play_ground_app/ui/shifts/view_models/shifts_view_model.dart';
import 'package:play_ground_app/ui/teach_calendar/view_models/teach_calendar_view_model.dart';
import 'package:play_ground_app/ui/teach_calendar/widgets/show_quick_roll_call_dialog.dart';
import 'package:play_ground_app/utils/success_dialog.dart';

class CreateTeachCalendarWidget extends StatefulWidget {
  const CreateTeachCalendarWidget({super.key, 
    required CourseViewModel courseViewModel,
    required ShiftViewModel shiftViewModel,
    required TeachCalendarViewModel learnCalendarViewModel
  }) : _courseViewModel = courseViewModel,
      _shiftViewModel = shiftViewModel,
      _teachCalendarViewModel = learnCalendarViewModel;

  final CourseViewModel _courseViewModel;
  final ShiftViewModel _shiftViewModel;
  final TeachCalendarViewModel _teachCalendarViewModel;
  @override
  State<CreateTeachCalendarWidget> createState() => _CreateTeachCalendarState();
}

class _CreateTeachCalendarState extends State<CreateTeachCalendarWidget> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  Course? choosenCourse;
  Shift? choosenShift;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tạo Lịch Dạy"),
      ),
      body: Column(
        children: [
          Form(
            key: _formState,
            child: Column(
              children: [
                FutureBuilder(
                  future: widget._courseViewModel.courses, 
                  builder: (context, snapshot) {
                    if(snapshot.hasData && snapshot.data != null) {
                      List<Course> courses = snapshot.data!;
                      if(courses.isEmpty) {
                        return TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => locator<CreateCourseFormWidget>()));
                          }, 
                          child: Text("Chưa Có Khoá Học Bấm Vào Đây Để Tạo Ngay"),
                        );
                      }
                      return Column(
                        children: [
                          DropdownButtonFormField(
                            value: choosenCourse,
                            items: courses.map((course) {
                              return DropdownMenuItem<Course>(
                                value: course, 
                                child: Text("Môn ${course.subject} Lớp ${course.clazz} Năm ${course.term}")
                              );
                            }).toList(), 
                            onChanged: (value) {
                              choosenCourse = value;
                            }
                          )
                      ],);
                    }
                    return CircularProgressIndicator();
                  }
                ),
                FutureBuilder(
                  future: widget._shiftViewModel.shifts, 
                  builder: (context, snapshot) {
                    if(snapshot.hasData && snapshot.data != null) {
                      List<Shift> shifts = snapshot.data!;
                      if(shifts.isEmpty) {
                        return TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => locator<CreateCourseFormWidget>()));
                          }, 
                          child: Text("Chưa Có Khoá Học Bấm Vào Đây Để Tạo Ngay"),
                        );
                      }
                      return Column(
                        children: [
                          DropdownButtonFormField(
                            value: choosenShift,
                            items: shifts.map((shift) {
                              return DropdownMenuItem<Shift>(
                                value: shift, 
                                child: Text("${shift.name} ${shift.startTo} - ${shift.endAt}")
                              );
                            }).toList(), 
                            onChanged: (value) {
                              choosenShift = value;
                            }
                          )
                      ],);
                    }
                    return CircularProgressIndicator();
                  }
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if(choosenCourse != null && choosenShift != null) {
                        DateTime currentDate = DateTime.now();
                        String dateString = "${currentDate.day}-${currentDate.month}-${currentDate.year}";
                        CourseShift teachCalendar = CourseShift.create(courseId: choosenCourse!.id, shiftId: choosenShift!.id, date: dateString);
                        await widget._teachCalendarViewModel.submit(teachCalendar);
                        
                        if(context.mounted) {
                          if(widget._teachCalendarViewModel.success) {
                            showQuickRollCallDialog(context, teachCalendar.id);
                          }
                          if(widget._teachCalendarViewModel.onError) {
                            showAnimatedFailureDialog(context, widget._teachCalendarViewModel.exception.toString());
                          }
                        }
                        
                      } else {
                        showAnimatedFailureDialog(context, "Vui lòng nhập đầy đủ dữ liệu");
                      }
                    }, 
                    child: Text("Tạo Lịch Dạy")
                  ),
                )
              ],
            )
          )
        ],
      )
    );
  }
}