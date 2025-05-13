import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showSuccess(BuildContext context, String message) {
    _showSnackbar(context, message, Colors.green, Icons.check_circle);
  }

  static void showError(BuildContext context, String message) {
    _showSnackbar(context, message, Colors.red, Icons.cancel);
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackbar(context, message, Colors.orange, Icons.warning);
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackbar(context, message, Colors.blue, Icons.access_time);
  }

  static void _showSnackbar(
      BuildContext context, String message, Color color, IconData icon) {
    final snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      content: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Color(0xFF2C4305),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
