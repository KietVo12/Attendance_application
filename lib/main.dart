import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:play_ground_app/data/services/auth/login_service.dart';
import 'package:play_ground_app/data/services/auth/logout_service.dart';
import 'package:play_ground_app/data/services/jwt/check_jwt_service.dart';
import 'package:play_ground_app/injection_container.dart';
import 'package:play_ground_app/ui/auth/forgot_password_screen.dart';
import 'package:play_ground_app/ui/auth/otp_input_screen.dart';
import 'package:play_ground_app/ui/auth/reset_password_screen.dart';
import 'package:play_ground_app/ui/courses/widgets/course.dart';
import 'package:play_ground_app/ui/home/widgets/home.dart';
import 'package:play_ground_app/ui/roll_call/widgets/roll_call_show.dart';
import 'package:play_ground_app/ui/students/widgets/students.dart';
import 'package:play_ground_app/utils/success_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUp();
  await dotenv.load(fileName: ".env");

  runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => AuthCheck(),
    '/login': (context) => LoginPageScreen(),
    '/admin': (context) => AdminDashboard(),
    '/teacher': (context) => TeacherDashboard(),
    '/student': (context) => StudentDashboard(),
    '/otp': (context) => OtpInputScreen(),
    '/forgot-password': (context) => ForgotPasswordScreen(),
    '/reset-password': (context) => ResetPasswordScreen()
  },
  ));
}

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  CheckJwtService checkJwtService = locator<CheckJwtService>();
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    List<String> roles = [];
    bool isValid = false;
    if(token != null) {
      isValid = await checkJwtService.validate(token);

      JWT jwt = JWT.decode(token);
      for(dynamic role in jwt.payload['role']) {
        roles.add(role as String);
      }
      print(roles);
    }
    if (token == null || !isValid) {
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      // Token hợp lệ → điều hướng theo role
      if (roles.contains("Admin")) {
        Navigator.of(context).pushReplacementNamed('/admin');
      } else if (roles.contains("Student")) {
        Navigator.of(context).pushReplacementNamed('/student');
      } else if (roles.contains("Teacher")) {
        Navigator.of(context).pushReplacementNamed('/teacher');
      } else {
        // role không hợp lệ
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()), // chờ kiểm tra token
    );
  }
}

class StudentDashboard extends StatefulWidget {
  StudentDashboard({super.key});
  final LogoutService logoutService = locator<LogoutService>();
  @override
  State<StatefulWidget> createState() {
    return StudentDashboardState();
  }
}
class StudentDashboardState extends State<StudentDashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ElevatedButton(
          onPressed: () => widget.logoutService.logout(context),
          child: Text("Log Out")),
      )
    );
  }
}
class AdminDashboard extends StatefulWidget {
  AdminDashboard({super.key});
  final LogoutService logoutService = locator<LogoutService>();
  @override
  State<StatefulWidget> createState() {
    return AdminDashboardState();
  }
}
class AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ElevatedButton(
          onPressed: () => widget.logoutService.logout(context),
          child: Text("Log Out")),
      )
    );
  }
}

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return TeacherDashboardState();
  }
}

class TeacherDashboardState extends State<TeacherDashboard> {
  int _currentIndex = 0;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  // Titles for the AppBar corresponding to each page.
  final List<Widget> _pages = [
    HomePage(),
    locator<StudentsWidget>(),
    locator<CoursesWidget>(),
    locator<RollCallShow>(),
  ];
  // Switch pages using the nested Navigator.
  void _onTabTapped(int index) {
    if (_currentIndex == index) return; // Avoid unnecessary navigation if the same tab is tapped.
    setState(() {
      _currentIndex = index;
    });
    _navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return _pages[index];
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The nested Navigator manages the page routes.
      body: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          // Start with PageOne as the default route.
          return MaterialPageRoute(
            builder: (context) => HomePage(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang Chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Students',
            backgroundColor: const Color.fromARGB(255, 22, 100, 157),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Khoá Học',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Điểm Danh',
          ),
        ],
      ),
    );
  }
  
}
class LoginPageScreen extends StatelessWidget {
  LoginPageScreen({super.key});
  final LoginService loginService = locator<LoginService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bạn có thể thêm AppBar ở đây nếu muốn tiêu đề riêng cho màn hình
      // appBar: AppBar(
      //   title: Text("Đăng Nhập"),
      // ),
      backgroundColor: Colors.white, // Đặt màu nền cho Scaffold nếu cần
      body: SafeArea( // SafeArea giúp nội dung không bị che bởi tai thỏ, notch
        child: Center( // Center để căn giữa LoginInterface nếu nó không chiếm toàn bộ không gian
          child: LoginInterface(
            // Truyền các callback nếu cần
            onSignUpPressed: () {
              print("Nút Sign Up từ LoginPageScreen đã được nhấn!");
            },
            onForgotPasswordPressed: () {
              print("Nút Forgot Password từ LoginPageScreen đã được nhấn!");
            },
            loginService: loginService,
          ),
        ),
      ),
    );
  }
}
class LoginInterface extends StatefulWidget {
  final VoidCallback? onSignUpPressed;
  final VoidCallback? onForgotPasswordPressed;
  final Function(String)? onEmailChanged; // Callback for email changes
  final Function(String)? onPasswordChanged; // Callback for password changes
  final String? initialEmail;
  final String? initialPassword;
  final LoginService loginService;
  const LoginInterface({
    super.key,
    this.onSignUpPressed,
    this.onForgotPasswordPressed,
    this.onEmailChanged,
    this.onPasswordChanged,
    this.initialEmail,
    this.initialPassword, required this.loginService,
  });

  @override
  State<LoginInterface> createState() => _LoginInterfaceState();
}

class _LoginInterfaceState extends State<LoginInterface> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
    _passwordController = TextEditingController(text: widget.initialPassword);

    if (widget.onEmailChanged != null) {
      _emailController.addListener(() {
        widget.onEmailChanged!(_emailController.text);
      });
    }
    if (widget.onPasswordChanged != null) {
      _passwordController.addListener(() {
        widget.onPasswordChanged!(_passwordController.text);
      });
    }
  }

 @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        hintText: 'Email',
        filled: true,
        fillColor: Colors.grey[100], // Màu nền nhạt hơn một chút
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), // Bo tròn hơn
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0), // Tăng padding
        prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[600]), // Thêm icon prefix
      ),
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildPasswordField() {
  return TextFormField(
    controller: _passwordController,
    obscureText: _obscurePassword, // dùng biến để thay đổi trạng thái
    decoration: InputDecoration(
      hintText: 'Password',
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
      prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: Colors.grey[600],
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
    ),
    style: const TextStyle(fontSize: 16),
  );
}
  void _onLoginPressed() async {
    String accountName = _emailController.text;
    String password = _passwordController.text;
    if(accountName == "" || password == "") {
      showAnimatedFailureDialog(context, "Tên Tài Khoản Hoặc Mật Khẩu Không Được Để Trống");
      return;
    }
    String token = await widget.loginService.login(accountName, password);
    if(token == "") {
      showAnimatedFailureDialog(context, "Sai Email Hoặc Mật Khẩu");
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
    Navigator.of(context).pushReplacementNamed('/');
  }
  void _onForgetPasswordPress() {
    Navigator.of(context).pushReplacementNamed('/forgot-password');
  }
  Widget _buildLoginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor, // Sử dụng màu chủ đạo của theme
        padding: const EdgeInsets.symmetric(vertical: 18.0), // Tăng chiều cao nút
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 3,
        shadowColor: Theme.of(context).primaryColor.withOpacity(0.4), // Đổ bóng nhẹ với màu primary
      ),
      onPressed: _onLoginPressed,
      child: const Text(
        'Login',
        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Widget này thường được đặt bên trong Scaffold > body của một màn hình
    // Ví dụ:
    // Scaffold(
    //   appBar: AppBar(title: Text("Sign In")),
    //   body: LoginInterface(),
    // )
    return SingleChildScrollView( // Cho phép cuộn nếu nội dung dài
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc (nếu không cuộn)
          crossAxisAlignment: CrossAxisAlignment.stretch, // Kéo dãn các widget con theo chiều ngang
          children: <Widget>[
            // 1. Tiêu đề "Sign In" (có thể bỏ nếu bạn đặt tiêu đề ở AppBar của màn hình chứa widget này)
            const Text(
              'Sign In',
              textAlign: TextAlign.left, // Căn lề trái
              style: TextStyle(
                fontSize: 28, // Tăng kích thước
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24), // Khoảng cách lớn hơn

            // 2. Hình ảnh minh họa (thay thế bằng widget Image của bạn)
            Container(
              height: 180, // Giảm chiều cao một chút
              alignment: Alignment.center,
              // margin: const EdgeInsets.symmetric(vertical: 20),
              child: Image.network( // Hoặc Image.asset nếu bạn có ảnh cục bộ
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVhE6BR-rfQWZ_lpTkxrjLc70wncjrIps1_Q&s', // URL ảnh mẫu
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),

            // 4. Trường nhập Email
            _buildEmailField(),
            const SizedBox(height: 20),

            // 5. Trường nhập Password
            _buildPasswordField(),
            const SizedBox(height: 10),

            // 6. Nút Quên mật khẩu
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _onForgetPasswordPress,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8), // Giảm padding
                ),
                child: Text(
                  'Forgot Password?', // Thêm dấu ?
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 7. Nút Login
            _buildLoginButton(),
            const SizedBox(height: 24), // Khoảng cách lớn hơn một chút

            // 8. Link Đăng ký
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Don't have an account? ", // Thêm khoảng trắng
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                ),
                TextButton(
                  onPressed: widget.onSignUpPressed,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, // Bỏ padding mặc định để sát hơn
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Giảm vùng chạm
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
