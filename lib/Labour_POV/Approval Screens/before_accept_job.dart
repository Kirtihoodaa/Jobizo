import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:jobizo/SnackBar/Snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../All_app_bars/normal_app_bar.dart';

class BeforeAcceptJob extends StatefulWidget {
  final Map<String, dynamic> jobData;
  const BeforeAcceptJob({Key? key, required this.jobData}) : super(key: key);

  @override
  State<BeforeAcceptJob> createState() => _BeforeAcceptJobState();
}

class _BeforeAcceptJobState extends State<BeforeAcceptJob> {
  final Dio _dio = Dio();
  bool _isSubmitting = false;
  String? _jobStatus;

  int get _jobId => widget.jobData['id'] as int;
  String get _title => widget.jobData['job_title'] ?? '';
  String get _location => widget.jobData['job_location'] ?? '';
  String get _salary => widget.jobData['job_salary'] ?? '';
  String get _duration => widget.jobData['job_duration'] ?? '';
  String get _facilities => widget.jobData['site_facilities'] ?? '';

  List<String> get _facilitiesList => _facilities.isNotEmpty
      ? _facilities.split(',').map((e) => e.trim()).toList()
      : [];

  Map<String, dynamic> get _req =>
      (widget.jobData['labour_request'] as Map<String, dynamic>?) ?? {};
  String get _siteManager => _req['site_manager_name'] ?? '';
  String get _startDate => _req['start_date'] ?? '';
  String get _projectname => _req['project_name'] ?? 'N/A';

  Future<void> _postStatus(String status) async {
    setState(() => _isSubmitting = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('⚠️ Authentication token is missing!');
      }

      final response = await _dio.post(
        'https://backend.jobizoindia.com/api/upcoming-assignment/$_jobId/status',
        data: {
          'labour_job_id': '$_jobId',
          'status': status,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          followRedirects: false,
          validateStatus: (statusCode) =>
              statusCode != null && statusCode < 500,
        ),
      );

      final data = response.data;

      debugPrint('✅ API Response: $data');

      if (data is! Map<String, dynamic>) {
        throw Exception('⚠️ Unexpected response format from server.');
      }

      final success = (data['status'] == true ||
          data['status'].toString().toLowerCase() == 'accept');
      final message = data['message'] ?? (success ? 'Success' : 'Failed');

      setState(() {
        _jobStatus = data['status']?.toString();
      });

      SnackbarHelper.showInfo(context, 'message');

      if (success) Navigator.pop(context, status);
    } catch (e, stackTrace) {
      debugPrint('⚠️ Error posting status: $e');
      debugPrint('$stackTrace');
      SnackbarHelper.showError(context, 'Failed to $status: ${e.toString()}');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  String _iconFor(String facility) {
    switch (facility.toLowerCase()) {
      case 'Free Parking':
        return 'Assets/Labour_image/parking.png';
      case 'rest Rooms':
        return 'Assets/Labour_image/rest_room.png';
      case 'Canteen':
        return 'Assets/Labour_image/canteen.png';
      case 'Medical Bay':
        return 'Assets/Labour_image/medical_boy.png';
      default:
        return 'Assets/Labour_image/rest_room.png';
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    _projectname,
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
                      Flexible(child: Text(_location)),
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
                  Row(
                    children: [
                      Image.asset("Assets/Labour_image/zone.png"),
                      const SizedBox(width: 9),
                      Expanded(child: Text(_title)),
                      Text(
                        'INR $_salary/DAY',
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
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
                      ? const Text(' No facilities available')
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
                  Text(
                    'Contact Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: AppColors.green),
                      SizedBox(width: 4),
                      Text('Site Manager: $_siteManager'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 16, color: AppColors.green),
                      SizedBox(width: 4),
                      const Text('+91 7788990089'),
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
                        _isSubmitting ? null : () => _postStatus('rejected'),
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
                        _isSubmitting ? null : () => _postStatus('accept'),
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
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: child);
}
