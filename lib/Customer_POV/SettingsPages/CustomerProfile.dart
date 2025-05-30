import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import '../../Design contraints/FontSizes.dart';
import '../AppBar/commonAppBar.dart';

class Customerprofile extends StatefulWidget {
  const Customerprofile({super.key});

  @override
  State<Customerprofile> createState() => _CustomerprofileState();
}

class _CustomerprofileState extends State<Customerprofile> {
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
        print('❌ No token found');
        return;
      }

      final dio = Dio();
      dio.options.headers["Authorization"] = "Bearer $token";

      final response = await dio.get('https://backend.jobizoindia.com/api/profile');

      if (response.statusCode == 200) {
        setState(() {
          userData = response.data['user'];
          isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error fetching profile: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: AppColors.gold,)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: "My Profile"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.gold,
                    backgroundImage: userData?['image'] != null &&
                        userData!['image'].toString().isNotEmpty
                        ? NetworkImage(
                        "https://backend.jobizoindia.com/storage/${userData!['image']}")
                        : null,
                    child: userData?['image'] == null ||
                        userData!['image'].toString().isEmpty
                        ? const Icon(Icons.person,
                        size: 60, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userData?['name'] ?? 'N/A',
                          style: TextStyle(
                            fontSize: secondary(),
                            fontWeight: FontWeight.w600,
                            color: AppColors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userData?['email'] ?? 'N/A',
                          style: TextStyle(
                            fontSize: tertiary(),
                            color: Colors.grey[700],
                          ),
                        ),
                        // const SizedBox(height: 12),
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: AppColors.gold,
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(20)),
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 20, vertical: 8),
                        //     elevation: 0,
                        //   ),
                        //   onPressed: () {
                        //     // TODO: navigate to edit profile screen
                        //   },
                        //   child: Text(
                        //     'Edit Profile',
                        //     style: TextStyle(
                        //       fontSize: tertiary(),
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: primary(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildInfoRow('Full Name', userData?['name'] ?? 'N/A'),
                  const Divider(height: 1),

                  _buildInfoRow('Email', userData?['email'] ?? 'N/A'),
                  const Divider(height: 1),

                  _buildInfoRow('Phone Number', userData?['phone'] ?? 'N/A'),
                  const Divider(height: 1),

                  _buildInfoRow('Date of Birth', userData?['dob'] ?? 'N/A'),
                  const Divider(height: 1),

                  _buildInfoRow('Location', userData?['address'] ?? 'N/A'),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: tertiary()),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: tertiary(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}