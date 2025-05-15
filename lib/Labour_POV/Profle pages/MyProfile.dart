import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Design contraints/FontSizes.dart';
import 'EditProfile.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

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
        print('No auth token found');
        setState(() => isLoading = false);
        return;
      }
      final dio = Dio();
      // Replace with your real token or header logic
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await dio.get('https://backend.jobizoindia.com/api/profile');

      setState(() {
        userData = response.data['user'];
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userData == null) {
      return const Scaffold(
        body: Center(child: Text("Failed to load profile")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.gold,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'My Profile',
          style: TextStyle(
              fontSize: primary(),
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.gold,
                    child:
                        const Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData!['name'] ?? '',
                          style: TextStyle(
                              fontSize: secondary(),
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userData!['email'] ?? '',
                          style: TextStyle(
                              fontSize: tertiary(), color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 2),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => EditProfileScreen()));
                          },
                          child: Text('Edit Profile',
                              style: TextStyle(
                                  fontSize: tertiary(), color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            _divider(),
            const SizedBox(height: 10),

            // Personal Info
            _sectionTitle('Personal Information'),
            _infoRow('Name', userData!['name'] ?? ''),
            _divider(),
            _infoRow('Email', userData!['email'] ?? ''),
            _divider(),
            _infoRow('Phone Number', userData!['phone'] ?? ''),
            _divider(),
            _infoRow('Date of Birth', userData!['dob'] ?? 'N/A'),
            _divider(),
            _infoRow('Location', userData!['address'] ?? 'N/A'),
            _divider(),
            _infoRow(
              'Skills',
              (() {
                final skillsRaw = userData!['skills'];
                if (skillsRaw == null) return 'N/A';
                try {
                  final parsed = json.decode(skillsRaw);
                  if (parsed is List) {
                    return parsed.join(' , ');
                  } else {
                    return skillsRaw.toString();
                  }
                } catch (e) {
                  return skillsRaw.toString();
                }
              })(),
            ),
            _divider(),
            _infoRow('Experience', userData!['experience'] ?? 'N/A'),
            _divider(),

            // Bio Section
            _sectionTitle('Bio'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                userData!['bio'] ?? 'No bio added.',
                style: TextStyle(fontSize: tertiary(), color: Colors.grey[800]),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Align(
          child: Text(title,
              style: TextStyle(
                  fontSize: secondary(), fontWeight: FontWeight.w600)),
        ),
      );

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(label,
                  style: TextStyle(fontSize: tertiary(), color: Colors.black)),
            ),
            Expanded(
              flex: 4,
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: tertiary(), color: Colors.black)),
            ),
          ],
        ),
      );

  Widget _divider() =>
      const Divider(height: 2, thickness: 1, color: Color(0xFFF9FAFB));
}
