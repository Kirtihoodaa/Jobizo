import 'package:flutter/material.dart';
import 'package:jobizo/Customer_POV/HomePages/ActiveList.dart';
import 'package:jobizo/Customer_POV/HomePages/AddComplaint.dart';
import 'package:jobizo/Customer_POV/HomePages/AllotoedLabour.dart';
import 'package:jobizo/Customer_POV/HomePages/Allsites.dart';
import 'package:jobizo/Customer_POV/HomePages/ComplaintStatus.dart';
import 'package:jobizo/Customer_POV/HomePages/Labour_types/Details_labour.dart';
import 'package:jobizo/Customer_POV/HomePages/ManageLabour.dart';
import 'package:jobizo/Customer_POV/HomePages/Payement/PendingPayement.dart';
import 'package:jobizo/Customer_POV/HomePages/PendingRequest.dart';
import 'package:jobizo/Customer_POV/HomePages/RequiredLabour.dart';
import 'package:jobizo/Customer_POV/HomePages/WorkOpportunities.dart';
import 'package:jobizo/Customer_POV/RequestPages/CustomerRequest.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:pie_chart/pie_chart.dart';

import '../AppBar/CustomerAppBar.dart';

class DashboardScreenC extends StatefulWidget {
  const DashboardScreenC({Key? key}) : super(key: key);

  @override
  State<DashboardScreenC> createState() => _DashboardScreenStateC();
}

class _DashboardScreenStateC extends State<DashboardScreenC> {
  // Dummy API data (replace with your actual API calls)
  int totalLabour = 24;
  int billingAmount = 230000;
  int pendingRequests = 23;
  int activeSites = 18;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    // TODO: Replace with Dio/HTTP GET request to fetch API data
    // Example:
    // final response = await Dio().get('your-api-endpoint');
    // setState(() {
    //   totalLabour = response.data['totalLabour'];
    //   ...
    // });
  }

  List<Map<String, dynamic>> labourCategories = [
    {"category": "Construction", "count": 32},
    {"category": "Electrician", "count": 33},
    {"category": "Plumber", "count": 60},
    {"category": "Painter", "count": 45},
    {"category": "Carpenter", "count": 44},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Customerappbar(
        name: 'Deep',
        location: 'chand',
        profileImageUrl: '',
      ),
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
        "value": "24",
        "desc": "+12 TODAY",
        "screen": Activelist()
      },
      {
        "title": "Total Billing Amount",
        "value": "INR 230000",
        "desc": "",
        "screen": PendingPaymentScreen()
      },
      {
        "title": "Pending Requests",
        "value": "23",
        "desc": "5 URGENT",
        "screen": PendingRequestScreen()
      },
      {
        "title": "Active Sites",
        "value": "18",
        "desc": "2 NEW",
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
          children: stats
              .map((item) => GestureDetector(
                    onTap: () {
                      if (item['screen'] != null) {
                        Widget? screen = item['screen'] as Widget?;
                        if (screen != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => screen,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('No page assigned for this card!')),
                        );
                      }
                    },
                    child: _statCard(
                      item['title'] as String,
                      item['value'] as String,
                      item['desc'] as String,
                    ),
                  ))
              .toList(),
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
          Text(
            title,
            style: TextStyle(fontSize: tertiary(), color: Colors.black),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                value,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Text(
                descriptor,
                style: TextStyle(color: Colors.green, fontSize: tertiary()),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
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
              height: 100, // restrict height explicitly
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _categoryCard("Construction", "32",
                        "Assets/Customer_Images/Construction.png"),
                    const SizedBox(width: 10),
                    _categoryCard("Electrician", "21",
                        "Assets/Customer_Images/Electrician.png"),
                    const SizedBox(width: 10),
                    _categoryCard(
                        "Plumber", "15", "Assets/Customer_Images/plumbing.png"),
                    const SizedBox(width: 10),
                    _categoryCard(
                        "Painter", "12", "Assets/Customer_Images/painter.png"),
                    const SizedBox(width: 10),
                    _categoryCard("Carpenter", "12",
                        "Assets/Customer_Images/carpanter.png"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard(String title, String count, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LabourListScreen(
              category: title,
            ),
          ),
        );
      },
      child: Container(
        height: 100,
        width: MediaQuery.sizeOf(context).width / 3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "$title",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: tertiary()),
                ),
                Text(
                  "$count",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: tertiary(),
                      color: AppColors.gold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButtons() {
    return Column(
      children: [
        _mainButton(
          "ALLOTED LABOUR",
          const Color(0xFF415202),
          "Assets/Customer_Images/labour type.png",
          AllottedLaboursScreen(),
        ),
        _mainButton(
          "REQUEST LABOUR",
          const Color(0xFF4B1E03),
          "Assets/Customer_Images/add comp details.png",
          Customerrequest(),
        ),
        _mainButton(
          "WORK INTEREST",
          const Color(0xFFF97616),
          "Assets/Customer_Images/work.png",
          WorkOpportunitiesPage(),
        ),
      ],
    );
  }

  Widget _mainButton(
      String label, Color color, String imagePath, Widget? destination) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () {
          if (destination != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          } else {
            // Optional: Show a snackbar if no destination is available
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('Coming Soon')),
            // );
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              height: 20,
              width: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: tertiary(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      color: AppColors.gold,
      width: MediaQuery.sizeOf(context).width,
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
          ]),
    );
  }

  Widget _actionButton(BuildContext context, String label, Widget? targetPage) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          if (targetPage != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => targetPage),
            );
          } else {
            // Optional: Add placeholder logic here if needed later
            print('$label page is not implemented yet.');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildAttendanceChart() {
    Map<String, double> dataMap = {
      "Present": 142,
      "Late": 20,
      "Leave": 4,
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
            Text(
              "Today's Attendance",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.green),
            ),
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
                Text("Present - 142",
                    style: TextStyle(
                        color: Color(0xFF4B1E03),
                        fontSize: tertiary(),
                        fontWeight: FontWeight.bold)),
                Text("Late - 20",
                    style: TextStyle(
                        color: Color(0xFFEE6666),
                        fontSize: tertiary(),
                        fontWeight: FontWeight.bold)),
                Text("Leave - 4",
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
          children: const [
            Text("Recent Activities",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.gold)),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.location_on, color: Colors.blue),
              title: Text("15 workers checked in at Downtown Site"),
              subtitle: Text("2 minutes ago"),
            ),
            ListTile(
              leading: Icon(Icons.warning, color: Colors.orange),
              title: Text("Shortage alert: 5 workers needed"),
              subtitle: Text("15 minutes ago"),
            ),
            ListTile(
              leading: Icon(Icons.verified, color: Colors.green),
              title: Text("Labour request approved"),
              subtitle: Text("1 hour ago"),
            ),
          ],
        ),
      ),
    );
  }
}
