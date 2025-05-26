import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class Requiredlabour extends StatefulWidget {
  const Requiredlabour({Key? key}) : super(key: key);

  @override
  State<Requiredlabour> createState() => _RequiredlabourState();
}

class _RequiredlabourState extends State<Requiredlabour> {
  bool _loading = true;
  String? _error;
  int _totalLabours = 0;
  List<Map<String, dynamic>> _labourCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchRequiredLabour();
  }

  Future<void> _fetchRequiredLabour() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final resp = await dio.get(
        'https://backend.jobizoindia.com/api/labour-category',
        options: Options(validateStatus: (_) => true),
      );

      if (resp.statusCode == null ||
          resp.statusCode! < 200 ||
          resp.statusCode! >= 300) {
        throw 'Server returned status ${resp.statusCode}';
      }

      dynamic raw = resp.data;
      if (raw is String) raw = jsonDecode(raw);

      if (raw is! Map<String, dynamic> || raw['status'] != true) {
        throw 'Unexpected response format';
      }

      final data = raw['data'] as List<dynamic>;
      final total = raw['total_labours'] as int? ?? 0;

      final List<Map<String, dynamic>> list = data.map((e) {
        final m = e as Map<String, dynamic>;
        final name = (m['name'] as String? ?? '').replaceFirst(
            (m['name'] as String)[0], (m['name'] as String)[0].toUpperCase());
        final available = m['labour_count'] as int? ?? 0;
        return {
          'category': name,
          'available': available,
          'required': available, // adjust if you have a real "required" field
        };
      }).toList();

      setState(() {
        _totalLabours = total;
        _labourCategories = list;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: const Commonappbar(title: "Required Workers"),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color:AppColors.green ,))
          : _error != null
          ? Center(child: Text(_error!))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _TotalLaboursCard(total: _totalLabours),
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
            ..._labourCategories.map(
                  (item) => _CategoryItem(
                title: item['category'] as String,
                available: item['available'] as int,
                required: item['required'] as int,
                onTap: () {
                  // // navigate to details if needed
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => DetailsLabour(
                  //       categoryId: item['category'] as String,
                  //     ),
                  //   ),
                  // );
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
  const _TotalLaboursCard({Key? key, required this.total}) : super(key: key);

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
            "Total Required Labours",
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
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
  final int available;
  final int required;
  final VoidCallback onTap;

  const _CategoryItem({
    Key? key,
    required this.title,
    required this.available,
    required this.required,
    required this.onTap,
  }) : super(key: key);

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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }
}
