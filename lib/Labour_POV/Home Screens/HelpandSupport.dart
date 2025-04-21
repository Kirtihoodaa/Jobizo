import 'package:flutter/material.dart';
import 'package:jobizo/All_app_bars/normal_app_bar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final List<Map<String, String>> faqItems = [
    {
      "question": "What insurance do workers carry?",
      "answer":
          "Workers carry liability and health insurance as per company policy."
    },
    {
      "question": "How are workers verified?",
      "answer":
          "Workers undergo background checks and ID verification before joining."
    },
    {
      "question": "How do I log in to the system?",
      "answer":
          "Use your registered email and password to log in on the app or website."
    },
    {
      "question": "Where can I see my payment details?",
      "answer":
          "You can view your payment details under the 'Payments' section in the dashboard."
    },
    {
      "question": "How do I apply for leave?",
      "answer":
          "Request Leave, select your dates, type of leave, and submit. Track approval status under 'Leave History.'"
    },
  ];

  Map<String, bool> expandedState = {};

  @override
  void initState() {
    super.initState();
    for (var item in faqItems) {
      expandedState[item["question"]!] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomBackAppBar(
        title: 'Help & Support',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: faqItems.map((item) => buildHelpCard(item)).toList(),
        ),
      ),
    );
  }

  Widget buildHelpCard(Map<String, String> item) {
    bool isExpanded = expandedState[item["question"]] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 55,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                offset: const Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item["question"]!,
                    style: TextStyle(
                      fontSize: tertiary(),
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      expandedState[item["question"]!] = !isExpanded;
                    });
                  },
                  child: Icon(
                    isExpanded ? Icons.close : Icons.add,
                    color: Color(0xFF415202),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  offset: const Offset(0, 0),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Text(
              item["answer"]!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
      ],
    );
  }
}
