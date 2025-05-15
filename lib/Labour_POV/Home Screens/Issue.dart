import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../SnackBar/Snackbar.dart';
import '../All_app_bars/normal_app_bar.dart';

class LabourIssuesScreen extends StatefulWidget {
  const LabourIssuesScreen({super.key});
  @override
  State<LabourIssuesScreen> createState() => _LabourIssuesScreenState();
}

class _LabourIssuesScreenState extends State<LabourIssuesScreen> {
  final _issueCtrl = TextEditingController();
  final _descCtrl  = TextEditingController();
  final _dateCtrl  = TextEditingController();
  final _priorities = ['Low','Medium','High'];
  String _selectedPriority = '';

  bool _isSubmitting = false;

  Future<void> _submitIssue() async {
    if (_issueCtrl.text.trim().isEmpty ||
        _descCtrl.text.trim().isEmpty ||
        _dateCtrl.text.trim().isEmpty ||
        _selectedPriority.isEmpty) {
      SnackbarHelper.showWarning(context, "Please fill all the fields");
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token') ?? '';
      if (token.isEmpty) {
        SnackbarHelper.showError(context, "Not Authenticated! Please login");
        return;
      }
      if (!token.startsWith('Bearer ')) token = 'Bearer $token';

      final dio = Dio(BaseOptions(headers:{'Authorization':token}));
      final resp = await dio.post(
        'https://backend.jobizoindia.com/api/create-issue',
        data:{
          'issue_type'      : _issueCtrl.text.trim(),
          'description'     : _descCtrl.text.trim(),
          'date_of_incident': _dateCtrl.text.trim(),
          'priority_level'  : _selectedPriority,
        },
        options: Options(validateStatus:(s)=>s!=null && s<500),
      );

      debugPrint('POST create-issue ${resp.statusCode}: ${resp.data}');
      final body = resp.data as Map<String,dynamic>;

      if ((resp.statusCode==200||resp.statusCode==201) && body['status']==true) {
        SnackbarHelper.showSuccess(context, body['message'] ?? 'Submitted successfully');
        setState(() {
          _issueCtrl.clear();
          _descCtrl.clear();
          _dateCtrl.clear();
          _selectedPriority = '';
        });
      } else if (resp.statusCode==422 && body['errors']!=null) {
        final errs = body['errors'] as Map<String,dynamic>;
        final msg = errs.entries.map((e){
          final list = (e.value as List).cast<String>();
          return "${e.key}: ${list.join(', ')}";
        }).join("\n");
        SnackbarHelper.showError(context, msg);
      } else {
        SnackbarHelper.showError(
          context,
          body['message'] ?? 'Submission failed (code ${resp.statusCode})',
        );
      }
    }
    on DioError catch(e) {
      final m = e.response?.data['message'] ?? e.message;
      SnackbarHelper.showInfo(context, 'Network error: $m');
    }
    catch(e,st) {
      debugPrint('Error in _submitIssue(): $e\n$st');
      SnackbarHelper.showError(context, 'Unexpected error: $e');
    }
    finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final p = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder:(ctx,child)=>Theme(
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
    if (p!=null) {

      _dateCtrl.text = DateFormat('yyyy-MM-dd').format(p);
    }
  }

  @override
  void dispose() {
    _issueCtrl.dispose();
    _descCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomBackAppBar(title:'Labour Issues'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
            const Text("Issue Type", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height:8),
            TextField(
              controller:_issueCtrl,
              decoration: InputDecoration(
                hintText:"Enter issue type",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color:Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color:AppColors.gold, width:2),
                ),
              ),
            ),

            const SizedBox(height:20),
            const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height:8),
            TextField(
              controller:_descCtrl,
              maxLines:4,
              decoration: InputDecoration(
                hintText:"Describe the issue in detail",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color:Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color:AppColors.gold,width:2),
                ),
              ),
            ),

            const SizedBox(height:20),
            const Text("Date of Incident", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height:8),
            TextField(
              controller:_dateCtrl,
              readOnly:true,
              onTap:_pickDate,
              decoration: InputDecoration(
                hintText:"Select date",
                suffixIcon:const Icon(Icons.calendar_today),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color:Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color:AppColors.gold,width:2),
                ),
              ),
            ),

            const SizedBox(height:20),
            const Text("Priority Level", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height:8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal:12),
              decoration: BoxDecoration(
                border: Border.all(color:Colors.black),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value:_selectedPriority.isEmpty?null:_selectedPriority,
                hint:const Text("Select Priority Level"),
                decoration: const InputDecoration(border:InputBorder.none),
                items:_priorities.map((p)=>DropdownMenuItem(value:p, child:Text(p))).toList(),
                onChanged:(v)=>setState(()=>_selectedPriority=v!),
              ),
            ),

            const SizedBox(height:30),
            Center(
              child: ElevatedButton(
                onPressed:_isSubmitting?null:_submitIssue,
                style: ElevatedButton.styleFrom(
                  backgroundColor:AppColors.gold,
                  padding:const EdgeInsets.symmetric(horizontal:40,vertical:16),
                  shape:RoundedRectangleBorder(
                    borderRadius:BorderRadius.circular(30),
                  ),
                ),
                child:_isSubmitting
                    ? const SizedBox(width:20,height:20,child:CircularProgressIndicator(strokeWidth:2,color:AppColors.green))
                    : Text("Submit Issue", style:TextStyle(color:Colors.white, fontSize:primary())),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
