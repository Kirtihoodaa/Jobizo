import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobizo/Customer_POV/CustomMenuCustomer.dart';

import '../../Design contraints/FontSizes.dart';
import '../../Labour_POV/CustomMenu.dart';

class Customerappbar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String location;
  final String profileImageUrl;
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const Customerappbar({
    Key? key,
    required this.name,
    required this.location,
    required this.profileImageUrl,
    this.onMenuTap,
    this.onNotificationTap,
    this.onProfileTap,
  }) : super(key: key);


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
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: onMenuTap ?? () {CustomMenuCustomer.show(context);},
                ),
                GestureDetector(
                  onTap: onProfileTap,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    backgroundImage: profileImageUrl.isNotEmpty
                        ? NetworkImage(profileImageUrl)
                        : const AssetImage('Assets/Labour_image/user profile.png')
                    as ImageProvider,
                    onBackgroundImageError: (_, __) =>
                    const Icon(Icons.error, color: Colors.red),
                  ),
                ),
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
                  onTap: onNotificationTap,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFFFAC015),
                          child: Image.asset(
                            "Assets/Labour_image/notification icon.png",
                            height: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onProfileTap,
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
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
