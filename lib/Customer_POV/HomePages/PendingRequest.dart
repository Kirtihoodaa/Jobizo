import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Customer_POV/HistoryPages/RequestDetails.dart';
import 'package:jobizo/Customer_POV/HomePages/ApplicationDetails.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

// MODEL CLASS
class PendingRequest {
  final String type;
  final String title;
  final int? workers;
  final String location;
  final String? startDate;
  final String submittedDate;

  PendingRequest({
    required this.type,
    required this.title,
    this.workers,
    required this.location,
    this.startDate,
    required this.submittedDate,
  });
}

// MAIN SCREEN
class PendingRequestScreen extends StatelessWidget {
  const PendingRequestScreen({super.key});

  // This will later be fetched from API
  List<PendingRequest> getPendingList() {
    return [
      PendingRequest(
        type: "Construction",
        title: "25 Workers",
        workers: 25,
        location: "Mumbai Construction Site, Maharashtra",
        startDate: "Apr 18, 2025",
        submittedDate: "Apr 10, 2025",
      ),
      PendingRequest(
        type: "Construction",
        title: "15 Workers",
        workers: 15,
        location: "Pune Industrial Park, Maharashtra",
        startDate: "Apr 25, 2025",
        submittedDate: "Apr 15, 2025",
      ),
      PendingRequest(
        type: "Job Application",
        title: "Application for Office Manager",
        location: "",
        submittedDate: "Apr 15, 2025",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<PendingRequest> pendingList = getPendingList();

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: "Pending Request"),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pending Request",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.green,
                    fontSize: secondary())),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: pendingList.length,
                itemBuilder: (context, index) {
                  final item = pendingList[index];
                  return PendingCard(item: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PendingCard extends StatelessWidget {
  final PendingRequest item;

  const PendingCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.type,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.green,
                      fontSize: secondary())),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Pending',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),

          // Workers
          if (item.workers != null)
            Row(
              children: [
                const Icon(FontAwesomeIcons.peopleGroup, size: 16),
                const SizedBox(width: 10),
                Text(
                  "${item.workers} Workers",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: tertiary()),
                ),
              ],
            ),
          if (item.workers != null) const SizedBox(height: 6),

          // Title or Location

          if (item.location.isNotEmpty)
            Text(
              item.location,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: tertiary()),
            ),
          const SizedBox(height: 6),

          // Start Date
          if (item.startDate != null)
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 6),
                Text(
                  "Start: ${item.startDate}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: tertiary()),
                ),
              ],
            ),
          if (item.startDate != null) const SizedBox(height: 6),

          // Submitted Date
          Row(
            children: [
              Text(
                "Submitted: ${item.submittedDate}",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: tertiary()),
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (item.type == "Construction") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Requestdetails(),
                        ),
                      );
                    } else if (item.type == "Job Application") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ApplicationDetail(), // <-- Add this
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    "View Details",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: tertiary()),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // View Details Button
        ],
      ),
    );
  }
}
