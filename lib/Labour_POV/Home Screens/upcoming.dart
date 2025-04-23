import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import '../All_app_bars/normal_app_bar.dart';

class UpcomingAssignmentScreen extends StatefulWidget {
  const UpcomingAssignmentScreen({super.key});

  @override
  State<UpcomingAssignmentScreen> createState() => _UpcomingAssignmentScreenState();
}

class _UpcomingAssignmentScreenState extends State<UpcomingAssignmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: CustomBackAppBar(title: 'Upcoming Assignment'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            AssignmentInfoCard(),
            WorkAreaCard(),
            SiteFacilitiesCard(),
            ContactInfoCard(),
          ],
        ),
      ),
    );
  }
}

// Reusable Card Container
class ReusableCard extends StatelessWidget {
  final Widget child;

  const ReusableCard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }
}

// Assignment Info Section
class AssignmentInfoCard extends StatelessWidget {
  const AssignmentInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Riverside Tower Project',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: primary(),
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: AppColors.green),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  '123 Construction Ave, Downtown',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: secondary()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Work Area Section
class WorkAreaCard extends StatelessWidget {
  const WorkAreaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Work Area Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: primary(),
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'Assets/Labour_image/map.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Image.asset("Assets/Labour_image/zone.png"),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Zone B - Structural Works',
                  style: TextStyle(fontSize: secondary()),
                ),
              ),
              Text(
                'INR 1000/Day',
                style: TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: primary(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Image.asset("Assets/Labour_image/workers.png"),
              const SizedBox(width: 9),
              Text(
                'Current Workers: 45/60',
                style: TextStyle(fontSize: secondary()),
              ),
              const Spacer(),
              Image.asset("Assets/Labour_image/month_alarm.png"),
              const SizedBox(width: 9),
              Text(
                '3 Months',
                style: TextStyle(fontSize: secondary()),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Image.asset("Assets/Labour_image/clock.png"),
              const SizedBox(width: 9),
              Text(
                '7:00 AM - 5:00 PM',
                style: TextStyle(fontSize: secondary()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Site Facilities Section
class SiteFacilitiesCard extends StatelessWidget {
  const SiteFacilitiesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Site Facilities',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: primary(),
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 80,
            runSpacing: 10,
            children: [
              facilityItem('Assets/Labour_image/parking.png', 'Free Parking'),
              facilityItem('Assets/Labour_image/rest_room.png', 'Rest Rooms'),
              facilityItem(null, 'Canteen', isIcon: true),
              facilityItem('Assets/Labour_image/medical_boy.png', 'Medical Bay'),
            ],
          ),
        ],
      ),
    );
  }

  Widget facilityItem(String? assetPath, String label, {bool isIcon = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        isIcon
            ? Icon(Icons.restaurant, color: AppColors.green)
            : Image.asset(assetPath!, height: 20, width: 20),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: secondary())),
      ],
    );
  }
}

// Contact Info Section
class ContactInfoCard extends StatelessWidget {
  const ContactInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: primary(),
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person, size: 16, color: AppColors.green),
              const SizedBox(width: 4),
              Text('Site Manager: Robert Wilson',
                  style: TextStyle(fontSize: secondary())),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.phone, size: 16, color: AppColors.green),
              const SizedBox(width: 4),
              Text('+91 7788990089', style: TextStyle(fontSize: secondary())),
            ],
          ),
        ],
      ),
    );
  }
}
