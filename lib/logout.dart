import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Design contraints/FontSizes.dart';
import 'Login/login.dart'; // Import your login screen


import 'package:get/get.dart';

void showLogoutDialog(VoidCallback onConfirm) {
  Get.defaultDialog(
    title: '',
    content: Column(
      children: [
        Text(
          "Are you sure you want to logout?",
          style: TextStyle(fontSize: secondary(), color: Colors.black),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA1A1A1),
              ),
              onPressed: () {
                Get.back(); // close dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(fontSize: secondary(), color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B1E03),
              ),
              onPressed: () async {
                Get.back(); // close dialog
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                onConfirm(); // callback if any
                Get.offAll(() => const LoginPage()); // navigate to login
              },
              child: Text(
                "Logout",
                style: TextStyle(fontSize: secondary(), color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    ),
    radius: 12,
    backgroundColor: Colors.white,
  );
}