import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class ComplaintStatusScreen extends StatefulWidget {
  const ComplaintStatusScreen({Key? key}) : super(key: key);

  @override
  State<ComplaintStatusScreen> createState() => _ComplaintStatusScreenState();
}

class _ComplaintStatusScreenState extends State<ComplaintStatusScreen> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _complaints = [];

  @override
  void initState() {
    super.initState();
    _fetchComplaints();
  }

  Future<void> _fetchComplaints() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token') ?? '';
      if (!token.startsWith('Bearer ')) token = 'Bearer $token';

      final dio = Dio(BaseOptions(headers: {'Authorization': token}));
      final resp = await dio.get(
        'https://backend.jobizoindia.com/api/complaint',
        options: Options(validateStatus: (s) => s != null && s < 500),
      );

      if (resp.statusCode == 200 && resp.data['status'] == true) {
        // Cast into the right type...
        final List<Map<String, dynamic>> items =
        (resp.data['complaints'] as List<dynamic>)
            .cast<Map<String, dynamic>>();
        // THEN reverse them:
        _complaints = items.reversed.toList();
      } else {
        throw resp.data['message'] ??
            'Failed to load complaints (code ${resp.statusCode})';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() => _isLoading = false);
    }
  }


  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in progress':
      case 'open':
        return AppColors.gold;
      case 'resolved':
        return Colors.green;
      case 'cancel':
        return AppColors.brown;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Show loading or error states first
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: Commonappbar(title: 'Complaint Status'),
        body: const Center(child: CircularProgressIndicator(color: AppColors.green)),
      );
    }
    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: Commonappbar(title: 'Complaint Status'),
        body: Center(child: Text(_error!)),
      );
    }

    // Otherwise show the list
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: 'Complaint Status'),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _complaints.length,
        itemBuilder: (context, index) {
          final item = _complaints[index];
          final createdAt = DateTime.parse(item['created_at'] as String);
          final dateStr = DateFormat('MMM d, yyyy').format(createdAt);
          final idLabel = '#${item['ticket_number']}';
          final title = item['name'] as String? ?? '';
          final description = item['description'] as String? ?? '';
          final status = item['status'] as String? ?? '';

          return Container(
            width: screenWidth * 0.95,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.bgColor),
            ),
            child: Wrap(
              runSpacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: primary(),
                      ),
                    ),
                    Container(
                      padding:  EdgeInsets.symmetric(
                          horizontal: 25, vertical: 5),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        status,
                        style:  TextStyle(
                          color: Colors.white,
                          fontSize: tertiary(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      idLabel,
                      style: TextStyle(color: Colors.black, fontSize: tertiary()),
                    ),
                  ],
                ),
                Text(
                  description,
                  style:  TextStyle(fontSize: secondary()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateStr,
                      style:  TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500, fontSize:  tertiary()),
                    ),
                    if (status.toLowerCase() == 'open' ||
                        status.toLowerCase() == 'in progress')
                      ElevatedButton(
                        onPressed: () {
                          // Handle cancel logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brown,
                          padding:  EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          minimumSize: Size(screenWidth * 0.2, 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child:  Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: tertiary(),
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
