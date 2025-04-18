import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';

import '../../Design contraints/gradients.dart';
import '../../app_bar.dart';
import '../NavBar.dart';

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
      // "navigateTo": Screen1(),
    },
    {
      "label": "Payment",
      "image": "Assets/Labour_image/payment icon.png",
      // "navigateTo": Screen2(),
    },
    {
      "label": "Leave\nRequest",
      "image": "Assets/Labour_image/Leave req icon.png",
      // "navigateTo": Screen3(),
    },
    {
      "label": "Ongoing\nContract",
      "image": "Assets/Labour_image/ongoing contract.png",
      // "navigateTo": Screen4(),
    },
    {
      "label": "labour\nIssue",
      "image": "Assets/Labour_image/labour issue.png",
      // "navigateTo": Screen5(),
    },
    {
      "label": "Emergency",
      "image": "Assets/Labour_image/emergency icon.png",
      // "navigateTo": Screen6(),
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
                        const SizedBox(height: 8),
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
