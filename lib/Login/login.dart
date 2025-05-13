import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import '../Design contraints/gradients.dart';
import '../Labour_POV/Home Screens/HomePage.dart';
import '../Customer_POV/HomePages/HomePagess.dart';
import '../splash/splash_screen2.dart';
import 'forgotPassword.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = usernameController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dio = Dio();
      final response = await dio.post(
        "https://backend.jobizoindia.com/api/login",
        data: {'email': email, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;
      if (data['status'] == true) {
        final token = '${data['token_type']} ${data['token']}';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        final roles = List<String>.from(data['role'] as List);
        await prefs.setBool('isLoggedIn', true);

// Save user role
        if (roles.contains('labour')) {
          await prefs.setString('userRole', 'labour');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Homepage()),
          );
        } else if (roles.contains('customer')) {
          await prefs.setString('userRole', 'customer');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Homepagess()),
          );
        } else {
          // fallback or admin
          await prefs.setString('userRole', 'unknown');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unknown role.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Login failed')),
        );
      }
    } on DioError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.response?.data['message'] ?? e.message)),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: "Email",
            hintStyle: TextStyle(
              fontSize: secondary(),
              color: const Color(0xFF66680E),
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: "Password",
            hintStyle: TextStyle(
              fontSize: secondary(),
              color: AppColors.green,
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: AppGradients.yellowOrangeVertical,
            ),
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "Assets/jobizo/JobizoName.png",
                      width: 180.w,
                    ),
                    SizedBox(height: 50.h),
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            top: 80.h,
                            left: 20.w,
                            right: 20.w,
                            bottom: 40.h,
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.33),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Welcome back!",
                                style: TextStyle(
                                  color: AppColors.green,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: implement Google login
                                },
                                // icon: const Icon(Icons.email, color: AppColors.green, size: 20,),
                                label: Text(
                                  "Login with Gmail",
                                  style: TextStyle(
                                    color: AppColors.green,
                                    fontSize: tertiary(),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 75.w, vertical: 12.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.r),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "OR",
                                style: TextStyle(
                                  color: AppColors.green,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              _buildInputFields(),
                              SizedBox(height: 15.h),
                              _isLoading
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton.icon(
                                      onPressed: _login,
                                      icon: const Icon(Icons.login,
                                          color: AppColors.green),
                                      label: Text(
                                        "Login",
                                        style: TextStyle(
                                          color: AppColors.green,
                                          fontSize: secondary(),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 75.w, vertical: 12.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40.r),
                                        ),
                                      ),
                                    ),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const Forgotpassword()),
                                ),
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    fontSize: tertiary(),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                "New User?",
                                style: TextStyle(color: Colors.white),
                              ),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const SplashScreen2()),
                                ),
                                child: const Text(
                                  "Register Here",
                                  style: TextStyle(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -40.h,
                          child: CircleAvatar(
                            radius: 45.r,
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              'Assets/jobizo/jobizoLogo.png',
                              height: 95.h,
                              width: 95.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  "Need Help? Contact Support",
                  style: TextStyle(color: Colors.white, fontSize: tertiary()),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Version 2.1.0",
                  style: TextStyle(color: Colors.white70, fontSize: tertiary()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
