import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Customer_POV/HomePages/WorkApplication.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class WorkOpportunitiesPage extends StatelessWidget {
  const WorkOpportunitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: 'Work'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Image
            Stack(
              children: [
                Image.asset(
                  'Assets/Customer_Images/work frame.png',
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color.fromRGBO(250, 192, 21, 0.76), // Yellowish
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Grow With Us Section
            Text(
              'Grow With Us',
              style: TextStyle(
                fontSize: primary(),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Transform from Customer to Business Partner',
              style: TextStyle(
                fontSize: secondary(),
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Yellow container with white boxes
            Container(
              color: AppColors.gold,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why Partner With Us?',
                    style: TextStyle(
                      fontSize: secondary(),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      // Your white cards data
                      final items = [
                        {
                          'icon': Icons.attach_money,
                          'title': 'Financial Growth',
                          'subtitle': 'Maximize your earnings potential'
                        },
                        {
                          'icon': FontAwesomeIcons.handshake,
                          'title': 'Business Support',
                          'subtitle': 'Comprehensive assistance'
                        },
                        {
                          'icon': Icons.school,
                          'title': 'Training Programs',
                          'subtitle': 'Expert guidance & learning'
                        },
                        {
                          'icon': Icons.campaign,
                          'title': 'Marketing Assistance',
                          'subtitle': 'Promotional support'
                        },
                      ];

                      return _WhiteCard(
                        icon: items[index]['icon'] as IconData,
                        title: items[index]['title'] as String,
                        subtitle: items[index]['subtitle'] as String,
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Basic Requirements
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Basic Requirements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _RequirementItem(text: 'Proven business experience'),
                  const _RequirementItem(text: 'Strong financial capability'),
                  const _RequirementItem(text: 'Strategic Location'),
                  const _RequirementItem(text: 'Full-time commitment'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Role Category
            Container(
              color: AppColors.gold,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Role Category',
                    style: TextStyle(
                      fontSize: tertiary(),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _RoleCard(title: 'Franchisee', icon: Icons.store),
                        _RoleCard(
                          title: 'Vendor',
                          icon: FontAwesomeIcons.handshake,
                        ),
                        _RoleCard(title: 'HR', icon: Icons.people),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Start Your Journey Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WorkApplicationForm()));
                  },
                  child: Text(
                    'Start Your Journey',
                    style:
                        TextStyle(fontSize: secondary(), color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// White Card Widget
class _WhiteCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _WhiteCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: AppColors.green),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.green),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: tertiary(), color: AppColors.green),
          ),
        ],
      ),
    );
  }
}

// Requirement Item Widget
class _RequirementItem extends StatelessWidget {
  final String text;

  const _RequirementItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.green),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}

// Role Card Widget
class _RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const _RoleCard({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: AppColors.green),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: tertiary()),
            ),
          ],
        ),
      ),
    );
  }
}
