import 'package:flutter/material.dart';
import 'package:jobizo/All_app_bars/normal_app_bar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class UpcomingAssignmentScreen extends StatelessWidget {
  const UpcomingAssignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: CustomBackAppBar(title: 'Upcoming Assignment'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildCardContainer(
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
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: AppColors.green),
                      SizedBox(width: 4),
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
            ),
            buildCardContainer(
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
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
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
                ],
              ),
            ),
            buildCardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Site Facilities',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: primary(),
                      color: const Color(0xFF4D7C0F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 80,
                    runSpacing: 10,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "Assets/Labour_image/parking.png",
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(width: 4),
                          Text('Free Parking',
                              style: TextStyle(fontSize: secondary())),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'Assets/Labour_image/rest_room.png',
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(width: 4),
                          Text('Rest Rooms',
                              style: TextStyle(fontSize: secondary())),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.restaurant,
                            color: AppColors.green,
                          ),
                          const SizedBox(width: 4),
                          Text('Canteen',
                              style: TextStyle(fontSize: secondary())),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'Assets/Labour_image/medical_boy.png',
                            height: 18,
                            width: 18,
                          ),
                          SizedBox(width: 4),
                          Text('Medical Bay',
                              style: TextStyle(fontSize: secondary())),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            buildCardContainer(
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
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: AppColors.green),
                      SizedBox(width: 4),
                      Text('Site Manager: Robert Wilson',
                          style: TextStyle(fontSize: secondary())),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 16, color: AppColors.green),
                      SizedBox(width: 4),
                      Text('+91 7788990089',
                          style: TextStyle(fontSize: secondary())),
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

  Widget buildCardContainer({required Widget child}) {
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
