import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../SnackBar/Snackbar.dart';
import '../AppBar/CustomerAppBar.dart';
import '../CustomerNavBar.dart';

class Customerrequest extends StatefulWidget {
  const Customerrequest({super.key});

  @override
  State<Customerrequest> createState() => _CustomerrequestState();
}

class _CustomerrequestState extends State<Customerrequest> {
  // 1) Department + controllers
  final List<String> departmentList = [
    'Construction', 'Electrical', 'Plumbing',
    'Painting', 'Carpentry', 'Labour'
  ];
  late List<TextEditingController> controllers;

  // 2) Site Manager
  final _siteNameCtrl  = TextEditingController();
  final _sitePhoneCtrl = TextEditingController();
  final _siteEmailCtrl = TextEditingController();

  // 3) Work Details
  final _projectnameCtrl = TextEditingController();
  final _workDescCtrl  = TextEditingController();
  final _workAddrCtrl  = TextEditingController();
  final _startDateCtrl = TextEditingController();
  final _durationCtrl  = TextEditingController();

  // 4) Contact Info
  final _contactNameCtrl  = TextEditingController();
  final _contactPhoneCtrl = TextEditingController();
  final _contactEmailCtrl = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      departmentList.length,
          (_) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (var c in controllers) c.dispose();
    _siteNameCtrl.dispose();
    _sitePhoneCtrl.dispose();
    _siteEmailCtrl.dispose();
    _projectnameCtrl.dispose();
    _workDescCtrl.dispose();
    _workAddrCtrl.dispose();
    _startDateCtrl.dispose();
    _durationCtrl.dispose();
    _contactNameCtrl.dispose();
    _contactPhoneCtrl.dispose();
    _contactEmailCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.gold,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _startDateCtrl.text =
      "${picked.year.toString().padLeft(4,'0')}-"
          "${picked.month.toString().padLeft(2,'0')}-"
          "${picked.day.toString().padLeft(2,'0')}";
    }
  }

  Future<void> _submitForm() async {
    // gather & validate
    final siteName    = _siteNameCtrl.text.trim();
    final sitePhone   = _sitePhoneCtrl.text.trim();
    final siteEmail   = _siteEmailCtrl.text.trim();
    final projectname = _projectnameCtrl.text.trim();
    final workDesc    = _workDescCtrl.text.trim();
    final workAddr    = _workAddrCtrl.text.trim();
    final startDate   = _startDateCtrl.text.trim();
    final durationNum = int.tryParse(_durationCtrl.text.trim()) ?? 0;
    final contactName = _contactNameCtrl.text.trim();
    final contactPhone= _contactPhoneCtrl.text.trim();
    final contactEmail= _contactEmailCtrl.text.trim();

    if (siteName.isEmpty ||
        sitePhone.isEmpty ||
        siteEmail.isEmpty ||
        projectname.isEmpty ||
        workDesc.isEmpty ||
        workAddr.isEmpty ||
        startDate.isEmpty ||
        durationNum <= 0 ||
        contactName.isEmpty ||
        contactPhone.isEmpty ||
        contactEmail.isEmpty) {
      SnackbarHelper.showWarning(context, 'Please fill all fields');
      return;
    }

    // build departments array
    final depts = <Map<String,int>>[];
    for (var i = 0; i < controllers.length; i++) {
      final cnt = int.tryParse(controllers[i].text.trim()) ?? 0;
      if (cnt > 0) {
        depts.add({
          'department_id': i + 1,           // adjust if your IDs differ
          'number_of_labour': cnt,
        });
      }
    }
    if (depts.isEmpty) {
      SnackbarHelper.showWarning(
        context,
        'Enter workers for at least one department',
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // get token
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token') ?? '';
      if (!token.startsWith('Bearer ')) token = 'Bearer $token';

      // POST
      final dio = Dio(BaseOptions(headers: {'Authorization': token}));
      final resp = await dio.post(
        'https://backend.jobizoindia.com/api/labour-request',
        data: {
          'site_manager_name'  : siteName,
          'site_manager_phone' : sitePhone,
          'site_manager_email' : siteEmail,
          'project_name'       : projectname,
          'work_description'   : workDesc,
          'work_address'       : workAddr,
          'start_date'         : startDate,
          'duration_days'      : durationNum,
          'contact_name'       : contactName,
          'contact_phone'      : contactPhone,
          'contact_email'      : contactEmail,
          'departments'        : depts,
        },
        options: Options(validateStatus: (s) => s != null && s < 500),
      );

      final data = resp.data as Map<String, dynamic>;
      if ((resp.statusCode == 200 || resp.statusCode == 201)
          && data['status'] == true) {
        SnackbarHelper.showSuccess(
            context, data['message'] ?? 'Request created.'
        );
        Get.back();

      } else {
        SnackbarHelper.showError(
            context,
            data['message'] ?? 'Failed (${resp.statusCode})'
        );
      }
    } on DioError catch (e) {
      final msg = e.response?.data['message'] ?? e.message;
      SnackbarHelper.showError(context, msg);
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Customerappbar(profileImageUrl: '',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Labour Requirements
            Text("Labour Requirements",
                style: TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: secondary(),
                )),
            const SizedBox(height: 10),

            // Department dropdown
            Text("Department",
                style: TextStyle(
                  fontSize: secondary(),
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.green, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.green, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              hint: const Text("Select Department"),
              dropdownColor: Colors.white,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              items: departmentList.map((dept) {
                return DropdownMenuItem(
                  value: dept,
                  child: Text(dept, style: const TextStyle(color: Colors.black)),
                );
              }).toList(),
              onChanged: (_) {}, // we don’t actually use this here
            ),
            const SizedBox(height: 15),

            // Number of Workers Needed grid
            Text("Number of Workers Needed",
                style: TextStyle(
                  fontSize: secondary(),
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 15),
            GridView.builder(
              itemCount: departmentList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (ctx, idx) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(departmentList[idx],
                        style: TextStyle(
                            fontSize: tertiary(), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: controllers[idx],
                      decoration: InputDecoration(
                        hintText: 'eg. 20',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          const BorderSide(color: Colors.grey, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          const BorderSide(color: AppColors.gold, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // Site Manager Details
            Text("Site Manager Details",
                style: TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: secondary(),
                )),
            const SizedBox(height: 10),
            _buildTextField("Site Manager Name", _siteNameCtrl),
            _buildTextField("Phone Number", _sitePhoneCtrl),
            _buildTextField("Email", _siteEmailCtrl),

            const SizedBox(height: 20),

            // Work Details
            Text("Work Details",
                style: TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: secondary(),
                )),
            const SizedBox(height: 10),
            _buildTextField("Project name", _projectnameCtrl,),
            _buildTextField("Work Description", _workDescCtrl, maxLines: 4),
            _buildTextField("Work Address", _workAddrCtrl),

            // Start Date with picker
            const SizedBox(height: 10),
            Text("Start Date",
                style: TextStyle(
                  fontSize: secondary(),
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 6),
            TextField(
              controller: _startDateCtrl,
              readOnly: true,
              onTap: _pickDate,
              decoration: InputDecoration(
                hintText: "Select start date",
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  const BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  const BorderSide(color: AppColors.gold, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: Icon(Icons.calendar_today, color: AppColors.gold),
              ),
            ),

            const SizedBox(height: 10),
            _buildTextField("Duration Days", _durationCtrl, keyboardType: TextInputType.number),

            const SizedBox(height: 20),

            // Contact Information
            Text("Contact Information",
                style: TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: secondary(),
                )),
            const SizedBox(height: 10),
            _buildTextField("Full Name", _contactNameCtrl),
            _buildTextField("Phone Number", _contactPhoneCtrl),
            _buildTextField("Email Address", _contactEmailCtrl),

            const SizedBox(height: 30),

            // Submit button
            Center(
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
                    : Text(
                  'Submit Request',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: tertiary(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50,),
          ],
        ),
      ),
      bottomNavigationBar: Customernavbar(currentIndex: 1),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController ctrl, {
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: tertiary(), fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: 'Enter $label',
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                const BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                const BorderSide(color: AppColors.gold, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
