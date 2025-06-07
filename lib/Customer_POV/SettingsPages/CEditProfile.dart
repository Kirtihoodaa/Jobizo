import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Design contraints/FontSizes.dart';
import '../../SnackBar/Snackbar.dart';

class Ceditprofile extends StatefulWidget {
  const Ceditprofile({super.key});

  @override
  State<Ceditprofile> createState() => _CeditprofileState();
}

class _CeditprofileState extends State<Ceditprofile> {
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();
  String? cachedProfileImage;
  XFile? pickedImage;
  final ImagePicker _picker = ImagePicker();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadCachedProfileImage();
    fetchProfileData();
  }

  void _loadCachedProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cachedProfileImage = prefs.getString('user_profile_image');
    });
  }

  Future<void> fetchProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        print("❌ No token found");
        return;
      }

      final dio = Dio();
      dio.options.headers["Authorization"] = "Bearer $token";

      final response =
          await dio.get('https://backend.jobizoindia.com/api/profile');

      print("Full response: ${response.data}");

      final user = response.data['user'];
      if (user == null || user['email'] == null) {
        print("❌ 'email' is missing in response");
        return;
      }

      setState(() {
        _emailCtrl.text = user['email'];
        _nameCtrl.text = user['name'] ?? '';
        _phoneCtrl.text = user['phone'] ?? '';
        _dobCtrl.text = user['dob'] ?? '';
        _locationCtrl.text = user['address'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      print("❌ Exception: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        print("⚠️ Token not found");
        return;
      }

      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer $token";

      FormData formData = FormData.fromMap({
        "name": _nameCtrl.text.trim(),
        "email": _emailCtrl.text.trim(),
        "phone": _phoneCtrl.text.trim(),
        "dob": _dobCtrl.text.trim(),
        "address": _locationCtrl.text.trim(),
        if (pickedImage != null)
          "image": await MultipartFile.fromFile(
            pickedImage!.path,
            filename: pickedImage!.name,
          ),
      });

      final response = await dio.post(
        'https://backend.jobizoindia.com/api/profile',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final updatedData = response.data['data'] ?? response.data['user'];

        if (updatedData != null) {
          // ✅ Save updated values to SharedPreferences
          await prefs.setString('user_name', updatedData['name'] ?? '');
          await prefs.setString('user_location', updatedData['address'] ?? '');
          await prefs.setString(
              'user_profile_image', updatedData['image'] ?? '');

          print("✅ Profile updated successfully: $updatedData");
          if (!mounted) return;
          Navigator.pop(context, 'refresh');
        } else {
          print("⚠️ Response missing 'data' or 'user' field");
          SnackbarHelper.showError(context, "Unexpected response from server.");
        }
      } else {
        print("❌ Profile update failed with status ${response.statusCode}");
        SnackbarHelper.showError(context, "Failed to update profile.");

      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("❌ Error Body: ${e.response?.data}");
        print("❌ Status Code: ${e.response?.statusCode}");
      } else {
        print("❌ Dio error without response: ${e.message}");
      }

      SnackbarHelper.showError(context, "Something went wrong. Please try again.");

    }
  }

  // @override
  // void dispose() {
  //   _nameCtrl.dispose();
  //   _emailCtrl.dispose();
  //   _phoneCtrl.dispose();
  //   _dobCtrl.dispose();
  //   _locationCtrl.dispose();
  //   super.dispose();
  // }

  Future<void> _pickDate() async {
    DateTime initialDate;

    try {
      initialDate = _dobCtrl.text.isNotEmpty
          ? DateTime.parse(_dobCtrl.text)
          : DateTime(1990, 1, 1);
    } catch (e) {
      initialDate = DateTime(1990, 1, 1);
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: AppColors.gold,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.gold),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobCtrl.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  InputDecoration _fieldDecoration({required String hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.gold),
      ),
      suffixIcon: suffix,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: primary(),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: _updateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                elevation: 0,
              ),
              child: Text('Save',
                  style: TextStyle(fontSize: tertiary(), color: Colors.white)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Profile picture + camera icon
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8)
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.gold,
                        backgroundImage: pickedImage != null
                            ? FileImage(File(pickedImage!.path)) // <-- show picked image
                            : (cachedProfileImage != null && cachedProfileImage!.trim().isNotEmpty
                            ? NetworkImage("https://backend.jobizoindia.com/storage/${cachedProfileImage!.trim()}")
                            : null) as ImageProvider?, // fallback to cached
                        child: pickedImage == null &&
                            (cachedProfileImage == null || cachedProfileImage!.trim().isEmpty)
                            ? Icon(Icons.person, size: 70, color: Colors.white)
                            : null,
                      ),

                    ),
                    Positioned(
                      right: -4,
                      bottom: -4,
                      child: GestureDetector(
                        onTap: () async {
                          final XFile? picked = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (picked != null) {
                            setState(() => pickedImage = picked);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Full Name
              _buildLabeledField(
                'Full Name',
                TextFormField(
                  controller: _nameCtrl,
                  decoration: _fieldDecoration(hint: 'Enter full name'),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(height: 16),

              // Email
              _buildLabeledField(
                'Email',
                TextFormField(
                  controller: _emailCtrl,
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _fieldDecoration(hint: 'Enter email'),
                ),
              ),
              const SizedBox(height: 16),

              // Phone Number
              _buildLabeledField(
                'Phone Number',
                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: _fieldDecoration(hint: '+91 .....'),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(height: 16),

              // Date of Birth
              _buildLabeledField(
                'Date of Birth',
                TextFormField(
                  controller: _dobCtrl,
                  readOnly: true,
                  decoration: _fieldDecoration(
                    hint: 'YYYY-MM-DD',
                    suffix: IconButton(
                      icon: const Icon(Icons.calendar_today_outlined),
                      onPressed: _pickDate,
                    ),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(height: 16),

              // Location
              _buildLabeledField(
                'Location',
                TextFormField(
                  controller: _locationCtrl,
                  decoration: _fieldDecoration(hint: 'Enter location'),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                TextStyle(fontSize: tertiary(), fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        SizedBox(height: 48, child: field),
      ],
    );
  }
}
