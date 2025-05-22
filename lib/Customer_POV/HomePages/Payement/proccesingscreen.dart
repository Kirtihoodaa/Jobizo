import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:async';

import 'package:jobizo/Customer_POV/HomePages/Payement/payementSucces.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();

    Future.delayed(const Duration(seconds: 4), () {
      Get.off(
            () => const PaymentSuccessPage(),
        transition: Transition.cupertino,
        duration: const Duration(milliseconds: 400),
      );

    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _controller,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      Colors.transparent,
                      const Color(0xFF62A910).withOpacity(0.5),
                      Color(0xFF62A910),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
            const Text(
              "Processing Your Payment...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF62A910),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Please wait a moment",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF62A910),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
