import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:jobizo/SnackBar/Snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobizo/Design contraints/app color.dart';
import 'package:jobizo/Design contraints/FontSizes.dart';
import 'package:jobizo/Labour_POV/Approval Screens/before_accept_job.dart';
import '../All_app_bars/app_bar.dart';
import '../Histroy Pages/detailsWorks.dart';
import '../NavBar.dart';

// Model classes to parse JSON response
class LabourRequest {
  final int id;
  final String siteManagerName;
  final String status;

  LabourRequest({
    required this.id,
    required this.siteManagerName,
    required this.status,
  });

  factory LabourRequest.fromJson(Map<String, dynamic> json) {
    return LabourRequest(
      id: json['id'],
      siteManagerName: json['site_manager_name'] ?? 'N/A',
      status: json['status'],
    );
  }
}

class ApprovalItem {
  final int id;
  final String jobTitle;
  final String projectName;
  final String jobLocation;
  final String startDate;
  final String duration;
  final String status;
  final LabourRequest labourRequest;
  final Map<String, dynamic> raw;

  ApprovalItem({
    required this.id,
    required this.jobTitle,
    required this.projectName,
    required this.jobLocation,
    required this.startDate,
    required this.status,
    required this.duration,
    required this.labourRequest,
    required this.raw,
  });

  factory ApprovalItem.fromJson(Map<String, dynamic> json) {
    return ApprovalItem(
      id: json['id'],
      jobTitle: json['job_title'] ?? 'N/A',
      projectName: json['labour_request']['project_name'] ?? 'N/A',
      jobLocation: json['job_location'],
      status: json['labour_status'],
      startDate: json['labour_request']['start_date'],
      duration: json['job_duration'],
      labourRequest: LabourRequest.fromJson(json['labour_request']),
      raw: json, // keep the original JSON in case you want it later
    );
  }
}

class ApprovalsPage extends StatefulWidget {
  const ApprovalsPage({Key? key}) : super(key: key);

  @override
  State<ApprovalsPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends State<ApprovalsPage> {
  int _selectedFilter = 0;
  bool _isLoading = true;
  List<ApprovalItem> _approvals = [];

  final List<Map<String, String>> _filters = [
    {'label': 'All', 'count': '0'},
    {'label': 'Pending', 'count': '0'},
    {'label': 'Approved', 'count': '0'},
    {'label': 'Rejected', 'count': '0'},
  ];

  @override
  void initState() {
    super.initState();
    fetchApprovals();
  }

  Future<void> fetchApprovals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      Dio dio = Dio();
      if (token != null) dio.options.headers['Authorization'] = 'Bearer $token';

      final response =
          await dio.get('https://backend.jobizoindia.com/api/labour-jobs');
      final List data = response.data['data'];

      // Reverse the list so that newest items come first
      final items = data
          .map((json) => ApprovalItem.fromJson(json))
          .toList()
          .reversed
          .toList();

      // Update filter counts
      final allCount = items.length;
      final pendingCount = items.where((i) => i.status == 'pending').length;
      final approvedCount = items.where((i) => i.status == 'accept').length;
      final rejectedCount = items.where((i) => i.status == 'rejected').length;

      setState(() {
        _approvals = items;
        _filters[0]['count'] = allCount.toString();
        _filters[1]['count'] = pendingCount.toString();
        _filters[2]['count'] = approvedCount.toString();
        _filters[3]['count'] = rejectedCount.toString();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching approvals: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: AppColors.gold,
            ))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.search, color: AppColors.gold),
                        hintText: 'Search applications…',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: secondary(),
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onChanged: (q) {
                        // Optional: implement search filtering here
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Filter Tabs
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, i) {
                        final f = _filters[i];
                        final isSel = i == _selectedFilter;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFilter = i),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSel ? AppColors.gold : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border:
                                  Border.all(color: AppColors.gold, width: 1),
                            ),
                            child: Text(
                              '${f['label']} ${f['count']}',
                              style: TextStyle(
                                fontSize: tertiary(),
                                color: isSel ? Colors.white : AppColors.gold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Application Cards
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _approvals.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, idx) {
                      final item = _approvals[idx];
                      final status = item.status;
                      final statusColor = status == 'pending'
                          ? AppColors.gold
                          : status == 'accept'
                              ? Colors.green
                              : Colors.brown;

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: const Offset(0, 2)),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // header: site manager name & job title
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.labourRequest.siteManagerName,
                                        style: TextStyle(
                                          fontSize: secondary(),
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.green,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.jobTitle,
                                        style: TextStyle(
                                          fontSize: tertiary(),
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    status.capitalizeFirst!,
                                    style: TextStyle(
                                      fontSize: tertiary(),
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // project name + location & start date
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.projectName,
                                  style: TextStyle(
                                    fontSize: secondary(),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.green,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.location_on, size: 18),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        item.jobLocation,
                                        style: TextStyle(fontSize: tertiary()),
                                        softWrap: true,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Icon(Icons.schedule, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Start: ${item.startDate}',
                                      style: TextStyle(fontSize: tertiary()),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // duration
                            Row(
                              children: [
                                const Icon(Icons.hourglass_bottom, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  item.duration,
                                  style: TextStyle(fontSize: tertiary()),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // View Details button
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.gold,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                onPressed: () {
                                  final status = item.status;

                                  if (status == 'accept') {
                                    // ✅ Navigate to WorkDetailsScreen
                                    Get.to(
                                      () => WorkDetails(
                                          jobData: item
                                              .raw), // <-- Replace with your actual screen
                                      transition: Transition.rightToLeft,
                                      duration:
                                          const Duration(milliseconds: 400),
                                    );
                                  } else if (status == 'pending') {
                                    // ⏳ Navigate to detailed acceptance page
                                    Get.to(
                                      () => BeforeAcceptJob(jobData: item.raw),
                                      transition: Transition.cupertino,
                                      duration:
                                          const Duration(milliseconds: 400),
                                    );
                                  } else if (status == 'rejected') {
                                    // 🚫 Show warning
                                    SnackbarHelper.showError(
                                      context,
                                      'This application has been rejected.',
                                    );
                                  }
                                },
                                child: Text(
                                  'View Details',
                                  style: TextStyle(
                                    fontSize: tertiary(),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const NavBarLabour(currentIndex: 1),
    );
  }
}
