import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:play_ground_app/data/services/auth/check_account_name_service.dart';

class CheckAccountNameServiceImp implements CheckAccountNameService {
  final String? _apiEndpoint = dotenv.env["API_ENDPOINT"];
  @override
  Future<bool> check(String accountName) async {
    try {
      http.Response response = await checkAccountName(accountName);
      Map<String, dynamic> responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      if(response.statusCode != 200) {
        return false;
      }
      return responseJson["exists"] as bool;
    } catch(e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
  Future<http.Response> checkAccountName(String accountName) {
    return http.get(Uri.parse("$_apiEndpoint/auth/check-account-name?accountName=$accountName"));
  }
}