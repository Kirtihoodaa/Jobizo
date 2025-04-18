import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../../Design contraints/FontSizes.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController =
  TextEditingController(text: 'Rajesh Kumar');
  final TextEditingController emailController =
  TextEditingController(text: 'rajeshkumar@email.com');
  final TextEditingController phoneController =
  TextEditingController(text: '+91 8856554432');
  final TextEditingController dobController =
  TextEditingController(text: '15-01-1990');
  final TextEditingController bioController = TextEditingController(
      text:
      'Product Designer with 5+ years of experience in creating user-centered digital experiences.');
  final TextEditingController locationController =
  TextEditingController(text: 'Mumbai');
  final TextEditingController skillsController =
  TextEditingController(text: 'Plumbing, Electrician');
  final TextEditingController experienceController =
  TextEditingController(text: '4 Yrs');

  DateTime? selectedDate;

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
                // Save functionality
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
                      backgroundImage: NetworkImage(
                          'https://i.imgur.com/BoN9kdC.png'),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFFFAC015),
                      radius: 16,
                      child: const Icon(Icons.camera_alt,
                          size: 20, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            buildTextField('Full Name', nameController),
            buildTextField('Email', emailController),
            buildTextField('Phone Number', phoneController),
            buildDatePickerField('Date of Birth', dobController, pickDate),
            buildTextField('Bio', bioController, maxLines: 3),
            buildTextField('Location', locationController),
            buildTextField('Skills', skillsController, hint: 'eg. Plumber'),
            buildTextField('Experience', experienceController, hint: 'eg. 4 Yrs'),
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
