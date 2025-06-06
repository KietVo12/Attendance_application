import 'package:flutter/material.dart';
import 'package:play_ground_app/data/services/auth/logout_service.dart';
import 'package:play_ground_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutServiceImp implements LogoutService {
  @override
  void logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    Navigator.of(context).pushNamed("/");
  }
}