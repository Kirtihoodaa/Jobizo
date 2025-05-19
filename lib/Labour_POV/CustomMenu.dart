// CustomMenu.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobizo/Labour_POV/Home%20Screens/Dashboard.dart';
import 'package:jobizo/Labour_POV/Home%20Screens/Feedback.dart';
import 'package:jobizo/Labour_POV/Home%20Screens/HelpandSupport.dart';
import 'package:jobizo/Labour_POV/Profle%20pages/MyProfile.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Login/login.dart';
import '../logout.dart';

class CustomMenu {
  static Future<void> show(
      BuildContext context, AnimationController? controller) async {
    if (controller != null) controller.forward();
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? "Guest";
    final image = prefs.getString('user_profile_image') ?? "";
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, animation1, animation2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation1, curve: Curves.easeOutBack),
          child: Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              width: MediaQuery.sizeOf(context).height * 0.4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                                      ? NetworkImage(
                                          "https://backend.jobizoindia.com/storage/$image")
                                      : const AssetImage(
                                              "Assets/Labour_image/person.png")
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
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () {
                                if (controller != null) controller.reverse();
                                Navigator.of(context).pop();
                              },
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
                    ListTile(
                      leading: Icon(Icons.dashboard_customize),
                      title: Text('Dashboard'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DashboardScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profile'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyProfilePage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.support_agent),
                      title: Text('Help & Support'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HelpSupportPage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.feedback),
                      title: Text('Feedback'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FeedbackPage()),
                        );
                      },
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 12),
                      color: AppColors.brown,
                      child: TextButton.icon(
                        onPressed: () {
                          showLogoutDialog(() {
                            Get.offAll(() => const LoginPage()); // Clears the stack and navigates
                          });
                        },
                        icon: Icon(Icons.logout, color: Colors.white),
                        label: Text('Logout',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedMenuButton extends StatefulWidget {
  @override
  _AnimatedMenuButtonState createState() => _AnimatedMenuButtonState();
}

class _AnimatedMenuButtonState extends State<AnimatedMenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _menuController;

  @override
  void initState() {
    super.initState();
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _menuController,
        color: Colors.white,
      ),
      onPressed: () async {
        await CustomMenu.show(context, _menuController); // 👈 await the dialog
        _menuController
            .reverse(); // 👈 always reset icon after dialog is dismissed
      },
    );
  }
}
