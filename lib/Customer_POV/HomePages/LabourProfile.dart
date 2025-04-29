import 'package:flutter/material.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';

class WorkHistory {
  final String company;
  final String role;
  final String duration;
  final String description;

  WorkHistory({
    required this.company,
    required this.role,
    required this.duration,
    required this.description,
  });
}

class LabourProfilePage extends StatelessWidget {
  final String name;
  final String role;
  final String employeeId;
  final String location;
  final String phone;
  final String email;

  const LabourProfilePage({
    super.key,
    required this.name,
    required this.role,
    required this.employeeId,
    required this.location,
    required this.phone,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> attendanceStatus = [
      {"day": "M", "status": "Present"},
      {"day": "T", "status": "Present"},
      {"day": "W", "status": "Leave"},
      {"day": "T", "status": "Leave"},
      {"day": "F", "status": "Absent"},
      {"day": "S", "status": "Absent"},
    ];

    final List<WorkHistory> workHistoryList = [
      WorkHistory(
        company: 'BuildTech Solutions',
        role: 'Construction Engineer',
        duration: '15/01/2025 - 12/04/2021',
        description: 'Led multiple residential construction projects',
      ),
      WorkHistory(
        company: 'Metro Builders Inc',
        role: 'Construction',
        duration: '1 Year',
        description: 'Assisted in commercial building projects',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: "Labour Profile"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        AssetImage("Assets/Labour_image/labour_profile.png"),
                  ),
                  const SizedBox(height: 10),
                  Text(name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: primary())),
                  const SizedBox(height: 4),
                  Text(role, style: TextStyle(fontSize: tertiary())),
                  Text("Employee ID : $employeeId",
                      style: TextStyle(fontSize: tertiary())),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Project
            buildWhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Riverside Tower Project",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.green,
                          fontSize: primary())),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 4),
                      Text(location, style: TextStyle(fontSize: secondary())),
                    ],
                  ),
                ],
              ),
            ),

            // Work Area Details
            buildWhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Work Area Details',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: primary(),
                          color: AppColors.green)),
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
                        child: Text('Zone B - Structural Works',
                            style: TextStyle(fontSize: secondary())),
                      ),
                      Text('INR 1000/Day',
                          style: TextStyle(
                              color: AppColors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: primary())),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Image.asset("Assets/Labour_image/workers.png"),
                      const SizedBox(width: 9),
                      Text('Current Workers: 45/60',
                          style: TextStyle(fontSize: secondary())),
                      const Spacer(),
                      Image.asset("Assets/Labour_image/month_alarm.png"),
                      const SizedBox(width: 9),
                      Text('3 Months', style: TextStyle(fontSize: secondary())),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Image.asset("Assets/Labour_image/clock.png"),
                      const SizedBox(width: 9),
                      Text('7:00 AM - 5:00 PM',
                          style: TextStyle(fontSize: secondary())),
                    ],
                  ),
                ],
              ),
            ),

            // Contact Info
            buildWhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contact Information',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: primary(),
                          color: AppColors.green)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.call, size: 16, color: AppColors.green),
                      const SizedBox(width: 6),
                      Text(phone, style: TextStyle(fontSize: secondary())),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.email_outlined,
                          size: 16, color: AppColors.green),
                      const SizedBox(width: 6),
                      Text(email, style: TextStyle(fontSize: secondary())),
                    ],
                  ),
                ],
              ),
            ),

            // Attendance
            buildWhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Attendance Overview',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: primary(),
                          color: AppColors.green)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      AttendanceBox(
                          title: 'Present', count: 22, color: Colors.green),
                      AttendanceBox(
                          title: 'Absent', count: 2, color: Colors.grey),
                      AttendanceBox(
                          title: 'Leave', count: 1, color: Colors.brown),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('This Week',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: tertiary())),
                  const SizedBox(height: 12),
                  Row(
                    children: attendanceStatus.map((entry) {
                      Color color;
                      switch (entry["status"]!.toLowerCase()) {
                        case 'present':
                          color = AppColors.green;
                          break;
                        case 'absent':
                          color = Colors.grey;
                          break;
                        case 'leave':
                          color = AppColors.brown;
                          break;
                        default:
                          color = Colors.black;
                      }
                      return dayCircle(entry["day"]!, color);
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Work History (dynamic)
            buildWhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Previous Work History',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: primary(),
                          color: AppColors.green)),
                  const SizedBox(height: 12),
                  Column(
                    children: workHistoryList.map((history) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 3,
                                offset: Offset(0, 1)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(history.company,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: secondary())),
                            const SizedBox(height: 4),
                            Text(history.role,
                                style: TextStyle(fontSize: tertiary())),
                            const SizedBox(height: 4),
                            Text(history.duration,
                                style: TextStyle(fontSize: tertiary())),
                            const SizedBox(height: 4),
                            Text(history.description,
                                style: TextStyle(fontSize: tertiary())),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWhiteCard({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.18),
              blurRadius: 4,
              offset: Offset(0, 0)),
        ],
      ),
      child: child,
    );
  }

  Widget dayCircle(String text, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 35,
      width: 35,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      alignment: Alignment.center,
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}

class AttendanceBox extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const AttendanceBox({
    super.key,
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count.toString(),
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(title),
      ],
    );
  }
}
