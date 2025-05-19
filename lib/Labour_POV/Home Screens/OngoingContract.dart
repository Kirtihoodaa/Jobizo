import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobizo/Design contraints/app color.dart';
import 'package:jobizo/Design contraints/FontSizes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OngoingContractPage extends StatefulWidget {
  const OngoingContractPage({super.key});

  @override
  State<OngoingContractPage> createState() => _OngoingContractPageState();
}

class _OngoingContractPageState extends State<OngoingContractPage> {
  List<_ContractData> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOngoingContracts();
  }
  Future<void> fetchOngoingContracts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token'); // 🔐 get token
      print(token);
      if (token == null || token.isEmpty) {
        print("❌ No auth token found.");
        setState(() => isLoading = false);
        return;
      }
      final dio = Dio();
      final response = await dio.get('https://backend.jobizoindia.com/api/labour-request');

      if (response.statusCode == 200 && response.data['status'] == true) {
        print("✔️ Response fetched successfully");

        final List dataList = response.data['data'] ?? [];
        final List<_ContractData> contracts = [];

        for (var item in dataList) {
          // Safely extract departments
          String roles = "";
          if (item['departments'] is List) {
            final List deptList = item['departments'];
            roles = deptList
                .map((d) => d['department']?['name'] ?? '')
                .where((name) => name.toString().isNotEmpty)
                .join(', ');
          }

          contracts.add(
            _ContractData(
              company: item['project_name'] ?? 'N/A',
              siteName: item['work_address'] ?? 'N/A',
              siteNo: item['id'].toString(),
              jobType: roles.isNotEmpty ? roles : 'N/A',
              location: item['work_address'] ?? 'N/A',
              employeeName: item['site_manager_name'] ?? 'N/A',
              employeeId: item['user_id'].toString(),
              hours: '8:00 AM - 5:00 PM',
              startDate: item['start_date'] ?? '',
              duration: "${item['duration_days'] ?? 0} days",
            ),
          );
        }

        setState(() {
          items = contracts;
          isLoading = false;
        });
      } else {
        print("❌ Unexpected response: ${response.data}");
        setState(() => isLoading = false);
      }
    } catch (e, stacktrace) {
      print("❌ Error fetching contracts: $e");
      print(stacktrace);
      setState(() => isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.gold,
        elevation: 0,
        leading: BackButton(color: Colors.white),
        centerTitle: true,
        title: Text(
          'Ongoing Contract',
          style: TextStyle(
            fontSize: primary(),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
        body: isLoading
            ? Center(child: CircularProgressIndicator(color: AppColors.gold,))
            : items.isEmpty
            ? Center(child: Text("No ongoing contracts found."))
            : SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: items
                .map((data) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ContractCard(data: data),
            ))
                .toList(),
          ),
        ),
    );
  }
}

class _ContractData {
  final String company,
      siteName,
      siteNo,
      jobType,
      location,
      employeeName,
      employeeId,
      hours,
      startDate,
      duration;

  _ContractData({
    required this.company,
    required this.siteName,
    required this.siteNo,
    required this.jobType,
    required this.location,
    required this.employeeName,
    required this.employeeId,
    required this.hours,
    required this.startDate,
    required this.duration,
  });
}

class _ContractCard extends StatelessWidget {
  final _ContractData data;
  const _ContractCard({required this.data});

  @override
  Widget build(BuildContext context) {
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
          // Header row: title & status
          Row(
            children: [
              Expanded(
                child: Text(
                  'Current Assignment',
                  style: TextStyle(
                      fontSize: secondary(),
                      fontWeight: FontWeight.w600,
                      color: AppColors.green),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Ongoing',
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
          // Company & site info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey.shade200,
                child:
                    Icon(Icons.location_city, size: 35, color: AppColors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.company,
                      style: TextStyle(
                          fontSize: secondary(),
                          fontWeight: FontWeight.w600,
                          color: AppColors.green),
                    ),
                    const SizedBox(height: 8),
                    Text('Site: ${data.siteName}'),
                    Text('Job Type: ${data.jobType}'),
                    Text('Location: ${data.location}'),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Site No: ${data.siteNo}',
                style: TextStyle(fontSize: tertiary()),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Employee section
          Text(
            data.employeeName,
            style: TextStyle(
                fontSize: secondary(),
                fontWeight: FontWeight.w600,
                color: AppColors.green),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Text('Employee ID:'),
              const SizedBox(width: 8),
              Text(data.employeeId),
              Spacer(),
              Icon(Icons.access_time, size: 18),
              const SizedBox(width: 8),
              Text(data.hours),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Text('Role:'),
              const SizedBox(width: 8),
              Text(data.jobType),
              Spacer(),
              Icon(Icons.calendar_today, size: 18),
              const SizedBox(width: 8),
              Text('Start: ${data.startDate}'),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Text('Duration:'),
              const SizedBox(width: 8),
              Text(
                data.duration,
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
