import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

import '../All_app_bars/normal_app_bar.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  String? _selectedReason;
  bool _isConfirmed = false;
  final List<String> _reasons = [
    "I have privacy concerns",
    "I have another account",
    "I'm not using the app anymore",
    "I'm having technical issues",
    "Other Reason"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomBackAppBar(title: "Delete Account"),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Are you sure you want to delete the account?",
              style: TextStyle(
                  fontSize: secondary(),
                  color: AppColors.green,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "This action can't be undone. Once your account is deleted:",
              style: TextStyle(fontSize: secondary()),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "• All your data will be permanently deleted",
              style: TextStyle(fontSize: secondary()),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "• You will lose access to all your content",
              style: TextStyle(fontSize: secondary()),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "• Your username will be available for others",
              style: TextStyle(fontSize: secondary()),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "• Active subscriptions will be cancelled",
              style: TextStyle(fontSize: secondary()),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Please tell us why are you leaving",
              style: TextStyle(
                  fontSize: secondary(),
                  color: AppColors.green,
                  fontWeight: FontWeight.bold),
            ),
            ..._reasons.map((reason) {
              return RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                dense: true,
                visualDensity: VisualDensity(vertical: -4),
                title: Text(reason, style: TextStyle(fontSize: tertiary())),
                value: reason,
                groupValue: _selectedReason,
                activeColor: AppColors.gold,
                onChanged: (value) {
                  setState(() {
                    _selectedReason = value;
                  });
                },
              );
            }).toList(),
            SizedBox(
              height: 10,
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(
                "I understand and want to proceed with account deletion",
                style: TextStyle(
                    fontSize: tertiary(),
                    color: AppColors.green,
                    fontWeight: FontWeight.bold),
              ),
              value: _isConfirmed,
              activeColor: AppColors.gold,
              onChanged: (value) {
                setState(() {
                  _isConfirmed = value ?? false;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFA1A1A1),
                        minimumSize:
                            Size(MediaQuery.sizeOf(context).width * 0.4, 50)),
                    onPressed: () {},
                    child: Text(
                      "Cancel",
                      style:
                          TextStyle(color: Colors.white, fontSize: secondary()),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4B1E03),
                        minimumSize:
                            Size(MediaQuery.sizeOf(context).width * 0.4, 50)),
                    onPressed: () {},
                    child: Text("Delete Account",
                        style: TextStyle(
                            color: Colors.white, fontSize: secondary()))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
