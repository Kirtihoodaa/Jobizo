// CustomMenu.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobizo/Labour_POV/Home%20Screens/Feedback.dart';
import 'package:jobizo/Labour_POV/Home%20Screens/HelpandSupport.dart';
import 'package:jobizo/Labour_POV/Profle%20pages/MyProfile.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Login/login.dart';
import '../logout.dart';
import '../Customer_POV/HomePages/Dashboard.dart';
import '../Customer_POV/SettingsPages/CustomerProfile.dart';
import 'Customerfeedback.dart';

class CustomMenuCustomer {
  static Future<void> show(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? "Guest";
    final image = prefs.getString('user_profile_image') ?? "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: MediaQuery.sizeOf(context).height*0.4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 28,
                                backgroundImage: image.isNotEmpty
                                    ? NetworkImage("https://backend.jobizoindia.com/storage/$image")
                                    : const AssetImage("Assets/Labour_image/person.png")
                                as ImageProvider,
                              ),
                              SizedBox(height: 8),
                              Text(
                                name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              // Text(
                              //   'Joined March 2025',
                              //   style:
                              //   TextStyle(color: Colors.white, fontSize: 12),
                              // ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.brown,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.close,
                                  color: AppColors.gold, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Menu items
                ListTile(
                  leading: Icon(Icons.dashboard_customize),
                  title: Text('Dashboard'),
                  onTap: () => Get.to(
                        () => const DashboardScreenC(),
                    transition: Transition.cupertino,
                    duration: Duration(milliseconds: 400),
                  ),
                ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                    onTap: () => Get.to(
                          () => Customerprofile(),
                      transition: Transition.cupertino,
                      duration: Duration(milliseconds: 400),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.support_agent),
                    title: Text('Help & Support'),
                    onTap: () => Get.to(
                          () => const HelpSupportPage(),
                      transition: Transition.cupertino,
                      duration: Duration(milliseconds: 400),
                    ),
                  ),
                ListTile(
                  leading: Icon(Icons.feedback),
                  title: Text('Feedback'),
                  onTap: () => Get.to(
                        () => const Customerfeedback(),
                    transition: Transition.cupertino,
                    duration: Duration(milliseconds: 400),
                  ),
                ),

                  // Logout button
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 12),
                    color: AppColors.brown,
                    child: TextButton.icon(
                      onPressed: () {
                        showLogoutDialog(() {
                          Get.offAll(() => const LoginPage()); // Clear navigation stack and go to login
                        });
                      },
                      icon: Icon(Icons.logout, color: Colors.white),
                      label:
                      Text('Logout', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 36),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
