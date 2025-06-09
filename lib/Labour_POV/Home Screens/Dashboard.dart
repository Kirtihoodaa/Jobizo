import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:jobizo/Labour_POV/Home%20Screens/upcoming.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Design contraints/FontSizes.dart';
import '../All_app_bars/app_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? profile;
  Map<String, dynamic>? statusData;
  List<dynamic> upcomingAssignments = [];
  int presentCount = 0;
  int absentCount = 0;
  int leaveCount = 0;
  String weeklyEarnings = "INR 7,800";
  String creditedAmount = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('auth_token') ?? '';
      final dio = Dio(BaseOptions(headers: {'Authorization': token}));

      final response =
          await dio.get('https://backend.jobizoindia.com/api/available-salary');
      final data = response.data;
      print(data);
      setState(() {
        creditedAmount = "INR ${data['available_salary'].toString()}";
        final availableBalance =
            double.tryParse(creditedAmount.replaceAll(RegExp(r'[^0-9.]'), ''))
                    ?.floor() ??
                0;
        print(availableBalance);
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        creditedAmount = "INR 0";
      });
    }
  }

  Future<void> fetchDashboardData() async {
    final dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    dio.options.headers["Authorization"] = "Bearer $token";

    try {
      final response =
          await dio.get("https://backend.jobizoindia.com/api/labour-dashboard");

      if (response.statusCode == 200 && response.data['status'] == true) {
        final data = response.data['data'];

        setState(() {
          profile = data['profile'];
          statusData = data['status'];
          upcomingAssignments = data['upcoming_assignments'];
          presentCount = data['presentCount'];
          absentCount = data['absentCount'];
          leaveCount = data['leaveCount'];
          print(upcomingAssignments);
        });
      }
    } catch (e) {
      print("❌ Error fetching dashboard data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            _buildCurrentStatus(),
            _buildEarnings(),
            _buildUpcomingAssignments(),
            _buildAttendanceOverview(),
            // _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    final imageUrl = profile?['photo_url'] != null
        ? "https://backend.jobizoindia.com/storage/${profile!['photo_url']}"
        : null;
    return Container(
      width: MediaQuery.sizeOf(context).width,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl)
                    : AssetImage("Assets/Labour_image/user profile.png")
                        as ImageProvider,
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              Text(profile?['name'] ?? 'N/A',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: primary())),
              SizedBox(height: 5),
              Text(profile?['designation'] ?? 'Designation',
                  style: TextStyle(fontSize: secondary())),
              SizedBox(height: 5),
              Text("Employee ID : ${profile?['employee_id'] ?? 'N/A'}",
                  style: TextStyle(fontSize: tertiary())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStatus() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 12),
      child: ListTile(
        title: Text("Current Status:", style: TextStyle(fontSize: tertiary())),
        subtitle: Text(
          "Last Ative: ${statusData?['last_active'] ?? 'N/A'}",
          style: TextStyle(fontSize: tertiary()),
        ),
        trailing: Text(
          statusData?['availability'] ?? 'N/A',
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
            _earningsTile("Totals Earnings", creditedAmount),
            SizedBox(
              height: 5,
            ),
            _earningsTile(
              "Weekly Earnings",
              "INR ${((double.tryParse(creditedAmount.replaceAll(RegExp(r'[^0-9.]'), ''))?.floor() ?? 0) ~/ 4).toString()}",
            ),
            SizedBox(
              height: 5,
            ),
            _earningsTile("Monthly Earnings", creditedAmount),
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
            ...upcomingAssignments.map((assignment) {
              return GestureDetector(
                onTap: () {
                  Get.to(
                    () => UpcomingAssignmentScreen(
                      jobId: assignment['labour_project_id'],

                    ),
                    transition: Transition.cupertino,
                    duration: const Duration(milliseconds: 400),
                  );
                },
                child: assignmentTile(
                  assignment['project_name'],
                  assignment['site_description'],
                  assignment['location'],
                  "Starts in ${assignment['starts_in_days']} days",
                ),
              );
            }).toList(),
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
              children: [
                _attendanceCircle("$presentCount", "Present", Colors.green),
                _attendanceCircle("$absentCount", "Absent", Colors.red),
                _attendanceCircle("$leaveCount", "Leave", Colors.orange),
              ],
            ),
            // const SizedBox(height: 12),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     CircleAvatar(
            //         radius: 12,
            //         backgroundColor: Colors.green,
            //         child: Text("M",
            //             style: TextStyle(
            //                 fontSize: tertiary(), color: Colors.white))),
            //     CircleAvatar(
            //         radius: 12,
            //         backgroundColor: Colors.green,
            //         child: Text("T",
            //             style: TextStyle(
            //                 fontSize: tertiary(), color: Colors.white))),
            //     CircleAvatar(
            //         radius: 12,
            //         backgroundColor: Colors.green,
            //         child: Text("W",
            //             style: TextStyle(
            //                 fontSize: tertiary(), color: Colors.white))),
            //     CircleAvatar(
            //         radius: 12,
            //         backgroundColor: Colors.green,
            //         child: Text("T",
            //             style: TextStyle(
            //                 fontSize: tertiary(), color: Colors.white))),
            //     CircleAvatar(
            //         radius: 12,
            //         backgroundColor: Colors.grey,
            //         child: Text("F",
            //             style: TextStyle(
            //                 fontSize: tertiary(), color: Colors.white))),
            //     CircleAvatar(
            //         radius: 12,
            //         backgroundColor: Colors.grey,
            //         child: Text("S",
            //             style: TextStyle(
            //                 fontSize: tertiary(), color: Colors.white))),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  // Widget _buildRecentActivity() {
  //   return Card(
  //     color: Colors.white,
  //     margin: const EdgeInsets.only(top: 12, bottom: 24),
  //     child: Padding(
  //       padding: const EdgeInsets.all(10),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text("Recent Activity",
  //               style: TextStyle(
  //                   fontWeight: FontWeight.bold, fontSize: secondary())),
  //           SizedBox(height: 12),
  //           _activityTile("Payment Received", "+₹35,000",
  //               "From: Skyline Construction Co.\nToday 2:30 PM", Colors.green),
  //           _activityTile("Job Completed", "★ 4.8",
  //               "Metro Station Project\nYesterday 5:00 PM", Colors.black),
  //           _activityTile("Warning Notice", "High Severity",
  //               "From: Skyline Construction Co.\nToday 2:30 PM", Colors.red),
  //           _activityTile("Complaint Status", "Pending",
  //               "Equipment issue #123\n3 days ago", Colors.orange),
  //           _activityTile("Late Arrival", "Warning",
  //               "Reported by site supervisor\n4 days ago", Colors.redAccent),
  //         ],
  //       ),
  //     ),
  //   );
  // }
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
