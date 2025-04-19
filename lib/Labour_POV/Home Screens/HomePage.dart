import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Labour_POV/LeaveRequest/leave_request.dart';
import 'package:jobizo/Payments/Payment.dart';

import '../../Design contraints/gradients.dart';
import '../../All_app_bars/app_bar.dart';
import '../NavBar.dart';
import 'Dashboard.dart';
import 'OngoingContract.dart';
import 'EmergencyPage.dart';
import 'Issue.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<Map<String, dynamic>> options = [
    {
      "label": "Dashboard",
      "image": "Assets/Labour_image/dashboard icon.png",
      "navigateTo": DashboardScreen(),
    },
    {
      "label": "Payment",
      "image": "Assets/Labour_image/payment icon.png",
      "navigateTo": Payment(),
    },
    {
      "label": "Leave\nRequest",
      "image": "Assets/Labour_image/Leave req icon.png",
      "navigateTo": LeaveRequestDetailsPage(),
    },
    {
      "label": "Ongoing\nContract",
      "image": "Assets/Labour_image/ongoing contract.png",
      "navigateTo": OngoingContractPage(),
    },
    {
      "label": "labour\nIssue",
      "image": "Assets/Labour_image/labour issue.png",
      "navigateTo": LabourIssuesScreen(),
    },
    {
      "label": "Emergency",
      "image": "Assets/Labour_image/emergency icon.png",
      "navigateTo": EmergencyPage(),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        name: 'Deepak',
        location: 'Chandigarh',
        profileImageUrl: '',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Welcome to Jobizo !",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            )),
            Container(
              // height: 250,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.center,
                    colors: [
                      Color(0xFFEEA700), // Yellow
                      Color(0xFFEA9D18),
                    ]),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                        "Assets/Labour_image/labour deshboard image.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      "Assets/jobizo/JobizoName.png",
                      width: 200,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 30,
              ),
              width: MediaQuery.of(context).size.width,
              // height: 300,
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: options.map((item) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => item['navigateTo']),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: const Color(0xFFEEA700),
                          child: Image.asset(
                            item['image'],
                            width: 35,
                            height: 35,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item['label'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: tertiary(),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBarLabour(),
    );
  }
}
