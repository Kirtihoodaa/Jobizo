// lib/Customer_POV/ActiveLabours.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobizo/Design contraints/app color.dart';
import 'package:jobizo/Design contraints/FontSizes.dart';
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

  @override
  Widget build(BuildContext context) {
    final darkBrown = AppColors.brown;

    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: const Commonappbar(title: 'Active Labours'),
        body: const Center(child: CircularProgressIndicator()),
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
                    style: TextStyle(
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
    // Always use the asset placeholder for the left icon
    const placeholder = AssetImage('Assets/Customer_Images/List_icon.png');

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
            // Fixed logo/avatar placeholder
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: placeholder,
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
                      const Icon(Icons.person, size: 16, color: AppColors.green),
                      const SizedBox(width: 4),
                      Text(agent['name'] ?? 'null'),
                      const Spacer(),
                      Text(
                        'ID: ${agent['labour_id'] ?? 'null'}',
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
                      Expanded(child: Text(agent['location'] ?? 'null')),
                      const Icon(Icons.phone, size: 16, color: AppColors.green),
                      const SizedBox(width: 4),
                      Text(agent['phone'] ?? 'null'),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Email
                  Row(
                    children: [
                      const Icon(Icons.email, size: 16, color: AppColors.green),
                      const SizedBox(width: 4),
                      Expanded(child: Text(agent['email'] ?? 'null')),
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
