import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../SnackBar/Snackbar.dart';
import '../All_app_bars/normal_app_bar.dart';

class LeaveRequestDetailsPage extends StatefulWidget {
  const LeaveRequestDetailsPage({super.key});

  @override
  State<LeaveRequestDetailsPage> createState() => _LeaveRequestDetailsPageState();
}

class _LeaveRequestDetailsPageState extends State<LeaveRequestDetailsPage> {
  List<Map<String, dynamic>> leaveRequests = [];
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
    fetchLeaveRequests();
  }

  Future<void> fetchLeaveRequests() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        print("⚠️ Token not found");
        return;
      }

      Dio dio = Dio();
      dio.options.headers = {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      };

      print("📡 Fetching leave requests with token: Bearer $token");

      final response = await dio.get("https://backend.jobizoindia.com/api/leave-request");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        setState(() {
          leaveRequests = List<Map<String, dynamic>>.from(data.reversed);
        });
      }
    } on DioException catch (e) {
      print("❌ DioException: ${e.response?.statusCode}");
      print("❌ Response body: ${e.response?.data}");
    } catch (e) {
      print("❌ Unknown error fetching leave requests: $e");
    }
  }

  Future<void> PostLeaveRequest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        print("⚠️ Token not found");
        return;
      }

      Dio dio = Dio();
      dio.options.headers = {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      };

      final formData = {
        "leave_type": leaveTypeController.text.trim(),
        "from_date": fromDateController.text.trim(),
        "to_date": toDateController.text.trim(),
        "reason": reasonController.text.trim(),
      };

      print("📤 Submitting leave request: $formData");

      final response = await dio.post(
        'https://backend.jobizoindia.com/api/leave-request',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newRequest = {
          'status': 'Pending',
          'approved_by': null,
          'approved_date': null,
          'requested_on': DateTime.now().toIso8601String(),
          'leave_type': leaveTypeController.text.trim(),
          'from_date': fromDateController.text.trim(),
          'to_date': toDateController.text.trim(),
          'reason': reasonController.text.trim(),
        };

        setState(() {
          leaveRequests.insert(0, newRequest);
        });

        SnackbarHelper.showSuccess(context, 'Leave request submitted successfully');
        leaveTypeController.clear();
        fromDateController.clear();
        toDateController.clear();
        reasonController.clear();
      } else {
        SnackbarHelper.showError(context, 'Failed to submit leave request');
      }
    } on DioException catch (e) {
      print("❌ DioException: ${e.response?.statusCode}");
      print("❌ Response body: ${e.response?.data}");
      SnackbarHelper.showError(context, 'Error submitting leave request');
    } catch (e) {
      print("❌ Unknown error submitting leave request: $e");
      SnackbarHelper.showError(context, 'Unexpected error submitting leave request');
    }
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
                  PostLeaveRequest();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
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
            leaveRequests.isEmpty
                ? Center(child: Text("No leave requests submitted yet"))
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: leaveRequests.length,
              itemBuilder: (context, index) {
                final leave = leaveRequests[index];
                final requestedTime = leave['requested_on'];
                final formattedRequestTime = requestedTime != null
                    ? DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(requestedTime))
                    : 'N/A';

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildStatusRow('Status', leave['status'] ?? 'N/A'),
                      const SizedBox(height: 8),
                      buildInfoRow('Approved By', leave['approved_by'] ?? 'Pending'),
                      const SizedBox(height: 8),
                      buildInfoRow('Approved Date', leave['approved_date'] ?? 'Pending'),
                      const SizedBox(height: 8),
                      buildInfoRow('Requested On', formattedRequestTime),
                    ],
                  ),
                );
              },
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

  Widget buildReasonField(TextEditingController controller, {String? hintText}) {
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

  InputDecoration buildInputDecoration({
    String? hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hintText,
      hintStyle: TextStyle(fontSize: tertiary()),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.gold, width: 2),
      ),
      suffixIcon: suffixIcon,
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: AppColors.gold,
              onPrimary: Colors.white,
              onSurface: Colors.black,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }
}