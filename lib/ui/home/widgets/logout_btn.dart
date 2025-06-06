import 'package:flutter/material.dart';
import 'package:play_ground_app/data/services/auth/logout_service.dart';
import 'package:play_ground_app/injection_container.dart';

class LogoutBtn extends StatefulWidget {
  LogoutBtn({super.key});
  final LogoutService logoutService = locator<LogoutService>();
  @override
  State<StatefulWidget> createState() {
    return LogoutBtnState();
  }
}

class LogoutBtnState extends State<LogoutBtn> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
          onPressed: () => widget.logoutService.logout(context),
          child: Text("Log Out"));
  }
}