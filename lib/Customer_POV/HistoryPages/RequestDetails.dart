import 'package:flutter/material.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class Requestdetails extends StatefulWidget {
  const Requestdetails({super.key});

  @override
  State<Requestdetails> createState() => _RequestdetailsState();
}

class _RequestdetailsState extends State<Requestdetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: "Request Details"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 30, bottom: 50, right: 20, left: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Construction",
                        style: TextStyle(
                          fontSize: secondary(),
                          fontWeight: FontWeight.bold,
                          color: AppColors.green,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Pending',
                          style: TextStyle(
                            fontSize: tertiary(),
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Workers Required
                  Text(
                    "Workers Required",
                    style: TextStyle(
                      fontSize: secondary(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      Text(
                        "Painting 25",
                        style: TextStyle(
                          fontSize: tertiary(),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Carpenter 25",
                        style: TextStyle(
                          fontSize: tertiary(),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Construction 25",
                        style: TextStyle(
                          fontSize: tertiary(),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Electrical 10",
                        style: TextStyle(
                          fontSize: tertiary(),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Duration
                  Text(
                    "Duration",
                    style: TextStyle(
                      fontSize: secondary(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "10 days",
                    style: TextStyle(
                      fontSize: tertiary(),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Start & End Date
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Start Date",
                              style: TextStyle(
                                fontSize: tertiary(),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Apr 18, 2024",
                              style: TextStyle(
                                fontSize: tertiary(),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "End Date",
                              style: TextStyle(
                                fontSize: tertiary(),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Apr 28, 2024",
                              style: TextStyle(
                                fontSize: tertiary(),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // Location
                  Text(
                    "Location",
                    style: TextStyle(
                      fontSize: secondary(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Mumbai Construction Site, Maharashtra",
                    style: TextStyle(
                      fontSize: tertiary(),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 30),

                  // Site Manager
                  Text(
                    "Site Manager Name",
                    style: TextStyle(
                      fontSize: secondary(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Wilton",
                    style: TextStyle(
                      fontSize: tertiary(),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 30),

                  // Phone Number
                  Text(
                    "Phone Number",
                    style: TextStyle(
                      fontSize: secondary(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "+91 8878990087",
                    style: TextStyle(
                      fontSize: tertiary(),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 30),

                  // Email
                  Text(
                    "Email",
                    style: TextStyle(
                      fontSize: secondary(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "eg. ZIUahn@gmail.com",
                    style: TextStyle(
                      fontSize: tertiary(),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 30),

                  // Work Description
                  Text(
                    "Work Description",
                    style: TextStyle(
                      fontSize: secondary(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Construction work involves building foundation, structural work, and finishing for a new commercial complex. Workers needed for various tasks including masonry, carpentry, and general labor.",
                    style: TextStyle(
                      fontSize: tertiary(),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
