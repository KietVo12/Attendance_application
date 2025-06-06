import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:play_ground_app/data/services/jwt/check_jwt_service.dart';
import 'package:http/http.dart' as http;
class CheckJwtServiceImp implements CheckJwtService {
  final String? _apiEndpoint = dotenv.env["API_ENDPOINT"];
  @override
  Future<bool> validate(String token) async {
    try {
      http.Response response = await checkJwtValid(token);
      Map<String, dynamic> responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      if(response.statusCode != 200) {
        return false;
      }
      return responseJson["valid"] as bool;
    } catch(e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
  Future<http.Response> checkJwtValid(String token) {
    return http.get(Uri.parse("$_apiEndpoint/auth/check-jwt-valid?token=$token"));
  }
}