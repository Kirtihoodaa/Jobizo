import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Design contraints/gradients.dart';

class SucessRegister extends StatefulWidget {
  const SucessRegister({super.key});

  @override
  State<SucessRegister> createState() => _SucessRegisterState();
}

class _SucessRegisterState extends State<SucessRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration:
                BoxDecoration(gradient: AppGradients.yellowOrangeVertical),
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "Assets/jobizo/JobizoName.png",
                      width: 180.w,
                    ),
                    SizedBox(height: 100.h),
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 100, left: 20, right: 20, bottom: 20),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            gradient: AppGradients.Green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Text(
                                "SUCCESS !",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Thank you for \nshowing interest \n in Jobizo",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                    ),
                              ),
                              SizedBox(height: 40.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           RegistrationScreen()),
                                      // );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFEEA700),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 10),
                                    ),
                                    child: const Text(
                                      "COMPLETE YOUR PROFILE",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        /// Avatar Positioned Overlapping the Card
                        Positioned(
                          top: -55,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              'Assets/jobizo/jobizoLogo.png',
                              height: 125,
                              width: 125,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      label: const Text(
                        "Skip",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: const [
                Text(
                  "Need Help? Contact Support",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Version 2.1.0",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
