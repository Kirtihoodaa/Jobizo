import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Design contraints/FontSizes.dart';
import '../../Design contraints/app color.dart';
import '../All_app_bars/app_bar.dart';
import '../NavBar.dart';
import 'detailsWorks.dart';

class JobModel {
  final String company;
  final String jobTitle;
  final String jobLocation;
  final String duration;
  final String status;
  final String startDate;
  final String labourName;
  final int jobid;

  JobModel({
    required this.company,
    required this.jobTitle,
    required this.jobLocation,
    required this.duration,
    required this.status,
    required this.startDate,
    required this.labourName,
    required this.jobid,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      company: json['company'] ?? 'N/A',
      jobTitle: json['job_title'] ?? '',
      jobLocation: json['job_location'] ?? '',
      duration: json['job_duration'] ?? '',
      status: json['status'] ?? '',
      startDate: json['start_date'] ?? '',
      labourName: json['site_manager_name'] ?? '',
      jobid: json['project_id'] ?? 0,
    );
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _selectedFilter = 0;
  List<JobModel> jobList = [];

  final List<Map<String, String>> _filters = [
    {'label': 'All Jobs', 'count': '0'},
    {'label': 'Ongoing', 'count': '0'},
    {'label': 'Completed', 'count': '0'},
    {'label': 'Cancelled', 'count': '0'},
  ];

  @override
  void initState() {
    super.initState();
    fetchJobHistory();
  }

  Future<void> fetchJobHistory() async {
    final dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    dio.options.headers["Authorization"] = "Bearer $token";

    try {
      final response = await dio
          .get('https://backend.jobizoindia.com/api/labour-job-history');
      if (response.statusCode == 200 && response.data['status'] == true) {
        final jobsJson = response.data['jobs'] as List;
        setState(() {
          jobList = jobsJson.map((e) => JobModel.fromJson(e)).toList();
        });
      }
    } catch (e) {
      print("❌ Failed to fetch job history: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              ),
            ),
            const SizedBox(height: 16),
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
                        border: Border.all(color: AppColors.gold, width: 1),
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
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: jobList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, idx) {
                final job = jobList[idx];
                final statusColor = job.status.toLowerCase() == 'pending'
                    ? AppColors.gold
                    : job.status.toLowerCase() == 'accept'
                        ? Colors.lightGreen[700]
                        : Colors.brown;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job.labourName,
                                  style: TextStyle(
                                      fontSize: secondary(),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.green),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  job.jobTitle,
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
                              job.status,
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
                      Text(
                        job.company,
                        style: TextStyle(
                            fontSize: secondary(),
                            fontWeight: FontWeight.w600,
                            color: AppColors.green),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 18),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              job.jobLocation,
                              style: TextStyle(fontSize: tertiary()),
                              softWrap: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.schedule, size: 18),
                          const SizedBox(width: 4),
                          Text('Start Date: ${job.startDate}',
                              style: TextStyle(fontSize: tertiary())),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.hourglass_bottom, size: 18),
                          const SizedBox(width: 4),
                          Text(job.duration,
                              style: TextStyle(fontSize: tertiary())),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Get.to(
                                  () => WorkDetails(
                                jobId: job.jobid,

                              ),
                              transition: Transition.cupertino,
                              duration: const Duration(milliseconds: 400),
                            );
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
      bottomNavigationBar: NavBarLabour(currentIndex: 2),
    );
  }
}
