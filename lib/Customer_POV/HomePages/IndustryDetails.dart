import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Design contraints/FontSizes.dart';
import '../AppBar/commonAppBar.dart';

class Industrydetails extends StatefulWidget {
  const Industrydetails({super.key});

  @override
  State<Industrydetails> createState() => _IndustrydetailsState();
}

class _IndustrydetailsState extends State<Industrydetails> {
  bool _insuranceExpanded = false;
  bool _verifiedExpanded = false;

  List<Map<String, dynamic>> _recentWork = [];
  bool _loadingRecent = true;
  String? _recentError;

  @override
  void initState() {
    super.initState();
    _fetchRecentWork();
  }

  Future<void> _fetchRecentWork() async {
    setState(() {
      _loadingRecent = true;
      _recentError = null;
    });

    try {
      // Retrieve token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      // Configure Dio with auth header
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final resp = await dio.get(
        'https://backend.jobizoindia.com/api/work-gallery',
        options: Options(validateStatus: (s) => s != null && s < 500),
      );

      dynamic raw = resp.data;
      List<dynamic> list;

      if (raw is String) {
        // sometimes APIs return a JSON string
        raw = jsonDecode(raw);
      }

      if (raw is List) {
        list = raw;
      } else if (raw is Map<String, dynamic> && raw['data'] is List) {
        list = raw['data'] as List;
      } else {
        throw 'Unexpected response format';
      }

      setState(() {
        _recentWork = list
            .map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      setState(() {
        _recentError = e.toString();
        _recentWork = [];
      });
    } finally {
      setState(() {
        _loadingRecent = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: 'Industry Details'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: Stack(
                children: [
                  Image.asset(
                    'Assets/Customer_Images/IndustryDetails.png',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 16,
                    bottom: 48,
                    child: Row(
                      children: [
                        const Icon(Icons.construction,
                            color: Colors.white, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          'JOBIZO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: primary(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellowAccent, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '4.8 (2,456 reviews)',
                          style: TextStyle(
                              color: Colors.white, fontSize: tertiary()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // —— Overview section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Overview',
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: primary(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Professional construction services for residential and commercial projects. '
                    'Our skilled workers specialize in building, renovation, and infrastructure development.',
                    style: TextStyle(fontSize: tertiary(), height: 1.4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // —— Stats row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildStat('247', 'Workers'),
                  _buildStat('4.8', 'Avg Rating'),
                  _buildStat('1.2k', 'Jobs Done'),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // —— Skills & Specializations
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Skills & Specializations',
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: primary(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSkill(Icons.construction, 'Construction'),
                  _buildSkill(Icons.format_paint, 'Painting'),
                  _buildSkill(Icons.build, 'Plumbing'),
                  _buildSkill(Icons.flash_on, 'Electrical'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // —— Service Locations
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Text(
            //     'Service Locations',
            //     style: TextStyle(
            //       color: AppColors.green,
            //       fontSize: primary(),
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Service Locations',
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: primary(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      ClipRRect(
                        child: Image.asset(
                          'Assets/Labour_image/map.png',
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLocation('Mumbai'),
                                const SizedBox(height: 8),
                                _buildLocation('Bangalore'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLocation('Delhi'),
                                const SizedBox(height: 8),
                                _buildLocation('Punjab'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // —— Certifications
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Certifications',
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: primary(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: _buildCert(
                              Icons.verified, 'OSHA Certified', '142 workers')),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildCert(
                              Icons.handyman, 'Master Builder', '98 workers')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                          child: _buildCert(Icons.architecture_sharp,
                              'Blueprint Expert', '75 workers')),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildCert(Icons.local_shipping,
                              'Heavy Equipment', '89 workers')),
                    ],
                  ),
                ],
              ),
            ),

            // —— Top Rated Workers
            // SizedBox(height: 25),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Text(
            //     'Top Rated Workers',
            //     style: TextStyle(
            //       color: AppColors.green,
            //       fontSize: primary(),
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 16),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: _buildTopWorker(
            //           'Assets/Customer_Images/james_wilson.png',
            //           'James Wilson',
            //           '4.9',
            //           'Plumber',
            //         ),
            //       ),
            //       const SizedBox(width: 16),
            //       Expanded(
            //         child: _buildTopWorker(
            //           'Assets/Customer_Images/robert_chen.png',
            //           'Robert Chen',
            //           '4.8',
            //           'Painting',
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

// —— Recent Work
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Recent Work',
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: primary(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (_loadingRecent)
              const Center(child: CircularProgressIndicator())
            else if (_recentError != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Failed to load recent work: $_recentError',
                  style: TextStyle(color: Colors.red, fontSize: tertiary()),
                ),
              )
            else if (_recentWork.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'No recent work found.',
                  style: TextStyle(fontSize: tertiary()),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _recentWork.map((item) {
                    final img = item['image'] as String?;
                    final imgPath = img != null
                        ? 'https://backend.jobizoindia.com/storage/$img'
                        : 'Assets/Customer_Images/villa.png';
                    final title = item['title'] as String? ?? 'Untitled';
                    final date =
                        item['complition_date'] as String? ?? 'Date N/A';

                    return buildRecentWork(imgPath, title, date);
                  }).toList(),
                ),
              ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Text(
            //     'Work Gallery',
            //     style: TextStyle(
            //       color: AppColors.green,
            //       fontSize: primary(),
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 16),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: GridView.count(
            //     crossAxisCount: 2,
            //     mainAxisSpacing: 12,
            //     crossAxisSpacing: 12,
            //     shrinkWrap: true,
            //     physics: NeverScrollableScrollPhysics(),
            //     children: [
            //       'Assets/Customer_Images/villa.png',
            //       'Assets/Customer_Images/villa.png',
            //       'Assets/Customer_Images/villa.png',
            //       'Assets/Customer_Images/villa.png',
            //     ].map((path) => ClipRRect(
            //       borderRadius: BorderRadius.circular(12),
            //       child: Image.asset(path, fit: BoxFit.cover),
            //     )).toList(),
            //   ),
            // ),

            const SizedBox(height: 24),

// — FAQ Section —
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'FAQ',
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: primary(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Q1
                  _buildFaqItem(
                    question: 'What insurance do workers carry?',
                    answer:
                        'Workers carry comprehensive liability and workers\' compensation insurance, covering both property damage and personal injury on-site.',
                    expanded: _insuranceExpanded,
                    onTap: () => setState(
                        () => _insuranceExpanded = !_insuranceExpanded),
                  ),
                  const SizedBox(height: 8),
                  // Q2
                  _buildFaqItem(
                    question: 'How are workers verified?',
                    answer:
                        'Workers undergo background checks, license verification, and skills assessment before joining our platform.',
                    expanded: _verifiedExpanded,
                    onTap: () =>
                        setState(() => _verifiedExpanded = !_verifiedExpanded),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Widget _buildTopWorker(
  //     String imgPath,
  //     String name,
  //     String rating,
  //     String role,
  //     ) {
  //   return  Card(
  //         color: Colors.white,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         elevation: 1,
  //         child: Padding(
  //           padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               // Avatar
  //               CircleAvatar(
  //                 radius: 40,
  //                 backgroundImage: AssetImage(imgPath),
  //               ),
  //               SizedBox(height: 12),
  //               // Name
  //               Text(
  //                 name,
  //                 style: TextStyle(
  //                   fontSize: tertiary(),
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               SizedBox(height: 8),
  //
  //               // Rating
  //               Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Icon(Icons.star, size: 16, color:AppColors.gold,),
  //                   SizedBox(width: 4),
  //                   Text(
  //                     rating,
  //                     style: TextStyle(fontSize: tertiary()),
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(height: 8),
  //
  //               // Role
  //               Text(
  //                 role,
  //                 style: TextStyle(fontSize: tertiary()),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  // }

  Widget _buildFaqItem({
    required String question,
    required String answer,
    required bool expanded,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              question,
              style: TextStyle(
                fontSize: tertiary(),
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Icon(
              expanded ? Icons.cancel_outlined : Icons.add,
              color: AppColors.green,
            ),
            onTap: onTap,
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: tertiary(),
                  height: 1.4,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildRecentWork(String imgPath, String title, String subtitle) {
    final imageProvider = imgPath.startsWith('http')
        ? NetworkImage(imgPath)
        : AssetImage(imgPath) as ImageProvider;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
            image: imageProvider,
            width: double.infinity,
            height: 100,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: tertiary(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: tertiary()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: primary(),
                fontWeight: FontWeight.bold,
                color: AppColors.green,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: tertiary()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkill(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Icon(icon, size: 28, color: AppColors.green),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: tertiary()),
        ),
      ],
    );
  }

  Widget _buildLocation(String city) {
    return Row(
      children: [
        Icon(Icons.location_on, color: AppColors.green, size: 20),
        const SizedBox(width: 6),
        Text(
          city,
          style: TextStyle(fontSize: tertiary()),
        ),
      ],
    );
  }

  Widget _buildCert(IconData icon, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 25, color: AppColors.green),
              SizedBox(width: 8),
              SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: tertiary(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: tertiary()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
