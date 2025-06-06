import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

import '../LabourProfile.dart';

class LabourListScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const LabourListScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<LabourListScreen> createState() => _LabourListScreenState();
}

class _LabourListScreenState extends State<LabourListScreen> {
  bool _loading = true;
  String? _error;
  int _totalLabours = 0;
  List<LabourItem> _labours = [];

  @override
  void initState() {
    super.initState();
    _fetchLabours();
  }

  Future<void> _fetchLabours() async {
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
        'https://backend.jobizoindia.com/api/get-labour-category/${widget.categoryId}',
        options: Options(validateStatus: (status) => status != null && status < 500),
      );

      final data = resp.data as Map<String, dynamic>;
      if (resp.statusCode == 200 && data['status'] == true) {
        _totalLabours = data['total_labours'] ?? 0;
        final labourArray = (data['labours'] as List<dynamic>);
        _labours = labourArray
            .map((e) => LabourItem.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw data['message'] ?? 'Failed to load labours';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  String _capitalize(String? input) {
    if (input == null || input.isEmpty) return '';
    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: '${widget.categoryName} Labours'),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _error != null
          ? Center(child: Text(_error!))
          : _labours.isEmpty
          ? Center(
        child: Text(
          "No labours found in ${widget.categoryName}.",
          style: TextStyle(fontSize: secondary()),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TotalLaboursCard(total: _totalLabours),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _labours.length,
                itemBuilder: (context, index) {
                  final labour = _labours[index];

                  // Decide whether to show a NetworkImage or local placeholder
                  ImageProvider avatarImage;
                  if (labour.profilePicture != null &&
                      labour.profilePicture!.isNotEmpty) {
                    // Prepend the base URL to your relative path
                    avatarImage = NetworkImage(
                      'https://backend.jobizoindia.com/storage/${labour.profilePicture!}',
                    );
                  } else {
                    avatarImage = const AssetImage(
                        "Assets/Labour_image/labour_profile.png")
                    as ImageProvider;
                  }

                  return InkWell(
                    onTap: () {
                      Get.to(
                            () => LabourProfilePage(
                          labourId: labour.labourId,
                        ),
                        transition: Transition.cupertino,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      margin:
                      const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: avatarImage,
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
                                    labour.labourName.isNotEmpty
                                        ? _capitalize(
                                        labour.labourName)
                                        : '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: secondary(),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Job Title: ${_capitalize(labour.jobTitle)}",
                                    style: TextStyle(
                                      fontSize: tertiary(),
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Experience: ${labour.experience}",
                                    style: TextStyle(
                                      fontSize: tertiary(),
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Status: ${_capitalize(labour.status)}",
                                    style: TextStyle(
                                      fontSize: tertiary(),
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
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

class LabourItem {
  final int labourId;
  final String labourName;
  final String jobTitle;
  final String status;
  final String experience;
  final String? profilePicture;

  LabourItem({
    required this.labourId,
    required this.labourName,
    required this.jobTitle,
    required this.status,
    required this.experience,
    required this.profilePicture,
  });

  factory LabourItem.fromJson(Map<String, dynamic> json) {
    return LabourItem(
      labourId: json['labour_id'] as int,
      labourName: json['labour_name'] as String? ?? '',
      jobTitle: json['job_title'] as String? ?? '',
      status: json['status'] as String? ?? '',
      experience: json['experience'] as String? ?? 'N/A',
      profilePicture: json['profile_picture'] as String?,
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
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "- $total - ",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
