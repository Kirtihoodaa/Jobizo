import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobizo/Customer_POV/HomePages/Allsites.dart';
import 'package:jobizo/Customer_POV/HomePages/AssignedLabour.dart';
import 'package:jobizo/Customer_POV/HomePages/Labour_types/labour_avi.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import '../AppBar/CustomerAppBar.dart';
import '../CustomerNavBar.dart';
import 'AddCompanyDetails.dart';
import 'AgentsList.dart';
import 'Allsites.dart';
import 'CompanyDetails.dart';
import 'Dashboard.dart';
import 'IndustryDetails.dart';
import 'LabourLocalities.dart';
import 'SiteDetails.dart';

class Homepagess extends StatefulWidget {
  const Homepagess({super.key});

  @override
  State<Homepagess> createState() => _HomepagessState();
}

class _HomepagessState extends State<Homepagess> {
  final List<Map<String, dynamic>> options = [
    {
      "label": "Dashboard",
      "image": "Assets/Labour_image/dashboard icon.png",
      "navigateTo": DashboardScreenC(),
    },
    {
      "label": "Industry",
      "image": "Assets/Customer_Images/industry.png",
      "navigateTo": Industrydetails(),
    },
    {
      "label": "Sites",
      "image": "Assets/Customer_Images/sites.png",
      "navigateTo": AllSitesScreen(),
    },
    {
      "label": "Labour\nTypes",
      "image": "Assets/Customer_Images/labour type.png",
      "navigateTo": AllLaboursScreen(),
    },
    {
      "label": "Agents",
      "image": "Assets/Customer_Images/agents.png",
      "navigateTo": AgentsList(),
    },
    {
      "label": "Labour\nLocalities",
      "image": "Assets/Customer_Images/location.png",
      "navigateTo": Labourlocalities(),
    },
    {
      "label": "Add Company\nDetails",
      "image": "Assets/Customer_Images/add comp details.png",
      "navigateTo": AddCompanyDetails(),
    },
    {
      "label": "Company\nDetails",
      "image": "Assets/Customer_Images/details comp.png",
      "navigateTo": Companydetails(),
    },
    {
      "label": "Assigned\nLabour",
      "image": "Assets/Customer_Images/assigned labour.png",
      "navigateTo": AssignedWorkerPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: Customerappbar(profileImageUrl: '',
          // onMenuTap: () => CustomMenu.show(context),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Welcome to Jobizo !",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF2C4305)),
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
                      padding: const EdgeInsets.only(top: 10.0, right: 25, left: 25, bottom: 10),
                      child: Image.asset(
                          "Assets/Labour_image/labour deshboard image.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                      child: Image.asset(
                        "Assets/jobizo/JobizoName.png",
                        width: 120,
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
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
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
        bottomNavigationBar: Customernavbar(),
      ),
    );
  }
}
