import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:play_ground_app/data/services/auth/login_service.dart';

class LoginServiceImp implements LoginService {
  final String? _apiEndpoint = dotenv.env["API_ENDPOINT"];
  @override
  Future<String> login(String accountName, String password) async {
      http.Response response = await checkJwtValid(accountName, password);
      if(response.statusCode != 200) {
        return "";
      }
      Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if(jsonResponse['token'] == null) {
        return "";
      }
      return jsonResponse['token'] as String;
  }
    Future<http.Response> checkJwtValid(String accountName, String password) {
    return http.post(Uri.parse("$_apiEndpoint/auth/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      }
    , body: jsonEncode(<String, String>
      {
        "accountName": accountName,
        "password": password
      }
    ));
  }
}