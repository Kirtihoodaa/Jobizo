import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Design contraints/FontSizes.dart';
import '../../Design contraints/app color.dart';
import '../../SnackBar/Snackbar.dart';
import '../All_app_bars/normal_app_bar.dart';
import '../Payments/request_advance.dart';
import '../Payments/request_salary.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

Future<Map<String, dynamic>> fetchPayments() async {
  try {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('auth_token') ?? '';
    final dio = Dio(BaseOptions(headers: {'Authorization': token}));

    final response =
    await dio.get('https://backend.jobizoindia.com/api/available-salary');

    final data = response.data;
    final creditedAmount = data['available_salary'].toString();
    final transactions = List<Map<String, dynamic>>.from(data['transactions']);

    return {
      'creditedAmount': creditedAmount,
      'transactions': transactions,
    };
  } catch (e) {
    print('Error: $e');
    return {
      'creditedAmount': '0',
      'transactions': [],
    };
  }
}
Future<void> downloadSalaryPdf(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  final dio = Dio();
  dio.options.headers["Authorization"] = "Bearer $token";

  // Handle permissions
  if (Platform.isAndroid) {
    if (Platform.version.startsWith('13') || Platform.version.startsWith('14')) {
      final statuses = await [Permission.photos, Permission.videos].request();
      if (statuses.values.any((status) => !status.isGranted)) {
        SnackbarHelper.showWarning(context, "Media access is required to download the file.");
        return;
      }
    } else {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        SnackbarHelper.showWarning(context, "Storage permission is required to download the file.");
        return;
      }
    }
  }

  try {
    // ✅ Save to public Downloads folder
    final downloadsDir = Directory('/storage/emulated/0/Download');
    final filePath = "${downloadsDir.path}/salary_statement_${DateTime.now().millisecondsSinceEpoch}.pdf";

    await dio.download(
      'https://backend.jobizoindia.com/api/transaction-statement',
      filePath,
    );

    SnackbarHelper.showSuccess(context, "PDF downloaded to: $filePath");
  } catch (e) {
    SnackbarHelper.showError(context, "Failed to download PDF.");
    print("Download error: $e");
  }
}


Future<void> mailSalaryStatement(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  final dio = Dio();

  dio.options.headers["Authorization"] = "Bearer $token";

  try {
    final response = await dio.get(
      'https://backend.jobizoindia.com/api/transaction-statement?delivery_type=email',
    );

    final data = response.data;
    if (response.statusCode == 200 && data['status'] == true) {
      SnackbarHelper.showSuccess(context, data['message']);
    } else {
      SnackbarHelper.showError(context, "Failed to send mail.");
    }
  } catch (e) {
    SnackbarHelper.showError(context, "API error while sending mail.");
    print("Mail error: $e");
  }
}





class _PaymentState extends State<Payment> {
  String creditedAmount = 'Loading...';
  List<Map<String, dynamic>> transactions = [];
  String selectedAction = '';

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  Future<void> _loadPayments() async {
    final data = await fetchPayments();
    setState(() {
      creditedAmount = data['creditedAmount'];
      transactions = data['transactions'];
    });
  }

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
                salaryAmount: creditedAmount,
                month: " 2025",
                dueDate: "31st",
                onRefresh: _loadPayments,
              ),
              const SizedBox(height: 20),
              // AdvanceSalaryLimitsCard(
              //   availableAdvance: "INR 25,500",
              //   maxAdvance: "INR 42,500",
              //   progressValue: 0.6,
              // ),
              const SizedBox(height: 20),
              Row(
                children: [
                  SalaryActionButton(
                    text: "Request Salary",
                    isSelected: selectedAction == "salary",
                    onTap: () {
                      setState(() {
                        selectedAction = "salary";
                        Get.to(() => const RequestSalary(),
                            transition: Transition.cupertino,
                            duration: const Duration(milliseconds: 400));
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
                        Get.to(() => const RequestAdvance(),
                            transition: Transition.cupertino,
                            duration: const Duration(milliseconds: 400));
                      });
                    },
                  ),
                ],
              ),const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () async {
                      await downloadSalaryPdf(context);
                    },
                    icon: const Icon(Icons.download, color: AppColors.gold),
                    label: const Text("Download", style: TextStyle(color: AppColors.gold)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.gold),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await mailSalaryStatement(context);
                    },
                    icon: const Icon(Icons.email, color: AppColors.gold),
                    label: const Text("Send Mail", style: TextStyle(color: AppColors.gold)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.gold),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TransactionHistoryCard(transactions: transactions),
              const SizedBox(height: 20),
              PaymentDetailsCard(creditedAmount: creditedAmount),
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
  final VoidCallback onRefresh;

  const SalarySummaryCard({
    super.key,
    required this.salaryAmount,
    required this.month,
    required this.dueDate,
    required this.onRefresh,
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
              Text("Current salary",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: secondary(), color: Colors.white)),
              const Spacer(),
              Text(month,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: tertiary(), color: Colors.white)),
            ],
          ),
          const SizedBox(height: 12),
          Text(salaryAmount,
              style: TextStyle(fontSize: primary(), color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Text("Net salary after deductions",
              style: TextStyle(fontSize: tertiary(), color: Colors.white, fontWeight: FontWeight.w400)),
          const SizedBox(height: 12),
          Row(
            children: [
              Image.asset("Assets/Labour_image/payment_due.png", height: 18, width: 18),
              const SizedBox(width: 9),
              Text("Payment due on $dueDate",
                  style: TextStyle(fontSize: tertiary(), color: Colors.white, fontWeight: FontWeight.w400)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: onRefresh,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TransactionHistoryCard extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  const TransactionHistoryCard({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Text("No recent transactions");
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, 1), blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Transaction History", style: TextStyle(fontWeight: FontWeight.w500, fontSize: secondary(), color: AppColors.green)),
          const SizedBox(height: 15),
          ...transactions.map((txn) {
            bool isCredit = txn['type'] == 'credit';
            return Column(
              children: [
                _transactionRow(
                  context,
                  icon: isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                  iconColor: isCredit ? AppColors.green : const Color(0xFF4B1E03),
                  bgColor: isCredit ? const Color(0xFFDCFCE7) : const Color(0xFFFFF3E0),
                  title: txn['description'] ?? '',
                  date: txn['created_at'] != null ? DateTime.parse(txn['created_at']).toLocal().toString().split(' ')[0] : '',
                  amount: "${isCredit ? '+' : '-'}INR ${txn['amount'] ?? '0'}",
                  amountColor: isCredit ? Colors.green : const Color(0xFF4B1E03),
                ),

                const SizedBox(height: 15),
              ],
            );
          }).toList(),
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
        CircleAvatar(backgroundColor: bgColor, radius: 20, child: Icon(icon, size: 20, color: iconColor)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: secondary(), fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(date, style: TextStyle(fontSize: tertiary(), color: Colors.black, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
        Text(amount, style: TextStyle(color: amountColor, fontWeight: FontWeight.w500, fontSize: tertiary())),
      ],
    );
  }
}

class PaymentDetailsCard extends StatelessWidget {
  final String creditedAmount;
  const PaymentDetailsCard({super.key, required this.creditedAmount});

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
          Text("Payment Details",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: secondary(), color: AppColors.green)),
          const SizedBox(height: 15),
          _PaymentDetailRow(label: "Basic Salary", value: creditedAmount),
          const _PaymentDetailRow(label: "HRA", value: "INR 0"),
          const _PaymentDetailRow(label: "Special Allowance", value: "INR 0"),
          const _PaymentDetailRow(label: "PF Deduction", value: "-INR 0", valueColor: Color(0xFF4B1E03)),
          const _PaymentDetailRow(label: "Tax Deduction", value: "-INR 0", valueColor: Color(0xFF4B1E03)),
          const Divider(),
          _PaymentDetailRow(label: "Net Salary", value: creditedAmount, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }
}

class _PaymentDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final FontWeight? fontWeight;

  const _PaymentDetailRow({required this.label, required this.value, this.valueColor, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontWeight: fontWeight ?? FontWeight.w400, fontSize: tertiary())),
          const Spacer(),
          Text(value,
              style: TextStyle(color: valueColor ?? Colors.black, fontWeight: fontWeight ?? FontWeight.w500, fontSize: tertiary())),
        ],
      ),
    );
  }
}

class SalaryActionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const SalaryActionButton({super.key, required this.text, required this.isSelected, required this.onTap});

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
          child: Text(text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: tertiary(),
                color: isSelected ? Colors.white : AppColors.gold,
              )),
        ),
      ),
    );
  }
}
