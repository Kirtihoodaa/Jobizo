import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

// MODEL
class JobApplication {
  final int id;
  final String name;
  final String role;
  final String email;
  final String phone;
  final String dob;
  final String location;
  final String lastPosition;
  final String yearsOfExperience;
  final String expectedSalary;
  final String education;
  final String joiningDescription;
  final String? resume;
  final String? coverLetter;
  final String? photo;
  final String? status;
  final String applicationId;
  final String createdAt;

  JobApplication({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    required this.dob,
    required this.location,
    required this.lastPosition,
    required this.yearsOfExperience,
    required this.expectedSalary,
    required this.education,
    required this.joiningDescription,
    this.resume,
    this.coverLetter,
    this.photo,
    this.status,                  // ← include in constructor
    required this.applicationId,
    required this.createdAt,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      dob: json['dob'] as String? ?? '',
      location: json['location'] as String? ?? '',
      lastPosition: json['last_position'] as String? ?? '',
      yearsOfExperience: json['years_of_experience'] as String? ?? '',
      expectedSalary: json['expected_salary'] as String? ?? '',
      education: json['education'] as String? ?? '',
      joiningDescription: json['joining_description'] as String? ?? '',
      resume: json['resume'] as String?,
      coverLetter: json['cover_letter'] as String?,
      photo: json['photo'] as String?,
      status: json['status'] as String?,    // ← parse status
      applicationId: json['application_id'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}

// SCREEN
class ApplicationDetail extends StatefulWidget {
  final int applicationId;
  const ApplicationDetail({Key? key, required this.applicationId})
      : super(key: key);

  @override
  State<ApplicationDetail> createState() => _ApplicationDetailState();
}

class _ApplicationDetailState extends State<ApplicationDetail> {
  JobApplication? _app;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchApplication();
  }

  Future<void> _fetchApplication() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final resp = await dio.get(
        'https://backend.jobizoindia.com/api/job-application/${widget.applicationId}',
        options: Options(validateStatus: (_) => true),
      );

      if (resp.statusCode == null ||
          resp.statusCode! < 200 ||
          resp.statusCode! >= 300) {
        throw 'Server returned ${resp.statusCode}';
      }

      dynamic raw = resp.data;
      if (raw is String) raw = jsonDecode(raw);

      if (raw is! Map<String, dynamic> || raw['status'] != true) {
        throw 'Unexpected response format';
      }

      final ja = raw['job_application'] as Map<String, dynamic>;
      setState(() => _app = JobApplication.fromJson(ja));
    } catch (e) {
      setState(() => _error = 'Failed to load: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: const Commonappbar(title: "Application Details"),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    final a = _app!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildJobStatusCard(a),
          const SizedBox(height: 16),
          _buildPersonalInfoSection(a),
          const SizedBox(height: 16),
          _buildProfessionalDetailsSection(a),
          const SizedBox(height: 16),
          _buildDocumentsSection(a),
          const SizedBox(height: 16),
          _buildInfoCard(a),
        ],
      ),
    );
  }

  Widget _buildJobStatusCard(JobApplication a) {
    final appliedOn = a.createdAt.split('T').first;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(a.role,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: secondary())),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  a.status ?? 'Pending',              // ← now uses a.status
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16),
              const SizedBox(width: 4),
              Text("Applied on $appliedOn",
                  style: TextStyle(fontSize: tertiary())),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(JobApplication a) {
    return _buildSectionContainer(
      title: "Personal Information",
      child: Column(children: [
        _buildInfoRow(Icons.person_outline, "Full Name", a.name),
        _buildInfoRow(Icons.email_outlined, "Email Address", a.email),
        _buildInfoRow(Icons.phone_outlined, "Phone Number", a.phone),
        _buildInfoRow(Icons.calendar_today_outlined, "Date of Birth", a.dob),
        _buildInfoRow(Icons.location_on_outlined, "Location", a.location),
      ]),
    );
  }

  Widget _buildProfessionalDetailsSection(JobApplication a) {
    return _buildSectionContainer(
      title: "Professional Details",
      child: Column(children: [
        _buildInfoRow(Icons.work_outline, "Last Position", a.lastPosition),
        _buildInfoRow(Icons.access_time, "Experience", "${a.yearsOfExperience} years"),
        _buildInfoRow(Icons.attach_money, "Expected Salary", a.expectedSalary),
        _buildInfoRow(Icons.school_outlined, "Education", a.education),
      ]),
    );
  }

  Widget _buildDocumentsSection(JobApplication a) {
    return _buildSectionContainer(
      title: "Documents",
      child: Column(children: [
        _buildDocumentRow("Resume", a.resume),
        _buildDocumentRow("Cover Letter", a.coverLetter),
        _buildDocumentRow("Photo", a.photo),
      ]),
    );
  }

  Widget _buildInfoCard(JobApplication a) {
    return _buildSectionContainer(
      title: "Why do you want to join us?",
      child: Text(
        a.joiningDescription,
        style: TextStyle(fontSize: tertiary(), height: 1.4),
      ),
    );
  }

  Widget _buildSectionContainer({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: secondary(),
                  color: AppColors.green)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.green),
          const SizedBox(width: 12),
          Expanded(child: Text("$label: $value", style: TextStyle(fontSize: tertiary()))),
        ],
      ),
    );
  }

  Widget _buildDocumentRow(String label, String? path) {
    final fileName = path?.split('/').last ?? 'Not provided';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text("$label:", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Expanded(child: Text(fileName)),
          TextButton(onPressed: () {
            // TODO: implement download or preview
          }, child: const Text("Download"))
        ],
      ),
    );
  }
}
