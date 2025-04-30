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
    {"category": "Construction", "count": 32},
    {"category": "Electrician", "count": 33},
    {"category": "Plumber", "count": 60},
    {"category": "Painter", "count": 45},
    {"category": "Carpenter", "count": 44},
  ];

  int get totalLabours =>
      labourCategories.fold(0, (sum, item) => sum + (item['count'] as int));

  // @override
  // void initState() {
  //   super.initState();

  // }

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
            _TotalLaboursCard(total: totalLabours),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Labour Category",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: secondary(),
                    color: AppColors.green),
              ),
            ),
            const SizedBox(height: 12),
            ...labourCategories.map(
              (item) => _CategoryItem(
                title: item['category'],
                count: item['count'],
                onTap: () {
                  // TODO: Navigate to category details
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalLaboursCard extends StatelessWidget {
  final int total;

  const _TotalLaboursCard({required this.total});

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
        children: [
          Text(
            "All Labours",
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            "-$total-",
            style: const TextStyle(
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
  final int count;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.title,
    required this.count,
    required this.onTap,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "$title $count",
                style: TextStyle(
                    fontSize: tertiary(),
                    fontWeight: FontWeight.w500,
                    color: AppColors.green),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "View All",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
