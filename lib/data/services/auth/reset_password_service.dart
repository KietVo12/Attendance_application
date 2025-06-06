abstract class ResetPasswordService {
  Future<bool> execute(String accountName, String otp, String newPassword);
}