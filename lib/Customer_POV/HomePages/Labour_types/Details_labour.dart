import 'package:flutter/material.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class Labour {
  final String name;
  final String profession;
  final int experience;
  final double rating;
  final String imageUrl;

  Labour({
    required this.name,
    required this.profession,
    required this.experience,
    required this.rating,
    required this.imageUrl,
  });
}

class LabourListScreen extends StatefulWidget {
  final String category;

  const LabourListScreen({super.key, required this.category});

  @override
  State<LabourListScreen> createState() => _LabourListScreenState();
}

class _LabourListScreenState extends State<LabourListScreen> {
  final List<Labour> allLabours = [
    Labour(
      name: "Michael Anderson",
      profession: "Electrician",
      experience: 15,
      rating: 4.9,
      imageUrl: "Assets/Labour_image/labour_profile.png",
    ),
    Labour(
      name: "David Thompson",
      profession: "Plumber",
      experience: 8,
      rating: 4.7,
      imageUrl: "Assets/Labour_image/labour_profile.png",
    ),
    Labour(
      name: "Ali Khan",
      profession: "Electrician",
      experience: 6,
      rating: 4.5,
      imageUrl: "Assets/Labour_image/labour_profile.png",
    ),
    Labour(
      name: "Ravi Verma",
      profession: "Painter",
      experience: 10,
      rating: 4.8,
      imageUrl: "Assets/Labour_image/labour_profile.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = allLabours
        .where((labour) => labour.profession
            .toLowerCase()
            .contains(widget.category.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: "Construction Labours"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top card showing available labour count
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.brown,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Available Labours",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "-${filtered.length}-",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Filter row
            Row(
              children: [
                Text(
                  "All Labours",
                  style: TextStyle(
                    color: AppColors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: const [
                      Text("Sort by Experience"),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Labour List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                          "No labours found in ${widget.category} category."),
                    )
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final labour = filtered[index];
                        return Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 108,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        AssetImage(labour.imageUrl),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          labour.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: secondary(),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          labour.profession,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: tertiary(),
                                              fontWeight: FontWeight.w100),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Icon(Icons.work,
                                                size: 16, color: Colors.black),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${labour.experience} years experience",
                                              style: TextStyle(
                                                  fontSize: tertiary(),
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.star, color: AppColors.gold),
                                      const SizedBox(width: 4),
                                      Text(
                                        labour.rating.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: tertiary(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
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
