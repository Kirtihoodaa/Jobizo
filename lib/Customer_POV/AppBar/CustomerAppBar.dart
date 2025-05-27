import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobizo/hamburgerCustomer/CustomMenuCustomer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Design contraints/FontSizes.dart';
import '../../Design contraints/app color.dart';
import '../../Labour_POV/CustomMenu.dart';

class Customerappbar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const Customerappbar({
    Key? key,
    this.onMenuTap,
    this.onNotificationTap,
    this.onProfileTap,
    required String profileImageUrl,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<Customerappbar> createState() => CustomerappbarState();
}

class CustomerappbarState extends State<Customerappbar> {
  String name = "Loading...";
  String location = "Please wait...";
  String profileImage = "";

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('user_name');
    final savedLocation = prefs.getString('user_location');
    final savedImage = prefs.getString('user_profile_image');

    if (savedName != null && savedLocation != null && savedImage != null) {
      setState(() {
        name = savedName;
        location = savedLocation;
        profileImage = savedImage;
      });
    } if (savedImage == null || savedImage.isEmpty) {
      await _fetchAndStoreProfile(); // fetch only if image is missing
    }
  }

  Future<void> _fetchAndStoreProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        print("Token not found");
        return;
      }

      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer $token";

      final response =
          await dio.get("https://backend.jobizoindia.com/api/profile");

      if (response.statusCode == 200) {
        final user = response.data['user'];
        final userName = user['name'] ?? "No Name";
        final userLocation = user['address'] ?? "No Location";
        final imagePath = user['image'] ?? "";

        await prefs.setString('user_name', userName);
        await prefs.setString('user_location', userLocation);
        await prefs.setString('user_profile_image', imagePath);

        setState(() {
          name = userName;
          location = userLocation;
          profileImage = imagePath;
        });
      } else {
        print("Failed to fetch profile");
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  void refreshUserInfo() {
    _fetchAndStoreProfile();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFAC015),
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Menu + Profile Info
            Row(
              children: [
                AnimatedMenuButtonCustomer(),
                GestureDetector(
                    onTap: widget.onProfileTap,
                    child: CircleAvatar(
                      radius: 21,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.gold,
                        backgroundImage: (profileImage.isNotEmpty)
                            ? NetworkImage("https://backend.jobizoindia.com/storage/${profileImage.trim()}")
                            : null,
                        child: (profileImage.isEmpty)
                            ? const Icon(Icons.person, size: 35, color: Colors.white)
                            : null,
                      ),
                    )),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: primary(),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      location,
                      style:
                          TextStyle(color: Colors.white, fontSize: secondary()),
                    ),
                  ],
                ),
              ],
            ),

            /// Notifications and Dynamic Profile Image
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onNotificationTap,
                  child:  CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xFFFAC015),
                          child: Image.asset(
                            "Assets/Labour_image/notification icon.png",
                            height: 25,
                          ),
                        ),
                  ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: widget.onProfileTap,
                  child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Image.asset("Assets/jobizo/jobizoLogo.png")),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
