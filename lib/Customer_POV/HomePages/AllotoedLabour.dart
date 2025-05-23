// lib/Customer_POV/AllottedLaboursScreen.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllottedLaboursScreen extends StatefulWidget {
  const AllottedLaboursScreen({Key? key}) : super(key: key);

  @override
  State<AllottedLaboursScreen> createState() => _AllottedLaboursScreenState();
}

class _AllottedLaboursScreenState extends State<AllottedLaboursScreen> {
  bool _loading = true;
  String? _error;
  List<SiteData> _sites = [];

  @override
  void initState() {
    super.initState();
    _fetchSites();
  }

  Future<void> _fetchSites() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token') ?? '';
      if (!token.startsWith('Bearer ')) token = 'Bearer $token';

      final resp = await Dio(BaseOptions(headers: {'Authorization': token}))
          .get('https://backend.jobizoindia.com/api/alloted-labours',
          options: Options(validateStatus: (s) => s != null && s < 500));

      final body = resp.data as Map<String, dynamic>;
      if (resp.statusCode == 200 && body['status'] == true) {
        final list = body['projects'] as List<dynamic>;
        _sites = list.map((raw) {
          final m = raw as Map<String, dynamic>;
          final workersRaw = m['active_labours'] as List<dynamic>;
          final workerList = workersRaw.map((w) {
            final wm = w as Map<String, dynamic>;
            return Worker(
              name: wm['name'] as String? ?? 'Unknown',
              role: wm['category'] as String? ?? '-',
              time: wm['phone'] as String? ?? '-',
            );
          }).toList();

          return SiteData(
            siteName: m['job_title'] as String? ?? 'Untitled',
            location: m['job_location'] as String? ?? '-',
            workersCount: workerList.length,
            workers: workerList,
          );
        }).toList();
      } else {
        throw body['message'] ?? 'Failed to load';
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
        appBar: const Commonappbar(title: "Alloted Labour"),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: const Commonappbar(title: "Alloted Labour"),
        body: Center(child: Text(_error!)),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: const Commonappbar(title: "Alloted Labour"),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _sites.length,
        itemBuilder: (context, index) {
          return SiteCard(site: _sites[index]);
        },
      ),
    );
  }
}

class SiteCard extends StatelessWidget {
  final SiteData site;
  const SiteCard({Key? key, required this.site}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header row
          Row(
            children: [
              Text(
                site.siteName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.green,
                  fontSize: secondary(),
                ),
              ),
              const Spacer(),
              Text(
                '${site.workersCount} Workers',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // location
          Text(
            site.location,
            style: TextStyle(
              color: Colors.black,
              fontSize: tertiary(),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),

          // if no active_labours
          if (site.workers.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  'No labour allotted',
                  style: TextStyle(
                    fontSize: tertiary(),
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            )
          else
            ...site.workers.map((w) => WorkerTile(worker: w)).toList(),
        ],
      ),
    );
  }
}

class WorkerTile extends StatelessWidget {
  final Worker worker;
  const WorkerTile({Key? key, required this.worker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: const CircleAvatar(
        backgroundImage:
        AssetImage('Assets/Labour_image/labour_profile.png'),
        radius: 22,
      ),
      title: Text(
        worker.name,
        style: TextStyle(
          color: Colors.black,
          fontSize: tertiary(),
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            worker.role,
            style: TextStyle(
              color: Colors.black,
              fontSize: tertiary(),
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            worker.time,
            style: TextStyle(
              color: Colors.black,
              fontSize: tertiary(),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.lightGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Active',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}

class SiteData {
  final String siteName;
  final String location;
  final int workersCount;
  final List<Worker> workers;

  SiteData({
    required this.siteName,
    required this.location,
    required this.workersCount,
    required this.workers,
  });
}

class Worker {
  final String name;
  final String role;
  final String time;

  Worker({
    required this.name,
    required this.role,
    required this.time,
  });
}
