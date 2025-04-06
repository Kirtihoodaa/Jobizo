import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobizo/Design%20contraints/gradients.dart';
import 'package:jobizo/Login/login.dart';
import 'package:jobizo/Register/RoleSelection.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          gradient: AppGradients.yellowOrangeVertical,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10.h),
            Image.asset(
              'Assets/jobizo/jobizoLogo.png',
              width: 140.w,
              height: 140.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 15.h),
            const Text(
              'Welcome to Jobizo!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.h),
            Image.asset(
              'Assets/jobizo/sketch_labour.png',
              width: 281.w,
              height: 210.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 8.h),
            const Text(
              'Here for the first time?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.h),
            _customButton(
              width: 170.w,
              height: 45.h,
              bgColor: const Color(0xFF2C4305),
              text: 'Register',
              textColor: Colors.white,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RoleScreen()),
                );
              },
            ),
            SizedBox(height: 60.h),
            const Text(
              'Already registered?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30.h),
            _customButton(
              width: 170.w,
              height: 45.h,
              bgColor: Colors.white,
              text: 'Login',
              textColor: Colors.black,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _customButton({
    required double width,
    required double height,
    required Color bgColor,
    required String text,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(152),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
