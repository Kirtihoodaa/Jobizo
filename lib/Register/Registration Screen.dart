import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Design contraints/FontSizes.dart';
import '../Design contraints/gradients.dart';
import '../SnackBar/Snackbar.dart';
import 'RoleSelection.dart';
import 'Sucess Registration.dart';

class RegistrationScreen extends StatefulWidget {
  final dynamic selectedRole;

  const RegistrationScreen({Key? key, required this.selectedRole})
      : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // ✅ Dispose controllers
  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ✅ API call with validation
  Future<void> registerUser(BuildContext context) async {
    final name = _nameController.text.trim();
    final mobile = _mobileController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final role = widget.selectedRole?.toString().toLowerCase();

    // ✅ Field validation
    if (name.isEmpty ||
        mobile.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        role == null) {
      SnackbarHelper.showWarning(
          context, "All fields are required.");
      return;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(mobile)) {
      SnackbarHelper.showWarning(
          context, "Enter a valid 10-digit mobile number.");
      return;
    }

    if (!email.contains("@") || !email.contains(".")) {
      SnackbarHelper.showWarning(
          context, "Enter a valid email address.");
      return;
    }

    if (password.length < 6) {
      SnackbarHelper.showWarning(
          context, "Password must be at least 6 characters.");
      return;
    }

    try {
      Dio dio = Dio();
      final response = await dio.post(
        'https://backend.jobizoindia.com/api/register',
        data: {
          "name": name,
          "email": email,
          "password": password,
          "role": role,
          "phone": mobile,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', response.data['token']);
        SnackbarHelper.showSuccess(context, "Registration Successful");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SucessRegister()),
        );
      } else {
        SnackbarHelper.showError(
            context, response.data['message'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        String errorMessage = "Validation Error";

        if (errors != null && errors is Map) {
          errorMessage = errors.entries
              .map(
                  (entry) => entry.value[0]) // grab first error from each field
              .join('\n'); // join multiple messages
        }

        SnackbarHelper.showWarning(context, errorMessage);
      } else {
        SnackbarHelper.showWarning(context, "Server Error: ${e.message}");
      }
    } catch (e) {
      SnackbarHelper.showWarning(context, "Unexpected Error: $e");
    }
  }

  // ✅ UI starts here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration:
                BoxDecoration(gradient: AppGradients.yellowOrangeVertical),
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.33),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "Registration",
                                style: TextStyle(
                                  color: Color(0xFF3E4E00),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                onPressed: () {},
                                label: const Text(
                                  "Register with Google",
                                  style: TextStyle(
                                    color: Color(0xFF3E4E00),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 55, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "OR",
                                style: TextStyle(
                                  color: Color(0xFF2C4305),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _nameController,
                                decoration: _inputDecoration("Full Name"),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _mobileController,
                                decoration: _inputDecoration("Mobile Number"),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _emailController,
                                decoration: _inputDecoration("Email ID"),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration:
                                    _inputDecoration("Password").copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.gold,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                readOnly: true,
                                decoration: _inputDecoration(
                                    widget.selectedRole?.toString() ?? "Role"),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () => registerUser(context),
                                icon: const Icon(Icons.lock_open,
                                    color: Color(0xFF66680E)),
                                label: const Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Color(0xFF66680E),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 75, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -40,
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              'Assets/jobizo/jobizoLogo.png',
                              height: 95,
                              width: 95,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RoleScreen()),
                      ),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      label: const Text(
                        "Back",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C4305),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Column(
              children: const [
                Text("Need Help? Contact Support",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                SizedBox(height: 4),
                Text("Version 2.1.0",
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Reusable decoration function
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: secondary(),
        color: Color(0xFF66680E),
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
