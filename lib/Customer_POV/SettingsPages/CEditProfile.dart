import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import '../../Design contraints/FontSizes.dart';

class Ceditprofile extends StatefulWidget {
  const Ceditprofile({super.key});

  @override
  State<Ceditprofile> createState() => _CeditprofileState();
}

class _CeditprofileState extends State<Ceditprofile> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl     = TextEditingController(text: 'Murali Monohar');
  final _emailCtrl    = TextEditingController(text: 'muralimanohar@email.com');
  final _phoneCtrl    = TextEditingController(text: '+91 8856554432');
  final _dobCtrl      = TextEditingController(text: '1990-01-15');
  final _locationCtrl = TextEditingController(text: 'Mumbai');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _dobCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(_dobCtrl.text),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: AppColors.gold,    // header & selected day
              onPrimary: Colors.white,    // text color on selected day
              onSurface: Colors.black,    // default text color
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
      _dobCtrl.text = picked.toIso8601String().split('T').first;
    }
  }


  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // TODO: save logic
      Navigator.pop(context);
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
        borderSide: BorderSide(color: AppColors.green),
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
              onPressed: _saveProfile,
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
                        radius: 60,
                        backgroundImage:
                        NetworkImage('https://i.imgur.com/BoN9kdC.png'),
                      ),
                    ),
                    Positioned(
                      right: -4,
                      bottom: -4,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: pick image
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
                  decoration:
                  _fieldDecoration(hint: 'Enter full name'),
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(height: 16),

              // Email
              _buildLabeledField(
                'Email',
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _fieldDecoration(hint: 'Enter email'),
                  validator: (v) =>
                  v != null && v.contains('@') ? null : 'Invalid email',
                ),
              ),
              const SizedBox(height: 16),

              // Phone Number
              _buildLabeledField(
                'Phone Number',
                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: _fieldDecoration(hint: '+91 ...'),
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
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
                      icon:
                      const Icon(Icons.calendar_today_outlined),
                      onPressed: _pickDate,
                    ),
                  ),
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(height: 16),

              // Location
              _buildLabeledField(
                'Location',
                TextFormField(
                  controller: _locationCtrl,
                  decoration:
                  _fieldDecoration(hint: 'Enter location'),
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
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
            style: TextStyle(
                fontSize: tertiary(), fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        SizedBox(height: 48, child: field),
      ],
    );
  }
}
