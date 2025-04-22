import 'package:flutter/material.dart';
import 'package:jobizo/All_app_bars/normal_app_bar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:jobizo/Payments/request_advance.dart';
import 'package:jobizo/Payments/request_salary.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String selectedAction = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomBackAppBar(title: 'Salary Portal'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              SalarySummaryCard(
                salaryAmount: "INR 85,000",
                month: "May 2025",
                dueDate: "31st May",
              ),
              const SizedBox(height: 20),
              AdvanceSalaryLimitsCard(
                availableAdvance: "INR 25,500",
                maxAdvance: "INR 42,500",
                progressValue: 0.6,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  SalaryActionButton(
                    text: "Request Salary",
                    isSelected: selectedAction == "salary",
                    onTap: () {
                      setState(() {
                        selectedAction = "salary";
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RequestSalary()));
                      });
                    },
                  ),
                  const Spacer(),
                  SalaryActionButton(
                    text: "Request Advance",
                    isSelected: selectedAction == "advance",
                    onTap: () {
                      setState(() {
                        selectedAction = "advance";
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RequestAdvance()));
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const TransactionHistoryCard(),
              const SizedBox(height: 20),
              const PaymentDetailsCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class SalarySummaryCard extends StatelessWidget {
  final String salaryAmount;
  final String month;
  final String dueDate;

  const SalarySummaryCard({
    super.key,
    required this.salaryAmount,
    required this.month,
    required this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF4B1E03),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Current salary",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: secondary(),
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                month,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: tertiary(),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            salaryAmount,
            style: TextStyle(
              fontSize: primary(),
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Net salary after deductions",
            style: TextStyle(
              fontSize: tertiary(),
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Image.asset(
                "Assets/Labour_image/payment_due.png",
                height: 18,
                width: 18,
              ),
              const SizedBox(width: 9),
              Text(
                "Payment due on $dueDate",
                style: TextStyle(
                  fontSize: tertiary(),
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdvanceSalaryLimitsCard extends StatelessWidget {
  final String availableAdvance;
  final String maxAdvance;
  final double progressValue;

  const AdvanceSalaryLimitsCard({
    super.key,
    required this.availableAdvance,
    required this.maxAdvance,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Advance Salary Limits",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: secondary(),
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text(
                "Available Advance",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: tertiary(),
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Text(
                "$availableAdvance / $maxAdvance",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: tertiary(),
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation(Color(0xFF62A910)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Maximum advance limit: 50% of monthly salary",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: tertiary(),
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class SalaryActionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const SalaryActionButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        width: 164,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : Colors.transparent,
          border: Border.all(color: AppColors.gold),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: tertiary(),
              color: isSelected ? Colors.white : AppColors.gold,
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionHistoryCard extends StatelessWidget {
  const TransactionHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transaction History",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: secondary(),
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 15),
          _transactionRow(
            context,
            icon: Icons.arrow_downward,
            iconColor: AppColors.green,
            bgColor: const Color(0xFFDCFCE7),
            title: "Salary Credit",
            date: "April 30, 2024",
            amount: "+INR 85,000",
            amountColor: Colors.green,
          ),
          const SizedBox(height: 20),
          _transactionRow(
            context,
            icon: Icons.arrow_upward,
            iconColor: Color(0xFF4B1E03),
            bgColor: const Color(0xFFFFF3E0),
            title: "Advance Withdrawal",
            date: "April 15, 2024",
            amount: "-INR 17,000",
            amountColor: Color(0xFF4B1E03),
          ),
        ],
      ),
    );
  }

  Widget _transactionRow(BuildContext context,
      {required IconData icon,
      required Color iconColor,
      required Color bgColor,
      required String title,
      required String date,
      required String amount,
      required Color amountColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: bgColor,
          radius: 20,
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: secondary(), fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(date,
                  style: TextStyle(
                      fontSize: tertiary(),
                      color: Colors.black,
                      fontWeight: FontWeight.w400)),
            ],
          ),
        ),
        Text(amount,
            style: TextStyle(
                color: amountColor,
                fontWeight: FontWeight.w500,
                fontSize: tertiary())),
      ],
    );
  }
}

class PaymentDetailsCard extends StatelessWidget {
  const PaymentDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Payment Details",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: secondary(),
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 15),
          const _PaymentDetailRow(label: "Basic Salary", value: "INR 65,000"),
          const _PaymentDetailRow(label: "HRA", value: "INR 15,000"),
          const _PaymentDetailRow(
              label: "Special Allowance", value: "INR 12,000"),
          const _PaymentDetailRow(
            label: "PF Deduction",
            value: "-INR 3,600",
            valueColor: Color(0xFF4B1E03),
          ),
          const _PaymentDetailRow(
            label: "Tax Deduction",
            value: "-INR 3,400",
            valueColor: Color(0xFF4B1E03),
          ),
          const Divider(),
          const _PaymentDetailRow(
            label: "Net Salary",
            value: "INR 85,000",
            fontWeight: FontWeight.w600, // Bold text for net salary
          ),
        ],
      ),
    );
  }
}

class _PaymentDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final FontWeight? fontWeight; // Optional fontWeight parameter

  const _PaymentDetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.fontWeight, // Initialize fontWeight here
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
                fontWeight: fontWeight ?? FontWeight.w400,
                fontSize: tertiary()),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
                color: valueColor ?? Colors.black,
                fontWeight: fontWeight ??
                    FontWeight.w500, // Use passed fontWeight or default
                fontSize: tertiary()),
          ),
        ],
      ),
    );
  }
}
