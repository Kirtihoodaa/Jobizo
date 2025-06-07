import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Design contraints/FontSizes.dart';
import '../../Design contraints/app color.dart';
import '../../SnackBar/Snackbar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = true;
  String? profileImagePath;
  XFile? pickedImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> updateProfile() async {
    // No changes here, form validation is correct
    if (!_formKey.currentState!.validate()) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        SnackbarHelper.showError(context, "Authentication token not found.");
        return;
      }

      dio.Dio dioClient = dio.Dio();
      dioClient.options.headers["Authorization"] = "Bearer $token";

      // FormData creation is correct
      final formData = dio.FormData.fromMap({
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "dob": dobController.text.trim(),
        "address": locationController.text.trim(),
        "bio": bioController.text.trim(),
        "experience": experienceController.text.trim(),
        "skills": skillsController.text.trim(),
        if (pickedImage != null)
          "image": await dio.MultipartFile.fromFile(
            pickedImage!.path,
            filename: pickedImage!.name,
          ),
      });

      final response = await dioClient.post(
        'https://backend.jobizoindia.com/api/profile',
        data: formData,
      );

      // This part handles the success case
      if (response.statusCode == 200 && response.data['status'] == true) {
        SnackbarHelper.showSuccess(context, "Profile updated successfully.");
        fetchProfileData();
        Get.back(result: 'refresh');
      } else {
        // START OF THE FIX
        // This part now robustly handles logical failures (status: false)
        String errorMsg = "Failed to update profile.";
        final responseData = response.data;

        if (responseData != null) {
          if (responseData is Map<String, dynamic> && responseData.containsKey('message')) {
            errorMsg = responseData['message'].toString();
          } else if (responseData is List && responseData.isNotEmpty) {
            errorMsg = responseData[0].toString();
          } else if (responseData is String && responseData.trim().toLowerCase().startsWith('<!doctype html')) {
            errorMsg = "An unexpected server error occurred.";
          } else {
            errorMsg = responseData.toString();
          }
        }
        SnackbarHelper.showError(context, errorMsg);
        // END OF THE FIX
      }
    } on dio.DioException catch (dioError) {
      // This block you already fixed is correct, no changes needed here.
      String message = "Network error occurred.";
      final responseData = dioError.response?.data;

      if (responseData != null) {
        if (responseData is String && responseData.trim().toLowerCase().startsWith('<!doctype html')) {
          message = "The server returned an unexpected response.";
        } else if (responseData is Map<String, dynamic> && responseData.containsKey('message')) {
          message = responseData['message'].toString();
        } else if (responseData is List && responseData.isNotEmpty) {
          message = responseData[0].toString();
        } else {
          message = responseData.toString();
        }
      }
      SnackbarHelper.showError(context, "Error: $message");
    } catch (e) {
      SnackbarHelper.showError(context, "Something went wrong. Please try again.");
    }
  }

  Future<void> fetchProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      profileImagePath = prefs.getString('user_profile_image');

      if (token == null) return;

      final dioClient = dio.Dio();
      dioClient.options.headers["Authorization"] = "Bearer $token";
      dioClient.options.headers["Accept"] = "application/json";

      final response =
          await dioClient.get('https://backend.jobizoindia.com/api/profile');

      final user = response.data['user'];
      if (user == null || user['email'] == null) return;

      setState(() {
        emailController.text = user['email'] ?? '';
        nameController.text = user['name'] ?? '';
        phoneController.text = user['phone'] ?? '';
        dobController.text = user['dob'] ?? '';
        bioController.text = user['bio'] ?? '';
        locationController.text = user['address'] ?? '';
        skillsController.text = user['skills'] ?? '';
        experienceController.text = user['experience'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> pickDate() async {
    DateTime initialDate = selectedDate ?? DateTime(2000, 1, 01);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: const Color(0xFFFAC015),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFFAC015)),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dobController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAC015),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: primary(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: updateProfile,
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFFAC015),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: tertiary(),
                ),
              ),
            ),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: AppColors.gold,
            ))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Material(
                            elevation: 10,
                            shape: const CircleBorder(),
                            shadowColor: Colors.grey,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: AppColors.gold,
                              backgroundImage: pickedImage != null
                                  ? FileImage(File(pickedImage!.path))
                                  : (profileImagePath != null &&
                                          profileImagePath!.isNotEmpty)
                                      ? NetworkImage(
                                          "https://backend.jobizoindia.com/storage/$profileImagePath")
                                      : null,
                              child: (pickedImage == null &&
                                      (profileImagePath == null ||
                                          profileImagePath!.isEmpty))
                                  ? const Icon(Icons.person,
                                      size: 60, color: Colors.white)
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: GestureDetector(
                              onTap: () async {
                                final XFile? image = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                if (image != null) {
                                  setState(() {
                                    pickedImage = image;
                                  });
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: const Color(0xFFFAC015),
                                radius: 16,
                                child: const Icon(Icons.camera_alt,
                                    size: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    buildTextField('Full Name', nameController,
                        hint: 'Enter your full name'),
                    buildTextField('Email', emailController, readOnly: true),
                    buildTextField('Phone Number', phoneController,
                        hint: 'Enter your phone number'),
                    buildDatePickerField(
                        'Date of Birth', dobController, pickDate),
                    buildTextField('Bio', bioController,
                        maxLines: 3, hint: 'Enter your bio'),
                    buildTextField('Location', locationController,
                        hint: 'Enter your location'),
                    buildTextField('Skills', skillsController,
                        hint: 'eg. Plumber'),
                    buildTextField('Experience', experienceController,
                        hint: 'eg. 4 Yrs'),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    String? hint,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: secondary(),
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            readOnly: readOnly,
            validator: (value) {
              if (!readOnly && (value == null || value.trim().isEmpty)) {
                return "This field is required";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: hint ?? '',
              contentPadding: const EdgeInsets.all(12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFFAC015),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.red.shade600, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.red.shade600, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDatePickerField(
    String label,
    TextEditingController controller,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: secondary(),
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            readOnly: true,
            onTap: onTap,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please select your date of birth";
              }
              return null;
            },
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.calendar_today),
              contentPadding: const EdgeInsets.all(12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFFFAC015), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.red.shade600, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.red.shade600, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
