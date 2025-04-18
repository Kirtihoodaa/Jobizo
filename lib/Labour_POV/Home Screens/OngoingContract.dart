import 'package:flutter/material.dart';
import 'package:jobizo/Design contraints/app color.dart';
import 'package:jobizo/Design contraints/FontSizes.dart';

class OngoingContractPage extends StatelessWidget {
  const OngoingContractPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = List.filled(2, _ContractData(
      company: 'Skyline Construction Co.',
      siteName: 'DownTown Project',
      siteNo: '1001',
      jobType: 'Construction',
      location: '123 Construction Ave, Downtown',
      employeeName: 'Sarah Martinez',
      employeeId: '00154',
      hours: '8:00 AM - 5:00 PM',
      startDate: 'Apr 18, 2025',
      duration: '3 months',
    ));

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.gold,
        elevation: 0,
        leading: BackButton(color: Colors.white),
        centerTitle: true,
        title: Text(
          'Ongoing Contract',
          style: TextStyle(
            fontSize: primary(),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: items
              .map((data) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _ContractCard(data: data),
          ))
              .toList(),
        ),
      ),
    );
  }
}

class _ContractData {
  final String company,
      siteName,
      siteNo,
      jobType,
      location,
      employeeName,
      employeeId,
      hours,
      startDate,
      duration;

  _ContractData({
    required this.company,
    required this.siteName,
    required this.siteNo,
    required this.jobType,
    required this.location,
    required this.employeeName,
    required this.employeeId,
    required this.hours,
    required this.startDate,
    required this.duration,
  });
}

class _ContractCard extends StatelessWidget {
  final _ContractData data;
  const _ContractCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: title & status
          Row(
            children: [
              Expanded(
                child: Text(
                  'Current Assignment',
                  style: TextStyle(
                    fontSize: secondary(),
                    fontWeight: FontWeight.w600,
                    color: AppColors.green
                  ),
                ),
              ),
              Container(
                padding:
                 EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Ongoing',
                  style: TextStyle(
                    fontSize: tertiary(),
                    color: Colors.white,
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
                radius: 25,
                backgroundColor: Colors.grey.shade200,
                child: Icon(Icons.location_city, size: 35,color: AppColors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.company,
                      style: TextStyle(
                        fontSize: secondary(),
                        fontWeight: FontWeight.w600,
                          color: AppColors.green
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Site: ${data.siteName}'),
                    Text('Job Type: ${data.jobType}'),
                    Text('Location: ${data.location}'),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Site No: ${data.siteNo}',
                style: TextStyle(fontSize: tertiary()),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Employee section
          Text(
            data.employeeName,
            style: TextStyle(
              fontSize: secondary(),
              fontWeight: FontWeight.w600,
                color: AppColors.green
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Text('Employee ID:'),
              const SizedBox(width: 8),
              Text(data.employeeId),
              Spacer(),
              Icon(Icons.access_time, size: 18),
              const SizedBox(width: 8),
              Text(data.hours),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Text('Role:'),
              const SizedBox(width: 8),
              Text(data.jobType),
              Spacer(),
              Icon(Icons.calendar_today, size: 18),
              const SizedBox(width: 8),
              Text('Start: ${data.startDate}'),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Text('Duration:'),
              const SizedBox(width: 8),
              Text(
                data.duration,
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
