import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:jobizo/SnackBar/Snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../All_app_bars/normal_app_bar.dart';

class BeforeAcceptJob extends StatefulWidget {
  final int jobId;
  const BeforeAcceptJob({Key? key, required this.jobId}) : super(key: key);

  @override
  State<BeforeAcceptJob> createState() => _BeforeAcceptJobState();
}

class _BeforeAcceptJobState extends State<BeforeAcceptJob> {
  final Dio _dio = Dio();

  bool _isSubmitting = false;
  bool _isLoading = true;
  Map<String, dynamic>? _jobData;

  Future<void> _fetchJobDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      print(token);
      if (token == null) throw Exception('Token not found');
      debugPrint('📌 Job ID received: ${widget.jobId}');

      final response = await _dio.get(
        'https://backend.jobizoindia.com/api/labour-jobs-status/${widget.jobId}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print(response);
      setState(() {
        _jobData = response.data['data'];
        _isLoading = false;
      });
    } catch (e, stack) {
      debugPrint('❌ Error fetching job details: $e');
      debugPrint('📦 Stack: $stack');
      SnackbarHelper.showError(context, 'Failed to load job details');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _postStatus(String status) async {
    setState(() => _isSubmitting = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) throw Exception('Token not found');

      final response = await _dio.get(
        'https://backend.jobizoindia.com/api/labour-jobs-status/${widget.jobId}',
        data: {'labour_job_id': '${widget.jobId}', 'status': status},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final data = response.data;

      final success = data['status'] == true || data['status'] == 'accept';
      final message = data['message'] ?? 'Action completed';

      SnackbarHelper.showInfo(context, message);

      if (success) Navigator.pop(context, status);
    } catch (e) {
      SnackbarHelper.showError(context, 'Failed to $status: ${e.toString()}');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  String get _projectName => _jobData?['labour_request']?['project_name'] ?? '';
  String get _siteManager =>
      _jobData?['labour_request']?['site_manager_name'] ?? '';
  String get _siteManagerPhone =>
      _jobData?['labour_request']?['site_manager_phone'] ?? '';
  String get _location => _jobData?['location'] ?? '';
  String get _salary => _jobData?['salary'] ?? 'N/A';
  String get _duration => _jobData?['duration'] ?? '';
  List<String> get _facilitiesList =>
      (_jobData?['site_facilities'] as List?)?.cast<String>() ?? [];

  String _iconFor(String facility) {
    switch (facility.toLowerCase()) {
      case 'free parking':
        return 'Assets/Labour_image/parking.png';
      case 'rest rooms':
        return 'Assets/Labour_image/rest_room.png';
      case 'canteen':
        return 'Assets/Labour_image/canteen.png';
      case 'medical bay':
        return 'Assets/Labour_image/medical_boy.png';
      default:
        return 'Assets/Labour_image/rest_room.png';
    }
  }
  Future<void> _postStatusss(String status) async {
    setState(() => _isSubmitting = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) throw Exception('Token not found');

      final response = await _dio.post(
        'https://backend.jobizoindia.com/api/labour/project-status/${widget.jobId}',
        data: {'status': status},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final data = response.data;
      print(data);
      final success = data['status'] == true;
      final message = data['message'] ?? 'Action completed';

      SnackbarHelper.showInfo(context, message);
      if (success) Navigator.pop(context, status);
    } catch (e) {
      SnackbarHelper.showError(context, 'Failed to $status: ${e.toString()}');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchJobDetails();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.gold)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomBackAppBar(title: 'Work Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildCardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _projectName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: AppColors.green),
                      const SizedBox(width: 4),
                      Expanded(child: Text(_location)),
                    ],
                  ),
                ],
              ),
            ),
            buildCardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Work Area Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'Assets/Labour_image/map.png',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Row(
                  //   children: [
                  //     // Image.asset("Assets/Labour_image/zone.png"),
                  //     // const SizedBox(width: 9),
                  //     // // const Expanded(child: Text("Zone A")),
                  //     Text(
                  //       'INR $_salary/DAY',
                  //       style: TextStyle(
                  //
                  //         color: AppColors.green,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Image.asset("Assets/Labour_image/workers.png"),
                      const SizedBox(width: 9),
                      const Text('Current Workers: 45/60'),
                      const Spacer(),
                      Image.asset("Assets/Labour_image/month_alarm.png"),
                      const SizedBox(width: 9),
                      Text(_duration),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Image.asset("Assets/Labour_image/clock.png"),
                      const SizedBox(width: 9),
                      const Text('7:00 AM - 5:00 PM'),
                      Spacer(),
                      Text(
                        'INR $_salary/DAY',
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            buildCardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Site Facilities',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4D7C0F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _facilitiesList.isEmpty
                      ? const Text('No facilities available')
                      : Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: _facilitiesList.map((facility) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  _iconFor(facility),
                                  height: 20,
                                  width: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(facility),
                              ],
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
            buildCardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.person,
                          size: 16, color: AppColors.green),
                      const SizedBox(width: 4),
                      Text('Site Manager: $_siteManager'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 16, color: AppColors.green),
                      const SizedBox(width: 4),
                      Text(_siteManagerPhone),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _isSubmitting ? null : () => _postStatusss('rejected'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B1E03),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Reject',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _isSubmitting ? null : () => _postStatusss('accept'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Accept',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCardContainer({required Widget child}) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      );
}
