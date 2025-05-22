import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Design contraints/FontSizes.dart';
import '../../Design contraints/app color.dart';
import '../../SnackBar/Snackbar.dart';
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
  bool _isLoading = false;

  Future<void> _changePassword() async {
    final current = _currentCtrl.text.trim();
    final neu     = _newCtrl.text.trim();
    final confirm = _confirmCtrl.text.trim();

    if (current.isEmpty || neu.isEmpty || confirm.isEmpty) {
      SnackbarHelper.showWarning(context, 'Please fill all fields.');
      return;
    }
    if (neu != confirm) {
      SnackbarHelper.showError(context, 'New & confirm must match.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token') ?? '';
      if (token.isEmpty) {
        SnackbarHelper.showError(context, 'Not authenticated. Please log in.');
        return;
      }
      if (!token.startsWith('Bearer ')) token = 'Bearer $token';

      final dio = Dio(BaseOptions(headers: {'Authorization': token}));
      final resp = await dio.post(
        'https://backend.jobizoindia.com/api/change-password',
        data: {
          'current_password': current,
          'new_password': neu,
          'new_password_confirmation': confirm,
        },
        options: Options(validateStatus: (s) => s != null && s < 500),
      );

      final data = resp.data as Map<String, dynamic>;
      if (resp.statusCode == 200 && data['status'] == true) {
        SnackbarHelper.showSuccess(context, data['message'] ?? 'Password changed.');
        Get.back();
      } else {
        SnackbarHelper.showError(
          context,
          data['message'] ?? 'Password should be atleast 8 characters.',
        );
      }
    } on DioError catch (e) {
      final msg = e.response?.data['message'] ?? e.message;
      SnackbarHelper.showInfo(context, 'Error: $msg');
    } catch (e) {
      SnackbarHelper.showError(context, 'Unexpected error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.gold,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Change Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: primary(),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Password
            Text('Current Password',
                style: TextStyle(fontSize: secondary(), fontWeight: FontWeight.w600)),
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
            Text('New Password',
                style: TextStyle(fontSize: secondary(), fontWeight: FontWeight.w600)),
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
            Text('Confirm New Password',
                style: TextStyle(fontSize: secondary(), fontWeight: FontWeight.w600)),
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
                onPressed: _isLoading ? null : _changePassword,
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : Text(
                  'Update Password',
                  style: TextStyle(
                      fontSize: secondary(), color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
