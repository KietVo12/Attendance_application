import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:play_ground_app/data/services/auth/send_otp_service.dart';

class SendOtpServiceImp implements SendOtpService {
  final String? _apiEndpoint = dotenv.env["API_ENDPOINT"];
  
  @override
  void send(String accountName) {
    http.post(Uri.parse("$_apiEndpoint/auth/send-otp?accountName=$accountName"));
  }

}