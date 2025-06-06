import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Requestdetails extends StatefulWidget {
  final int requestId;

  const Requestdetails({Key? key, required this.requestId}) : super(key: key);

  @override
  State<Requestdetails> createState() => _RequestdetailsState();
}

class _RequestdetailsState extends State<Requestdetails> {
  bool _loading = true;
  String? _error;
  _Detail? _detail; // May be null until loaded

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
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
        final dataList = resp.data['data'] as List;
        final match = dataList.firstWhere(
              (item) => item['id'] == widget.requestId,
          orElse: () => null,
        );

        if (match != null) {
          _detail = _Detail.fromJson(match);
        } else {
          throw 'No request found with ID ${widget.requestId}';
        }
      } else {
        throw resp.data['message'] ?? 'Invalid response';
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
        appBar: Commonappbar(title: "Request Details"),
        body: const Center(
            child: CircularProgressIndicator(color: AppColors.green)),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: Commonappbar(title: "Request Details"),
        body: Center(child: Text(_error!)),
      );
    }

    // At this point, _detail is non-null
    final d = _detail!;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: "Request Details"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      d.projectName ?? "—",
                      style: TextStyle(
                        fontSize: secondary(),
                        fontWeight: FontWeight.bold,
                        color: AppColors.green,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: d.status.toLowerCase() == 'pending'
                          ? AppColors.gold
                          : AppColors.brown,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      d.status.capitalize!,
                      style: TextStyle(
                        fontSize: tertiary(),
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Workers Required (flatten departments)
              Text("Workers Required",
                  style: TextStyle(
                      fontSize: secondary(), fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: d.departments
                    .map((dept) => Text(
                  "${dept.departmentName} ${dept.numberOfLabour}",
                  style: TextStyle(
                      fontSize: tertiary(),
                      fontWeight: FontWeight.w400),
                ))
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Duration
              Text("Duration",
                  style: TextStyle(
                      fontSize: secondary(), fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text("${d.durationDays} day(s)",
                  style: TextStyle(
                      fontSize: tertiary(), fontWeight: FontWeight.w400)),
              const SizedBox(height: 16),

              // Start & End Date
              Row(
                children: [
                  Expanded(
                    child: _dateColumn("Start Date", d.startDate),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _dateColumn(
                        "End Date",
                        d.startDate.add(
                            Duration(days: d.durationDays))),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Location
              Text("Location",
                  style: TextStyle(
                      fontSize: secondary(), fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(d.workAddress ?? "—",
                  style: TextStyle(
                      fontSize: tertiary(), fontWeight: FontWeight.w400)),
              const SizedBox(height: 30),

              // Site Manager Name
              Text("Site Manager Name",
                  style: TextStyle(
                      fontSize: secondary(), fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(d.siteManagerName ?? "—",
                  style: TextStyle(
                      fontSize: tertiary(), fontWeight: FontWeight.w400)),
              const SizedBox(height: 30),

              // Phone Number
              Text("Phone Number",
                  style: TextStyle(
                      fontSize: secondary(), fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(d.siteManagerPhone ?? "—",
                  style: TextStyle(
                      fontSize: tertiary(), fontWeight: FontWeight.w400)),
              const SizedBox(height: 30),

              // Email
              Text("Email",
                  style: TextStyle(
                      fontSize: secondary(), fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(d.siteManagerEmail ?? "—",
                  style: TextStyle(
                      fontSize: tertiary(), fontWeight: FontWeight.w400)),
              const SizedBox(height: 30),

              // Work Description
              Text("Work Description",
                  style: TextStyle(
                      fontSize: secondary(), fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(d.workDescription ?? "—",
                  style: TextStyle(
                      fontSize: tertiary(), fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateColumn(String label, DateTime date) {
    final formatted =
        "${_monthNames[date.month - 1]} ${date.day}, ${date.year}";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
            TextStyle(fontSize: tertiary(), fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(formatted,
            style:
            TextStyle(fontSize: tertiary(), fontWeight: FontWeight.w400)),
      ],
    );
  }

  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
}

class _RequestDepartment {
  final String departmentName;
  final int numberOfLabour;

  _RequestDepartment({
    required this.departmentName,
    required this.numberOfLabour,
  });
}

class _Detail {
  final int id;
  final String? projectName;
  final String? siteManagerName;
  final String? siteManagerPhone;
  final String? siteManagerEmail;
  final String? workDescription;
  final String? workAddress;
  final DateTime startDate;
  final int durationDays;
  final String status;
  final List<_RequestDepartment> departments;

  _Detail({
    required this.id,
    this.projectName,
    this.siteManagerName,
    this.siteManagerPhone,
    this.siteManagerEmail,
    this.workDescription,
    this.workAddress,
    required this.startDate,
    required this.durationDays,
    required this.status,
    required this.departments,
  });

  factory _Detail.fromJson(Map<String, dynamic> json) {
    // Departments: safely map each entry, defaulting missing strings
    final depsJson = (json['departments'] as List<dynamic>? ?? []);
    final deps = depsJson.map((d) {
      final deptObj = d['department'] as Map<String, dynamic>? ?? {};
      return _RequestDepartment(
        departmentName: (deptObj['name'] as String?) ?? 'Unknown',
        numberOfLabour: (d['number_of_labour'] as int?) ?? 0,
      );
    }).toList();

    return _Detail(
      id: json['id'] as int,
      projectName: (json['project_name'] as String?),
      siteManagerName: (json['site_manager_name'] as String?) ?? '—',
      siteManagerPhone: (json['site_manager_phone'] as String?) ?? '—',
      siteManagerEmail: (json['site_manager_email'] as String?) ?? '—',
      workDescription: (json['work_description'] as String?) ?? '—',
      workAddress: (json['work_address'] as String?) ?? '—',
      startDate: DateTime.parse(json['start_date'] as String? ?? ''),
      durationDays: (json['duration_days'] as num?)?.toInt() ?? 0,
      status: (json['status'] as String?) ?? 'pending',
      departments: deps,
    );
  }
}
