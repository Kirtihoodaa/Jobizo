import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'package:jobizo/Design contraints/app color.dart';
import 'package:jobizo/Design contraints/FontSizes.dart';
import '../../SnackBar/Snackbar.dart';
import '../AppBar/commonAppBar.dart';

class AddCompanyDetails extends StatefulWidget {
  const AddCompanyDetails({Key? key}) : super(key: key);

  @override
  State<AddCompanyDetails> createState() => _AddCompanyDetailsState();
}

class _AddCompanyDetailsState extends State<AddCompanyDetails> {
  bool _isSubmitting = false;

  //–– Text controllers
  final _companyNameCtrl   = TextEditingController();
  final _regNumberCtrl     = TextEditingController();
  final _yearCtrl          = TextEditingController();
  final _gstNumberCtrl     = TextEditingController();
  final _streetCtrl        = TextEditingController();
  final _cityCtrl          = TextEditingController();
  final _stateCtrl         = TextEditingController();
  final _countryCtrl       = TextEditingController();
  final _pinCtrl           = TextEditingController();
  final _directorNameCtrl  = TextEditingController();
  final _dinCtrl           = TextEditingController();
  final _directorEmailCtrl = TextEditingController();

  //–– Dropdown / checkboxes
  String? _companyType;
  final _companyTypes = [
    'Private Limited Company',
    'Public Limited Company',
  ];
  final _projectCategoriesList = [
    'IT Services & Consulting',
    'Appartment Building',
    'Cloud Solutions',
    'Digital Transformation',
    'Cybersecurity',
  ];
  final _selectedCategories = <String>{};

  //–– Stored local file‐paths (for UX only; upload separately)
  String? _gstCertificatePath;
  String? _idProofPath;
  String? _companyRegDocPath;
  String? _panCardPath;
  String? _otherDocsPath;

  @override
  void initState() {
    super.initState();
    _companyType = _companyTypes.first;
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Text fields
      _companyNameCtrl.text   = prefs.getString('company_name')           ?? '';
      _regNumberCtrl.text     = prefs.getString('registration_number')     ?? '';
      _yearCtrl.text          = prefs.getString('year_of_establishment')   ?? '';
      _gstNumberCtrl.text     = prefs.getString('gst_number')             ?? '';
      _streetCtrl.text        = prefs.getString('street_address')          ?? '';
      _cityCtrl.text          = prefs.getString('city')                    ?? '';
      _stateCtrl.text         = prefs.getString('state')                   ?? '';
      _countryCtrl.text       = prefs.getString('country')                 ?? '';
      _pinCtrl.text           = prefs.getString('pin_code')                ?? '';
      _directorNameCtrl.text  = prefs.getString('director_name')           ?? '';
      _dinCtrl.text           = prefs.getString('din_number')              ?? '';
      _directorEmailCtrl.text = prefs.getString('email')                   ?? '';

      // Dropdown & categories
      _companyType            = prefs.getString('company_type')           ?? _companyTypes.first;
      _selectedCategories
        ..clear()
        ..addAll(prefs.getStringList('project_categories') ?? []);

      // File‐paths
      _gstCertificatePath     = prefs.getString('gst_certificate');
      _idProofPath            = prefs.getString('id_proof');
      _companyRegDocPath      = prefs.getString('company_registration_doc');
      _panCardPath            = prefs.getString('pan_card');
      _otherDocsPath          = prefs.getString('other_documents');
    });
  }

  @override
  void dispose() {
    _companyNameCtrl.dispose();
    _regNumberCtrl.dispose();
    _yearCtrl.dispose();
    _gstNumberCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _countryCtrl.dispose();
    _pinCtrl.dispose();
    _directorNameCtrl.dispose();
    _dinCtrl.dispose();
    _directorEmailCtrl.dispose();
    super.dispose();
  }

  /// Only accept PDF; else warn user.
  Future<void> _pickAndSave(String prefKey, ValueChanged<String> onSaved) async {
    final result = await FilePicker.platform.pickFiles();
    if (result?.files.single.path != null) {
      final filePath = result!.files.single.path!;
      final ext = p.extension(filePath).toLowerCase();
      if (ext != '.pdf') {
        SnackbarHelper.showWarning(context, 'Please select a PDF file');
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(prefKey, filePath);
      onSaved(filePath);
    }
  }

  Future<void> _submitCompanyProfile() async {
    // 1) Validate
    if (_companyNameCtrl.text.trim().isEmpty ||
        _regNumberCtrl.text.trim().isEmpty ||
        _yearCtrl.text.trim().isEmpty ||
        _companyType == null ||
        _gstNumberCtrl.text.trim().isEmpty ||
        _streetCtrl.text.trim().isEmpty ||
        _cityCtrl.text.trim().isEmpty ||
        _stateCtrl.text.trim().isEmpty ||
        _countryCtrl.text.trim().isEmpty ||
        _pinCtrl.text.trim().isEmpty ||
        _directorNameCtrl.text.trim().isEmpty ||
        _dinCtrl.text.trim().isEmpty ||
        _directorEmailCtrl.text.trim().isEmpty ||
        _selectedCategories.isEmpty) {
      SnackbarHelper.showWarning(context, 'Please fill all fields');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // 2) Auth
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token') ?? '';
      if (token.isEmpty) {
        SnackbarHelper.showError(context, 'Not authenticated. Please login.');
        return;
      }
      if (!token.startsWith('Bearer ')) token = 'Bearer $token';

      // 3) Build payload
      final payload = {
        'company_name': _companyNameCtrl.text.trim(),
        'registration_number': _regNumberCtrl.text.trim(),
        'year_of_establishment': _yearCtrl.text.trim(),
        'company_type': _companyType!,
        'gst_number': _gstNumberCtrl.text.trim(),
        'gst_certificate': _gstCertificatePath != null
            ? 'https://backend.jobizoindia.com/storage/certificates/${p.basename(_gstCertificatePath!)}'
            : null,
        'street_address': _streetCtrl.text.trim(),
        'city': _cityCtrl.text.trim(),
        'state': _stateCtrl.text.trim(),
        'country': _countryCtrl.text.trim(),
        'pin_code': _pinCtrl.text.trim(),
        'director_name': _directorNameCtrl.text.trim(),
        'din_number': _dinCtrl.text.trim(),
        'email': _directorEmailCtrl.text.trim(),
        'id_proof': _idProofPath != null
            ? 'https://backend.jobizoindia.com/storage/id_proofs/${p.basename(_idProofPath!)}'
            : null,
        'project_categories': _selectedCategories.join(', '),
        'company_registration_doc': _companyRegDocPath != null
            ? 'https://backend.jobizoindia.com/storage/registrations/${p.basename(_companyRegDocPath!)}'
            : null,
        'pan_card': _panCardPath != null
            ? 'https://backend.jobizoindia.com/storage/pan_cards/${p.basename(_panCardPath!)}'
            : null,
        'other_documents': _otherDocsPath != null
            ? 'https://backend.jobizoindia.com/storage/other_documents/${p.basename(_otherDocsPath!)}'
            : null,
      };

      // 4) POST JSON
      final dio = Dio(BaseOptions(headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      }));
      final resp = await dio.post(
        'https://backend.jobizoindia.com/api/company-details',
        data: payload,
        options: Options(validateStatus: (s) => s != null && s < 500),
      );

      final body = resp.data as Map<String, dynamic>;
      if ((resp.statusCode == 200 || resp.statusCode == 201) && body['status'] == true) {
        // **Save** text + selections
        await prefs
          ..setString('company_name', _companyNameCtrl.text.trim())
          ..setString('registration_number', _regNumberCtrl.text.trim())
          ..setString('year_of_establishment', _yearCtrl.text.trim())
          ..setString('company_type', _companyType!)
          ..setString('gst_number', _gstNumberCtrl.text.trim())
          ..setStringList('project_categories', _selectedCategories.toList());
        SnackbarHelper.showSuccess(context, body['message'] ?? 'Company created successfully');
        Get.back();
      } else {
        SnackbarHelper.showError(context, body['message'] ?? 'Failed (${resp.statusCode})');
      }
    } on DioError catch (e) {
      final msg = e.response?.data['message'] ?? e.message;
      SnackbarHelper.showError(context, msg);
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  // --- UI helpers ---

  Widget _sectionContainer({required Widget child}) => Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
    child: child,
  );

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Text(title,
        style: TextStyle(fontSize: primary(), fontWeight: FontWeight.bold, color: AppColors.green)),
  );

  Widget _textField(String label, TextEditingController ctrl, String hint) => Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontSize: secondary(), fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      TextField(
        controller: ctrl,
        decoration: InputDecoration(
          hintText: hint,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.gold), borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      )
    ]),
  );

  Widget _dropdownField(String label, List<String> items, String? value, ValueChanged<String?> onChanged) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: secondary(), fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            dropdownColor: Colors.white,
            value: value,
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: secondary()))))
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gold), borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          )
        ]),
      );

  Widget _categoryCheckbox(String title) => CheckboxListTile(
    value: _selectedCategories.contains(title),
    onChanged: (v) {
      setState(() {
        if (v == true) _selectedCategories.add(title);
        else _selectedCategories.remove(title);
      });
    },
    activeColor: AppColors.gold,
    title: Text(title, style: TextStyle(fontSize: tertiary())),
    controlAffinity: ListTileControlAffinity.leading,
  );

  Widget _uploadButton(String label, VoidCallback onTap, {bool uploaded = false}) => Center(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(uploaded ? Icons.check_circle : Icons.upload, size: 22, color: Colors.white),
        label: Text(uploaded ? 'Uploaded' : label,
            style: TextStyle(fontSize: tertiary(), color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        ),
      ),
    ),
  );

  Widget _uploadDocumentButton(String label, VoidCallback onTap, {bool uploaded = false}) => Center(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(uploaded ? Icons.check_circle : Icons.upload_file_rounded,
            size: 22, color: uploaded ? Colors.white : Colors.black),
        label: Text(label,
            style: TextStyle(fontSize: tertiary(), color: uploaded ? Colors.white : Colors.black)),
        style: ElevatedButton.styleFrom(
          backgroundColor: uploaded ? AppColors.gold : AppColors.grey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          minimumSize: const Size(300, 48),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: 'Add / Edit Company Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Company Details
          _sectionContainer(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _sectionTitle('Company Details'),
              _textField('Company Name', _companyNameCtrl, 'TechVision Solutions Ltd.'),
              _textField('Registration Number', _regNumberCtrl, 'REG123456789'),
              _textField('Year of Establishment', _yearCtrl, '2024'),
              _dropdownField('Company Type', _companyTypes, _companyType,
                      (v) => setState(() => _companyType = v)),
            ]),
          ),

          // GST
          _sectionContainer(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _sectionTitle('GST Information'),
              _textField('GST Number', _gstNumberCtrl, '22AAAAA0000A1Z5'),
              _sectionTitle('GST Certificate'),
              _uploadButton(
                'Upload Certificate',
                    () => _pickAndSave('gst_certificate', (p) => setState(() => _gstCertificatePath = p)),
                uploaded: _gstCertificatePath != null,
              ),
            ]),
          ),

          // Address
          _sectionContainer(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _sectionTitle('Address Information'),
              _textField('Street Address', _streetCtrl, '123 Innovation Park'),
              Row(children: [
                Expanded(child: _textField('City', _cityCtrl, 'Delhi')),
                const SizedBox(width: 8),
                Expanded(child: _textField('State', _stateCtrl, 'Delhi')),
              ]),
              Row(children: [
                Expanded(child: _textField('Country', _countryCtrl, 'India')),
                const SizedBox(width: 8),
                Expanded(child: _textField('PIN Code', _pinCtrl, '110001')),
              ]),
            ]),
          ),

          // Director
          _sectionContainer(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _sectionTitle('Director Information'),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () {}, // optional add more
                  style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.gold)),
                  child: Text('+ Add Director', style: TextStyle(fontSize: tertiary(),color: AppColors.gold)),
                ),
              ),
              _textField('Director Name', _directorNameCtrl, 'Sarah Anderson'),
              _textField('DIN Number', _dinCtrl, '00123456'),
              _textField('Contact Email', _directorEmailCtrl, 'sarah.anderson@techvision.com'),
              _sectionTitle('ID Proof'),
              _uploadButton(
                'Upload ID Proof',
                    () => _pickAndSave('id_proof', (p) => setState(() => _idProofPath = p)),
                uploaded: _idProofPath != null,
              ),
            ]),
          ),

          // Categories
          _sectionContainer(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _sectionTitle('Project Categories'),
              ..._projectCategoriesList.map(_categoryCheckbox),
            ]),
          ),

          // Documents
          _sectionContainer(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _sectionTitle('Other Documents'),
              Text('Company Registration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: secondary())),
              _uploadDocumentButton(
                'Upload Registration',
                    () => _pickAndSave('company_registration_doc', (p) => setState(() => _companyRegDocPath = p)),
                uploaded: _companyRegDocPath != null,
              ),
              Text('PAN Card', style: TextStyle(fontWeight: FontWeight.bold, fontSize: secondary())),
              _uploadDocumentButton(
                'Upload PAN Card',
                    () => _pickAndSave('pan_card', (p) => setState(() => _panCardPath = p)),
                uploaded: _panCardPath != null,
              ),
              Text('Other Documents', style: TextStyle(fontWeight: FontWeight.bold, fontSize: secondary())),
              _uploadDocumentButton(
                'Upload Other Docs',
                    () => _pickAndSave('other_documents', (p) => setState(() => _otherDocsPath = p)),
                uploaded: _otherDocsPath != null,
              ),
            ]),
          ),

          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitCompanyProfile,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14)),
              child: _isSubmitting
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
                  : Text('Submit Company Profile',
                  style: TextStyle(fontSize: tertiary(), color: Colors.white)),
            ),
          ),
          const SizedBox(height: 50),
        ]),
      ),
    );
  }
}
