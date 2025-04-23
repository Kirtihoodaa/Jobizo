import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import '../../Design contraints/FontSizes.dart';
import '../AppBar/commonAppBar.dart';

class Labourlocalities extends StatefulWidget {
  const Labourlocalities({super.key});

  @override
  State<Labourlocalities> createState() => _LabourlocalitiesState();
}

class _LabourlocalitiesState extends State<Labourlocalities> {
  // categories for the chip list
  final List<String> _categories = [
    'All',
    'Construction',
    'Painting',
    'Plumbing',
    'Electrical',
    'Carpentry',
  ];
  int _selectedCategory = 0;

  // sample workers
  final List<Map<String, dynamic>> _workers = [
    {
      'name': 'Michael Thompson',
      'avatar': 'Assets/Customer_Images/michael.png',
      'rating': 4.8,
      'role': 'Construction Expert',
      'address': '123 Main St, Mumbai, India',
      'status': 'Available Now',
      'statusColor': Colors.lightGreen,
    },
    {
      'name': 'Sarah Martinez',
      'avatar': 'Assets/Customer_Images/sarah.png',
      'rating': 4.9,
      'role': 'Professional Painter',
      'address': '456 Market St, Mumbai, India',
      'status': 'Busy Today',
      'statusColor': AppColors.brown
    },
    {
      'name': 'David Wilson',
      'avatar': 'Assets/Customer_Images/david.png',
      'rating': 4.8,
      'role': 'Construction Expert',
      'address': '789 Broadway, Mumbai, India',
      'status': 'Available Now',
      'statusColor': Colors.lightGreen,
    },
    // add more entries...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: 'Labour Localities'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.green),
                     SizedBox(width: 8),
                    Text(
                      'Mumbai',
                      style: TextStyle(fontSize: tertiary()),
                    ),
                  ],
                ),
              ),
            ),

             SizedBox(height: 16),

            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final bool selected = index == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.gold : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: selected ? Colors.transparent : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        _categories[index],
                        style: TextStyle(
                          fontSize: tertiary(),
                          color: selected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // — Worker Cards —
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: _workers.map((w) => _buildWorkerCard(w)).toList(),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerCard(Map<String, dynamic> w) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // avatar
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: AssetImage(w['avatar']),
            ),

            const SizedBox(width: 12),

            // details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // name & rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        w['name'],
                        style: TextStyle(
                          fontSize: secondary(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: AppColors.gold),
                          const SizedBox(width: 4),
                          Text(
                            w['rating'].toStringAsFixed(1),
                            style: TextStyle(fontSize: tertiary()),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // role
                  Text(
                    w['role'],
                    style: TextStyle(
                      fontSize: tertiary(),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // address
                  Text(
                    w['address'],
                    style: TextStyle(fontSize: tertiary() - 1),
                  ),

                  const SizedBox(height: 8),

                  // status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: w['statusColor'],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      w['status'],
                      style: TextStyle(
                        fontSize: tertiary() - 1,
                        color: Colors.white,
                      ),
                    ),
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
