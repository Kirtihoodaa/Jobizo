import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../SnackBar/Snackbar.dart';

class AddComplaintPage extends StatefulWidget {
  const AddComplaintPage({super.key});

  @override
  _AddComplaintPageState createState() => _AddComplaintPageState();
}

class _AddComplaintPageState extends State<AddComplaintPage> {
  final TextEditingController nameController        = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController _dobController         = TextEditingController();
  final TextEditingController emailController       = TextEditingController();
  final TextEditingController phoneController       = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PlatformFile? selectedFile;
  bool _isSubmitting = false;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    _dobController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() => selectedFile = result.files.first);
    }
  }

  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    } else if (value.length != 10) {
      return 'Phone number must be 10 digits';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Phone number must contain only digits';
    }
    return null;
  }

  Future<void> _submitComplaint() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);
    try {
      // Get auth token
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token') ?? '';
      if (!token.startsWith('Bearer ')) token = 'Bearer $token';

      // Convert dd/MM/yyyy → yyyy-MM-dd
      final incidentDate = DateFormat('dd/MM/yyyy').parse(_dobController.text);
      final formattedDate = DateFormat('yyyy-MM-dd').format(incidentDate);

      // Build Dio with auth header
      final dio = Dio(BaseOptions(headers: {'Authorization': token}));

      // Prepare multipart form
      final form = FormData.fromMap({
        'name':             nameController.text.trim(),
        'description':      descriptionController.text.trim(),
        'date_of_incident': formattedDate,
        'contact_email':    emailController.text.trim(),
        'phone':            phoneController.text.trim(),
        if (selectedFile != null)
          'attachment': await MultipartFile.fromFile(
            selectedFile!.path!,
            filename: selectedFile!.name,
          ),
      });

      // POST to your complaints endpoint
      final response = await dio.post(
        'https://backend.jobizoindia.com/api/complaint',
        data: form,
      );

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final ticket = response.data['ticket_number'] ?? '–';
        if (mounted) {
          Navigator.of(context).pop();
          SnackbarHelper.showSuccess(
            context,
            'Complaint filed! Ticket: $ticket',
          );
        }
      } else {
        SnackbarHelper.showError(
          context,
          'Failed to file complaint (${response.statusCode})',
        );
      }
    } catch (e) {
      SnackbarHelper.showError(context, 'Error: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }


  Widget _buildDateField(BuildContext context) {
    return TextFormField(
      controller: _dobController,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Select Date',
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gold, width: 2),
        ),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (c, child) => Theme(
            data: Theme.of(c).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.gold,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          ),
        );
        if (picked != null) {
          _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
        }
      },
      validator: (v) => v == null || v.isEmpty ? 'Date is required' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: 'Add Complaint'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Form(
            key: _formKey,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 700,
              padding:  EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text('Name', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.gold),
                        ),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    const Text('Description', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Describe the issue in detail',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.gold),
                        ),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Description is required' : null,
                    ),
                    const SizedBox(height: 16),

                    // Date of Incident
                    const Text('Date of Incident', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    _buildDateField(context),
                    const SizedBox(height: 16),

                    // Contact Email
                    const Text('Contact Email', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'your@email.com',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.gold),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email is required';
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(v)) {
                          return 'Invalid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Phone Number
                    const Text('Phone Number', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                        hintText: 'Enter phone number',
                        counterText: '',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.gold),
                        ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: phoneValidator,
                    ),
                    const SizedBox(height: 16),

                    // Attachments
                    const Text('Attachments', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: pickFile,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            selectedFile?.name ?? 'Tap to upload a file',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit button
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitComplaint,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                              : const Text('File a Complaint', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
