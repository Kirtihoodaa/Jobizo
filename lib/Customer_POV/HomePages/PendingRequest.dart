import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Customer_POV/HistoryPages/RequestDetails.dart';
import 'package:jobizo/Customer_POV/HomePages/ApplicationDetails.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

// Model class
class PendingRequest {
  final int id;
  final String type; // "Construction" or "Job Application"
  final String? title; // Only for Job Application
  final int? workers;  // Sum of all departments
  final String location;
  final String? startDate;
  final String submittedDate;

  PendingRequest({
    required this.id,
    required this.type,
    this.title,
    this.workers,
    required this.location,
    this.startDate,
    required this.submittedDate,
  });

  factory PendingRequest.fromLabourRequest(Map<String, dynamic> json) {
    final departments = json['departments'] as List<dynamic>? ?? [];
    int workers = departments.fold<int>(
      0,
          (sum, d) => sum + (d['number_of_labour'] as int? ?? 0),
    );
    return PendingRequest(
      id: json['id'] as int,
      type: 'Construction',
      workers: workers,
      location: json['work_address'] ?? '',
      startDate: json['start_date'],
      submittedDate: (json['created_at'] ?? '')
          .toString()
          .split('T')
          .first,
    );
  }

  factory PendingRequest.fromJobApplication(Map<String, dynamic> json) {
    return PendingRequest(
      id: json['id'] as int,
      type: 'Job Application',
      title: json['job_title'] ?? 'Job Application',
      workers: null,
      location: '',
      startDate: null,
      submittedDate: (json['created_at'] ?? '')
          .toString()
          .split('T')
          .first,
    );
  }
}

class PendingRequestScreen extends StatefulWidget {
  const PendingRequestScreen({Key? key}) : super(key: key);

  @override
  State<PendingRequestScreen> createState() => _PendingRequestScreenState();
}

class _PendingRequestScreenState extends State<PendingRequestScreen> {
  List<PendingRequest> pendingList = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchPendingRequests();
  }

  Future<void> fetchPendingRequests() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final resp = await dio.get(
        'https://backend.jobizoindia.com/api/pending-requests',
        options: Options(validateStatus: (_) => true),
      );

      if (resp.statusCode == null ||
          resp.statusCode! < 200 ||
          resp.statusCode! >= 300) {
        setState(() {
          error = 'Failed to load: Server returned status ${resp.statusCode}';
          pendingList = [];
        });
        return;
      }

      dynamic raw = resp.data;
      if (raw is String) raw = jsonDecode(raw);

      if (raw is! Map<String, dynamic> || raw['status'] != true) {
        setState(() {
          error = 'Failed to load: Unexpected response format';
          pendingList = [];
        });
        return;
      }

      final data = raw['data'] as Map<String, dynamic>;
      final labourRequests = (data['labour_requests'] as List<dynamic>?) ?? [];
      final jobApps = (data['job_applications'] as List<dynamic>?) ?? [];

      final List<PendingRequest> list = [];
      for (final entry in labourRequests) {
        list.add(PendingRequest.fromLabourRequest(entry));
      }
      for (final entry in jobApps) {
        list.add(PendingRequest.fromJobApplication(entry));
      }

      // **Reverse the combined list** so the most recent items appear first
      final reversedList = list.reversed.toList();

      setState(() {
        pendingList = reversedList;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load: $e';
        pendingList = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: const Commonappbar(title: "Pending Request"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!))
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pending Request",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.green,
                    fontSize: secondary())),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: pendingList.length,
                itemBuilder: (context, index) {
                  return PendingCard(item: pendingList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PendingCard extends StatelessWidget {
  final PendingRequest item;
  const PendingCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.type,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.green,
                      fontSize: secondary())),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Pending',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),

          // Workers (for Construction)
          if (item.workers != null) ...[
            Row(
              children: [
                const Icon(Icons.people, size: 16),
                const SizedBox(width: 10),
                Text(
                  "${item.workers} Workers",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: tertiary()),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],

          // Location
          if (item.location.isNotEmpty) ...[
            Text(
              item.location,
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: tertiary()),
            ),
            const SizedBox(height: 6),
          ],

          // Start Date
          if (item.startDate != null) ...[
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 6),
                Text(
                  "Start: ${item.startDate}",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: tertiary()),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],

          // Submitted + Button
          Row(
            children: [
              Text(
                "Submitted: ${item.submittedDate}",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: tertiary()),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (item.type == "Construction") {
                    Get.to(
                          () => Requestdetails(requestId: item.id),      // passes id here
                      transition: Transition.cupertino,
                      duration: const Duration(milliseconds: 400),
                    );
                  } else if (item.type == "Job Application") {
                    Get.to(
                          () => ApplicationDetail(applicationId: item.id),  // and here
                      transition: Transition.cupertino,
                      duration: const Duration(milliseconds: 400),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "View Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: tertiary(),
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
