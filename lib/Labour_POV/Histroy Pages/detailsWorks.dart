import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../All_app_bars/normal_app_bar.dart';

class WorkDetails extends StatefulWidget {
  final int jobId; // 🔹 Expecting job ID

  const WorkDetails({Key? key, required this.jobId,})
      : super(key: key);

  @override
  State<WorkDetails> createState() => _WorkDetailsState();
}

class _WorkDetailsState extends State<WorkDetails> {
  Map<String, dynamic>? jobData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJobDetails();
  }

  Future<void> fetchJobDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      print('🔐 Token: $token');

      if (token == null) {
        throw Exception('Auth token not found.');
      }

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      print('👉 Requesting job ID: ${widget.jobId}');
      print('🔗 Final URL: https://backend.jobizoindia.com/api/labour-jobs-status/${widget.jobId}');
      final response = await dio.get(
        'https://backend.jobizoindia.com/api/labour-jobs-status/${widget.jobId}',
      );

      print('👉 Response status: ${response.statusCode}');
      print('👉 Content-Type: ${response.headers.value('content-type')}');
      if (response.statusCode == 200 &&
          response.headers.value('content-type')?.contains('application/json') == true &&
          response.data['status'] == true) {
        final data = response.data['data'];
        print('📦 Full API data: $data');

        print('👉 API data type: ${data.runtimeType}');

        if (data is Map<String, dynamic>) {
          setState(() {
            jobData = data;
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected job data format');
        }
      } else {
        throw Exception('Failed to load job data or unexpected content-type');
      }
    } catch (e) {
      print('❌ Error fetching job details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: const CustomBackAppBar(title: 'Work Details'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobData == null
              ? const Center(child: Text('No job data found.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Current Assignment',
                                style: TextStyle(
                                  fontSize: secondary(),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.green,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                jobData!['status'] ?? 'N/A',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: tertiary(),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Company & site info
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey.shade200,
                              child: Icon(Icons.location_city,
                                  color: Colors.grey[600]),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    jobData!['company_name'] ?? 'N/A',
                                    style: TextStyle(
                                      fontSize: secondary(),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                      'Site: ${jobData!['location'] ?? 'N/A'}'),
                                  Text(
                                      'Job Type: ${jobData!['job_type'] ?? 'N/A'}'),
                                  Text(
                                      'Location: ${jobData!['location'] ?? 'N/A'}'),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Site no: ${jobData!['site_no'] ?? 'N/A'}',
                              style: TextStyle(fontSize: tertiary()),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Employee info
                        Text(
                          jobData!['employee_name'] ?? 'N/A',
                          style: TextStyle(
                            fontSize: secondary(),
                            fontWeight: FontWeight.w600,
                            color: AppColors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('Employee ID:'),
                            const SizedBox(width: 8),
                            Text(jobData!['employee_id'] ?? 'N/A'),
                            const Spacer(),
                            const Icon(Icons.access_time, size: 18),
                            const SizedBox(width: 4),
                            Text(jobData!['shift_time'] ?? '-'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('Role:'),
                            const SizedBox(width: 8),
                            Text(jobData!['role'] ?? 'N/A'),
                            const Spacer(),
                            const Icon(Icons.calendar_today, size: 18),
                            const SizedBox(width: 4),
                            Text('Start: ${jobData!['start_date'] ?? 'N/A'}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('Total Hours Of Work'),
                            const Spacer(),
                            Text(jobData!['working_hours'] ?? 'N/A'),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const Text('Total Earnings'),
                            const Spacer(),
                            Text(
                              jobData!['total_earnings'] ?? 'N/A',
                              style: TextStyle(
                                fontSize: primary(),
                                fontWeight: FontWeight.bold,
                                color: Colors.lightGreen,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
