import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:jobizo/Labour_POV/Home%20Screens/upcoming.dart';

import '../../All_app_bars/app_bar.dart';
import '../../Design contraints/FontSizes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userName = "Rajesh Kumar";
  String location = "Patna, Bihar, IND";
  String jobTitle = "Senior Construction Engineer";
  String empId = "EMP-2024-0123";
  double rating = 4.7;
  String status = "Available";
  String lastCheckIn = "Today, 9:45 AM";
  String totalEarnings = "INR 12,000";
  String weeklyEarnings = "INR 7,800";
  String monthlyEarnings = "INR 32,000";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        name: 'Deepak',
        location: 'chandigarh, kharar',
        profileImageUrl: '',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            _buildCurrentStatus(),
            _buildEarnings(),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpcomingAssignmentScreen()));
                },
                child: _buildUpcomingAssignments()),
            _buildAttendanceOverview(),
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
                radius: 35,
                backgroundImage:
                    AssetImage("Assets/Labour_image/user profile.png")),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(userName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: primary())),
                Icon(Icons.star, color: Colors.orange, size: secondary()),
                SizedBox(width: 4),
                Text('$rating/5', style: TextStyle(fontSize: secondary())),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(jobTitle,
                style: TextStyle(fontSize: secondary(), color: Colors.black)),
            SizedBox(
              height: 5,
            ),
            Text("Employee ID : $empId",
                style: TextStyle(fontSize: tertiary(), color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStatus() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 12),
      child: ListTile(
        title: Text(
          "Current Status:",
          style: TextStyle(fontSize: tertiary()),
        ),
        subtitle: Text(
          "Last check-in: $lastCheckIn",
          style: TextStyle(fontSize: tertiary()),
        ),
        trailing: Text(
          status,
          style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: tertiary()),
        ),
      ),
    );
  }

  Widget _buildEarnings() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _earningsTile("Totals Earnings", totalEarnings),
            SizedBox(
              height: 5,
            ),
            _earningsTile("Weekly Earnings", weeklyEarnings),
            SizedBox(
              height: 5,
            ),
            _earningsTile("Monthly Earnings", monthlyEarnings),
          ],
        ),
      ),
    );
  }

  Widget _earningsTile(String label, String amount) {
    return Row(
      children: [
        Text(label,
            style: TextStyle(fontSize: tertiary(), color: Colors.black)),
        Spacer(),
        Text(amount,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: secondary(),
                color: Colors.green)),
      ],
    );
  }

  Widget _buildUpcomingAssignments() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Upcoming Assignments",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: secondary(),
                    color: AppColors.green)),
            const SizedBox(height: 10),
            assignmentTile("Metro Rail Project", "Site: East Line Extension",
                "Sector 62 Noida", "Starts in 3 days"),
            const SizedBox(height: 8),
            assignmentTile("Highway Construction", "Site: NH-8 Extension",
                "Sector 62 Noida", "Starts in 7 days"),
          ],
        ),
      ),
    );
  }

  Widget assignmentTile(
      String title, String subtitle, String location, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row with image + title
          Row(
            children: [
              Image.asset("Assets/Labour_image/location.png", height: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: secondary(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Subtitle (Site name)
          Text(
            subtitle,
            style: TextStyle(fontSize: secondary()),
          ),
          const SizedBox(height: 6),

          // 📍 Location
          Row(
            children: [
              Icon(Icons.location_on, size: tertiary(), color: Colors.black),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  style: TextStyle(fontSize: tertiary(), color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // ⏰ Status
          Row(
            children: [
              Icon(Icons.access_time, size: tertiary(), color: Colors.black),
              const SizedBox(width: 4),
              Text(
                status,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: tertiary(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceOverview() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Attendance Overview",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.green,
                  fontSize: secondary()),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _attendanceCircle("22", "Present", Colors.green),
                _attendanceCircle("2", "Absent", Colors.red),
                _attendanceCircle("1", "Leave", Colors.orange),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.green,
                    child: Text("M",
                        style: TextStyle(
                            fontSize: tertiary(), color: Colors.white))),
                CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.green,
                    child: Text("T",
                        style: TextStyle(
                            fontSize: tertiary(), color: Colors.white))),
                CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.green,
                    child: Text("W",
                        style: TextStyle(
                            fontSize: tertiary(), color: Colors.white))),
                CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.green,
                    child: Text("T",
                        style: TextStyle(
                            fontSize: tertiary(), color: Colors.white))),
                CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey,
                    child: Text("F",
                        style: TextStyle(
                            fontSize: tertiary(), color: Colors.white))),
                CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey,
                    child: Text("S",
                        style: TextStyle(
                            fontSize: tertiary(), color: Colors.white))),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 12, bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Recent Activity",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: secondary())),
            SizedBox(height: 12),
            _activityTile("Payment Received", "+₹35,000",
                "From: Skyline Construction Co.\nToday 2:30 PM", Colors.green),
            _activityTile("Job Completed", "★ 4.8",
                "Metro Station Project\nYesterday 5:00 PM", Colors.black),
            _activityTile("Warning Notice", "High Severity",
                "From: Skyline Construction Co.\nToday 2:30 PM", Colors.red),
            _activityTile("Complaint Status", "Pending",
                "Equipment issue #123\n3 days ago", Colors.orange),
            _activityTile("Late Arrival", "Warning",
                "Reported by site supervisor\n4 days ago", Colors.redAccent),
          ],
        ),
      ),
    );
  }
}

class _attendanceCircle extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _attendanceCircle(this.value, this.label, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
            radius: 20,
            backgroundColor: color,
            child: Text(value, style: const TextStyle(color: Colors.white))),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: tertiary())),
      ],
    );
  }
}

class _activityTile extends StatelessWidget {
  final String title;
  final String status;
  final String description;
  final Color color;

  const _activityTile(this.title, this.status, this.description, this.color,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,
          style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      subtitle: Text(
        description,
        style: TextStyle(fontSize: tertiary()),
      ),
      trailing: Text(status,
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: tertiary())),
    );
  }
}
