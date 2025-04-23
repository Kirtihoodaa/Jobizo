import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobizo/Customer_POV/HomePages/Allsites.dart';
import 'package:jobizo/splash/splash_screen1.dart';
import 'Customer_POV/AppBar/CustomerAppBar.dart';
import 'Customer_POV/CustomerNavBar.dart';
import 'Customer_POV/HomePages/LabourLocalities.dart';
import 'Customer_POV/SettingsPages/CustomerSetting.dart';
import 'Customer_POV/HomePages/HomePagess.dart';
import 'Customer_POV/HomePages/IndustryDetails.dart';
import 'Labour_POV/Home Screens/HomePage.dart';
import 'Labour_POV/NavBar.dart';
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
          //home: SplashScreen1(),
          // home: EditProfileScreen(),
          //  home: CustomAppBar(name: 'Deepak', location: 'chandigarh', profileImageUrl: '',),
          home: Homepagess(),
          //home: Industrydetails(),
        );
      },
    );
  }
}
