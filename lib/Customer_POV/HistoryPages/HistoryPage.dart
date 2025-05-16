import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

import '../AppBar/CustomerAppBar.dart';
import '../CustomerNavBar.dart';
import 'RequestDetails.dart';

class Histotypagee extends StatefulWidget {
  const Histotypagee({super.key});

  @override
  State<Histotypagee> createState() => _HistotypageeState();
}

class _HistotypageeState extends State<Histotypagee> {
  // Sample data model
  final List<_Request> _requests = [
    _Request(
      serviceType: 'Construction',
      workers: 25,
      location: 'Mumbai Construction Site, Maharashtra',
      startDate: DateTime(2025, 4, 18),
      submittedDate: DateTime(2025, 4, 10),
      status: 'Pending',
    ),
    _Request(
      serviceType: 'Construction',
      workers: 15,
      location: 'Pune Industrial Park, Maharashtra',
      startDate: DateTime(2025, 4, 25),
      submittedDate: DateTime(2025, 4, 15),
      status: 'Pending',
    ),
    _Request(
      serviceType: 'Plumbing',
      workers: 8,
      location: 'Delhi Logistics Center, New Delhi',
      startDate: DateTime(2025, 4, 25),
      submittedDate: DateTime(2025, 4, 15),
      status: 'Rejected',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Customerappbar(
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Request History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.green,
              ),
            ),
            SizedBox(height: 12),
            ..._requests.map((r) => _buildRequestCard(r)).toList(),
          ],
        ),
      ),
      bottomNavigationBar: Customernavbar(currentIndex: 2),
    );
  }

  Widget _buildRequestCard(_Request r) {
    final bool isPending = r.status == 'Pending';
    final Color statusColor = isPending ? AppColors.gold : AppColors.brown;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: service type + status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                r.serviceType,
                style: TextStyle(
                  fontSize: primary(),
                  fontWeight: FontWeight.w600,
                  color: AppColors.green,
                ),
              ),
              Container(
                padding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  r.status,
                  style:  TextStyle(
                    fontSize: tertiary(),
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
           SizedBox(height: 8),

          // Worker count
          Row(
            children: [
               Icon(Icons.group, size: 16),
               SizedBox(width: 6),
              Text(
                '${r.workers} Workers',
                style:  TextStyle(fontSize: secondary()),
              ),
            ],
          ),
           SizedBox(height: 8),

          // Location
          Text(
            r.location,
            style:  TextStyle(fontSize: secondary()),
          ),
           SizedBox(height: 8),

          // Start date
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16),
              SizedBox(width: 6),
              Text(
                'Start: ${_formatDate(r.startDate)}',
                style:  TextStyle(fontSize: secondary()),
              ),
            ],
          ),

          Divider(height: 24),

          // Submitted + View Details button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Submitted: ${_formatDate(r.submittedDate)}',
                style:  TextStyle(fontSize: tertiary(), color: Colors.black),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> Requestdetails()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  padding:  EdgeInsets.symmetric(
                      horizontal: 13, vertical: 5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  'View Details',
                  style: TextStyle(fontSize: tertiary(), color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    final monthNames = [
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
    return '${monthNames[d.month - 1]} ${d.day}, ${d.year}';
  }
}


class _Request {
  final String serviceType;
  final int workers;
  final String location;
  final DateTime startDate;
  final DateTime submittedDate;
  final String status;
  _Request({
    required this.serviceType,
    required this.workers,
    required this.location,
    required this.startDate,
    required this.submittedDate,
    required this.status,
  });
}
