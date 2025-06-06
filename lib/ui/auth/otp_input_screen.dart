import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:play_ground_app/data/services/auth/check_otp_service.dart';
import 'package:play_ground_app/data/services/auth/send_otp_service.dart';
import 'package:play_ground_app/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpInputScreen extends StatefulWidget {
  OtpInputScreen({Key? key}) : super(key: key);
  final SendOtpService sendOtpService = locator<SendOtpService>();
  final CheckOtpService checkOtpService = locator<CheckOtpService>();
  @override
  State<OtpInputScreen> createState() => _OtpInputScreenState();
}

class _OtpInputScreenState extends State<OtpInputScreen> {
  final int _otpLength = 6; // Độ dài OTP mong muốn
  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _otpFocusNodes;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(
      _otpLength,
      (index) => TextEditingController(),
    );
    _otpFocusNodes = List.generate(
      _otpLength,
      (index) => FocusNode(),
    );
    _sendOtp();
  }
  void _sendOtp() async {
    final prefs = await SharedPreferences.getInstance();
    String? accountName = prefs.getString("accountName");
    if(accountName != null) {
      widget.sendOtpService.send(accountName);
    } else {
      if(!mounted) return;
      setState(() {
        _errorMessage = "Không Thể Gửi OTP";
      });
    }
  }
  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1) {
      if (index < _otpLength - 1) {
        _otpFocusNodes[index + 1].requestFocus();
      } else {
        _otpFocusNodes[index].unfocus(); // Hủy focus khi đã nhập hết
      }
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
    // Xóa lỗi khi người dùng bắt đầu nhập lại
    if (_errorMessage.isNotEmpty) {
      setState(() {
        _errorMessage = '';
      });
    }
  }

  String _getOtp() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _verifyOtp() async {
    String otp = _getOtp();
    if (otp.length == _otpLength && int.tryParse(otp) != null) {
      // Logic xác thực OTP
      final prefs = await SharedPreferences.getInstance();
      String? accountName = prefs.getString("accountName");
      if(accountName == null) {
        if(!mounted) return;
        setState(() {
          _errorMessage = 'Không Thể Xác Thực OTP';
        });
        return;
      }
      bool success = await widget.checkOtpService.check(accountName, otp);

      // Ví dụ: kiểm tra OTP hợp lệ
      if (success) { // OTP mẫu
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Xác thực OTP thành công!')),
        );
        prefs.setString("otp", otp);
        Navigator.of(context).pushReplacementNamed("/reset-password");
      } else {
        setState(() {
          _errorMessage = 'Mã OTP không đúng. Vui lòng thử lại.';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Vui lòng nhập đủ mã OTP có $_otpLength chữ số.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập Mã OTP'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Mã OTP đã được gửi đến gmail của bạn.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_otpLength, (index) {
                return SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: _otpFocusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1, // Chỉ cho phép nhập 1 ký tự
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: "", // Ẩn bộ đếm ký tự
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    onChanged: (value) => _onOtpChanged(value, index),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
                    ],
                  ),
                );
              }),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Xác Nhận OTP',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                String? accountName = prefs.getString("accountName");
                if(accountName != null) {
                  widget.sendOtpService.send(accountName);
                } else {
                  if(!mounted) return;
                  setState(() {
                    _errorMessage = "Không Thể Gửi OTP";
                  });
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đang gửi lại OTP...')),
                );
              },
              child: const Text(
                'Chưa nhận được mã? Gửi lại OTP',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Để chạy ứng dụng này, bạn có thể gọi OtpInputScreen trong MaterialApp của bạn.
// Ví dụ trong main.dart:
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OTP Input Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const OtpInputScreen(),
//     );
//   }
// }