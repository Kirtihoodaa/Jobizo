import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Double Circle with Tick
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 244, 241, 241),
                    ),
                  ),
                  Container(
                    height: 90,
                    width: 90,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xFF62A910)),
                    child: const Icon(
                      Icons.check,
                      size: 70,
                      color: Colors.white, // white tick
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              Text(
                'Payment Sucessful',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF62A910),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Your transaction has been completed',
                style: TextStyle(
                  fontSize: secondary(),
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 42),
              Text(
                'Amount Paid',
                style: TextStyle(
                  fontSize: secondary(),
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'INR 15,0000.00',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 42),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction Details',
                      style: TextStyle(
                        fontSize: secondary(),
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Date & Time',
                            style: TextStyle(color: Colors.black)),
                        Text('April 12, 2025 • 10:45 AM',
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Transaction ID',
                            style: TextStyle(color: Colors.black)),
                        Text('TXN8294710365',
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Payment Method',
                            style: TextStyle(color: Colors.black)),
                        Text('•••• 4582',
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    SizedBox(height: 25),
                    Text(
                      'Order Details',
                      style: TextStyle(
                        fontSize: secondary(),
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order Number',
                            style: TextStyle(color: Colors.black)),
                        Text('#ORD-59284',
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFC107),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Back to Payment',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
