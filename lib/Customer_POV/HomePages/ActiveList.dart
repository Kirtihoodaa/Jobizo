import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import '../../Design contraints/FontSizes.dart';
import '../AppBar/commonAppBar.dart';

class Activelist extends StatefulWidget {
  const Activelist({super.key});

  @override
  State<Activelist> createState() => _ActivelistState();
}

class _ActivelistState extends State<Activelist> {
  final int availableAgents = 24;

  final List<Map<String, String>> agents = [
    {
      'company': 'Thomas Plumbing co',
      'name': 'Robert Mitchell',
      'id': 'VEN-2024-001',
      'location': 'Delhi, India',
      'phone': '+91 7867898832',
      'email': 'r.mitchell@globaltech.com',
    },
    {
      'company': 'Thomas Plumbing co',
      'name': 'Robert Mitchell',
      'id': 'VEN-2024-002',
      'location': 'Delhi, India',
      'phone': '+91 7867898833',
      'email': 'r.mitchell2@globaltech.com',
    },
    {
      'company': 'Thomas Plumbing co',
      'name': 'Robert Mitchell',
      'id': 'VEN-2024-003',
      'location': 'Delhi, India',
      'phone': '+91 7867898834',
      'email': 'r.mitchell3@globaltech.com',
    },
  ];

  @override
  Widget build(BuildContext context) {
    Color darkBrown = AppColors.brown;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: 'Active List'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Available Agents Card
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
                    'Available Agents',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Center(
                        child: Text(
                          '-$availableAgents-',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // List of Agent Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children:
                    agents.map((agent) => _buildAgentCard(agent)).toList(),
              ),
            ),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAgentCard(Map<String, String> agent) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo placeholder
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade200,
              child: Icon(Icons.business, size: 32, color: AppColors.green),
            ),
            SizedBox(width: 16),

            // Agent details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company name
                  Text(
                    agent['company']!,
                    style: TextStyle(
                      fontSize: secondary(),
                      fontWeight: FontWeight.bold,
                      color: AppColors.green,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Name & ID
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.person,
                                size: 16, color: AppColors.green),
                            const SizedBox(width: 4),
                            Text(agent['name']!),
                          ],
                        ),
                      ),
                      Text(
                        'ID: ${agent['id']}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Location & Phone
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 16, color: AppColors.green),
                            SizedBox(width: 4),
                            Text(agent['location']!),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 16, color: AppColors.green),
                          SizedBox(width: 4),
                          Text(agent['phone']!),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Email
                  Row(
                    children: [
                      Icon(Icons.email, size: 16, color: AppColors.green),
                      SizedBox(width: 4),
                      Expanded(child: Text(agent['email']!)),
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
