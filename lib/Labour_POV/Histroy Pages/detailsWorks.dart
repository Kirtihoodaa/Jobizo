import 'package:flutter/material.dart';
import 'package:jobizo/Design contraints/app color.dart';
import 'package:jobizo/Design contraints/FontSizes.dart';
import '../NavBar.dart';

class WorkDetails extends StatefulWidget {
  const WorkDetails({Key? key}) : super(key: key);

  @override
  State<WorkDetails> createState() => _WorkDetailsState();
}

class _WorkDetailsState extends State<WorkDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.gold,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'Work Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: primary(),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Current Assignment & Status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Current Assignment',
                      style: TextStyle(
                        fontSize: secondary(),
                        fontWeight: FontWeight.w600,
                        color: AppColors.green,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.lightGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Completed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: tertiary(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Company & site info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(Icons.location_city, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Skyline Construction Co.',
                          style: TextStyle(
                            fontSize: secondary(),
                            fontWeight: FontWeight.w600,
                            color: AppColors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Site: DownTown Project'),
                        Text('Job Type: Construction'),
                        Text('Location: 123 Construction Ave, Downtown'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Site no: 1001',
                    style: TextStyle(fontSize: tertiary()),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Employee info
              Text(
                'Sarah Martinez',
                style: TextStyle(
                  fontSize: secondary(),
                  fontWeight: FontWeight.w600,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Employee ID:'),
                  const SizedBox(width: 8),
                  Text('00154'),
                  Spacer(),
                  Icon(Icons.access_time, size: 18),
                  const SizedBox(width: 4),
                  Text('8:00 AM - 5:00 PM'),
                ],
              ),

              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Role:'),
                  const SizedBox(width: 8),
                  Text('Electrician'),
                  Spacer(),
                  Icon(Icons.calendar_today, size: 18),
                  const SizedBox(width: 4),
                  Text('Start: Apr 18, 2025'),
                ],
              ),

              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Total Hours Of Work'),
                  Spacer(),
                  Text('4 Hours'),
                ],
              ),

              const SizedBox(height: 15),
              Row(
                children: [
                  Text('Totals Earnings'),
                  Spacer(),
                  Text(
                    'INR 1,200',
                    style: TextStyle(
                      fontSize: primary(),
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}