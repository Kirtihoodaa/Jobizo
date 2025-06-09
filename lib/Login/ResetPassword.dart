import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:jobizo/Login/login.dart';
import '../Design contraints/gradients.dart';
import 'package:jobizo/SnackBar/Snackbar.dart';

import 'Forgotpassword.dart';

class ResetPassword extends StatefulWidget {
  final String email;

  const ResetPassword({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackbarHelper.showSuccess(
        context,
        'Password  sent successfully to ${widget.email}',
      );
    });
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
          ),

          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "Assets/jobizo/JobizoName.png",
                    width: 180.w,
                  ),
                  SizedBox(height: 10.h),
                  Image.asset(
                    "Assets/jobizo/VerifiedMail.png",
                    height: 110.h,
                    width: 120.h,
                  ),
                  SizedBox(height: 20.h),
                  const Text(
                    "Password Sent!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "A password  has been sent to",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    widget.email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(
                            () =>  Forgotpassword(),
                        transition: Transition.cupertino,
                        duration:  Duration(milliseconds: 400),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor:  Color(0xFF66680E),
                      padding:  EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child:  Text(
                      "Resend Link",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                   Text(
                    "Resend available in 60 Secs",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 40,
            right: 40,
            child: Container(
              height: 140.h,
              decoration: BoxDecoration(
                gradient: AppGradients.Green,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(
                          () => const LoginPage(),
                      transition: Transition.cupertino,
                      duration: const Duration(milliseconds: 400),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFAC015),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    "Back to Login",
                    style: TextStyle(
                      color: Color(0xFF66680E),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
