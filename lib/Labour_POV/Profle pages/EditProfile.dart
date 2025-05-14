import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Design contraints/FontSizes.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isLoading = true;
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
  Future<void> updateProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        print("⚠️ Token not found");
        return;
      }
      final skillsText = skillsController.text.trim();
      final List<String> skillsArray = skillsText.isEmpty
          ? []
          : skillsText.split(',').map((e) => e.trim()).toList();
      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer $token";
      // final formData = FormData.fromMap({
      //   "name": nameController.text.trim(),
      //   "email": emailController.text.trim(),
      //   "phone": phoneController.text.trim(),
      //   "dob": dobController.text.trim(),
      //   "address": locationController.text.trim(),
      //   "bio": bioController.text.trim(),
      //   "experience": experienceController.text.trim(),
      //   "skills": skillsArray.join(','),
      //   if (pickedImage != null)
      //     "image": await MultipartFile.fromFile(
      //       pickedImage!.path,
      //       filename: pickedImage!.name,
      //     ),
      // });
      // final response = await dio.post(
      //   'https://backend.jobizoindia.com/api/profile',
      //   data: formData,
      // );

      final response = await dio.post(
        'https://backend.jobizoindia.com/api/profile',
        data: {
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": phoneController.text.trim(),
          "dob": dobController.text.trim(),
          "address": locationController.text.trim(),
          "bio": bioController.text.trim(),
          "experience": experienceController.text.trim(),
          "skills": skillsArray, // ✅ array
        },
      );

      if (response.statusCode == 200) {
        print("✅ Profile updated successfully: ${response.data}");
        Navigator.pop(context, 'refresh');
      } else {
        print("❌ Failed to update: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfileData();
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
        emailController.text = user['email'];
        isLoading = false;
      });
    } catch (e) {
      print("❌ Exception: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> pickDate() async {
    DateTime initialDate = selectedDate ?? DateTime(1990, 1, 15);
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
              primary: const Color(0xFFFAC015), // Your accent color
              onPrimary: Colors.white, // Text color on header
              onSurface: Colors.black, // Text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFAC015), // Button text color
              ),
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
          onPressed: () => Navigator.of(context).pop(),
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
              onPressed: () {
                updateProfile();
              },
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      backgroundColor: Colors.white,
                      backgroundImage: pickedImage != null
                          ? FileImage(File(pickedImage!.path))
                          : NetworkImage('https://i.imgur.com/BoN9kdC.png')
                              as ImageProvider,
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
                            pickedImage =
                                image; // store in your global variable
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
            buildDatePickerField('Date of Birth', dobController, pickDate),
            buildTextField('Bio', bioController,
                maxLines: 3, hint: 'Enter your bio'),
            buildTextField('Location', locationController,
                hint: 'Enter your location'),
            buildTextField('Skills', skillsController, hint: 'eg. Plumber'),
            buildTextField('Experience', experienceController,
                hint: 'eg. 4 Yrs'),
          ],
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
          TextField(
            controller: controller,
            maxLines: maxLines,
            readOnly: readOnly,
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
          TextField(
            controller: controller,
            readOnly: true,
            onTap: onTap,
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.calendar_today),
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
            ),
          ),
        ],
      ),
    );
  }
}
