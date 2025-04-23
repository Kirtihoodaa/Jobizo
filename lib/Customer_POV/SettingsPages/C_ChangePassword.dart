import 'package:flutter/material.dart';

import '../../Design contraints/FontSizes.dart';
import '../../Design contraints/app color.dart';
import '../AppBar/commonAppBar.dart';

class CChangepassword extends StatefulWidget {
  const CChangepassword({super.key});

  @override
  State<CChangepassword> createState() => _CChangepasswordState();
}

class _CChangepasswordState extends State<CChangepassword> {

  final TextEditingController _currentCtrl = TextEditingController();
  final TextEditingController _newCtrl     = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Commonappbar(title: "Change Password"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Password
            Text(
              'Current Password',
              style: TextStyle(fontSize: secondary(), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _currentCtrl,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter current password',
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.gold, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // New Password
            Text(
              'New Password',
              style: TextStyle(fontSize: secondary(), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _newCtrl,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter new password',
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.gold, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Confirm New Password
            Text(
              'Confirm New Password',
              style: TextStyle(fontSize: secondary(), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _confirmCtrl,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Confirm new password',
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.gold, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Update Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  // TODO: Validate & submit new password
                },
                child: Text(
                  'Update Password',
                  style: TextStyle(fontSize: secondary(), color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
