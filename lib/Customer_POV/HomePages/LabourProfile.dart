import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design contraints/app color.dart';
import 'package:jobizo/Design contraints/FontSizes.dart';

class LabourProfilePage extends StatefulWidget {
  final int labourId;

  const LabourProfilePage({
    super.key,
    required this.labourId,
  });

  @override
  State<LabourProfilePage> createState() => _LabourProfilePageState();
}

class _LabourProfilePageState extends State<LabourProfilePage> {
  bool _loading = true;
  String? _error;
  late Map<String, dynamic> _data;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token') ?? '';
      if (!token.startsWith('Bearer ')) token = 'Bearer $token';

      final resp = await Dio(BaseOptions(headers: {'Authorization': token}))
          .get(
        'https://backend.jobizoindia.com/api/labour-detail/${widget.labourId}',
        options: Options(validateStatus: (s) => s != null && s < 500),
      );

      final body = resp.data as Map<String, dynamic>;
      if (resp.statusCode == 200 && body['status'] == true) {
        _data = body['data'] as Map<String, dynamic>;
      } else {
        throw body['message'] ?? 'Failed to load';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() => _loading = false);
    }
  }

  String _safe(dynamic v) => v?.toString() ?? 'null';

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: Commonappbar(title: "Labour Profile"),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: Commonappbar(title: "Labour Profile"),
        body: Center(child: Text(_error!)),
      );
    }

    final user = _data['user'] as Map<String, dynamic>? ?? {};
    final category = _data['category'] as Map<String, dynamic>? ?? {};

    // attendanceStatus and workHistoryList remain static
    final attendanceStatus = [
      {"day": "M", "status": "Present"},
      {"day": "T", "status": "Present"},
      {"day": "W", "status": "Leave"},
      {"day": "T", "status": "Leave"},
      {"day": "F", "status": "Absent"},
      {"day": "S", "status": "Absent"},
    ];

    final workHistoryList = [
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
            // — Profile Card —
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: user['image'] != null
                        ? NetworkImage(
                        "https://backend.jobizoindia.com/storage/${user['image']}")
                        : const AssetImage(
                        "Assets/Labour_image/labour_profile.png")
                    as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _safe(user['name']),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: primary()),
                  ),
                  const SizedBox(height: 4),
                  Text(_safe(_data['work_schedule']),
                      style: TextStyle(fontSize: tertiary())),
                  Text("Employee ID : ${_safe(_data['id'])}",
                      style: TextStyle(fontSize: tertiary())),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // — Project / Category —
            buildWhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_safe(category['name']),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.green,
                          fontSize: primary())),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 4),
                      Text(_safe(_data['preferred_work_location']),
                          style: TextStyle(fontSize: secondary())),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // — Work Area Details —
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
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 16),
                      const SizedBox(width: 4),
                      Text(_safe(_data['work_schedule']),
                          style: TextStyle(fontSize: secondary())),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.date_range, size: 16),
                      const SizedBox(width: 4),
                      Text(_safe(_data['starting_date']),
                          style: TextStyle(fontSize: secondary())),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // — Contact Info —
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
                      Text(_safe(_data['emergency_phone']),
                          style: TextStyle(fontSize: secondary())),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.email_outlined,
                          size: 16, color: AppColors.green),
                      const SizedBox(width: 6),
                      Text(_safe(user['email']),
                          style: TextStyle(fontSize: secondary())),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // — Attendance Overview (static) —
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

            const SizedBox(height: 16),

            // — Previous Work History (static) —
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

  Widget buildWhiteCard({required Widget child}) => Container(
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

  Widget dayCircle(String text, Color color) => Container(
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
