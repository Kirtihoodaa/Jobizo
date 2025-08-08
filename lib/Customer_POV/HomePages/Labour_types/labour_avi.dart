import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Customer_POV/HomePages/Labour_types/Details_labour.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class AllLaboursScreen extends StatefulWidget {
  const AllLaboursScreen({super.key});

  @override
  State<AllLaboursScreen> createState() => _AllLaboursScreenState();
}

class _AllLaboursScreenState extends State<AllLaboursScreen> {
  bool _loading = true;
  String? _error;
  int _totalLabours = 0;
  List<LabourCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token') ?? '';
      if (!token.startsWith('Bearer ')) token = 'Bearer $token';

      final dio = Dio(BaseOptions(headers: {'Authorization': token}));
      final resp = await dio.get(
        'https://backend.jobizoindia.com/api/labour-category',
        options: Options(validateStatus: (s) => s != null && s < 500),
      );

      final body = resp.data as Map<String, dynamic>;
      if (resp.statusCode == 200 && body['status'] == true) {
        final data = body['data'] as List<dynamic>;
        setState(() {
          _totalLabours = body['total_labours'] as int;
          _categories = data.map((e) {
            final raw = e['category_name'] as String;
            return LabourCategory(
              id: e['category_id'] as int,
              name: raw.isNotEmpty
                  ? raw[0].toUpperCase() + raw.substring(1)
                  : '',
              count: e['count'] as int,
            );
          }).toList();
    });
      } else {
        throw body['message'] ?? 'Failed to load';
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: Commonappbar(title: 'All Labours'),
        body: const Center(child: CircularProgressIndicator(color: AppColors.gold,)),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: Commonappbar(title: 'All Labours'),
        body: Center(child: Text(_error!)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: "All Labours"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _TotalLaboursCard(total: _totalLabours),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Labour Category",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: secondary(),
                  color: AppColors.green,
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (var cat in _categories)
              _CategoryItem(
                title: cat.name,
                count: cat.count,
                onTap: () {
                  Get.to(
                        () => LabourListScreen(
                      categoryId: cat.id,
                      categoryName: cat.name,
                    ),
                    transition: Transition.cupertino,
                    duration: const Duration(milliseconds: 400),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class LabourCategory {
  final int id;
  final String name;
  final int count;
  LabourCategory({
    required this.id,
    required this.name,
    required this.count,
  });
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
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "- $total -",
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
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "$title ($count)",
              style: TextStyle(
                fontSize: tertiary(),
                fontWeight: FontWeight.bold,
                color: AppColors.green,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "View All",
                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple extension to capitalize the first letter
extension on String {
  String capitalize() =>
      length > 0 ? substring(0, 1).toUpperCase() + substring(1) : this;
}
