import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Customer_POV/HomePages/Payement/PayNow.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class DuePaymentsScreen extends StatefulWidget {
  const DuePaymentsScreen({Key? key}) : super(key: key);

  @override
  State<DuePaymentsScreen> createState() => _DuePaymentsScreenState();
}

class _DuePaymentsScreenState extends State<DuePaymentsScreen> {
  final List<Map<String, dynamic>> paymentDetails = [
    {
      'date': 'Mar 15',
      'description': 'Electrician',
      'count': 20,
      'amount': 'INR 20,250.00',
    },
    {
      'date': 'Mar 12',
      'description': 'Plumber',
      'count': 18,
      'amount': 'INR 20,875.25',
    },
    {
      'date': 'Mar 10',
      'description': 'Load man',
      'count': 25,
      'amount': 'INR 12,897.00',
    },
    {
      'date': 'Mar 05',
      'description': 'Painting',
      'count': 25,
      'amount': 'INR 16,000.00',
    },
    {
      'date': 'Mar 15',
      'description': 'Carpenter',
      'count': 25,
      'amount': 'INR 24,250.00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: "Due Payements"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAmountDueCard(),
            const SizedBox(height: 16),
            _buildSiteDetailsCard(),
            const SizedBox(height: 16),
            _buildTotalAmountCard(),
            const SizedBox(height: 12),
            _buildPaymentTable(),
            const SizedBox(height: 24),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountDueCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
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
          const SizedBox(height: 8),
          const Text(
            'INR 15000',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSiteDetailsCard() {
    return Container(
      width: double.infinity,
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
          Text('Site Details',
              style: TextStyle(
                  fontSize: secondary(),
                  fontWeight: FontWeight.bold,
                  color: AppColors.green)),
          const SizedBox(height: 12),
          const _DetailRow(label: 'Site Location:', value: '123 Riverside Ave'),
          const _DetailRow(
              label: 'Project Type:', value: 'Commercial Building'),
          const _DetailRow(label: 'Contact:', value: '+1 (555) 123-4567'),
        ],
      ),
    );
  }

  Widget _buildTotalAmountCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
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
          Center(
            child: Text('Payments',
                style: TextStyle(
                  fontSize: secondary(),
                  fontWeight: FontWeight.bold,
                )),
          ),
          const SizedBox(height: 10),
          buildDivider(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount',
                  style: TextStyle(
                      fontSize: tertiary(),
                      fontWeight: FontWeight.bold,
                      color: AppColors.brown)),
              Text('INR 15,0000.00',
                  style: TextStyle(
                      fontSize: tertiary(),
                      fontWeight: FontWeight.bold,
                      color: AppColors.brown)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPaymentTable() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
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
        children: [
          // Header
          _buildTableRow(
            date: 'Date',
            description: 'Description',
            count: 'No. of Labors',
            amount: 'Amount',
            isHeader: true,
          ),
          buildDivider(),
          // Rows with divider
          ...paymentDetails.map((data) {
            return Column(
              children: [
                _buildTableRow(
                  date: data['date'],
                  description: data['description'],
                  count: '${data['count']}',
                  amount: data['amount'],
                ),
                buildDivider(),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTableRow({
    required String date,
    required String description,
    required String count,
    required String amount,
    bool isHeader = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              date,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.w400,
                fontSize: tertiary(),
              ),
            ),
          ),
          Expanded(
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.w400,
                fontSize: tertiary(),
              ),
            ),
          ),
          Expanded(
            child: Text(
              count,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.w400,
                fontSize: tertiary(),
              ),
            ),
          ),
          Expanded(
            child: Text(
              amount,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.w800,
                fontSize: tertiary(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return const Divider(
      thickness: 1,
      color: Color.fromARGB(255, 209, 208, 208),
      height: 1,
    );
  }

  Widget _buildBottomButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Get.to(
                  () => const PaymentMethodScreen(),
              transition: Transition.cupertino,
              duration: const Duration(milliseconds: 400),
            );
          },

          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          ),
          child: const Text('Pay Now', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 150,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Download logic
                },
                icon: const Icon(Icons.download, color: Colors.white),
                label: const Text('Download',
                    style: TextStyle(color: Colors.white)),
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColors.green),
              ),
            ),
            SizedBox(
              width: 150,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Print logic
                },
                icon: const Icon(Icons.print, color: Colors.white),
                label:
                    const Text('Print', style: TextStyle(color: Colors.white)),
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColors.brown),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
