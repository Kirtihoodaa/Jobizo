import 'package:flutter/material.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Customer_POV/HomePages/Labour_types/Details_labour.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class Requiredlabour extends StatefulWidget {
  const Requiredlabour({super.key});

  @override
  State<Requiredlabour> createState() => _RequiredlabourState();
}

class _RequiredlabourState extends State<Requiredlabour> {
  List<Map<String, dynamic>> labourCategories = [
    {"category": "Construction", "available": 32, "required": 50},
    {"category": "Electrician", "available": 8, "required": 15},
    {"category": "Plumbing", "available": 5, "required": 8},
    {"category": "Painting", "available": 5, "required": 5},
    {"category": "Carpenter", "available": 2, "required": 12},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: "Required Workers"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _TotalLaboursCard(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Labour Category",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: secondary(),
                        color: AppColors.green)),
                Text("Available/Required",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: tertiary(),
                        color: AppColors.gold)),
              ],
            ),
            const SizedBox(height: 12),
            ...labourCategories.map(
              (item) => _CategoryItem(
                title: item['category'],
                available: item['available'],
                required: item['required'],
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalLaboursCard extends StatelessWidget {
  const _TotalLaboursCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.brown,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Total Required Labours",
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 8),
          Text(
            "-127-",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String title;
  final int available;
  final int required;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.title,
    required this.available,
    required this.required,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 0),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: tertiary(),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "$available/$required",
              style: TextStyle(
                  fontSize: tertiary(),
                  fontWeight: FontWeight.bold,
                  color: AppColors.green),
            ),
          ],
        ),
      ),
    );
  }
}
