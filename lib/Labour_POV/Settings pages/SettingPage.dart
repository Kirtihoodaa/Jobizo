import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Design contraints/app color.dart';
import '../../Design contraints/FontSizes.dart';
import '../../Login/login.dart';
import '../../logout.dart';
import '../All_app_bars/app_bar.dart';
import '../NavBar.dart';
import '../Profle pages/EditProfile.dart';
import '../Profle pages/MyProfile.dart';
import 'ChangePassword.dart';
import 'Delete.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<CustomAppBarState> appBarKey = GlobalKey<CustomAppBarState>();
  bool _biometric = false;
  bool _pushNotif = true;
  bool _emailNotif = true;
  Map<String, dynamic>? userData;
  // bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchProfileData(); // ✅ This was missing
  }

  Future<void> fetchProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        print('No auth token found');
        // setState(() => isLoading = false);
        // return;
      }
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await dio.get('https://backend.jobizoindia.com/api/profile');
      setState(() {
        userData = response.data['user'];
        // isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        // isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        key: appBarKey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.gold,
                    backgroundImage: userData?['image'] != null &&
                            userData!['image'].toString().isNotEmpty
                        ? NetworkImage(
                            "https://backend.jobizoindia.com/storage/${userData!['image']}")
                        : null,
                    child: userData?['image'] == null ||
                            userData!['image'].toString().isEmpty
                        ? const Icon(Icons.person,
                            size: 60, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData?['name'] ?? '',
                          style: TextStyle(
                            fontSize: secondary(),
                            fontWeight: FontWeight.w600,
                            color: AppColors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userData?['email'] ?? '',
                          style: TextStyle(
                            fontSize: tertiary(),
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      final result = await Get.to(
                        () => const EditProfileScreen(),
                        transition: Transition.cupertino,
                        duration: const Duration(milliseconds: 400),
                      );

                      if (result == 'refresh') {
                        appBarKey.currentState
                            ?.refreshUserInfo(); // ✅ Refresh logic
                      }
                    },
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: tertiary(),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Account
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Account',
                style: TextStyle(
                  fontSize: secondary(),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Divider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                'Personal Information',
                style: TextStyle(fontSize: tertiary(), color: Colors.black),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Get.to(
                  () => MyProfilePage(),
                  transition: Transition.cupertino,
                  duration: const Duration(milliseconds: 400),
                );
              },
            ),
            Divider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                'Language',
                style: TextStyle(fontSize: tertiary(), color: Colors.black),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'English',
                    style: TextStyle(
                        fontSize: tertiary(), color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right),
                ],
              ),
              onTap: () {},
            ),
            Divider(height: 8, thickness: 15, color: Colors.grey[200]),

            // Security
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Security',
                style: TextStyle(
                  fontSize: secondary(),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Divider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                'Change Password',
                style: TextStyle(fontSize: tertiary(), color: Colors.black),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Get.to(
                  () => Changepassword(),
                  transition: Transition.cupertino,
                  duration: const Duration(milliseconds: 400),
                );
              },
            ),
            Divider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                'Biometric Login',
                style: TextStyle(fontSize: tertiary(), color: Colors.black),
              ),
              trailing: Switch(
                value: _biometric,
                activeColor: AppColors.gold,
                inactiveThumbColor: Colors.white,
                onChanged: (v) => setState(() => _biometric = v),
              ),
            ),
            Divider(height: 8, thickness: 15, color: Colors.grey[200]),

            // Notifications
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Notifications',
                style: TextStyle(
                  fontSize: secondary(),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Divider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                'Push Notifications',
                style: TextStyle(fontSize: tertiary(), color: Colors.black),
              ),
              trailing: Switch(
                value: _pushNotif,
                activeColor: AppColors.gold,
                inactiveThumbColor: Colors.white,
                onChanged: (v) => setState(() => _pushNotif = v),
              ),
            ),
            Divider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                'Email Notifications',
                style: TextStyle(fontSize: tertiary(), color: Colors.black),
              ),
              trailing: Switch(
                value: _emailNotif,
                activeColor: AppColors.gold,
                inactiveThumbColor: Colors.white,
                onChanged: (v) => setState(() => _emailNotif = v),
              ),
            ),
            Divider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                'Sound & Vibration',
                style: TextStyle(fontSize: tertiary(), color: Colors.black),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chevron_right),
                ],
              ),
              onTap: () {},
            ),
            Divider(height: 8, thickness: 15, color: Colors.grey[200]),
            SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          minimumSize: Size.fromHeight(45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      onPressed: () {
                        showLogoutDialog(() {
                          Get.offAll(() => const LoginPage()); // Clear stack & go to login
                        });
                      },
                      child: Text(
                        "Logout",
                        style: TextStyle(
                            fontSize: secondary(),
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    // SizedBox(height: 20),
                    // OutlinedButton(
                    //   style: OutlinedButton.styleFrom(
                    //       side: BorderSide(color: AppColors.gold, width: 1),
                    //       minimumSize: Size.fromHeight(45),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(20),
                    //       )),
                    //   onPressed: () {
                    //     Get.to(
                    //           () => DeleteAccount(),
                    //       transition: Transition.cupertino,
                    //       duration: const Duration(milliseconds: 400),
                    //     );
                    //   },
                    //   child: Text(
                    //     "Delete Account",
                    //     style: TextStyle(
                    //         fontSize: secondary(),
                    //         color: AppColors.gold,
                    //         fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: NavBarLabour(currentIndex: 3),
    );
  }
}
