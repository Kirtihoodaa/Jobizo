import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';

class LabourProfilePage extends StatefulWidget {
  final int labourId;

  const LabourProfilePage({
    Key? key,
    required this.labourId,
  }) : super(key: key);

  @override
  State<LabourProfilePage> createState() => _LabourProfilePageState();
}

class _LabourProfilePageState extends State<LabourProfilePage> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _data;

  int presentCount = 0;
  int absentCount = 0;
  int leaveCount = 0;
  List<Map<String, String>> attendanceStatus = [];

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

        // Parse attendance data
        final attendances = (_data!['attendances'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>() ??
            [];
        presentCount = 0;
        absentCount = 0;
        leaveCount = 0;
        attendanceStatus = [];

        for (var att in attendances) {
          final status = (att['status'] as String? ?? '').toLowerCase();
          switch (status) {
            case 'present':
              presentCount++;
              break;
            case 'absent':
              absentCount++;
              break;
            case 'leave':
              leaveCount++;
              break;
            default:
              break;
          }
          // Convert date string to weekday initial
          final dateStr = att['date'] as String? ?? '';
          if (dateStr.isNotEmpty) {
            try {
              final dt = DateTime.parse(dateStr);
              final weekdayChar = _weekdayChar(dt.weekday);
              attendanceStatus.add({
                'day': weekdayChar,
                'status': status[0].toUpperCase() + status.substring(1),
              });
            } catch (_) {
              // Ignore parse errors
            }
          }
        }
      } else {
        throw body['message'] ?? 'Failed to load';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() => _loading = false);
    }
  }

  String _weekdayChar(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'M';
      case DateTime.tuesday:
        return 'T';
      case DateTime.wednesday:
        return 'W';
      case DateTime.thursday:
        return 'T';
      case DateTime.friday:
        return 'F';
      case DateTime.saturday:
        return 'S';
      case DateTime.sunday:
        return 'S';
      default:
        return '';
    }
  }

  String _safe(dynamic v) => v?.toString() ?? '—';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: 'Labour Profile'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_error != null
          ? Center(child: Text(_error!))
          : _buildContent()),
    );
  }

  Widget _buildContent() {
    final data = _data!;
    final rawName = _safe(data['name']);
    final formattedName =
    rawName.isNotEmpty ? rawName[0].toUpperCase() + rawName.substring(1) : '';

    // Use first project if available
    final projectEntry = (data['projects'] as List<dynamic>? ?? []).isNotEmpty
        ? (data['projects'] as List<dynamic>)[0] as Map<String, dynamic>
        : <String, dynamic>{};

    final jobTitle = _safe(projectEntry['job_title']);
    final employeeId = _safe(data['employee_id']);
    final projectName = _safe(projectEntry['job_title']);
    final projectLocation = _safe(projectEntry['job_location']);
    final projectSalary = _safe(projectEntry['job_salary']);
    final projectDuration = _safe(projectEntry['job_duration']);

    final siteManager = (projectEntry['site_manager'] as Map<String, dynamic>?) ?? {};
    final siteManagerName = _safe(siteManager['name']);
    final siteManagerEmail = _safe(siteManager['email']);
    final siteManagerPhone = _safe(siteManager['phone']);

    // Build the avatar image: use network if "image" exists; otherwise local placeholder
    ImageProvider avatarImage;
    final imagePath = data['image'] as String? ?? '';
    if (imagePath.isNotEmpty) {
      avatarImage = NetworkImage('https://backend.jobizoindia.com/storage/$imagePath');
    } else {
      avatarImage = const AssetImage("Assets/Labour_image/labour_profile.png") as ImageProvider;
    }

    // // Static past work history
    // final workHistoryList = [
    //   WorkHistory(
    //     company: 'BuildTech Solutions',
    //     role: 'Construction Engineer',
    //     duration: '15/01/2025 - 12/04/2021',
    //     description: 'Led multiple residential construction projects',
    //   ),
    //   WorkHistory(
    //     company: 'Metro Builders Inc',
    //     role: 'Construction Engineer',
    //     duration: '01/05/2021 - 30/11/2022',
    //     description: 'Assisted in commercial building projects',
    //   ),
    // ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        children: [
          // ■ Profile Card ■
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: avatarImage,
                    ),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  formattedName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: primary(),
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  jobTitle,
                  style: TextStyle(fontSize: secondary(), color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  "Employee ID: $employeeId",
                  style: TextStyle(fontSize: tertiary(), color: Colors.black54),
                ),
              ],
            ),
          ),

          // ■ Project / Category Card ■
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                //const Icon(Icons.work, color: AppColors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        projectName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: secondary(),
                          color: AppColors.green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              projectLocation,
                              style:
                              TextStyle(fontSize: tertiary(), color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ■ Work Area Details Card ■
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Map placeholder
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Image.asset(
                      'Assets/Labour_image/map.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '2.5 km from current location',
                        style: TextStyle(
                            fontSize: tertiary(), color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.place,
                                  color: AppColors.green, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                'Zone B - Structural Works',
                                style: TextStyle(
                                  fontSize: tertiary(),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'INR $projectSalary/Day',
                            style: TextStyle(
                              fontSize: tertiary(),
                              fontWeight: FontWeight.bold,
                              color: AppColors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.timer,
                              color: Colors.grey, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            projectDuration,
                            style: TextStyle(
                                fontSize: tertiary(), color: Colors.black54),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              color: Colors.grey, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'Operating Hours: 7:00 AM - 5:00 PM',
                            style: TextStyle(
                                fontSize: tertiary(), color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ■ Contact Information Card ■
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Information',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: secondary(),
                      color: AppColors.green),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.call, size: 18, color: AppColors.green),
                    const SizedBox(width: 8),
                    Text(
                      siteManagerPhone,
                      style:
                      TextStyle(fontSize: tertiary(), color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.email_outlined,
                        size: 18, color: AppColors.green),
                    const SizedBox(width: 8),
                    Text(
                      siteManagerEmail,
                      style:
                      TextStyle(fontSize: tertiary(), color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ■ Attendance Overview Card ■
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Attendance Overview',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: primary(),
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                // Row of counts (Present / Absent / Leave)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttendanceCount('Present', presentCount, AppColors.green),
                    _buildAttendanceCount('Absent', absentCount, AppColors.brown),
                    _buildAttendanceCount('Leave', leaveCount, Colors.orange),
                  ],
                ),
                const SizedBox(height: 16),

                // "This Week" label
                Text(
                  'This Week',
                  style: TextStyle(fontSize: tertiary(), color: Colors.black54),
                ),
                const SizedBox(height: 12),

                // Row of weekday circles
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: attendanceStatus.map((entry) {
                    Color color;
                    switch (entry["status"]!.toLowerCase()) {
                      case 'present':
                        color = AppColors.green;
                        break;
                      case 'absent':
                        color = AppColors.brown;
                        break;
                      case 'leave':
                        color = Colors.orange;
                        break;
                      default:
                        color = Colors.grey;
                    }
                    return _dayCircle(entry["day"]!, color);
                  }).toList(),
                ),
              ],
            ),
          ),

          // ■ Previous Work History Card ■
          // buildWhiteCard(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text('Previous Work History',
          //           style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //               fontSize: primary(),
          //               color: AppColors.green)),
          //       const SizedBox(height: 12),
          //       Column(
          //         children: workHistoryList.map((history) {
          //           return Container(
          //             width: double.infinity,
          //             padding: const EdgeInsets.all(12),
          //             margin: const EdgeInsets.only(bottom: 12),
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: BorderRadius.circular(12),
          //             ),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(history.company,
          //                     style: TextStyle(
          //                         fontWeight: FontWeight.bold,
          //                         fontSize: secondary(),
          //                         color: Colors.black87)),
          //                 const SizedBox(height: 4),
          //                 Text(history.role,
          //                     style: TextStyle(
          //                         fontSize: tertiary(), color: Colors.black54)),
          //                 const SizedBox(height: 4),
          //                 Text(history.duration,
          //                     style: TextStyle(
          //                         fontSize: tertiary(), color: Colors.black54)),
          //                 const SizedBox(height: 4),
          //                 Text(history.description,
          //                     style: TextStyle(
          //                         fontSize: tertiary(), color: Colors.black54)),
          //               ],
          //             ),
          //           );
          //         }).toList(),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildWhiteCard({required Widget child}) => Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );

  Widget _buildAttendanceCount(String title, int count, Color color) => Column(
    children: [
      Text(
        count.toString(),
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        title,
        style: TextStyle(
          fontSize: tertiary(),
          color: Colors.black54,
        ),
      ),
    ],
  );
  Widget _dayCircle(String text, Color color) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 4),
    height: 30,
    width: 30,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
    alignment: Alignment.center,
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

// class WorkHistory {
//   final String company;
//   final String role;
//   final String duration;
//   final String description;
//
//   WorkHistory({
//     required this.company,
//     required this.role,
//     required this.duration,
//     required this.description,
//   });
// }
