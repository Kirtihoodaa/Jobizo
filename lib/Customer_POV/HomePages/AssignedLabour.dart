import 'package:flutter/material.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Customer_POV/HomePages/LabourProfile.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class AssignedWorkerPage extends StatefulWidget {
  const AssignedWorkerPage({super.key});

  @override
  State<AssignedWorkerPage> createState() => _AssignedWorkerPageState();
}

class _AssignedWorkerPageState extends State<AssignedWorkerPage> {
  List<Map<String, dynamic>> labourList = [
    {
      "name": "Michael Anderson",
      "role": "Senior Electrician",
      "experience": "15 years experience",
      "rating": 4.9,
      "image": "Assets/Labour_image/labour_profile.png"
    },
    {
      "name": "David Thompson",
      "role": "Plumber",
      "experience": "8 years experience",
      "rating": 4.7,
      "image": "Assets/Labour_image/labour_profile.png"
    },
  ];

  String selectedSort = "Sort by Experience";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: 'Assigned Labours'),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.brown,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Available Labours",
                      style: TextStyle(color: Colors.white, fontSize: 28)),
                  SizedBox(height: 8),
                  Text("-32-",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Construction Labours",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: secondary(),
                      color: AppColors.gold),
                ),
                Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedSort,
                      dropdownColor: Colors.white,
                      iconEnabledColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      onChanged: (value) {
                        setState(() {
                          selectedSort = value!;
                        });
                      },
                      items:
                          ["Sort by Experience", "Sort by Rating"].map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item,
                              style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: labourList.length,
                itemBuilder: (context, index) {
                  final worker = labourList[index];
                  return LabourCard(
                    name: worker["name"],
                    role: worker["role"],
                    experience: worker["experience"],
                    rating: worker["rating"],
                    imagePath: worker["image"],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LabourProfilePage(
                            name: worker["name"],
                            role: worker["role"],
                            //now hardcode given when api will be there it will be fetched from it.
                            employeeId: "EMP-2024-0123",
                            location: "123 Construction Ave, Downtown",
                            phone: "9870999888",
                            email: "site.manager@construction.com",
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LabourCard extends StatelessWidget {
  final String name;
  final String role;
  final String experience;
  final double rating;
  final String imagePath;
  final VoidCallback onTap;

  const LabourCard({
    super.key,
    required this.name,
    required this.role,
    required this.experience,
    required this.rating,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 108,
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 10,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imagePath),
              radius: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: secondary())),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(role, style: TextStyle(fontSize: tertiary())),
                      Spacer(),
                      Icon(Icons.star, color: AppColors.gold, size: 20),
                      Text(rating.toString()),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.work, size: 16),
                      const SizedBox(width: 4),
                      Text(experience, style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
