// lib/Customer_POV/ActiveLabours.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import '../AppBar/commonAppBar.dart';

class Activelist extends StatefulWidget {
  const Activelist({super.key});

  @override
  State<Activelist> createState() => _ActivelistState();
}

class _ActivelistState extends State<Activelist> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _agents = [];

  @override
  void initState() {
    super.initState();
    _fetchActiveLabours();
  }

  Future<void> _fetchActiveLabours() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token') ?? '';
      if (!token.startsWith('Bearer ')) token = 'Bearer $token';

      final resp = await Dio(BaseOptions(headers: {'Authorization': token}))
          .get(
        'https://backend.jobizoindia.com/api/active-labours',
        options: Options(validateStatus: (s) => s != null && s < 500),
      );

      final body = resp.data as Map<String, dynamic>;
      if (resp.statusCode == 200 && body['status'] == true) {
        _agents = List<Map<String, dynamic>>.from(body['active_labours']);
      } else {
        throw body['message'] ?? 'Failed to load';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() => _loading = false);
    }
  }

  String _capitalize(String? input) {
    if (input == null || input.isEmpty) return '';
    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final darkBrown = AppColors.brown;

    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: const Commonappbar(title: 'Active Labours'),
        body:
        const Center(child: CircularProgressIndicator(color: AppColors.gold)),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: const Commonappbar(title: 'Active Labours'),
        body: Center(child: Text(_error!)),
      );
    }

    final availableAgents = _agents.length;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: const Commonappbar(title: 'Active Labours'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Available Labours Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: darkBrown,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Labours',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '-$availableAgents-',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // List of Labour Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children:
                _agents.map((agent) => _buildAgentCard(agent)).toList(),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAgentCard(Map<String, dynamic> agent) {
    // Base URL for stored images
    const baseUrl = 'https://backend.jobizoindia.com/storage/';

    // If "image" exists, prepend base URL. Otherwise use placeholder.
    ImageProvider avatarImage;
    if (agent['image'] != null && (agent['image'] as String).isNotEmpty) {
      avatarImage = NetworkImage(baseUrl + agent['image'] as String);
    } else {
      avatarImage =
      const AssetImage('Assets/Customer_Images/List_icon.png');
    }

    // Safely read and capitalize name/location/email
    final name = _capitalize(agent['name'] as String?);
    final location = _capitalize(agent['location'] as String?);
    final email = (agent['email'] as String? ?? '');
    final phone = agent['phone'] as String? ?? '';
    final labourId = agent['labour_id']?.toString() ?? 'N/A';

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo/avatar
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: avatarImage,
            ),
            const SizedBox(width: 16),

            // Labour details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & ID
                  Row(
                    children: [
                      const Icon(Icons.person,
                          size: 16, color: AppColors.green),
                      const SizedBox(width: 4),
                      Text(
                        name.isNotEmpty ? name : 'N/A',
                        style: TextStyle(fontSize: secondary()),
                      ),
                      const Spacer(),
                      Text(
                        'ID: $labourId',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Location & Phone
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: AppColors.green),
                      const SizedBox(width: 4),
                      Expanded(
                          child: Text(
                            location.isNotEmpty ? location : 'N/A',
                            style: TextStyle(fontSize: tertiary()),
                          )),
                      const Icon(Icons.phone,
                          size: 16, color: AppColors.green),
                      const SizedBox(width: 4),
                      Text(
                        phone.isNotEmpty ? phone : 'N/A',
                        style: TextStyle(fontSize: tertiary()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Email
                  Row(
                    children: [
                      const Icon(Icons.email,
                          size: 16, color: AppColors.green),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          email.isNotEmpty ? email : 'N/A',
                          style: TextStyle(fontSize: tertiary()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
