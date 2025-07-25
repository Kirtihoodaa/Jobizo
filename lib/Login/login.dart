import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:jobizo/Login/webView.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Design contraints/gradients.dart';
import '../Labour_POV/Home Screens/HomePage.dart';
import '../Customer_POV/HomePages/HomePagess.dart';
import '../SnackBar/Snackbar.dart';
import '../splash/splash_screen2.dart';
import 'forgotPassword.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      SnackbarHelper.showWarning(context, "Please enter Email and Password");
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
        print(token);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        final roles = List<String>.from(data['role'] as List);
        await prefs.setBool('isLoggedIn', true);

        if (roles.contains('labour')) {
          await prefs.setString('userRole', 'labour');
          Get.to(() => const Homepage(),
              transition: Transition.cupertino,
              duration: const Duration(milliseconds: 400));
        } else if (roles.contains('customer')) {
          await prefs.setString('userRole', 'customer');
          Get.to(() => const Homepagess(),
              transition: Transition.cupertino,
              duration: const Duration(milliseconds: 400));
        } else {
          await prefs.setString('userRole', 'unknown');
          // 👇 Open URL if role is something else
          final url = 'https://backend.jobizoindia.com/auth/login';
          Get.to(
              () => WebViewPage(
                    url: url,
                    email: '$email',
                    password: '$password',
                  ),
              transition: Transition.cupertino,
              duration: const Duration(milliseconds: 400));
        }
      } else {
        SnackbarHelper.showError(
          context,
          data['message'] ?? 'Login failed',
        );
      }
    } on DioError catch (e) {
      SnackbarHelper.showWarning(
        context,
        e.response?.data['message'] ?? e.message,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Future<void> _loginWithGoogle() async {
  //   setState(() => _isLoading = true);
  //   print("⏳ Starting Google Sign-In...");
  //
  //   try {
  //     final GoogleSignIn _googleSignIn = GoogleSignIn();
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //
  //     if (googleUser == null) {
  //       print("❌ Google Sign-In cancelled by user.");
  //       setState(() => _isLoading = false);
  //       return;
  //     }
  //
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //     final String? idToken = googleAuth.idToken;
  //
  //     print("✅ Google Sign-In successful. ID Token: ${idToken?.substring(0, 20)}...");
  //
  //     if (idToken == null) {
  //       throw Exception("Google ID token is null");
  //     }
  //
  //     final dio = Dio();
  //     print("📡 Sending ID token to Laravel backend...");
  //
  //     final response = await dio.post(
  //       "https://backend.jobizoindia.com/api/auth/google",
  //       data: {"idToken": idToken},
  //       options: Options(headers: {"Content-Type": "application/json"}),
  //     );
  //
  //     print("📥 Response received from backend: ${response.data}");
  //
  //     final data = response.data;
  //
  //     if (data['access_token'] != null) {
  //       final token = '${data['token_type'] ?? 'Bearer'} ${data['access_token']}';
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('auth_token', token);
  //       await prefs.setBool('isLoggedIn', true);
  //
  //       final roles = List<String>.from(data['user']['roles'] ?? []);
  //       print("🔐 Login success. Roles: $roles");
  //
  //       if (roles.contains('labour')) {
  //         await prefs.setString('userRole', 'labour');
  //         Get.to(() => const Homepage(),
  //             transition: Transition.cupertino,
  //             duration: const Duration(milliseconds: 400));
  //       } else if (roles.contains('customer')) {
  //         await prefs.setString('userRole', 'customer');
  //         Get.to(() => const Homepagess(),
  //             transition: Transition.cupertino,
  //             duration: const Duration(milliseconds: 400));
  //       } else {
  //         await prefs.setString('userRole', 'unknown');
  //         print("⚠️ Unknown user role");
  //         SnackbarHelper.showError(context, "Unknown user role");
  //       }
  //     } else {
  //       print("❌ Google login failed: ${data['message']}");
  //       SnackbarHelper.showError(context, data['message'] ?? 'Google login failed');
  //     }
  //   } on DioError catch (e) {
  //     print("❗ DioError: ${e.response?.data}");
  //     SnackbarHelper.showWarning(context, e.response?.data['message'] ?? e.message);
  //   } catch (e) {
  //     print("❌ Exception: $e");
  //     SnackbarHelper.showError(context, e.toString());
  //   } finally {
  //     setState(() => _isLoading = false);
  //     print("✅ Google login flow complete.");
  //   }
  // }

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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                              // ElevatedButton.icon(
                              //   onPressed:
                              //   label: Text(
                              //     "Login with Gmail",
                              //     style: TextStyle(
                              //       color: AppColors.green,
                              //       fontSize: tertiary(),
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              //   icon: const Icon(Icons.login,
                              //       color: AppColors.green),
                              //   style: ElevatedButton.styleFrom(
                              //     backgroundColor: Colors.white,
                              //     padding: EdgeInsets.symmetric(
                              //         horizontal: 75.w, vertical: 12.h),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(40.r),
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(height: 10.h),
                              // Text(
                              //   "OR",
                              //   style: TextStyle(
                              //     color: AppColors.green,
                              //     fontSize: 20.sp,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              SizedBox(height: 10.h),
                              _buildInputFields(),
                              SizedBox(height: 15.h),
                              _isLoading
                                  ? const CircularProgressIndicator(
                                      color: AppColors.gold)
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
                                onPressed: () => Get.to(
                                    () => const Forgotpassword(),
                                    transition: Transition.cupertino,
                                    duration:
                                        const Duration(milliseconds: 400)),
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
                                onPressed: () => Get.to(() => SplashScreen2(),
                                    transition: Transition.cupertino,
                                    duration:
                                        const Duration(milliseconds: 400)),
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
