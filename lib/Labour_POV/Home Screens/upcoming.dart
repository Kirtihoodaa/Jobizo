import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import '../All_app_bars/normal_app_bar.dart';

class UpcomingAssignmentScreen extends StatefulWidget {
  final int jobId;
  const UpcomingAssignmentScreen({super.key, required this.jobId});

  @override
  State<UpcomingAssignmentScreen> createState() =>
      _UpcomingAssignmentScreenState();
}

class _UpcomingAssignmentScreenState extends State<UpcomingAssignmentScreen> {
  Map<String, dynamic>? jobData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUpcomingAssignment();
  }

  Future<void> fetchUpcomingAssignment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      Dio dio = Dio();
      dio.options.headers["Authorization"] = "Bearer $token";

      final response = await dio.get(
          "https://backend.jobizoindia.com/api/labour-jobs-status/${widget.jobId}");
      print(widget.jobId);

      if (response.statusCode == 200 && response.data['status'] == true) {
        final data = response.data['data'];

        if (data != null) {
          setState(() {
            jobData = data;
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("❌ API Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: CustomBackAppBar(title: 'Upcoming Assignment'),
      body: isLoading
          ? const Center(
          child: CircularProgressIndicator(color: AppColors.gold))
          : jobData == null
          ? const Center(child: Text("No upcoming assignments"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AssignmentInfoCard(
              company: jobData!["labour_request"]["company_name"] ??
                  'N/A',
              location: jobData!["location"] ?? 'N/A',
            ),
            WorkAreaCard(
              salary: jobData!["salary"]?.toString() ?? '0',
              duration: jobData!["duration"] ?? '0 days',
              workingHours:
              jobData!["labour_request"]["working_hours"] ??
                  'N/A',
              department: jobData!["department_name"] ?? 'Unknown',
              startDate: jobData!["labour_request"]["start_date"] ?? 'N/A',
            ),
            SiteFacilitiesCard(
              facilities: jobData!["site_facilities"] is List
                  ? (jobData!["site_facilities"] as List<dynamic>)
                  .join(', ')
                  : 'No site facilities',
            ),
            ContactInfoCard(
              manager: jobData!["labour_request"]
              ["site_manager_name"] ??
                  'No Assigned',
              phone: jobData!["labour_request"]["site_manager_contact_number"] ?? 'N/A',
            ),
          ],
        ),
      ),
    );
  }
}

class ReusableCard extends StatelessWidget {
  final Widget child;

  const ReusableCard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
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

class AssignmentInfoCard extends StatelessWidget {
  final String company;
  final String location;

  const AssignmentInfoCard(
      {super.key, required this.company, required this.location});

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            company,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: primary(),
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: AppColors.green),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  location,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: secondary()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WorkAreaCard extends StatelessWidget {
  final String salary;
  final String duration;
  final String workingHours;
  final String department;
  final String startDate;

  const WorkAreaCard({
    super.key,
    required this.salary,
    required this.duration,
    required this.workingHours,
    required this.department,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Work Area Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: primary(),
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
              Expanded(
                child: Text(
                  '$department',
                  style: TextStyle(fontSize: secondary()),
                ),
              ),
              Text(
                'INR $salary/Day',
                style: TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: primary(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              // Image.asset("Assets/Labour_image/calendar.png"), // you can replace with any icon
              // const SizedBox(width: 9),
              Text(
                'Start Date: $startDate',
                style: TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: secondary(),
                ),
              ),
              const Spacer(),
              Image.asset("Assets/Labour_image/month_alarm.png"),
              const SizedBox(width: 9),
              Text(
                duration,
                style: TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: secondary(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Row(
            children: [
              Image.asset("Assets/Labour_image/clock.png"),
              const SizedBox(width: 9),
              Text(
                workingHours,
                style: TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: secondary(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SiteFacilitiesCard extends StatelessWidget {
  final String facilities;

  const SiteFacilitiesCard({super.key, required this.facilities});

  @override
  Widget build(BuildContext context) {
    final List<String> facilityList =
    facilities.split(',').map((e) => e.trim()).toList();

    return ReusableCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Site Facilities',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: primary(),
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: facilityList.map((facility) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check, size: 16, color: AppColors.green),
                  const SizedBox(width: 6),
                  Text(facility, style: TextStyle(fontSize: secondary())),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class ContactInfoCard extends StatelessWidget {
  final String manager;
  final String phone;

  const ContactInfoCard({
    super.key,
    required this.manager,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: primary(),
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person, size: 16, color: AppColors.green),
              const SizedBox(width: 4),
              Text('Site Manager: $manager',
                  style: TextStyle(fontSize: secondary())),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.phone, size: 16, color: AppColors.green),
              const SizedBox(width: 4),
              Text(phone, style: TextStyle(fontSize: secondary())),
            ],
          ),
        ],
      ),
    );
  }
}
