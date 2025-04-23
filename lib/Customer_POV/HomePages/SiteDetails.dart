import 'package:flutter/material.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class Sitedetails extends StatefulWidget {
  const Sitedetails({super.key});

  @override
  State<Sitedetails> createState() => _SitedetailsState();
}

class _SitedetailsState extends State<Sitedetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: Commonappbar(title: 'Site Details'),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            AssignmentInfoCard(),
            WorkAreaCard(),
            SiteFacilitiesCard(),
            ContactInfoCard(),
            SiteSummaryCard(),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
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
      ),
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
              facilityItem(
                  'Assets/Labour_image/medical_boy.png', 'Medical Bay'),
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

// Site Summary Section
class SiteSummaryCard extends StatelessWidget {
  const SiteSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Job Instruction
        ReusableCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Job Instruction',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: primary(),
                  color: AppColors.green,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'All scheduled tasks for the site must be completed as planned, ensuring that every team follows the necessary safety protocols throughout the day. It is essential that progress updates are reported to the site supervisor before the end of each shift to maintain workflow and accountability.',
                style: TextStyle(fontSize: secondary()),
              ),
            ],
          ),
        ),

        // Stats Row
        Container(
          width: MediaQuery.of(context).size.width,
          height: 160,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.gold,
          ),
          child: Row(
            children: [
              // Total Workers Card
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text('124',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black)),
                      const SizedBox(height: 4),
                      Text('Total Workers',
                          style: TextStyle(
                              color: Colors.black, fontSize: secondary())),
                      Text('+5% this week',
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 12)),
                    ],
                  ),
                ),
              ),

              // Active Today Card
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text('98',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black)),
                      const SizedBox(height: 4),
                      Text('Active Today',
                          style: TextStyle(
                              color: Colors.black, fontSize: secondary())),
                      Text('+3% this week',
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Labor Distribution
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Labor Distribution',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: primary(),
                color: AppColors.green),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            runSpacing: 12,
            spacing: 8,
            children: [
              laborCard(context, Icons.engineering, 'Construction', 45, 50,
                  Colors.blue),
              laborCard(
                  context, Icons.plumbing, 'Plumbers', 12, 20, Colors.orange),
              laborCard(context, Icons.electrical_services, 'Electricians', 15,
                  40, Colors.brown),
              laborCard(
                  context, Icons.handyman, 'Carpenters', 18, 20, Colors.green),
              laborCard(context, Icons.format_paint, 'Painters', 8, 20,
                  AppColors.gold),
              laborCard(
                  context, Icons.group, 'Others', 26, 30, Colors.blueGrey),
            ],
          ),
        ),
      ],
    );
  }

  Widget laborCard(BuildContext context, IconData icon, String role,
      int current, int total, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 24,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              offset: Offset(0, 1),
              blurRadius: 2)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            '$current/$total',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(role, style: TextStyle(fontSize: secondary())),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: current / total,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}
