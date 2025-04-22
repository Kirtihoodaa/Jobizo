import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

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

  final List<Map<String, dynamic>> feedbackTypes = [
    {'label': 'Bug Report', 'icon': Icons.bug_report},
    {'label': 'Feature Request', 'icon': Icons.lightbulb},
    {'label': 'General Feedback', 'icon': Icons.chat_bubble},
    {'label': 'Other', 'icon': Icons.more_horiz},
  ];

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
                          color: isSelected ? Colors.black : AppColors.gold,
                          width: isSelected ? 2.5 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            item['icon'],
                            size: isSelected ? 40 : 30,
                            color: Color(0xFF415202),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['label'],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: tertiary(),
                              color: Color(0xFF415202),
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
                        color: Color(0xFF415202)),
                  ),
                  const SizedBox(height: 8),

                  // Feedback text field
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: TextField(
                      controller: feedbackController,
                      maxLength: 500,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Describe your feedback in detail...',
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    'How was your experience?',
                    style: TextStyle(
                        fontSize: tertiary(),
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF415202)),
                  ),
                  const SizedBox(height: 8),

                  // Star rating row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          Icons.star_outline,
                          size: 30,
                          color: selectedRating > index
                              ? AppColors.gold
                              : Colors.grey.shade300,
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
                      style: TextStyle(fontSize: 12, color: Color(0xFF415202)),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        // Handle submit action
                        print('Feedback: ${feedbackController.text}');
                        print('Selected Type: $selectedFeedbackType');
                        print('Rating: $selectedRating');
                      },
                      child: const Text(
                        'Submit Feedback',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
