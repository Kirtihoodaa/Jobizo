import 'package:flutter/material.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class ComplaintStatusScreen extends StatelessWidget {
  const ComplaintStatusScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> complaints = const [
    {
      'title': 'Labour not working',
      'id': '#CP2024021',
      'description': 'Package delivery delayed by 5 days without any updates',
      'date': 'Feb 15, 2025',
      'status': 'In Progress'
    },
    {
      'title': 'Labour not working',
      'id': '#CP2024021',
      'description': 'Package delivery delayed by 5 days without any updates',
      'date': 'Feb 15, 2025',
      'status': 'Resolved'
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Progress':
        return AppColors.gold;
      case 'Resolved':
        return Colors.green;
      case 'Cancel':
        return AppColors.brown;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: 'Complaint Status'),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          final item = complaints[index];

          return Container(
            width: screenWidth * 0.95,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: Wrap(
              runSpacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: secondary(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: _getStatusColor(item['status']),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        item['status'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
                Text(
                  item['id'],
                  style: TextStyle(color: Colors.black, fontSize: tertiary()),
                ),
                Text(
                  item['description'],
                  style: const TextStyle(fontSize: 14),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['date'],
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    if (item['status'] == 'In Progress')
                      ElevatedButton(
                        onPressed: () {
                          // Handle cancel logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brown,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          minimumSize: Size(screenWidth * 0.2, 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
