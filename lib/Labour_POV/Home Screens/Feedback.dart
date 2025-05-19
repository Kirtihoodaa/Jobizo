import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../SnackBar/Snackbar.dart';
import '../All_app_bars/normal_app_bar.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController feedbackController = TextEditingController();
  String selectedFeedbackType = '';
  int selectedRating = 0;
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> feedbackTypes = [
    {'label': 'Bug Report', 'icon': Icons.bug_report},
    {'label': 'Feature Request', 'icon': Icons.lightbulb},
    {'label': 'General Feedback', 'icon': Icons.chat_bubble},
    {'label': 'Other', 'icon': Icons.more_horiz},
  ];

  Future<void> _submitFeedback() async{
    if(selectedFeedbackType.isEmpty || feedbackController.text.trim().isEmpty || selectedRating == 0){
      SnackbarHelper.showWarning(
          context, "Please select type, enter feedback and rate!");
      return;
    }

    setState(() => _isSubmitting = true);

    try{
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('auth_token') ?? '';
      if(token.isEmpty){
        SnackbarHelper.showError(
            context, "Not Authenticated! Please login");
      }

      final dio = Dio(BaseOptions(
        headers: {'Authorization': token},
      ));
      
      final response = await dio.post('https://backend.jobizoindia.com/api/feedback',
      data: {
        'type' : selectedFeedbackType,
        'description' : feedbackController.text.trim(),
        'rating' : selectedRating.toString(),
      },
      );

      final data = response.data as Map<String, dynamic>;
      if(data['status'] == true ){
        SnackbarHelper.showSuccess(
            context, data['message'] ?? 'Submitted Successfully');

        //clear the form
        setState(() {
          selectedFeedbackType = '';
          feedbackController.clear();
          selectedRating = 0;
        });
      }else {
        SnackbarHelper.showError(
            context, data['message'] ?? 'Submission failed');
      }
    } on DioError catch (e) {
      final msg = e.response?.data['message'] ?? e.message;
      SnackbarHelper.showInfo(
        context,
        msg,
      );
    } catch (e) {
      SnackbarHelper.showError(
        context,
        'Unexpected error: $e',
      );
    }
    finally {
      setState(() => _isSubmitting = false);

    }
  }

  @override
  void dispose(){
    feedbackController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomBackAppBar(
        title: 'FeedBack',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Text
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'What kind of feedback do you have?',
                style: TextStyle(
                    fontSize: tertiary(),
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF415202)),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            // GridView for feedback types
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(12),
              color: Color(0xFFEEA700),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: feedbackTypes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2,
                ),
                itemBuilder: (context, index) {
                  var item = feedbackTypes[index];
                  bool isSelected = selectedFeedbackType == item['label'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFeedbackType = item['label'];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? AppColors.gold : AppColors.green,
                          width: isSelected ? 3 : 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            item['icon'],
                            size: isSelected ? 40 : 30,
                            color: AppColors.green,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['label'],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: tertiary(),
                              color: AppColors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Rest of the content with padding
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Tell us more',
                    style: TextStyle(
                        fontSize: tertiary(),
                        fontWeight: FontWeight.w600,
                        color: AppColors.green,),
                  ),
                  const SizedBox(height: 8),

                  // Feedback text field
                  TextField(
                    controller: feedbackController,
                    maxLength: 500,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Describe your feedback in detail...',
                      counterText: '',
                      contentPadding: const EdgeInsets.all(12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.gold, width: 2),
                      ),
                    ),
                  ),


                  const SizedBox(height: 20),
                  Text(
                    'How was your experience?',
                    style: TextStyle(
                        fontSize: tertiary(),
                        fontWeight: FontWeight.w600,
                        color: AppColors.green,),
                  ),
                  const SizedBox(height: 8),

                  // Star rating row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final filled = selectedRating > index;
                      return IconButton(
                        icon: Icon(
                          filled ? Icons.star : Icons.star_outline,
                          size: 30,
                          color: filled ? AppColors.gold : Colors.grey.shade300,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),

                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      'Tap to rate',
                      style: TextStyle(fontSize: 12, color: AppColors.green,),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.green,
                        ),
                      )
                          : const Text(
                        'Submit Feedback',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
