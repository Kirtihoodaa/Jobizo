import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:jobizo/Login/ResetPassword.dart';
import '../Design contraints/FontSizes.dart';
import '../Design contraints/gradients.dart';
import 'login.dart';
import 'package:jobizo/SnackBar/Snackbar.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final dio = Dio();
      dio.options.headers['Accept'] = 'application/json';

      final response = await dio.post(
        'https://backend.jobizoindia.com/api/forgot-password',
        data: {
          'email': _emailController.text.trim(),
        },
      );

      final data = response.data as Map<String, dynamic>;

      if (response.statusCode == 200 && data['status'] == true) {
        SnackbarHelper.showSuccess(
          context,
          data['message'] ?? 'Reset link sent.',
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPassword(
              email: _emailController.text.trim(),
            ),
          ),
        );
      } else {
        SnackbarHelper.showError(
          context,
          data['message'] ?? 'Failed to send reset link.',
        );
      }
    } on DioException catch (e) {
      final msg = (e.response?.data as Map<String, dynamic>?)?['message'] ?? e.message;
      SnackbarHelper.showError(context, msg);
    } catch (_) {
      SnackbarHelper.showError(
        context,
        'Something went wrong. Please try again.',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: AppGradients.yellowOrangeVertical,
            ),
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("Assets/jobizo/JobizoName.png", width: 180.w),
                    SizedBox(height: 100.h),
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 80, 20, 40),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.33),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Text(
                                  "Forgot password?",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return "Email is required";
                                    }
                                    if (!v.contains('@')) {
                                      return "Enter a valid email";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: "Enter your Email ID",
                                    hintStyle: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF66680E),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                ElevatedButton(
                                  onPressed: _isLoading ? null : _sendResetLink,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.green,
                                    ),
                                  )
                                      : Text(
                                    "Send reset link",
                                    style: const TextStyle(
                                      color: Color(0xFF66680E),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: -40,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              'Assets/jobizo/jobizoLogo.png',
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.off(() => const LoginPage());
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      label: Text(
                        "Back",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: secondary(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: const [
                Text(
                  "Need Help? Contact Support",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Version 2.1.0",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
