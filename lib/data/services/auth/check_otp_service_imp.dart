import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:play_ground_app/data/services/auth/check_otp_service.dart';

class CheckOtpServiceImp implements CheckOtpService {
  final String? _apiEndpoint = dotenv.env["API_ENDPOINT"];
  @override
  Future<bool> check(String accountName, String otp) async {
    http.Response response = await _checkOtp(accountName, otp);
    if(response.statusCode != 200) {
      return false;
    }
    return true;
  }
  Future<http.Response> _checkOtp(String accountName, String otp) {
    return http.get(Uri.parse("$_apiEndpoint/auth/check-otp?accountName=$accountName&otp=$otp"));
  }
}