import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For TextInputFormatter
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class WorkApplicationForm extends StatefulWidget {
  const WorkApplicationForm({super.key});

  @override
  State<WorkApplicationForm> createState() => _WorkApplicationFormState();
}

class _WorkApplicationFormState extends State<WorkApplicationForm> {
  // Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _motivationController = TextEditingController();

  // Files
  File? _resumeFile;
  File? _coverLetterFile;
  File? _photoIdFile;

  // Pick File
  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _locationController.dispose();
    _positionController.dispose();
    _experienceController.dispose();
    _salaryController.dispose();
    _educationController.dispose();
    _motivationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: 'Work Application'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildDropdownField(),
              const SizedBox(height: 20),

              // Personal Information
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _containerDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Personal Information',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.green)),
                    const SizedBox(height: 16),
                    _buildLabel('Name'),
                    _buildTextField(
                      controller: _fullNameController,
                      keyboardType: TextInputType.name,
                      hintText: 'Enter your full name',
                    ),
                    _buildLabel('Email Address'),
                    _buildTextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'Enter your email',
                    ),
                    _buildLabel('Phone Number'),
                    _buildPhoneNumberField(), // << Updated this
                    _buildLabel('Date of Birth'),
                    _buildDateField(context),
                    _buildLabel('Current Location'),
                    _buildTextField(
                      controller: _locationController,
                      keyboardType: TextInputType.text,
                      hintText: 'Enter your location',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Professional Details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _containerDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Professional Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.green)),
                    const SizedBox(height: 16),
                    _buildLabel('Current/Last Position'),
                    _buildTextField(
                      controller: _positionController,
                      keyboardType: TextInputType.text,
                      hintText: 'Enter your position',
                    ),
                    _buildLabel('Years of Experience'),
                    _buildTextField(
                      controller: _experienceController,
                      keyboardType: TextInputType.number,
                      hintText: 'Enter your experience',
                    ),
                    _buildLabel('Current/Expected Salary'),
                    _buildTextField(
                      controller: _salaryController,
                      keyboardType: TextInputType.number,
                      hintText: 'Enter your salary',
                    ),
                    _buildLabel('Education Level'),
                    _buildTextField(
                      controller: _educationController,
                      keyboardType: TextInputType.text,
                      hintText: 'Enter education level',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Required Documents
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _containerDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Required Documents',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.green)),
                    const SizedBox(height: 16),
                    _buildLabel('Upload Resume/CV'),
                    _buildUploadField(
                        file: _resumeFile,
                        onPressed: () async {
                          final file = await pickFile();
                          if (file != null) {
                            setState(() {
                              _resumeFile = file;
                            });
                          }
                        }),
                    _buildLabel('Upload Cover Letter'),
                    _buildUploadField(
                        file: _coverLetterFile,
                        onPressed: () async {
                          final file = await pickFile();
                          if (file != null) {
                            setState(() {
                              _coverLetterFile = file;
                            });
                          }
                        }),
                    _buildLabel('Upload Photo ID'),
                    _buildUploadField(
                        file: _photoIdFile,
                        onPressed: () async {
                          final file = await pickFile();
                          if (file != null) {
                            setState(() {
                              _photoIdFile = file;
                            });
                          }
                        }),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Motivation
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _containerDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Why do you want to join us?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _motivationController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Tell us about your motivation...',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.gold, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.gold, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    _showSubmittedDialog();
                  },
                  child: const Text('Start Your Journey',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showSubmittedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle,
                  color: Color(0xFF62A910), size: 48),
              const SizedBox(height: 16),
              const Text(
                'Request Submitted',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF62A910)),
              ),
              const SizedBox(height: 12),
              const Text(
                'Thank you for applying for the Office Manager position at Jobizo.\n\nWe’ve received your application and will review it shortly and report to your Personal Mail.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              RichText(
                text: const TextSpan(
                  text: 'Application ID ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF62A910),
                      fontSize: 14),
                  children: [
                    TextSpan(
                      text: 'TB58856CRI876',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required TextInputType keyboardType,
    String? hintText,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gold, width: 2),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return _buildTextField(
      controller: _phoneController,
      keyboardType: TextInputType.number,
      hintText: 'Enter your 10-digit phone number',
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Allow only digits
        LengthLimitingTextInputFormatter(10), // Limit to 10 digits
      ],
    );
  }

  Widget _buildDateField(BuildContext context) {
    return TextFormField(
      controller: _dobController,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Select Date',
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gold, width: 2),
        ),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(2001, 2, 5),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColors.gold,
                  onSurface: Colors.black,
                  surface: AppColors.bgColor,
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          _dobController.text =
              '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
        }
      },
    );
  }

  Widget _buildUploadField(
      {required File? file, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            hintText: file != null ? file.path.split('/').last : 'Select File',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.gold, width: 2),
            ),
            suffixIcon: const Icon(Icons.cloud_upload),
            hintStyle: const TextStyle(fontWeight: FontWeight.normal),
          ),
          textAlign: TextAlign.center,
          readOnly: true,
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _containerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Position',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.green)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: 'Select Role',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.gold, width: 2),
              ),
            ),
            dropdownColor: AppColors.bgColor,
            borderRadius: BorderRadius.circular(12),
            items: const [
              DropdownMenuItem(value: 'role1', child: Text('Role 1')),
              DropdownMenuItem(value: 'role2', child: Text('Role 2')),
            ],
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}
