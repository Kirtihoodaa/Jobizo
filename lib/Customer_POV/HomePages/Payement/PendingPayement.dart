import 'package:flutter/material.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Customer_POV/HomePages/Payement/DuePayement.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class PendingPaymentScreen extends StatefulWidget {
  const PendingPaymentScreen({Key? key}) : super(key: key);

  @override
  State<PendingPaymentScreen> createState() => _PendingPaymentScreenState();
}

class _PendingPaymentScreenState extends State<PendingPaymentScreen> {
  final List<Map<String, String>> pendingBills = [
    {
      'address': '123 Riverside Ave',
      'amount': 'INR 15,000',
      'dueDate': 'Mar 15, 2025',
      'remainingTime': '24 Hours Remaining',
    },
    {
      'address': '123 Riverside Ave',
      'amount': 'INR 15,000',
      'dueDate': 'Mar 15, 2025',
      'remainingTime': '24 Hours Remaining',
    },
    {
      'address': '123 Riverside Ave',
      'amount': 'INR 15,000',
      'dueDate': 'Mar 15, 2025',
      'remainingTime': '24 Hours Remaining',
    },
    {
      'address': '123 Riverside Ave',
      'amount': 'INR 15,000',
      'dueDate': 'Mar 15, 2025',
      'remainingTime': '24 Hours Remaining',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: Commonappbar(title: "Pending Payement"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Total Amount Due Box
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.brown,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Amount Due',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: secondary(),
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'INR 230000',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // White Outer Container for Bills
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFEEEADB),
                    blurRadius: 4,
                    spreadRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pending Bills',
                    style: TextStyle(
                      fontSize: secondary(),
                      fontWeight: FontWeight.w600,
                      color: AppColors.green,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Scrollable list of bills
                  SizedBox(
                    child: SingleChildScrollView(
                      child: Column(
                        children: pendingBills
                            .map((bill) => _buildBillCard(bill))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillCard(Map<String, String> bill) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                bill['address'] ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: secondary(),
                ),
              ),
              Spacer(),
              Text(
                bill['amount'] ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: secondary(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                'Due Date : ${bill['dueDate']}',
                style: TextStyle(fontSize: tertiary(), color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            bill['remainingTime'] ?? '',
            style: TextStyle(fontSize: tertiary(), color: Colors.black),
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DuePaymentsScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Pay Now',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
