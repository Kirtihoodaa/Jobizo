import 'package:flutter/material.dart';

import '../../Design contraints/FontSizes.dart';
import '../../Design contraints/app color.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({Key? key}) : super(key: key);

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {

  final List<Map<String, String>> contacts = [
    {'name': 'Dr. Sarah Johnson', 'relation': 'Primary Doctor'},
    {'name': 'Emma Thompson', 'relation': 'Wife'},
    {'name': 'Michael Wilson', 'relation': 'Partner'},
  ];

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(
        icon: Icons.local_police,
        label: 'Call Police',
        onTap: () {

        },
      ),
      _ActionItem(
        icon: Icons.local_fire_department,
        label: 'Call Fire',
        onTap: () {

        },
      ),
      _ActionItem(
        icon: Icons.local_hospital,
        label: 'Contact Hospital',
        onTap: () {

        },
      ),
      _ActionItem(
        icon: Icons.emergency,
        label: 'Emergency',
        onTap: () {

        },
      ),
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: AppColors.gold,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Emergency',
          style: TextStyle(
            fontSize: primary(),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 24,
                  color: Colors.grey[700],
                ),
                SizedBox(width: 8),
                Text(
                  'Chandigarh, India',
                  style: TextStyle(
                    fontSize: secondary(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 16,
              childAspectRatio: 1.9,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: actions,
            ),
            SizedBox(height: 10),
            buildContactsSection(),
          ],
        ),
      ),
    );
  }
  Widget buildContactsSection(){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Emergency Contacts",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: secondary(),
      
            color: AppColors.gold,
          ),
          ),
          SizedBox(height: 15),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 4),
                title: Text(
                  contact['name']!,
                  style: TextStyle(
                    fontSize: secondary(),
                    fontWeight: FontWeight.w600,
                    color: AppColors.green,
                  ),
                ),
                subtitle: Text(
                  contact['relation']!,
                  style: TextStyle(
                    fontSize: tertiary(),
                    color: Colors.grey[700],
                  ),
                ),
                trailing: CircleAvatar(
                  backgroundColor: AppColors.gold,
                  radius: 20,
                  child: Icon(Icons.call, color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.white),
            SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: tertiary(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
