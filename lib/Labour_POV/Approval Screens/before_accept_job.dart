import 'package:flutter/material.dart';
import 'package:jobizo/All_app_bars/normal_app_bar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class BeforeAcceptJob extends StatefulWidget {
  const BeforeAcceptJob({super.key});

  @override
  State<BeforeAcceptJob> createState() => _BeforeAcceptJobState();
}

class _BeforeAcceptJobState extends State<BeforeAcceptJob> {
  String selectedAction = '';

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
                      fontSize: 16,
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
                      const Expanded(child: Text('Zone B - Structural Works')),
                      Text(
                        'INR 1000/Day',
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Image.asset("Assets/Labour_image/workers.png"),
                      const SizedBox(width: 9),
                      const Text('Current Workers: 45/60'),
                      const Spacer(),
                      Image.asset("Assets/Labour_image/month_alarm.png"),
                      const SizedBox(width: 9),
                      const Text('3 Months'),
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
                          const Text('7:00 AM - 5:00 PM'),
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
                  const Text(
                    'Site Facilities',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4D7C0F),
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
                          Text('Free Parking'),
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
                          Text('Rest Rooms'),
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
                          const Text('Canteen'),
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
                          Text('Medical Bay'),
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
                      color: AppColors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: AppColors.green),
                      SizedBox(width: 4),
                      Text('Site Manager: Robert Wilson'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 16, color: AppColors.green),
                      SizedBox(width: 4),
                      Text('+91 7788990089'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B1E03), // Deep brown
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Reject',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Start Job Logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF62A910), // Green
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Accept',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
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
