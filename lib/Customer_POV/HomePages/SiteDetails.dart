import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SiteDetail {
  final Map<String, dynamic> raw;
  final int id;
  final String? projectName;
  final String? siteManagerName;
  final String? siteManagerPhone;
  final String? siteManagerEmail;
  final String? workDescription;
  final String? workAddress;
  final String? startDate;
  final int? durationDays;
  final String? contactName;
  final String? contactPhone;
  final String? contactEmail;
  final List<Map<String, dynamic>> departments;

  SiteDetail.fromJson(Map<String, dynamic> json)
      : raw               = json,
        id                = json['id'] as int,
        projectName       = json['project_name'] as String?,
        siteManagerName   = json['site_manager_name'] as String?,
        siteManagerPhone  = json['site_manager_phone'] as String?,
        siteManagerEmail  = json['site_manager_email'] as String?,
        workDescription   = json['work_description'] as String?,
        workAddress       = json['work_address'] as String?,
        startDate         = json['start_date'] as String?,
        durationDays      = json['duration_days'] as int?,
        contactName       = json['contact_name'] as String?,
        contactPhone      = json['contact_phone'] as String?,
        contactEmail      = json['contact_email'] as String?,
        departments       = (json['departments'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>() ?? [];

  /// If the parsed field is null, fall back to printing the raw JSON value as a string.
  String rawValue(String key) {
    if (!raw.containsKey(key)) return '—';
    final v = raw[key];
    return v == null ? 'null' : v.toString();
  }
}

class Sitedetails extends StatefulWidget {
  final int siteId;
  const Sitedetails({Key? key, required this.siteId}) : super(key: key);

  @override
  State<Sitedetails> createState() => _SitedetailsState();
}

class _SitedetailsState extends State<Sitedetails> {
  bool   _loading = true;
  String _error   = '';
  SiteDetail? _detail;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() { _loading = true; _error = ''; });
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token') ?? '';
      if (token.isEmpty) throw 'Not authenticated';
      if (!token.startsWith('Bearer ')) token = 'Bearer $token';

      final dio = Dio(BaseOptions(headers: {'Authorization': token}));
      final resp = await dio.get(
        'https://backend.jobizoindia.com/api/labour-request/${widget.siteId}',
        options: Options(validateStatus: (s) => s != null && s < 500),
      );

      final body = resp.data as Map<String, dynamic>;
      if (resp.statusCode == 200 && body['status'] == true) {
        _detail = SiteDetail.fromJson(body['data'] as Map<String, dynamic>);
      } else {
        throw body['message'] ?? 'Failed to load';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: Commonappbar(title: 'Site Details'),
        body: const Center(child: CircularProgressIndicator(color: AppColors.gold,)),
      );
    }

    if (_error.isNotEmpty || _detail == null) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: Commonappbar(title: 'Site Details'),
        body: Center(child: Text(_error.isEmpty ? 'No data' : _error)),
      );
    }

    final d = _detail!;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: 'Site Details'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AssignmentInfoCard(detail: d),
            WorkAreaCard      (detail: d),
            SiteFacilitiesCard(),
            ContactInfoCard  (detail: d),
            SiteSummaryCard(detail: d),
          ],
        ),
      ),
    );
  }
}


class ReusableCard extends StatelessWidget {
  final Widget child;
  const ReusableCard({required this.child, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Color.fromRGBO(0,0,0,0.05), offset: Offset(0,1), blurRadius: 2)],
      ),
      child: child,
    ),
  );
}

// 1) Assignment Info
class AssignmentInfoCard extends StatelessWidget {
  final SiteDetail detail;
  const AssignmentInfoCard({required this.detail, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title   = detail.projectName ?? detail.rawValue('project_name');
    final address = detail.workAddress   ?? detail.rawValue('work_address');
    return ReusableCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: primary(), color: AppColors.green),
          ),
          const SizedBox(height: 4),
          Row(children: [
            Icon(Icons.location_on, size:16, color:AppColors.green),
            const SizedBox(width:4),
            Flexible(child: Text(address, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: secondary()))),
          ]),
        ],
      ),
    );
  }
}

// 2) Work Area
class WorkAreaCard extends StatelessWidget {
  final SiteDetail detail;
  const WorkAreaCard({required this.detail, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final desc = detail.workDescription ?? detail.rawValue('work_description');
    final addr = detail.workAddress   ?? detail.rawValue('work_address');
    final mgr  = detail.siteManagerName ?? detail.rawValue('site_manager_name');
    return ReusableCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        Text('Work Area Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: primary(), color: AppColors.green),
        ),
        const SizedBox(height:8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset('Assets/Labour_image/map.png', height:200, width: double.infinity, fit: BoxFit.cover),
        ),
        const SizedBox(height:12),
        Row(children:[
          Image.asset("Assets/Labour_image/zone.png"), const SizedBox(width:9),
          Expanded(child: Text(desc, style: TextStyle(fontSize: secondary()))),
          Text('${detail.durationDays ?? detail.rawValue('duration_days')} Days',
            style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold, fontSize: primary()),
          ),
        ]),
        const SizedBox(height:4),
        Row(children:[
          Image.asset("Assets/Labour_image/workers.png"), const SizedBox(width:9),
          Text('Contact: $mgr', style: TextStyle(fontSize: secondary())),
        ]),
        const SizedBox(height:4),
        Row(children:[
          Image.asset("Assets/Labour_image/clock.png"), const SizedBox(width:9),
          Text('Start: ${detail.startDate ?? detail.rawValue('start_date')}', style: TextStyle(fontSize: secondary())),
        ]),
      ]),
    );
  }
}

// 3) Site Facilities (static UI, unchanged)
class SiteFacilitiesCard extends StatelessWidget {
  const SiteFacilitiesCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => ReusableCard(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
      Text('Site Facilities',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: primary(), color: AppColors.green),
      ),
      const SizedBox(height:8),
      Wrap(spacing:80, runSpacing:10, children:[
        facilityItem('Assets/Labour_image/parking.png','Free Parking'),
        facilityItem('Assets/Labour_image/rest_room.png','Rest Rooms'),
        facilityItem(null,'Canteen', isIcon:true),
        facilityItem('Assets/Labour_image/medical_boy.png','Medical Bay'),
      ]),
    ]),
  );

  Widget facilityItem(String? assetPath,String label,{bool isIcon=false}) {
    return Row(mainAxisSize: MainAxisSize.min, children:[
      isIcon ? Icon(Icons.restaurant, color:AppColors.green)
          : Image.asset(assetPath!,height:20,width:20),
      const SizedBox(width:4),
      Text(label, style: TextStyle(fontSize: secondary())),
    ]);
  }
}

// 4) Contact Info
class ContactInfoCard extends StatelessWidget {
  final SiteDetail detail;
  const ContactInfoCard({required this.detail, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = detail.siteManagerName ?? detail.rawValue('site_manager_name');
    final phone= detail.siteManagerPhone?? detail.rawValue('site_manager_phone');
    return ReusableCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        Text('Contact Information',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: primary(), color: AppColors.green),
        ),
        const SizedBox(height:8),
        Row(children:[
          Icon(Icons.person, size:16, color:AppColors.green),
          const SizedBox(width:4),
          Text('Site Manager: $name', style: TextStyle(fontSize: secondary())),
        ]),
        const SizedBox(height:4),
        Row(children:[
          Icon(Icons.phone, size:16, color:AppColors.green),
          const SizedBox(width:4),
          Text(phone, style: TextStyle(fontSize: secondary())),
        ]),
      ]),
    );
  }
}

// 5) Site Summary (static UI)
class SiteSummaryCard extends StatelessWidget {
  final SiteDetail detail;
  const SiteSummaryCard({required this.detail, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final totalWorkers = detail.departments.fold<int>(
      0,
          (sum, entry) => sum + (entry['number_of_labour'] as int? ?? 0),
    );

    final counts = {
      'Electricians': 0,
      'Plumbers': 0,
      'Painters': 0,
      'Carpenters': 0,
      'Construction': 0,
      'Others': 0,
    };

    for (var entry in detail.departments) {
      final dept = entry['department'] as Map<String, dynamic>;
      final name = (dept['name'] as String).toLowerCase();
      final labourCount = (entry['number_of_labour'] as int?) ?? 0;

      if (name.contains('electrician')) {
        counts['Electricians'] = labourCount;
      } else if (name.contains('plumber')) {
        counts['Plumbers'] = labourCount;
      } else if (name.contains('painter')) {
        counts['Painters'] = labourCount;
      } else if (name.contains('carpenter')) {
        counts['Carpenters'] = labourCount;
      } else if (name.contains('construction')) {
        counts['Construction'] = labourCount;
      } else {
        counts['Others'] = labourCount;
      }
    }


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Job Instruction (unchanged)
        ReusableCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Job Instruction',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: primary(),
                  color: AppColors.green,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'All scheduled tasks for the site must be completed as planned, ensuring that every team '
                    'follows the necessary safety protocols throughout the day. It is essential that progress '
                    'updates are reported to the site supervisor before the end of each shift to maintain '
                    'workflow and accountability.',
                style: TextStyle(fontSize: secondary()),
              ),
            ],
          ),
        ),

        // Stats Row (unchanged)
        Container(
          width: double.infinity,
          height: 140,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.gold),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$totalWorkers',  // <- dynamic total here
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total Workers',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: secondary(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text('98',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black)),
                      const SizedBox(height: 4),
                      Text('Active Today',
                          style: TextStyle(
                              color: Colors.black, fontSize: secondary()
                          )
                      ),
                      // Text('+3% this week',
                      //     style:
                      //     TextStyle(color: Colors.grey[700], fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Labor Distribution – now driven by `counts`
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Labor Distribution',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: primary(),
                color: AppColors.green),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            runSpacing: 12,
            spacing: 8,
            children: [
              laborCard(context, Icons.engineering,       'Construction', counts['Construction']!, 50, Colors.blue),
              laborCard(context, Icons.electrical_services,'Electricians', counts['Electricians']!, 40, Colors.brown),
              laborCard(context, Icons.plumbing,          'Plumbers',     counts['Plumbers']!,     20, Colors.orange),
              laborCard(context, Icons.handyman,          'Carpenters',   counts['Carpenters']!,   20, Colors.green),
              laborCard(context, Icons.format_paint,      'Painters',     counts['Painters']!,     20, AppColors.gold),
              laborCard(context, Icons.group,             'Others',       counts['Others']!,       30, Colors.blueGrey),
            ],
          ),
        ),
      ],
    );
  }

  Widget laborCard(
      BuildContext context,
      IconData icon,
      String role,
      int current,
      int total,
      Color color,
      ) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 24,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              offset: Offset(0, 1),
              blurRadius: 2)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            '$current/$total',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(role, style: TextStyle(fontSize: secondary())),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: total > 0 ? current / total : 0.0,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}
