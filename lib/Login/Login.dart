import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? selectedRole;

  final List<String> roles = [
    'Client',
    'Designer',
    'Vendor',
    'Admin',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFACC15), Color(0xFFF97316)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("Assets/jobizo/JobizoName.png"),
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
                        color: const Color(0xFFFFCC80),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton<String>(
                              value: selectedRole,
                              hint: const Text("Select a role"),
                              isExpanded: true,
                              underline: const SizedBox(),
                              icon: const Icon(Icons.arrow_drop_down),
                              items: roles.map((role) {
                                return DropdownMenuItem<String>(
                                  value: role,
                                  child: Text(role),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedRole = value;
                                });
                              },
                            ),
                          ),

                          SizedBox(height: 50.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3E4E00),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  padding:  EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                ),
                                child:  Text("PREVIOUS",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  padding:  EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 10),
                                ),
                                child: const Text(
                                  "NEXT",
                                  style: TextStyle(color: Color(0xFF3E4E00)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// Avatar Positioned Overlapping the Card
                    Positioned(
                      top: -40,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'Assets/jobizo/jobizoLogo.png',
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                /// Footer
                const Column(
                  children: [
                    Text(
                      "Need Help? Contact Support",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}