import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobizo/Design%20contraints/gradients.dart';
import 'package:jobizo/splash/splash_screen2.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  Animation<Offset>? _slideAnimation;
  bool _showLogo = false; //first the logo will not appeared

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showLogo = true;
      });
      _controller.forward();
    });

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen2()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.yellowOrangeVertical,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 264.w,
            height: 540.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF789C2C), Color(0xFF464C14)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(187.5),
                topRight: Radius.circular(187.5),
              ),
            ),
            child: Column(
              children: [
                const Spacer(),
                if (_showLogo && _slideAnimation != null)
                  SlideTransition(
                    position: _slideAnimation!,
                    child: SizedBox(
                      width: 235.w,
                      height: 235.h,
                      child: Image.asset(
                        'Assets/jobizo/jobizoLogo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                SizedBox(height: 60.h),
                Image.asset(
                  'Assets/jobizo/JobizoName.png',
                  width: 150.w,
                  height: 40.h,
                ),
                SizedBox(height: 165.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
