// labour_list_screen.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

import '../LabourProfile.dart';

class LabourListScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const LabourListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<LabourListScreen> createState() => _LabourListScreenState();
}

class _LabourListScreenState extends State<LabourListScreen> {
  bool _loading = true;
  String? _error;
  int _total = 0;
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

      final resp = await Dio(BaseOptions(headers: {'Authorization': token}))
          .get(
        'https://backend.jobizoindia.com/api/labour-category/${widget.categoryId}',
        options: Options(validateStatus: (s) => s != null && s < 500),
      );

      final body = resp.data as Map<String, dynamic>;
      if (resp.statusCode == 200 && body['status'] == true) {
        // total_labours comes from top level
        _total = body['total_labours'] as int;

        // data.labour array
        final labourArray = (body['data']['labour'] as List<dynamic>);
        _labours = labourArray
            .map((e) => LabourItem.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw body['message'] ?? 'Failed to load';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: Commonappbar(title: '${widget.categoryName} Labours'),
        body: const Center(child: CircularProgressIndicator(color:  AppColors.gold,)),
      );
    }
    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: Commonappbar(title: '${widget.categoryName} Labours'),
        body: Center(child: Text(_error!)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: '${widget.categoryName} Labours'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TotalLaboursCard(total: _total),
            const SizedBox(height: 30),
            Row(
              children: [
                Text(
                  "All Labours",
                  style: TextStyle(
                    color: AppColors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: secondary(),
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
                      Text("Sort by Schedule"),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _labours.isEmpty
                  ? Center(
                child: Text(
                  "No labours found in ${widget.categoryName}.",
                  style: TextStyle(fontSize: secondary()),
                ),
              )
                  : ListView.builder(
                itemCount: _labours.length,
                itemBuilder: (context, i) {
                  final labour = _labours[i];
                  return InkWell(
                    onTap: () {
                      Get.to(
                            () => LabourProfilePage(
                          labourId: labour.id,
                        ),
                        transition: Transition.cupertino,
                        duration: const Duration(milliseconds: 300),
                      );
                    },

                    child: Container(
                      width: double.infinity,
                      height: 140,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: labour
                                  .profilePictureUrl !=
                                  null
                                  ? NetworkImage(
                                  labour.profilePictureUrl!)
                                  : (labour.user.image != null
                                  ? NetworkImage(labour.user.image!)
                                  : const AssetImage(
                                  "Assets/Labour_image/labour_profile.png")
                              as ImageProvider),
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
                                    labour.user.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: secondary(),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.work,
                                        size: 16,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${labour.user.experience} yrs",
                                        style: TextStyle(
                                          fontSize: tertiary(),
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Skills: ${labour.user.skills}",
                                    style: TextStyle(fontSize: tertiary()),
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
  final int id;
  final String workSchedule;
  final String startingDate;
  final String emergencyPhone;
  final String preferredLocation;
  final String salaryType;
  final String workingStatus;
  final String? profilePictureUrl;
  final LabourUser user;

  LabourItem({
    required this.id,
    required this.workSchedule,
    required this.startingDate,
    required this.emergencyPhone,
    required this.preferredLocation,
    required this.salaryType,
    required this.workingStatus,
    required this.profilePictureUrl,
    required this.user,
  });

  factory LabourItem.fromJson(Map<String, dynamic> json) {
    return LabourItem(
      id: json['id'] as int,
      workSchedule: json['work_schedule'] as String? ?? '',
      startingDate: json['starting_date'] as String? ?? '',
      emergencyPhone: json['emergency_phone'] as String? ?? '',
      preferredLocation:
      json['preferred_work_location'] as String? ?? '',
      salaryType: json['salary_type'] as String? ?? '',
      workingStatus: json['working_status'] as String? ?? '',
      profilePictureUrl: json['profile_picture'] as String?,
      user: LabourUser.fromJson(
        json['user'] as Map<String, dynamic>,
      ),
    );
  }
}

class LabourUser {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final int experience;
  final String skills;
  final String? image;

  LabourUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.experience,
    required this.skills,
    required this.image,
  });

  factory LabourUser.fromJson(Map<String, dynamic> json) {
    return LabourUser(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      experience: (json['experience'] as int?) ?? 0,
      skills: json['skills'] as String? ?? 'none',
      image: json['image'] as String?,
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
            "- $total -",
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
