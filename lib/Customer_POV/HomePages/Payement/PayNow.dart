import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Customer_POV/HomePages/Payement/AddCard.dart';
import 'package:jobizo/Customer_POV/HomePages/Payement/payementSucces.dart';
import 'package:jobizo/Customer_POV/HomePages/Payement/proccesingscreen.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int _selectedMethod = 0;

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'image': 'Assets/Customer_Images/visa.png',
      'title': 'Visa ending in 4242',
      'subtitle': 'Expires 12/27',
    },
    {
      'image': 'Assets/Customer_Images/mastercard.png',
      'title': 'Mastercard ending in 5678',
      'subtitle': 'Expires 03/25',
    },
    {
      'image': 'Assets/Customer_Images/gpay.png',
      'title': 'Google Pay',
      'subtitle': 'Connected',
    },
    {
      'image': 'Assets/Customer_Images/upi.png',
      'title': 'UPI / Net Banking',
      'subtitle': 'All Indian banks supported',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: "Pay Now"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Methods',
                      style: TextStyle(
                        fontSize: secondary(),
                        fontWeight: FontWeight.bold,
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(paymentMethods.length, (index) {
                      final method = paymentMethods[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 203, 202, 202)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            method['image'],
                            height: 32,
                            width: 32,
                          ),
                          title: Text(method['title'],
                              style: const TextStyle(fontSize: 14)),
                          subtitle: Text(method['subtitle'],
                              style: const TextStyle(fontSize: 12)),
                          trailing: Radio(
                            value: index,
                            groupValue: _selectedMethod,
                            onChanged: (value) {
                              setState(() {
                                _selectedMethod = value!;
                              });
                            },
                            activeColor: AppColors.gold,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                              () => AddCard(),
                          transition: Transition.cupertino,
                          duration: const Duration(milliseconds: 400),
                        );

                      },
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.black),
                          SizedBox(width: 8),
                          Text('Add Another Card',
                              style: TextStyle(
                                  fontSize: secondary(), color: Colors.black)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomPayNowButton(context),
        ],
      ),
    );
  }

  Widget _buildBottomPayNowButton(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      color: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Get.to(
                  () => ProcessingScreen(),
              transition: Transition.cupertino,
              duration: const Duration(milliseconds: 400),
            );

          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Pay Now',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
