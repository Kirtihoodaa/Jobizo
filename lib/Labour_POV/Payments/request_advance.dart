import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../SnackBar/Snackbar.dart';
import '../All_app_bars/normal_app_bar.dart';
import 'biometricsuccessscreen.dart';


class RequestAdvance extends StatefulWidget {
  const RequestAdvance({super.key});

  @override
  State<RequestAdvance> createState() => _RequestAdvanceState();
}

class _RequestAdvanceState extends State<RequestAdvance> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  String? selectedPaymentMethod;
  String creditedAmount = 'Loading...';

  final FocusNode amountFocus = FocusNode();
  final FocusNode reasonFocus = FocusNode();

  @override
  void dispose() {
    amountController.dispose();
    reasonController.dispose();
    amountFocus.dispose();
    reasonFocus.dispose();
    super.dispose();
  }

  void _submitRequest() async {
    final amount = amountController.text.trim();
    final reason = reasonController.text.trim();

    if (amount.isEmpty || reason.isEmpty) {
      SnackbarHelper.showWarning(context, "All Fields are Required");
      return;
    }

    final enteredAmount = int.tryParse(amount.replaceAll(',', ''));
    if (enteredAmount == null) {
      SnackbarHelper.showWarning(context, "Invalid amount entered");
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        SnackbarHelper.showError(context, "Unauthorized. Please log in again.");
        return;
      }

      final dioClient = Dio();
      dioClient.options.headers['Authorization'] = 'Bearer $token';

      final response = await dioClient.post(
        'https://backend.jobizoindia.com/api/request-salary',
        data: {
          "amount": enteredAmount,
          "reason": reason,
          "type": "advance"
        },
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        print("Salary request submitted: ${response.data['data']}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const BiometricSuccessScreen(requestType: 'Advance'),
          ),
        );
      } else {
        SnackbarHelper.showError(context, response.data['message'] ?? "Submission failed.");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        print("Status code: ${dioError.response?.statusCode}");
        print("Response data: ${dioError.response?.data}");
        SnackbarHelper.showError(
          context,
          dioError.response?.data['message'] ?? "Validation error occurred.",
        );
      } else {
        SnackbarHelper.showError(context, "Network error occurred.");
      }
    }
  }
  @override
  void initState() {
    super.initState();
    fetchPayments(); // Load available salary on screen start
  }
  Future<void> fetchPayments() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('auth_token') ?? '';
      final dio = Dio(BaseOptions(headers: {'Authorization': token}));

      final response = await dio.get('https://backend.jobizoindia.com/api/available-salary');
      final data = response.data;
      setState(() {
        creditedAmount = "INR ${data['available_salary'].toString()}";
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        creditedAmount = "INR 0";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomBackAppBar(title: 'Request Advance'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Available Amount Container (Height increased)
            Container(
              width: double.infinity,
              height: 180,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.brown.shade800,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Available Amount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: secondary(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    creditedAmount,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Amount Field
            customTextField(
              controller: amountController,
              label: 'Amount',
              hintText: 'Enter amount',
              fontSize: secondary(),
              focusNode: amountFocus,
            ),

            const SizedBox(height: 20),

            // Reason Field
            customTextField(
              controller: reasonController,
              label: 'Reason',
              hintText: 'Enter reason',
              fontSize: secondary(),
              focusNode: reasonFocus,
            ),

            const SizedBox(height: 20),

            // Payment Method Dropdown
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     'Payment Method',
            //     style: TextStyle(
            //       fontSize: secondary(),
            //       fontWeight: FontWeight.w500,
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 6),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 12),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey.shade400, width: 1.3),
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: DropdownButtonFormField<String>(
            //
            //     decoration: const InputDecoration(border: InputBorder.none),
            //     dropdownColor: Colors.white,
            //     hint: const Text('Select Payment Method'),
            //     value: selectedPaymentMethod,
            //     items: ['UPI', 'Bank Transfer', 'Wallet']
            //         .map((method) => DropdownMenuItem(
            //               value: method,
            //               child: Text(method),
            //             ))
            //         .toList(),
            //     onChanged: (value) {
            //       setState(() {
            //         selectedPaymentMethod = value;
            //       });
            //     },
            //   ),
            // ),
            //
            // const SizedBox(height: 40),

//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (_) => const BiometricSuccessScreen(requestType: 'Advance'),
//   ),
// );
//
//               },
//               child: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(14), // smaller circle
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.grey.shade300,
//                     ),
//                     child: const Icon(Icons.fingerprint,
//                         size: 36, color: Color(0xFF4B1E03)), // smaller icon
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Place your finger on the scanner\nto verify your identity',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: tertiary()),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Biometric Authentication',
//                     style: TextStyle(
//                       fontSize: secondary(),
//                       color: Colors.amber.shade800,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
          SizedBox(height: 50,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () { _submitRequest(); },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // onPressed: () {  },
                child: Text(
                  'Submit Request',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: secondary(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
//
//             const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget customTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required FocusNode focusNode,
    double fontSize = 16,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          focusNode: focusNode,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.3,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.3,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.gold,
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
