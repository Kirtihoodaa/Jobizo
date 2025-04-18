import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobizo/splash/splash_screen1.dart';
import 'Labour_POV/Home Screens/HomePage.dart';
import 'Labour_POV/NavBar.dart';
import 'All_app_bars/app_bar.dart';
import 'Labour_POV/Home Screens/EmergencyPage.dart';
import 'Labour_POV/Profle pages/MyProfile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
          //home: LoginPage(),
          // home: EditProfileScreen(),
          //  home: CustomAppBar(name: 'Deepak', location: 'chandigarh', profileImageUrl: '',),
          home: Homepage(),
        );
      },
    );
  }
}
