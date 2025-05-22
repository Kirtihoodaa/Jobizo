import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:jobizo/Customer_POV/AppBar/CustomerAppBar.dart';
import 'package:jobizo/Customer_POV/CustomerNavBar.dart';
import 'package:jobizo/Customer_POV/HistoryPages/RequestDetails.dart';
import 'package:jobizo/Design contraints/app color.dart';
import 'package:jobizo/Design contraints/FontSizes.dart';

class Histotypagee extends StatefulWidget {
  const Histotypagee({super.key});

  @override
  _HistotypageeState createState() => _HistotypageeState();
}

class _HistotypageeState extends State<Histotypagee> {
  bool _loading = true;
  String? _error;
  List<_Request> _requests = [];

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token') ?? '';
      if (!token.startsWith('Bearer ')) token = 'Bearer $token';

      final dio = Dio(BaseOptions(headers: {'Authorization': token}));
      final resp = await dio.get(
        'https://backend.jobizoindia.com/api/labour-request',
        options: Options(validateStatus: (s) => s != null && s < 500),
      );

      if (resp.statusCode == 200 && resp.data['data'] is List) {
        final List<dynamic> data = resp.data['data'] as List<dynamic>;
        _requests = data.map((e) => _Request.fromJson(e)).toList();
      } else {
        throw 'Failed to load: unexpected response format';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() => _loading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: Customerappbar(profileImageUrl: ''),
        body: const Center(child: CircularProgressIndicator(color: AppColors.green,)),
        bottomNavigationBar: Customernavbar(currentIndex: 2),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: Customerappbar(profileImageUrl: ''),
        body: Center(child: Text(_error!)),
        bottomNavigationBar: Customernavbar(currentIndex: 2),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Customerappbar(profileImageUrl: ''),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Request History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.green,
              ),
            ),
            const SizedBox(height: 12),
            ..._requests.map(_buildRequestCard),
          ],
        ),
      ),
      bottomNavigationBar: Customernavbar(currentIndex: 2),
    );
  }

  Widget _buildRequestCard(_Request r) {
    final isPending = r.status.toLowerCase() == 'pending';
    final statusColor = isPending ? AppColors.gold : AppColors.brown;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                r.serviceType,
                style: TextStyle(
                  fontSize: primary(),
                  fontWeight: FontWeight.w600,
                  color: AppColors.green,
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  r.status.capitalize!,
                  style: TextStyle(
                    fontSize: tertiary(),
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Worker count
          Row(
            children: [
              const Icon(Icons.group, size: 16),
              const SizedBox(width: 6),
              Text('${r.workers} Workers',
                  style: TextStyle(fontSize: secondary())),
            ],
          ),
          const SizedBox(height: 8),
          // Location
          Text(r.location, style: TextStyle(fontSize: secondary())),
          const SizedBox(height: 8),
          // Start
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 6),
              Text('Start: ${_formatDate(r.startDate)}',
                  style: TextStyle(fontSize: secondary())),
            ],
          ),
          const Divider(height: 24),
          // Submitted + button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Submitted: ${_formatDate(r.submittedDate)}',
                style: TextStyle(fontSize: tertiary(), color: Colors.black),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(
                        () => Requestdetails(requestId: r.id),
                    transition: Transition.cupertino,
                    duration: const Duration(milliseconds: 400),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13, vertical: 5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  'View Details',
                  style: TextStyle(
                      fontSize: tertiary(),
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    const monthNames = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${monthNames[d.month - 1]} ${d.day}, ${d.year}';
  }
}

class _Request {
  final int id;
  final String serviceType;
  final int workers;
  final String location;
  final DateTime startDate;
  final DateTime submittedDate;
  final String status;

  _Request({
    required this.id,
    required this.serviceType,
    required this.workers,
    required this.location,
    required this.startDate,
    required this.submittedDate,
    required this.status,
  });

  factory _Request.fromJson(Map<String, dynamic> json) {
    // department name fallback if project_name null
    final deptList = json['departments'] as List<dynamic>;
    final firstDept = deptList.isNotEmpty
        ? (deptList[0]['department']['name'] as String)
        : 'Unknown';
    return _Request(
      id: json['id'] as int,
      serviceType: firstDept.capitalize ?? firstDept,
      workers: json['total_labour'] as int,
      location: json['work_address'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      submittedDate: DateTime.parse(json['created_at'] as String),
      status: json['status'] as String? ?? 'pending',
    );
  }
}
