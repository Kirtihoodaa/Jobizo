import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import '../../Design contraints/FontSizes.dart';
import 'EditProfile.dart';

class MyProfilePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.gold,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'My Profile',
          style: TextStyle(fontSize: primary(),
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ─────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.gold,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rajesh Kumar',
                          style: TextStyle(
                            fontSize: secondary(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'rajeshkumar@email.com',
                          style: TextStyle(
                            fontSize: tertiary(),
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:AppColors.gold,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 2),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>EditProfileScreen() ));
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
            _divider(),
            SizedBox(height: 10,),

            // ─── Section Title ───────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: secondary(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // ─── Info List ───────────────────────────────────────
            _infoRow('First Name', 'Rajesh'),
            _divider(),
            _infoRow('Last Name', 'Kumar'),
            _divider(),
            _infoRow('Email', 'Priya@email.com'),
            _divider(),
            _infoRow('Phone Number', '+91 8856554432'),
            _divider(),
            _infoRow('Date of Birth', 'January 15, 1990'),
            _divider(),
            _infoRow('Location', 'Mumbai, India'),
            _divider(),
            _infoRow('Skills', 'Plumbing, Electrician'),
            _divider(),
            _infoRow('Experience', '4 Years'),
            _divider(),

            // ─── Bio ─────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                'Bio',
                style: TextStyle(
                  fontSize: secondary(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                'Product Designer with 5+ years of experience in creating user‑centered digital experiences.',
                style: TextStyle(
                  fontSize: tertiary(),
                  color: Colors.grey[800],
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                fontSize: tertiary(),
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: tertiary(),
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(height: 2, thickness: 1, color: Color(0xFFF9FAFB),);
}
