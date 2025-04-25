import 'package:flutter/material.dart';
import 'package:jobizo/Customer_POV/HomePages/AddComplaint.dart';
import 'package:jobizo/Customer_POV/HomePages/ComplaintStatus.dart';
import 'package:jobizo/Customer_POV/HomePages/WorkOpportunities.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

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
      {"title": "Total Active Labour", "value": "24", "desc": "+12 TODAY"},
      {"title": "Total Billing Amount", "value": "INR 230000", "desc": ""},
      {"title": "Pending Requests", "value": "23", "desc": "5 URGENT"},
      {"title": "Active Sites", "value": "18", "desc": "2 NEW"},
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
              .map((item) =>
                  _statCard(item['title']!, item['value']!, item['desc']!))
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
                    _categoryCard("Electrical", "21",
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
    return Container(
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
    );
  }

  Widget _buildMainButtons() {
    return Column(
      children: [
        _mainButton(
          "ALLOTED LABOUR",
          const Color(0xFF415202),
          "Assets/Customer_Images/labour type.png",
          null, // Replace with your actual page class
        ),
        _mainButton(
          "REQUEST LABOUR",
          const Color(0xFF4B1E03),
          "Assets/Customer_Images/add comp details.png",
          null, // Replace with your actual page class
        ),
        _mainButton(
          "WORK INTEREST",
          const Color(0xFFF97616),
          "Assets/Customer_Images/work.png",
          WorkOpportunitiesPage(), // Navigation disabled for now
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
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _actionButton(context, "Required Labour", null),
          _actionButton(context, "Manage Labour", null),
          _actionButton(context, "Add Complaint", AddComplaintPage()),
          _actionButton(context, "Complaint Status", ComplaintStatusScreen()),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, String label, Widget? targetPage) {
    return ElevatedButton(
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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(label),
    );
  }

  Widget _buildAttendanceChart() {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text("Today's Attendance",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Image.asset("Assets/DonutChart.png",
                height: 150), // Replace with dynamic chart later
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Present - 142", style: TextStyle(color: Colors.blue)),
                Text("Late - 20", style: TextStyle(color: Colors.orange)),
                Text("Leave - 4", style: TextStyle(color: Colors.red)),
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Recent Activities",
                style: TextStyle(fontWeight: FontWeight.bold)),
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
