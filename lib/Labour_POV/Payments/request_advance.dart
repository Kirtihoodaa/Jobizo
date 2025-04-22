import 'package:flutter/material.dart';
import 'package:jobizo/All_app_bars/normal_app_bar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:jobizo/Payments/biometricsuccessscreen.dart';

class RequestAdvance extends StatefulWidget {
  const RequestAdvance({super.key});

  @override
  State<RequestAdvance> createState() => _RequestAdvanceState();
}

class _RequestAdvanceState extends State<RequestAdvance> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  String? selectedPaymentMethod;

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
                    'INR 25,000',
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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: secondary(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 1.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: InputBorder.none),
                hint: const Text('Select Payment Method'),
                value: selectedPaymentMethod,
                items: ['UPI', 'Bank Transfer', 'Wallet']
                    .map((method) => DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 40),

            GestureDetector(
              onTap: () {
                Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const BiometricSuccessScreen(requestType: 'Advance'),
  ),
);

              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14), // smaller circle
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                    ),
                    child: const Icon(Icons.fingerprint,
                        size: 36, color: Color(0xFF4B1E03)), // smaller icon
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Place your finger on the scanner\nto verify your identity',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: tertiary()),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Biometric Authentication',
                    style: TextStyle(
                      fontSize: secondary(),
                      color: Colors.amber.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
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
                color: Colors.black,
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
