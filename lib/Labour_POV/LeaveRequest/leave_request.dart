import 'package:flutter/material.dart';
import 'package:jobizo/All_app_bars/normal_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class LeaveRequestDetailsPage extends StatefulWidget {
  const LeaveRequestDetailsPage({super.key});

  @override
  State<LeaveRequestDetailsPage> createState() =>
      _LeaveRequestDetailsPageState();
}

class _LeaveRequestDetailsPageState extends State<LeaveRequestDetailsPage> {
  late TextEditingController leaveTypeController;
  late TextEditingController fromDateController;
  late TextEditingController toDateController;
  late TextEditingController reasonController;

  @override
  void initState() {
    super.initState();
    leaveTypeController = TextEditingController();
    fromDateController = TextEditingController();
    toDateController = TextEditingController();
    reasonController = TextEditingController();
  }

  @override
  void dispose() {
    leaveTypeController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomBackAppBar(title: 'Leave Request Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabel('Leave Type'),
            buildTextField(leaveTypeController, hintText: 'Enter leave type'),
            const SizedBox(height: 16),
            buildLabel('From Date'),
            buildDateField(fromDateController, hintText: 'Select start date'),
            const SizedBox(height: 16),
            buildLabel('To Date'),
            buildDateField(toDateController, hintText: 'Select end date'),
            const SizedBox(height: 16),
            buildLabel('Reason'),
            buildReasonField(reasonController, hintText: 'Enter reason'),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // handle submit logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
                child: Text(
                  'Submit Request',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: primary(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildStatusRow('Status', 'Approved'),
                  const SizedBox(height: 8),
                  buildInfoRow('Approved By', 'John Smith'),
                  const SizedBox(height: 8),
                  buildInfoRow('Approved Date', '2024-02-20'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: secondary(),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller,
      {bool readOnly = false, String? hintText}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      style: TextStyle(fontSize: secondary()),
      decoration: buildInputDecoration(hintText: hintText),
    );
  }

  Widget buildDateField(TextEditingController controller, {String? hintText}) {
    return GestureDetector(
      onTap: () => _selectDate(controller),
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          style: TextStyle(fontSize: secondary()),
          decoration: buildInputDecoration(
            hintText: hintText,
            suffixIcon: const Icon(Icons.calendar_today, size: 20),
          ),
        ),
      ),
    );
  }

  Widget buildReasonField(TextEditingController controller,
      {String? hintText}) {
    return TextField(
      controller: controller,
      maxLines: 4,
      style: TextStyle(fontSize: secondary()),
      decoration: buildInputDecoration(hintText: hintText),
    );
  }

  Widget buildStatusRow(String title, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: secondary(),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: Colors.white,
              fontSize: tertiary(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: secondary(),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: secondary(),
          ),
        ),
      ],
    );
  }

  InputDecoration buildInputDecoration({String? hintText, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(fontSize: tertiary()),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade600, width: 1.5),
      ),
      suffixIcon: suffixIcon,
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }
}
