import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get/get_navigation/src/routes/transitions_type.dart' show Transition;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:jobizo/splash/splash_screen2.dart';


import '../Design contraints/gradients.dart';

class JobizoInfoSection extends StatefulWidget {


  const JobizoInfoSection({Key? key}) : super(key: key);

  @override
  State<JobizoInfoSection> createState() => _JobizoInfoSectionState();
}

class _JobizoInfoSectionState extends State<JobizoInfoSection> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchOverview();
  }

  Future<void> _fetchOverview() async {
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
        'https://backend.jobizoindia.com/api/overview',
        options: Options(validateStatus: (_) => true),
      );

      if (resp.statusCode == null || resp.statusCode! < 200 || resp.statusCode! >= 300) {
        throw 'Server returned status ${resp.statusCode}';
      }

      dynamic raw = resp.data;
      if (raw is String) raw = jsonDecode(raw);
      if (raw is! Map<String, dynamic> || raw['status'] != true) {
        throw 'Unexpected response format';
      }

      setState(() {
        _data = raw as Map<String, dynamic>;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }


  List<Widget> _buildStars(double rating, {double size = 20}) {
    final clamped = rating.isNaN ? 0.0 : rating.clamp(0.0, 5.0);
    final halfRounded = (clamped * 2).round() / 2.0; // nearest 0.5
    final full = halfRounded.floor();
    final hasHalf = (halfRounded - full) == 0.5;
    final empty = 5 - full - (hasHalf ? 1 : 0);

    final stars = <Widget>[];
    for (int i = 0; i < full; i++) {
      stars.add(Icon(Icons.star, color: Colors.amber, size: size));
    }
    if (hasHalf) {
      stars.add(Icon(Icons.star_half, color: Colors.amber, size: size));
    }
    for (int i = 0; i < empty; i++) {
      stars.add(Icon(Icons.star_border, color: Colors.amber, size: size));
    }
    return stars;
  }


  @override
  Widget build(BuildContext context) {
    final data = _data ?? {};

    final int totalLabours = (data['total_labours'] ?? 0) as int;
    final int totalLocations = (data['total_locations'] ?? 0) as int;
    final int totalProjects = (data['total_projects'] ?? 0) as int;
    final double rating = (data['rating_out_of_5'] is num) ? (data['rating_out_of_5'] as num).toDouble() : 0.0;
    final int satisfaction = (data['satisfaction_percentage'] ?? 0) as int;
    final int totalFeedbacks = (data['total_feedbacks'] ?? 0) as int;
    final String feedbackSummary = (data['feedback_summary'] ?? 'Excellent service and professional workers').toString();

    final List services = (data['services'] is List) ? (data['services'] as List) : const [];
    final List locations = (data['locations'] is List) ? (data['locations'] as List) : const [];
    final String locationsLine = locations.map((e) => (e is Map && e['work_address'] != null) ? e['work_address'].toString() : '')
        .where((s) => s.isNotEmpty)
        .join(' • ');

    return Scaffold(
      backgroundColor: Colors.white,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_error != null)
          ? _ErrorState(message: _error!, onRetry: _fetchOverview)
          : SingleChildScrollView(

        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'Assets/jobizo/jobizoLogo.png',
                height: 70,
              ),
            ),
            const SizedBox(height: 13),

            /// 1. Labourers Registered
            Card(
              color: Colors.white,
              elevation: 1.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Labourers Registered',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                          fontSize: secondary(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Image.asset('Assets/jobizo/onboard3.png', height: 120),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CountupNumber(
                          end: totalLabours,
                          duration: const Duration(milliseconds: 500),
                          style: TextStyle(
                            fontSize: tertiary(),
                            color: AppColors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          ' verified workers',
                          style: TextStyle(
                            fontSize: tertiary(),
                            color: AppColors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// 2. Locations
            Card(
              color: Colors.white,
              elevation: 1.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Locations Where Jobizo Works',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                          fontSize: secondary(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Image.asset('Assets/Labour_image/map.png', height: 120, width: double.infinity),
                    const SizedBox(height: 12),
                    CountupNumber(
                      end: totalLocations,
                      duration: const Duration(milliseconds: 500),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),

                    const Text('Cities Covered', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(
                      locationsLine.isEmpty ? '—' : locationsLine,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// 3. Our Services
            Card(
              color: Colors.white,
              elevation: 1.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Our Services',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: secondary(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                      children: services.isEmpty
                          ? [
                        _buildServiceTile(Icons.miscellaneous_services, 'No data'),
                      ]
                          : services.map<Widget>((s) {
                        final String name = (s is Map && s['name'] != null) ? s['name'].toString() : 'Service';
                        return _buildServiceTile(_iconFor(name), _capitalize(name));
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// 4. Jobs Completed + Testimonial
            Card(
              color: Colors.white,
              elevation: 1.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CountupNumber(
                          end: totalProjects,
                          duration: const Duration(milliseconds: 600),
                          style: TextStyle(
                            fontSize: 28,
                            color: AppColors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '+',
                          style: TextStyle(
                            fontSize: 28,
                            color: AppColors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),
                    Text(
                      'Jobs Successfully Completed',
                      style: TextStyle(fontSize: tertiary(), fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(color: AppColors.grey, borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.format_quote, color: AppColors.gold),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  feedbackSummary,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  totalFeedbacks > 0 ? '— Based on $totalFeedbacks feedbacks' : '—',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// 5. Customer Satisfaction
            Card(
              color: Colors.white,
              elevation: 1.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildStars(rating),
                    ),
                    const SizedBox(height: 8),

                    CountupNumber(
                      end: satisfaction,
                      duration: const Duration(milliseconds: 500),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.green,
                      ),
                      suffix: '%',
                    ),

                    const SizedBox(height: 4),
                    Text(
                      feedbackSummary,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// 6. Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const SplashScreen2(),
                      transition: Transition.cupertino, duration: const Duration(milliseconds: 400));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    )
    );
  }

  /// Grey container tile for each service
  Widget _buildServiceTile(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(color: AppColors.grey, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: AppColors.gold),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  IconData _iconFor(String name) {
    switch (name.toLowerCase().trim()) {
      case 'plumber':
        return Icons.plumbing;
      case 'electrician':
        return Icons.flash_on;
      case 'painter':
        return Icons.format_paint;
      case 'construction':
        return Icons.construction;
      case 'carpenter':
        return Icons.handyman;
      case 'labour':
      case 'labourer':
        return Icons.people;
      default:
        return Icons.miscellaneous_services;
    }
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(color: Colors.redAccent),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}




class CountupNumber extends StatelessWidget {
  final int end;
  final int start;
  final Duration duration;
  final Curve curve;
  final TextStyle? style;
  final String prefix;
  final String suffix;

  const CountupNumber({
    super.key,
    required this.end,
    this.start = 0,
    this.duration = const Duration(milliseconds: 600), // fast
    this.curve = Curves.easeOut,
    this.style,
    this.prefix = '',
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    final safeEnd = end < 0 ? 0 : end;
    return TweenAnimationBuilder<int>(
      key: ValueKey(safeEnd), // restart animation when target changes
      tween: IntTween(begin: start, end: safeEnd),
      duration: duration,
      curve: curve,
      builder: (_, value, __) => Text('$prefix$value$suffix', style: style),
    );
  }
}

/// Optional: for decimals like rating (e.g., 3.8 → 1 decimal place)
class CountupDouble extends StatelessWidget {
  final double end;
  final double start;
  final int fractionDigits;
  final Duration duration;
  final Curve curve;
  final TextStyle? style;
  final String prefix;
  final String suffix;

  const CountupDouble({
    super.key,
    required this.end,
    this.start = 0,
    this.fractionDigits = 1,
    this.duration = const Duration(milliseconds: 2000),
    this.curve = Curves.easeOut,
    this.style,
    this.prefix = '',
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    final safeEnd = end.isNaN ? 0.0 : (end < 0 ? 0.0 : end);
    return TweenAnimationBuilder<double>(
      key: ValueKey(safeEnd),
      tween: Tween<double>(begin: start, end: safeEnd),
      duration: duration,
      curve: curve,
      builder: (_, value, __) =>
          Text('$prefix${value.toStringAsFixed(fractionDigits)}$suffix', style: style),
    );
  }
}
