import 'package:flutter/material.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Customer_POV/HomePages/SiteDetails.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class AllSitesScreen extends StatefulWidget {
  const AllSitesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AllSitesScreenState createState() => _AllSitesScreenState();
}

class _AllSitesScreenState extends State<AllSitesScreen> {
  List<Site> siteList = [
    Site(
      title: "Riverside Tower Complex",
      id: "RTC-2024-001",
      location: "Mumbai India",
      duration: "Jan 2024 – Dec 2024",
      status: "Active",
      statusColor: Color(0xFF62A910),
      progress: 0.45,
    ),
    Site(
      title: "Riverside Tower Complex",
      id: "RTC-2024-001",
      location: "Mumbai India",
      duration: "Jan 2024 – Dec 2024",
      status: "Onhold",
      statusColor: Color(0xFFEEA700),
      progress: 0.45,
    ),
    Site(
      title: "Riverside Tower Complex",
      id: "RTC-2024-001",
      location: "Mumbai India",
      duration: "Jan 2024 – Dec 2024",
      status: "Critical",
      statusColor: AppColors.brown,
      progress: 0.45,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Commonappbar(title: 'All Sites'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: siteList
              .map((site) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: buildSiteCard(site),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget buildSiteCard(Site site) {
    return Container(
      width: 343,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                site.title,
                style: TextStyle(
                  fontSize: secondary(),
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: site.statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  site.status,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          ),
          SizedBox(height: 8),

          // ID
          Text(
            "ID: ${site.id}",
            style: TextStyle(
                color: Colors.black,
                fontSize: tertiary(),
                fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 8),

          // Location
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: Colors.black,
              ),
              SizedBox(width: 4),
              Text(site.location),
            ],
          ),
          SizedBox(height: 8),

          // Date
          Row(
            children: [
              Icon(Icons.calendar_month, size: 16),
              SizedBox(width: 4),
              Text(site.duration),
            ],
          ),
          SizedBox(height: 12),

          // Progress Bar and Text
          Text(
            "Progress",
            style: TextStyle(
                color: Colors.black,
                fontSize: tertiary(),
                fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 4),
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
              SizedBox(width: 8),
              Text("${(site.progress * 100).toInt()}%")
            ],
          ),
          SizedBox(height: 16),

          // View Details Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Sitedetails()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                "View Details",
                style: TextStyle(color: Colors.white, fontSize: tertiary()),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Site {
  final String title;
  final String id;
  final String location;
  final String duration;
  final String status;
  final Color statusColor;
  final double progress;

  Site({
    required this.title,
    required this.id,
    required this.location,
    required this.duration,
    required this.status,
    required this.statusColor,
    required this.progress,
  });
}
