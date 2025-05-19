import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Design contraints/app color.dart';
import '../../Design contraints/FontSizes.dart';
import '../../SnackBar/Snackbar.dart';
import '../AppBar/commonAppBar.dart';
import 'AddCompanyDetails.dart';

// Simple model for your company details
class CompanyDetail {
  final Map<String, dynamic> raw;
  final String companyName;
  final String registrationNumber;
  final String yearOfEstablishment;
  final String companyType;
  final String gstNumber;
  final String? gstCertificate;
  final String streetAddress;
  final String city;
  final String state;
  final String country;
  final String pinCode;
  final String directorName;
  final String dinNumber;
  final String directorEmail;
  final String? idProof;
  final String projectCategories;
  final String? companyRegistrationDoc;
  final String? panCard;
  final String? otherDocuments;

  CompanyDetail.fromJson(Map<String, dynamic> json)
      : raw = json,
        companyName            = json['company_name'] as String? ?? '—',
        registrationNumber     = json['registration_number'] as String? ?? '—',
        yearOfEstablishment    = json['year_of_establishment'] as String? ?? '—',
        companyType            = json['company_type'] as String? ?? '—',
        gstNumber              = json['gst_number'] as String? ?? '—',
        gstCertificate         = json['gst_certificate'] as String?,
        streetAddress          = json['street_address'] as String? ?? '—',
        city                   = json['city'] as String? ?? '—',
        state                  = json['state'] as String? ?? '—',
        country                = json['country'] as String? ?? '—',
        pinCode                = json['pin_code'] as String? ?? '—',
        directorName           = json['director_name'] as String? ?? '—',
        dinNumber              = json['din_number'] as String? ?? '—',
        directorEmail          = json['email'] as String? ?? '—',
        idProof                = json['id_proof'] as String?,
        projectCategories      = json['project_categories'] as String? ?? '—',
        companyRegistrationDoc = json['company_registration_doc'] as String?,
        panCard                = json['pan_card'] as String?,
        otherDocuments         = json['other_documents'] as String?;

  /// If you ever need to display the raw JSON value:
  String rawValue(String key) {
    if (!raw.containsKey(key)) return '—';
    final v = raw[key];
    return v == null ? 'null' : v.toString();
  }
}

class Companydetails extends StatefulWidget {
  const Companydetails({Key? key}) : super(key: key);

  @override
  State<Companydetails> createState() => _CompanydetailsState();
}

class _CompanydetailsState extends State<Companydetails> {
  bool _loading = true;
  String _error = '';
  CompanyDetail? _detail;

  @override
  void initState() {
    super.initState();
    _fetchCompanyDetails();
  }

  Future<void> _fetchCompanyDetails() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token') ?? '';
      if (token.isEmpty) throw 'Not authenticated';
      if (!token.startsWith('Bearer ')) token = 'Bearer $token';

      final dio = Dio(BaseOptions(headers: {'Authorization': token}));
      final resp = await dio.get(
        'https://backend.jobizoindia.com/api/company-details',
        options: Options(validateStatus: (s) => s != null && s < 500),
      );

      final body = resp.data as Map<String, dynamic>;
      if (resp.statusCode == 200 && body['status'] == true) {
        final list = (body['data'] as List<dynamic>);
        if (list.isEmpty) throw 'No company record found';
        _detail = CompanyDetail.fromJson(list.first as Map<String, dynamic>);
      } else {
        throw body['message'] ?? 'Failed to load';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: Commonappbar(title: 'Company Details'),
        body: const Center(child: CircularProgressIndicator(color: AppColors.gold,)),
      );
    }

    if (_error.isNotEmpty || _detail == null) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: Commonappbar(title: 'Company Details'),
        body: Center(child: Text(_error.isEmpty ? 'No data' : _error)),
      );
    }

    final d = _detail!;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: 'Company Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Information
            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Company Information'),
                  _infoRow('Company Name', d.companyName),
                  const SizedBox(height: 8),
                  _infoRow('Registration Number', d.registrationNumber),
                  const SizedBox(height: 8),
                  _infoRow('Year of Establishment', d.yearOfEstablishment),
                  const SizedBox(height: 8),
                  _infoRow('Company Type', d.companyType),
                ],
              ),
            ),

            // GST Information
            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('GST Information'),
                  _infoRow('GST Number', d.gstNumber),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      if (d.gstCertificate == null) {
                        SnackbarHelper.showWarning(
                          context,
                          'Please upload GST Certificate.',
                        );
                      } else {
                        // TODO: open d.gstCertificate URL or file
                      }
                    },
                    icon: const Icon(Icons.picture_as_pdf, color: AppColors.green),
                    label: Text(
                      'View GST Certificate',
                      style: TextStyle(fontSize: secondary(), color: AppColors.green),
                    ),
                  ),
                ],
              ),
            ),

            // Address Information
            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Address Information'),
                  _infoRow('Street Address', d.streetAddress),
                  Row(
                    children: [
                      Expanded(child: _infoSimple('City', d.city)),
                      const SizedBox(width: 16),
                      Expanded(child: _infoSimple('State', d.state)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _infoSimple('Country', d.country)),
                      const SizedBox(width: 16),
                      Expanded(child: _infoSimple('PIN Code', d.pinCode)),
                    ],
                  ),
                ],
              ),
            ),

            // Director Information
            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Director Information'),
                  _infoRow('Director Name', d.directorName),
                  const SizedBox(height: 8),
                  _infoRow('DIN Number', d.dinNumber),
                  const SizedBox(height: 8),
                  _infoRow('Contact Email', d.directorEmail),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      if (d.idProof == null) {
                        SnackbarHelper.showWarning(
                          context,
                          'Please upload ID Proof.',
                        );
                      } else {
                        // TODO: open d.idProof URL or file
                      }
                    },
                    icon: const Icon(Icons.picture_as_pdf, color: AppColors.green),
                    label: Text(
                      'View ID Proof',
                      style: TextStyle(fontSize: secondary(), color: AppColors.green),
                    ),
                  ),
                ],
              ),
            ),

            // Project Categories
            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Project Categories'),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: d.projectCategories
                        .split(', ')
                        .map((cat) => _bulletText(cat))
                        .toList(),
                  ),
                ],
              ),
            ),

            // Documents
            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Documents'),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.insert_drive_file_outlined, size: 20),
                    title: Text('View Company Registration', style: TextStyle(fontSize: secondary())),
                    onTap: () {
                      if (d.companyRegistrationDoc == null) {
                        SnackbarHelper.showWarning(context, 'Please upload Company Registration document');
                      } else {
                        // TODO: open d.companyRegistrationDoc
                      }
                    },
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.insert_drive_file_outlined, size: 20),
                    title: Text('View PAN Card', style: TextStyle(fontSize: secondary())),
                    onTap: () {
                      if (d.panCard == null) {
                        SnackbarHelper.showWarning(context, 'Please upload PAN Card');
                      } else {
                        // TODO: open d.panCard
                      }
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.insert_drive_file_outlined, size: 20),
                    title: Text('View Other Documents', style: TextStyle(fontSize: secondary())),
                    onTap: () {
                      if (d.otherDocuments == null) {
                        SnackbarHelper.showWarning(context, 'Please upload Other Documents');
                      } else {
                        // TODO: open d.otherDocuments
                      }
                    },
                  ),

                ],
              ),
            ),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) =>  AddCompanyDetails()));
                },
                icon: const Icon(Icons.edit_note, size: 25, color: Colors.white),
                label: Text('Edit', style: TextStyle(fontSize: secondary(), color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brown,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _sectionContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: primary(),
          fontWeight: FontWeight.bold,
          color: AppColors.green,
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: tertiary(), fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: secondary(), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _infoSimple(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: tertiary(), color: Colors.black54)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: secondary())),
        ],
      ),
    );
  }

  Widget _bulletText(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, size: 16, color: AppColors.gold),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: secondary())),
      ],
    );
  }
}
