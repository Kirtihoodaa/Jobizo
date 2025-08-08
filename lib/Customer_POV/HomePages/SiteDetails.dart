import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A data class that wraps the JSON fields for a labour request (site detail).
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
      : raw = json,
        id = json['id'] as int,
        projectName = json['project_name'] as String?,
  // Pull site manager info from nested "site_manager" -> "user"
        siteManagerName =
        (json['site_manager'] != null && json['site_manager']['user'] != null)
            ? (json['site_manager']['user']['name'] as String?)
            : null,
        siteManagerPhone =
        (json['site_manager'] != null && json['site_manager']['user'] != null)
            ? (json['site_manager']['user']['phone'] as String?)
            : null,
        siteManagerEmail =
        (json['site_manager'] != null && json['site_manager']['user'] != null)
            ? (json['site_manager']['user']['email'] as String?)
            : null,
        workDescription = json['work_description'] as String?,
        workAddress = json['work_address'] as String?,
        startDate = json['start_date'] as String?,
        durationDays = (json['duration_days'] as int?) ?? 0,
        contactName = json['contact_name'] as String?,
        contactPhone = json['contact_phone'] as String?,
        contactEmail = json['contact_email'] as String?,
        departments = (json['departments'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>() ??
            [];

  /// If a parsed field is null, this method prints a fallback of the raw JSON value
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
  bool _loading = true;
  String _error = '';
  SiteDetail? _detail;

  /// Tracks how many workers have been “accepted” for each role.
  final Map<String, int> _acceptedCounts = {
    'Construction': 0,
    'Electricians': 0,
    'Plumbers': 0,
    'Carpenters': 0,
    'Painters': 0,
    'Others': 0,
  };

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _loading = true;
      _error = '';
    });
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
        final data = body['data'] as Map<String, dynamic>;
        _detail = SiteDetail.fromJson(data['request'] as Map<String, dynamic>);

        // Parse assigned labour counts
        final assignedLabourCounts = Map<String, int>.from(data['assigned_labour_counts'] ?? {});
        // Set your _acceptedCounts per department (by capitalized role name for UI matching)
        _acceptedCounts.clear();
        assignedLabourCounts.forEach((role, count) {
          _acceptedCounts[_roleDisplayName(role)] = count;
        });

      } else {
        throw body['message'] ?? 'Failed to load';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
  String _roleDisplayName(String role) {
    if (role.contains('electrician')) return 'Electricians';
    if (role.contains('plumber')) return 'Plumbers';
    if (role.contains('painter')) return 'Painters';
    if (role.contains('carpenter')) return 'Carpenters';
    if (role.contains('construction')) return 'Construction';
    return 'Others';
  }


  /// Called when a user taps to “accept” a worker for [role].
  /// Finds the matching department_id, sends a POST to the server, and
  /// increments the local counter only if the server responds with success.
  Future<void> _acceptLaborRole(String role) async {
    if (_detail == null) return;

    // Find department entry whose name matches [role] (case-insensitive).
    final deptEntry = _detail!.departments.firstWhere(
          (entry) {
        final deptMap = entry['department'] as Map<String, dynamic>? ?? {};
        final name = (deptMap['name'] as String? ?? '').toLowerCase();
        return name == role.toLowerCase();
      },
      orElse: () => {},
    );

    final departmentId = (deptEntry['department_id'] as int?);

    if (departmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid department_id')),
      );
      return;
    }

    // Send POST to backend endpoint to register acceptance.
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token') ?? '';
      if (!token.startsWith('Bearer ')) token = 'Bearer $token';

      final dio = Dio(BaseOptions(headers: {'Authorization': token}));
      final response = await dio.post(
        'https://backend.jobizoindia.com/api/labour-request/${widget.siteId}/accept',
        data: {
          'department_id': departmentId,
          // include any additional fields if required by your API
        },
        options: Options(validateStatus: (s) => s != null && s < 500),
      );

      final respBody = response.data as Map<String, dynamic>;
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          respBody['status'] == true) {
        setState(() {
          _acceptedCounts[role] = (_acceptedCounts[role] ?? 0) + 1;
        });
      } else {
        final msg =
            respBody['message'] ?? 'Failed (code ${response.statusCode})';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: Commonappbar(title: 'Site Details'),
        body: const Center(
            child: CircularProgressIndicator(color: AppColors.gold)),
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
            WorkAreaCard(detail: d),
            SiteFacilitiesCard(),
            ContactInfoCard(detail: d),
            SiteSummaryCard(
              detail: d,
              acceptedCounts: _acceptedCounts,
              onAccept: (role) {
                _acceptLaborRole(role);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable container for a white “card” with padding & shadow.
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
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              offset: Offset(0, 1),
              blurRadius: 2),
        ],
      ),
      child: child,
    ),
  );
}

// 1) Assignment Info
class AssignmentInfoCard extends StatelessWidget {
  final SiteDetail detail;
  const AssignmentInfoCard({required this.detail, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = detail.projectName ?? detail.rawValue('project_name');
    final address = detail.workAddress ?? detail.rawValue('work_address');
    return ReusableCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: primary(),
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 4),
          Row(children: [
            Icon(Icons.location_on, size: 16, color: AppColors.green),
            const SizedBox(width: 4),
            Flexible(
              child: Text(address,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: secondary())),
            ),
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
    final addr = detail.workAddress ?? detail.rawValue('work_address');
    final mgr = detail.siteManagerName ?? detail.rawValue('site_manager_name');
    return ReusableCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        Row(children: [
          Image.asset("Assets/Labour_image/zone.png"),
          const SizedBox(width: 9),
          Expanded(child: Text(desc, style: TextStyle(fontSize: secondary()))),
          Text(
            '${detail.durationDays ?? detail.rawValue('duration_days')} Days',
            style: TextStyle(
              color: AppColors.green,
              fontWeight: FontWeight.bold,
              fontSize: primary(),
            ),
          ),
        ]),
        const SizedBox(height: 4),
        Row(children: [
          Image.asset("Assets/Labour_image/workers.png"),
          const SizedBox(width: 9),
          Text('Contact: $mgr', style: TextStyle(fontSize: secondary())),
        ]),
        const SizedBox(height: 4),
        Row(children: [
          Image.asset("Assets/Labour_image/clock.png"),
          const SizedBox(width: 9),
          Text('Start: ${detail.startDate ?? detail.rawValue('start_date')}',
              style: TextStyle(fontSize: secondary())),
        ]),
      ]),
    );
  }
}

// 3) Site Facilities (static UI)
class SiteFacilitiesCard extends StatelessWidget {
  const SiteFacilitiesCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ReusableCard(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Site Facilities',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: primary(),
          color: AppColors.green,
        ),
      ),
      const SizedBox(height: 8),
      Wrap(spacing: 80, runSpacing: 10, children: [
        facilityItem('Assets/Labour_image/parking.png', 'Free Parking'),
        facilityItem('Assets/Labour_image/rest_room.png', 'Rest Rooms'),
        facilityItem(null, 'Canteen', isIcon: true),
        facilityItem('Assets/Labour_image/medical_boy.png', 'Medical Bay'),
      ]),
    ]),
  );

  Widget facilityItem(String? assetPath, String label, {bool isIcon = false}) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      isIcon
          ? Icon(Icons.restaurant, color: AppColors.green)
          : Image.asset(assetPath!, height: 20, width: 20),
      const SizedBox(width: 4),
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
    final phone = detail.siteManagerPhone ?? detail.rawValue('site_manager_phone');
    final email = detail.siteManagerEmail ?? detail.rawValue('site_manager_email');

    return ReusableCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Contact Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: primary(),
            color: AppColors.green,
          ),
        ),
        const SizedBox(height: 8),
        Row(children: [
          Icon(Icons.person, size: 16, color: AppColors.green),
          const SizedBox(width: 4),
          Text('Site Manager: $name', style: TextStyle(fontSize: secondary())),
        ]),
        const SizedBox(height: 4),
        Row(children: [
          Icon(Icons.phone, size: 16, color: AppColors.green),
          const SizedBox(width: 4),
          Text(phone, style: TextStyle(fontSize: secondary())),
        ]),
        const SizedBox(height: 4),
        Row(children: [
          Icon(Icons.email_outlined, size: 16, color: AppColors.green),
          const SizedBox(width: 4),
          Text(email, style: TextStyle(fontSize: secondary())),
        ]),
      ]),
    );
  }
}

// 5) Site Summary (labor distribution)
class SiteSummaryCard extends StatelessWidget {
  final SiteDetail detail;
  final Map<String, int> acceptedCounts;
  final void Function(String role) onAccept;

  const SiteSummaryCard({
    Key? key,
    required this.detail,
    required this.acceptedCounts,
    required this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counts = {
      'Electricians': 0,
      'Plumbers': 0,
      'Painters': 0,
      'Carpenters': 0,
      'Construction': 0,
      'Others': 0,
    };

    for (var entry in detail.departments) {
      final deptName = (entry['department']['name'] as String).toLowerCase();
      final labourCount = (entry['number_of_labour'] as int?) ?? 0;
      if (deptName.contains('electrician')) {
        counts['Electricians'] = labourCount;
      } else if (deptName.contains('plumber')) {
        counts['Plumbers'] = labourCount;
      } else if (deptName.contains('painter')) {
        counts['Painters'] = labourCount;
      } else if (deptName.contains('carpenter')) {
        counts['Carpenters'] = labourCount;
      } else if (deptName.contains('construction')) {
        counts['Construction'] = labourCount;
      } else {
        counts['Others'] = labourCount;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Labour Distribution',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: primary(),
              color: AppColors.green,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Wrap(
            runSpacing: 12,
            spacing: 8,
            children: [
              _laborCard(
                context,
                Icons.engineering,
                'Construction',
                counts['Construction']!,
                acceptedCounts['Construction'] ?? 0,
                Colors.blue,
              ),
              _laborCard(
                context,
                Icons.electrical_services,
                'Electricians',
                counts['Electricians']!,
                acceptedCounts['Electricians'] ?? 0,
                Colors.brown,
              ),
              _laborCard(
                context,
                Icons.plumbing,
                'Plumbers',
                counts['Plumbers']!,
                acceptedCounts['Plumbers'] ?? 0,
                Colors.orange,
              ),
              _laborCard(
                context,
                Icons.handyman,
                'Carpenters',
                counts['Carpenters']!,
                acceptedCounts['Carpenters'] ?? 0,
                Colors.green,
              ),
              _laborCard(
                context,
                Icons.format_paint,
                'Painters',
                counts['Painters']!,
                acceptedCounts['Painters'] ?? 0,
                AppColors.gold,
              ),
              _laborCard(
                context,
                Icons.group,
                'Others',
                counts['Others']!,
                acceptedCounts['Others'] ?? 0,
                Colors.blueGrey,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _laborCard(
      BuildContext context,
      IconData icon,
      String role,
      int required,
      int accepted,
      Color color,
      ) {
    final pct = required > 0 ? (accepted / required).clamp(0.0, 1.0) : 0.0;

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
            blurRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            '$accepted / $required',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(role, style: TextStyle(fontSize: secondary())),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: pct,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}
