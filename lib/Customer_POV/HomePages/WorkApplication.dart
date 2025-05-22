import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';

import '../../SnackBar/Snackbar.dart';

class WorkApplicationForm extends StatefulWidget {
  const WorkApplicationForm({super.key});

  @override
  State<WorkApplicationForm> createState() => _WorkApplicationFormState();
}

class _WorkApplicationFormState extends State<WorkApplicationForm> {
  // Controllers
  final _formKey              = GlobalKey<FormState>();
  final _fullNameController   = TextEditingController();
  final _emailController      = TextEditingController();
  final _phoneController      = TextEditingController();
  final _dobController        = TextEditingController();
  final _locationController   = TextEditingController();
  final _positionController   = TextEditingController();
  final _experienceController = TextEditingController();
  final _salaryController     = TextEditingController();
  final _educationController  = TextEditingController();
  final _motivationController = TextEditingController();

  // Role
  String? _selectedRole;

  // Files
  File? _resumeFile;
  File? _coverLetterFile;
  File? _photoIdFile;

  bool _isSubmitting = false;

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

  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  Future<File?> pickPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate() || _selectedRole == null) {
      SnackbarHelper.showError(context, 'Please fill all fields including role');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token') ?? '';
      if (!token.startsWith('Bearer ')) token = 'Bearer $token';

      final dob = DateFormat('yyyy-MM-dd').parse(_dobController.text);
      final dobFormatted = DateFormat('yyyy-MM-dd').format(dob);

      final dio = Dio(BaseOptions(headers: {'Authorization': token}));
      final form = FormData.fromMap({
        'name':                _fullNameController.text.trim(),
        'role':                _selectedRole!,
        'email':               _emailController.text.trim(),
        'phone':               _phoneController.text.trim(),
        'dob':                 dobFormatted,
        'location':            _locationController.text.trim(),
        'last_position':       _positionController.text.trim(),
        'years_of_experience': _experienceController.text.trim(),
        'expected_salary':     _salaryController.text.trim(),
        'education':           _educationController.text.trim(),
        'joining_description': _motivationController.text.trim(),
        if (_resumeFile != null)
          'resume': await MultipartFile.fromFile(
            _resumeFile!.path,
            filename: _resumeFile!.path.split('/').last,
          ),
        if (_coverLetterFile != null)
          'cover_letter': await MultipartFile.fromFile(
            _coverLetterFile!.path,
            filename: _coverLetterFile!.path.split('/').last,
          ),
        if (_photoIdFile != null)
          'photo': await MultipartFile.fromFile(
            _photoIdFile!.path,
            filename: _photoIdFile!.path.split('/').last,
          ),
      });

      final response = await dio.post(
        'https://backend.jobizoindia.com/api/job-application',
        data: form,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('POST /job-application response body: ${response.data}');
        final appId = response.data['application_id'] as String? ?? '–';
        if (mounted) _showSubmittedDialog(appId);
      } else {
        SnackbarHelper.showError(context, 'Failed (${response.statusCode})');
      }

    } catch (e) {
      SnackbarHelper.showError(context, 'Error: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showSubmittedDialog(String applicationId) {
    print('Generated application_id: $applicationId');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF62A910), size: 48),
            const SizedBox(height: 16),
            const Text(
              'Application Submitted',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF62A910),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Thank you for applying. We’ve received your application and will review it shortly.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                Text(
                  'Application ID',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF62A910),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  applicationId,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }




  Widget _buildDropdownField() {
    const roles = ['Office Manager', 'Franchise', 'HR', 'Agent', 'Vendor'];
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        hintText: 'Select Role',
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.gold, width: 2)),
      ),
      value: _selectedRole,
      items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
      onChanged: (v) => setState(() => _selectedRole = v),
      validator: (v) => v == null ? 'Role is required' : null,
    );
  }

  BoxDecoration _containerDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 3))],
  );

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 16),
    child: Text(text, style:  TextStyle(fontWeight: FontWeight.bold)),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required TextInputType keyboardType,
    String? hintText,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        suffixIcon: readOnly
            ? Icon(Icons.calendar_today, color: AppColors.gold)
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.gold, width: 2)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: 'Work Application'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Position Dropdown
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _containerDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Select Position'),
                      _buildDropdownField(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Personal Information
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _containerDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Personal Information', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.green)),
                      const SizedBox(height: 16),
                      _buildLabel('Name'),
                      _buildTextField(
                        controller: _fullNameController,
                        keyboardType: TextInputType.name,
                        hintText: 'Enter your full name',
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      _buildLabel('Email Address'),
                      _buildTextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        hintText: 'Enter your email',
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      _buildLabel('Phone Number'),
                      _buildTextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                        hintText: 'Enter your 10-digit phone number',
                        validator: (v) => v == null || v.length != 10 ? 'Enter 10 digits' : null,
                      ),
                      _buildLabel('Date of Birth'),
                      _buildTextField(
                        controller: _dobController,
                        keyboardType: TextInputType.datetime,
                        hintText: 'YYYY-MM-DD',
                        readOnly: true,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2001, 1, 1),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: AppColors.gold,
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
                          }
                        },
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),


                      _buildLabel('Current Location'),
                      _buildTextField(
                        controller: _locationController,
                        keyboardType: TextInputType.text,
                        hintText: 'Enter your location',
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
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
                      Text('Professional Details', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.green)),
                      const SizedBox(height: 16),
                      _buildLabel('Current/Last Position'),
                      _buildTextField(
                        controller: _positionController,
                        keyboardType: TextInputType.text,
                        hintText: 'Enter your position',
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      _buildLabel('Years of Experience'),
                      _buildTextField(
                        controller: _experienceController,
                        keyboardType: TextInputType.number,
                        hintText: 'Enter your experience',
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      _buildLabel('Current/Expected Salary'),
                      _buildTextField(
                        controller: _salaryController,
                        keyboardType: TextInputType.number,
                        hintText: 'Enter your salary',
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      _buildLabel('Education Level'),
                      _buildTextField(
                        controller: _educationController,
                        keyboardType: TextInputType.text,
                        hintText: 'Enter education level',
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
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
                      Text('Required Documents', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.green)),
                      const SizedBox(height: 16),
                      _buildLabel('Upload Resume/CV'),
                      GestureDetector(
                        onTap: () async {
                          final file = await pickPdfFile();
                          if (file != null) setState(() => _resumeFile = file);
                        },
                        child: AbsorbPointer(
                          child: _buildTextField(
                            controller: TextEditingController(text: _resumeFile?.path.split('/').last),
                            keyboardType: TextInputType.text,
                            hintText: 'Select File (PDF only)',
                          ),
                        ),
                      ),
                      _buildLabel('Upload Cover Letter'),
                      GestureDetector(
                        onTap: () async {
                          final file = await pickPdfFile();
                          if (file != null) setState(() => _coverLetterFile = file);
                        },
                        child: AbsorbPointer(
                          child: _buildTextField(
                            controller: TextEditingController(text: _coverLetterFile?.path.split('/').last),
                            keyboardType: TextInputType.text,
                            hintText: 'Select File (PDF only)',
                          ),
                        ),
                      ),
                      _buildLabel('Upload Photo ID'),
                      GestureDetector(
                        onTap: () async {
                          final file = await pickFile();
                          if (file != null) setState(() => _photoIdFile = file);
                        },
                        child: AbsorbPointer(
                          child: _buildTextField(
                            controller: TextEditingController(text: _photoIdFile?.path.split('/').last),
                            keyboardType: TextInputType.text,
                            hintText: 'Select File',
                          ),
                        ),
                      ),
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
                      Text(
                        'Why do you want to join us?',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.green),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _motivationController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: 'Tell us your motivation…',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.gold, width: 2)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: _isSubmitting ? null : () => _submitApplication(),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Start Your Journey', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
