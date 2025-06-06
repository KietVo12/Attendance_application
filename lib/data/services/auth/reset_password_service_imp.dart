import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:play_ground_app/data/services/auth/reset_password_service.dart';

class ResetPasswordServiceImp implements ResetPasswordService {
  final String? _apiEndpoint = dotenv.env["API_ENDPOINT"];
  @override
  Future<bool> execute(String accountName, String otp, String newPassword) async {
    http.Response response = await _resetPasswordRequest(accountName, otp, newPassword);
    if(response.statusCode != 200) {
      return false;
    }
    return true;
  }
  Future<http.Response> _resetPasswordRequest(String accountName, String otp, String newPassword) {
    return http.post(Uri.parse("$_apiEndpoint/auth/reset-password"),
      headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        }
      , body: jsonEncode(<String, String>
        {
          "accountName": accountName,
          "otp": otp,
          "newPassword": newPassword
        }
    ));
  }
}