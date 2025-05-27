import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:jobizo/Customer_POV/HomePages/ActiveList.dart';
import 'package:jobizo/Customer_POV/HomePages/AddComplaint.dart';
import 'package:jobizo/Customer_POV/HomePages/AllotoedLabour.dart';
import 'package:jobizo/Customer_POV/HomePages/Allsites.dart';
import 'package:jobizo/Customer_POV/HomePages/ComplaintStatus.dart';
import 'package:jobizo/Customer_POV/HomePages/ManageLabour.dart';
import 'package:jobizo/Customer_POV/HomePages/Payement/PendingPayement.dart';
import 'package:jobizo/Customer_POV/HomePages/PendingRequest.dart';
import 'package:jobizo/Customer_POV/HomePages/RequiredLabour.dart';
import 'package:jobizo/Customer_POV/HomePages/WorkOpportunities.dart';
import 'package:jobizo/Customer_POV/RequestPages/CustomerRequest.dart';
import 'package:jobizo/Customer_POV/AppBar/CustomerAppBar.dart';
import 'package:jobizo/Customer_POV/HomePages/Labour_types/labour_avi.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

import 'Labour_types/Details_labour.dart';

class LabourCategory {
  final int id;
  final String name;
  final String imagePath;
  LabourCategory({
    required this.id,
    required this.name,
    required this.imagePath,
  });
}

class DashboardScreenC extends StatefulWidget {
  const DashboardScreenC({Key? key}) : super(key: key);

  @override
  State<DashboardScreenC> createState() => _DashboardScreenStateC();
}

class _DashboardScreenStateC extends State<DashboardScreenC> {
  // --- STATS ---
  int totalLabour = 0;
  int billingAmount = 0;
  int pendingRequests = 0;
  int activeSites = 0;

  bool _loading = true;
  String? _error;

  // --- ATTENDANCE ---
  int _present = 0, _late = 0, _leave = 0;

  // --- RECENT REQUESTS ---
  List<Map<String, dynamic>> _recentRequests = [];

  // --- CATEGORY COUNTS FROM API ---
  Map<String, int> _categoryCounts = {};
  bool _loadingCategories = true;
  String? _categoriesError;

  // --- STATIC CATEGORIES FOR UI (WITH IMAGES) ---
  final List<LabourCategory> _staticCategories = [
    LabourCategory(
      id: 0,
      name: "Construction",
      imagePath: "Assets/Customer_Images/Construction.png",
    ),
    LabourCategory(
      id: 1,
      name: "Electrician",
      imagePath: "Assets/Customer_Images/Electrician.png",
    ),
    LabourCategory(
      id: 2,
      name: "Plumber",
      imagePath: "Assets/Customer_Images/plumbing.png",
    ),
    LabourCategory(
      id: 3,
      name: "Painter",
      imagePath: "Assets/Customer_Images/painter.png",
    ),
    LabourCategory(
      id: 4,
      name: "Carpenter",
      imagePath: "Assets/Customer_Images/carpanter.png",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _loadingCategories = true;
      _categoriesError = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final dio = Dio()..options.headers['Authorization'] = 'Bearer $token';

      final resp = await dio.get(
        'https://backend.jobizoindia.com/api/labour-category',
        options: Options(validateStatus: (_) => true),
      );
      if (resp.statusCode == null ||
          resp.statusCode! < 200 ||
          resp.statusCode! >= 300) {
        throw 'Server returned ${resp.statusCode}';
      }

      dynamic raw = resp.data;
      if (raw is String) raw = jsonDecode(raw);
      if (raw is! Map<String, dynamic> || raw['status'] != true) {
        throw 'Unexpected response format';
      }

      final data = raw['data'] as List<dynamic>;
      _categoryCounts = {
        for (var entry in data)
          (entry['name'] as String).toLowerCase():
          (entry['labour_count'] as int? ?? 0)
      };
    } catch (e) {
      _categoriesError = e.toString();
    } finally {
      setState(() {
        _loadingCategories = false;
      });
    }
  }

  Future<void> _fetchDashboardData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final dio = Dio()..options.headers['Authorization'] = 'Bearer $token';

      final resp = await dio.get(
        'https://backend.jobizoindia.com/api/customer-dashboard',
        options: Options(validateStatus: (_) => true),
      );
      if (resp.statusCode == null ||
          resp.statusCode! < 200 ||
          resp.statusCode! >= 300) {
        throw 'Server returned ${resp.statusCode}';
      }

      dynamic raw = resp.data;
      if (raw is String) raw = jsonDecode(raw);
      if (raw is! Map<String, dynamic> || raw['status'] != true) {
        throw 'Unexpected response format';
      }

      final d = raw['data'] as Map<String, dynamic>;

      // Stats
      totalLabour = d['total_active_labours'] as int? ?? 0;
      billingAmount = d['total_billing_amount'] as int? ?? 0;
      pendingRequests = d['pending_requests'] as int? ?? 0;
      activeSites = d['active_sites'] as int? ?? 0;

      // Attendance
      final att = d['today_attendance'] as Map<String, dynamic>? ?? {};
      _present = att['present'] as int? ?? 0;
      _late = att['late'] as int? ?? 0;
      _leave = att['leave'] as int? ?? 0;

      // Recent Requests
      _recentRequests = (d['recent_activities']?['recent_requests']
      as List<dynamic>? ??
          [])
          .cast<Map<String, dynamic>>();

      setState(() {});
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: AppColors.gold,)),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: Customerappbar(profileImageUrl: ''),
        body: Center(child: Text('Error: $_error')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Customerappbar(profileImageUrl: ''),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildStatsSection(),
              _buildCategorySection(),
              _buildMainButtons(),
              _buildActionButtons(context),
              _buildAttendanceChart(),
              _buildRecentActivities(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    final stats = [
      {
        "title": "Total Active Labour",
        "value": totalLabour.toString(),
        "desc": "" ,
        "screen": Activelist()
      },
      {
        "title": "Total Billing Amount",
        "value": "INR $billingAmount",
        "desc": "",
        "screen": PendingPaymentScreen()
      },
      {
        "title": "Pending Requests",
        "value": pendingRequests.toString(),
        "desc": "",
        "screen": PendingRequestScreen()
      },
      {
        "title": "Active Sites",
        "value": activeSites.toString(),
        "desc": "",
        "screen": AllSitesScreen()
      },
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        color: AppColors.gold,
        padding: const EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: stats.map((item) {
            return GestureDetector(
              onTap: () {
                final screen = item['screen'] as Widget?;
                if (screen != null) {
                  Get.to(() => screen,
                      transition: Transition.cupertino,
                      duration: const Duration(milliseconds: 400));
                }
              },
              child: _statCard(
                item['title'] as String,
                item['value'] as String,
                item['desc'] as String,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, String descriptor) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: tertiary(), color: Colors.black)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
              Text(descriptor, style: TextStyle(color: Colors.green, fontSize: tertiary())),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    if (_loadingCategories) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_categoriesError != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(child: Text('Error loading categories: $_categoriesError')),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        color: AppColors.gold,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Labour Category",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: tertiary(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _staticCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final cat = _staticCategories[index];
                  final count = _categoryCounts[cat.name.toLowerCase()] ?? 0;
                  return GestureDetector(
                    onTap: () {
                      if (count > 0) {
                        Get.to(
                              () => LabourListScreen(
                            categoryId: cat.id,
                            categoryName: cat.name,
                          ),
                          transition: Transition.cupertino,
                          duration: const Duration(milliseconds: 400),
                        );
                      }
                      // else do nothing
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(cat.imagePath, height: 40, fit: BoxFit.contain),
                          const SizedBox(height: 6),
                          Text(
                            cat.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: tertiary(),
                            ),
                          ),
                          Text(
                            "$count",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: tertiary(),
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButtons() {
    return Column(
      children: [
        _mainButton("ALLOTED LABOUR", const Color(0xFF415202),
            "Assets/Customer_Images/labour type.png", AllottedLaboursScreen()),
        _mainButton("REQUEST LABOUR", const Color(0xFF4B1E03),
            "Assets/Customer_Images/add comp details.png", Customerrequest()),
        _mainButton("WORK INTEREST", const Color(0xFFF97616),
            "Assets/Customer_Images/work.png", WorkOpportunitiesPage()),
      ],
    );
  }

  Widget _mainButton(String label, Color color, String imagePath, Widget? destination) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () {
          if (destination != null) {
            Get.to(() => destination,
                transition: Transition.cupertino, duration: const Duration(milliseconds: 400));
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, height: 20, width: 20, color: Colors.white),
            const SizedBox(width: 10),
            Text(label,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: tertiary())),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      color: AppColors.gold,
      width: MediaQuery.of(context).size.width,
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          _actionButton(context, "Required Labour", Requiredlabour()),
          _actionButton(context, "Manage Labour", LabourManagementScreen()),
          _actionButton(context, "Add Complaint", AddComplaintPage()),
          _actionButton(context, "Complaint Status", ComplaintStatusScreen()),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, String label, Widget? targetPage) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          if (targetPage != null) {
            Get.to(() => targetPage,
                transition: Transition.cupertino, duration: const Duration(milliseconds: 400));
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        child: Text(label),
      ),
    );
  }

  Widget _buildAttendanceChart() {
    // If absolutely no attendance data, draw a red ring + "0%"
    if (_present + _late + _leave == 0) {
      return Card(
        margin: const EdgeInsets.all(10),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Today's Attendance",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.green)),
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red, width: 20),
                      ),
                    ),
                    const Text(
                      "0%",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Present - 0",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: tertiary(),
                          fontWeight: FontWeight.bold)),
                  Text("Late - 0",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: tertiary(),
                          fontWeight: FontWeight.bold)),
                  Text("Leave - 0",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: tertiary(),
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final dataMap = {
      "Present": _present.toDouble(),
      "Late": _late.toDouble(),
      "Leave": _leave.toDouble(),
    };
    final colorList = <Color>[
      Color(0xFF4B1E03),
      Color(0xFFEE6666),
      Color(0xFFFAC858),
    ];

    return Card(
      margin: const EdgeInsets.all(10),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Today's Attendance",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.green)),
            const SizedBox(height: 20),
            PieChart(
              dataMap: dataMap,
              animationDuration: const Duration(milliseconds: 2000),
              chartRadius: 120, // Adjust size
              colorList: colorList,
              chartType: ChartType.ring, // RING for Donut chart
              ringStrokeWidth: 20,
              legendOptions: const LegendOptions(
                showLegends: false, // Already showing below
              ),
              chartValuesOptions: const ChartValuesOptions(
                showChartValuesInPercentage: true,
                showChartValueBackground: true,
                showChartValues: true,
                decimalPlaces: 1,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Present - $_present",
                    style: TextStyle(
                        color: Color(0xFF4B1E03),
                        fontSize: tertiary(),
                        fontWeight: FontWeight.bold)),
                Text("Late - $_late",
                    style: TextStyle(
                        color: Color(0xFFEE6666),
                        fontSize: tertiary(),
                        fontWeight: FontWeight.bold)),
                Text("Leave - $_leave",
                    style: TextStyle(
                        color: Color(0xFFFAC858),
                        fontSize: tertiary(),
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Card(
      margin: const EdgeInsets.all(12),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Recent Activities",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.gold)),
            const SizedBox(height: 10),
            ..._recentRequests.map((r) {
              final date = (r['created_at'] as String).split('T').first;
              return ListTile(
                leading: const Icon(Icons.location_on, color: Colors.blue),
                title: Text(r['project_name'] as String? ?? 'No project'),
                subtitle: Text(date),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

}
