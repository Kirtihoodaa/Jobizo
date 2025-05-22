import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SiteDetails.dart';

class AllSitesScreen extends StatefulWidget {
  const AllSitesScreen({super.key});
  @override
  _AllSitesScreenState createState() => _AllSitesScreenState();
}

class _AllSitesScreenState extends State<AllSitesScreen> {
  bool _isLoading = true;
  String? _error;
  List<Site> siteList = [];

  @override
  void initState() {
    super.initState();
    _fetchSites();
  }

  Future<void> _fetchSites() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token') ?? '';
      if (token.isEmpty) throw 'Not authenticated';
      if (!token.startsWith('Bearer ')) token = 'Bearer $token';

      final dio = Dio(BaseOptions(headers: {'Authorization': token}));
      final resp = await dio.get(
        'https://backend.jobizoindia.com/api/labour-request',
        options: Options(validateStatus: (s) => s != null && s < 500),
      );

      // 1) Debug
      print("🛈 fetchSites resp.data = ${resp.data}");

      // 2) Normalize to a List<dynamic>
      List<dynamic> listData;
      if (resp.data is List) {
        listData = resp.data as List<dynamic>;
      } else if (resp.data is Map && resp.data['data'] is List) {
        listData = resp.data['data'] as List<dynamic>;
      } else {
        throw 'Unexpected response format';
      }

      // 3) Map into your model
      siteList = listData
          .map((e) => Site.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: 'All Sites'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator( color:AppColors.gold))
          : (_error != null)
          ? Center(child: Text(_error!))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: siteList
              .map((site) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildSiteCard(site),
          ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSiteCard(Site site) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                site.title,
                style:
                TextStyle(fontSize: secondary(), fontWeight: FontWeight.w800),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: site.statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  site.status,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // ID
          Text("ID: ${site.id}",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: tertiary(),
                  fontWeight: FontWeight.w400)),
          const SizedBox(height: 8),
          // Location
          Row(
            children: [
              const Icon(Icons.location_on, size: 16),
              const SizedBox(width: 4),
              Expanded(child: Text(site.location)),
            ],
          ),
          const SizedBox(height: 8),
          // Date / duration
          Row(
            children: [
              const Icon(Icons.calendar_month, size: 16),
              const SizedBox(width: 4),
              Text(site.durationLabel),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          Text("Progress",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: tertiary(),
                  fontWeight: FontWeight.w400)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: site.progress,
                  backgroundColor: Colors.grey[300],
                  color: AppColors.green,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Text("${(site.progress * 100).toInt()}%"),
            ],
          ),
          const SizedBox(height: 16),
          // View Details
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>  Sitedetails(siteId: site.id) )),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text("View Details",
                  style:
                  TextStyle(color: Colors.white, fontSize: tertiary())),
            ),
          ),
        ],
      ),
    );
  }
}

/// Model with computed status & progress
class Site {
  final int id;
  final String title;
  final String location;
  final DateTime startDate;
  final int durationDays;
  final double progress;       // 0.0–1.0
  final String status;         // Active / Onhold / Critical
  final Color statusColor;

  Site._({
    required this.id,
    required this.title,
    required this.location,
    required this.startDate,
    required this.durationDays,
    required this.progress,
    required this.status,
    required this.statusColor,
  });

  factory Site.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final title = (json['project_name'] as String?) ?? 'No Title';
    final location = (json['work_address'] as String?) ?? '';
    final startDate = DateTime.parse(json['start_date'] as String);
    final duration = (json['duration_days'] as num?)?.toInt() ?? 0;
    final now = DateTime.now();
    final elapsed = now.difference(startDate).inDays.toDouble();
    final prog = duration > 0 ? (elapsed / duration).clamp(0.0, 1.0) : 0.0;
    String statusLabel;
    Color statusColor;
    if (prog < 0.5) {
      statusLabel = 'Active';
      statusColor = AppColors.green;
    } else if (prog < 1.0) {
      statusLabel = 'Onhold';
      statusColor = const Color(0xFFEEA700);
    } else {
      statusLabel = 'Critical';
      statusColor = AppColors.brown;
    }

    return Site._(
      id: id,
      title: title,
      location: location,
      startDate: startDate,
      durationDays: duration,
      progress: prog,
      status: statusLabel,
      statusColor: statusColor,
    );
  }

  /// e.g. "2025-05-17 → +12 days"
  String get durationLabel =>
      "${startDate.toLocal().toIso8601String().split('T').first}  •  ${durationDays}d";
}
