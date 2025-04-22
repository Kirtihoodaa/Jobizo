import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class BiometricSuccessScreen extends StatelessWidget {
  final String requestType; // e.g. "Advance" or "Salary"

  const BiometricSuccessScreen({super.key, required this.requestType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Request $requestType',
          style: TextStyle(
            color: Colors.white,
            fontSize: secondary(),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFF62A910),
                      width: 8,
                    ),
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 60,
                    color: Color(0xFF62A910),
                  )),
              const SizedBox(height: 30),
              Text(
                'Biometric Authentication !',
                style: TextStyle(
                  fontSize: primary(),
                  color: AppColors.gold,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Successful !',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF62A910),
                ),
              ),
              const SizedBox(height: 180),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  onPressed: () {
                    // Handle post-success logic
                  },
                  child: Text(
                    'Request $requestType',
                    style: TextStyle(
                      fontSize: secondary(),
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
