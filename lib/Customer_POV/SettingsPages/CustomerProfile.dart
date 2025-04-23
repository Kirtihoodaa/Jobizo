import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import '../../Design contraints/FontSizes.dart';
import '../AppBar/commonAppBar.dart';

class Customerprofile extends StatefulWidget {
  const Customerprofile({super.key});

  @override
  State<Customerprofile> createState() => _CustomerprofileState();
}

class _CustomerprofileState extends State<Customerprofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: "My Profile"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.gold,
                    backgroundImage: NetworkImage(
                      'https://i.imgur.com/BoN9kdC.png',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deepak',
                          style: TextStyle(
                            fontSize: secondary(),
                            fontWeight: FontWeight.w600,
                            color: AppColors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'd@email.com',
                          style: TextStyle(
                            fontSize: tertiary(),
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            elevation: 0,
                          ),
                          onPressed: () {
                            // TODO: navigate to edit profile screen
                          },
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: tertiary(),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Personal Information ────────────────────────────────────────────
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

                  _buildInfoRow('First Name', 'Murali'),
                  const Divider(height: 1),

                  _buildInfoRow('Last Name', 'Monohar'),
                  const Divider(height: 1),

                  _buildInfoRow('Email', 'muralimanohar@email.com'),
                  const Divider(height: 1),

                  _buildInfoRow('Phone Number', '+91 8856554432'),
                  const Divider(height: 1),

                  _buildInfoRow('Date of Birth', 'January 15, 1990'),
                  const Divider(height: 1),

                  _buildInfoRow('Location', 'Mumbai, India'),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Helper for label/value rows in personal info
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: tertiary(),

            ),
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
