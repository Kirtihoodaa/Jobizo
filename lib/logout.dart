import 'package:flutter/material.dart';
import 'Design contraints/FontSizes.dart';
import 'Login/login.dart'; // Import your login screen

void showLogoutDialog(BuildContext context, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white, // White background
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(
          "Are you sure you want to logout?",
          style: TextStyle(fontSize: secondary(), color: Colors.black),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA1A1A1),
                ),
                onPressed: () {
                  Navigator.pop(context); // just close dialog
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: secondary(), color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4B1E03),
                ),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  // Then perform logout action
                  onConfirm();
                },
                child: Text(
                  "Logout",
                  style: TextStyle(fontSize: secondary(), color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}