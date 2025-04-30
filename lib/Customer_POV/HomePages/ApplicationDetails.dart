import 'package:flutter/material.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class ApplicationDetail extends StatelessWidget {
  const ApplicationDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: "Application Details"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildJobStatusCard(),
            const SizedBox(height: 16),
            _buildPersonalInfoSection(),
            const SizedBox(height: 16),
            _buildProfessionalDetailsSection(),
            _buildDocumentsSection(),
            _buildInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildJobStatusCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Office Manager",
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: secondary()),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Pending",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.black),
              SizedBox(width: 4),
              Text(
                "Applied on Feb 15, 2024",
                style: TextStyle(fontSize: tertiary(), color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Personal Information",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: secondary(),
                color: AppColors.green),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.person_outline, "Full Name", "John Anderson"),
          _buildInfoRow(
              Icons.email_outlined, "Email Address", "john.anderson@email.com"),
          _buildInfoRow(Icons.phone_outlined, "Phone Number", "+91 8899778865"),
          _buildInfoRow(
              Icons.calendar_today_outlined, "Date of Birth", "05/02/2001"),
          _buildInfoRow(
              Icons.location_on_outlined, "Location", "Mumbai , India"),
        ],
      ),
    );
  }

  Widget _buildProfessionalDetailsSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Professional Details",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: secondary(),
                color: AppColors.green),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
              Icons.work_outline, "Current Position", "Junior Developer"),
          _buildInfoRow(Icons.access_time, "Years of Experience", "2 years"),
          _buildInfoRow(Icons.attach_money, "Expected Salary",
              "INR 80,000 - INR 100,000"),
          _buildInfoRow(Icons.school_outlined, "Education Level",
              "Bachelor's in Computer Science"),
        ],
      ),
    );
  }

  Widget _buildDocumentsSection() {
    return Stack(
      children: [
        // The container styled like the absolute positioned div
        Positioned(
          left: 0,
          top: 0,
          child: Container(
            width: 326,
            height: 68,
            decoration: BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: null, // Content inside the positioned container
          ),
        ),

        // Main document section
        Container(
          margin: const EdgeInsets.only(
            top: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Documents",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: secondary(),
                    color: AppColors.green),
              ),
              const SizedBox(height: 16),
              _buildDocumentRow(
                  Icons.picture_as_pdf_outlined, "Resume.pdf", "2.4 MB"),
              _buildDocumentRow(
                  Icons.picture_as_pdf_outlined, "Cover_Letter.pdf", "1.2 MB"),
              _buildDocumentRow(Icons.image_outlined, "Photo_ID.jpg", "3.1 MB"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentRow(IconData icon, String fileName, String size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              Color(0xFFF9FAFB), // Grey background for each document container
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.gold),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fileName,
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(size,
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
            Text("Download",
                style: TextStyle(
                    color: AppColors.green, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Why do you want to join us?",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: secondary(),
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "I am passionate about creating innovative solutions and believe I would be a great addition to your team. "
            "My experience in full-stack development and problem-solving skills make me an ideal candidate for this position.",
            style: TextStyle(
              fontSize: tertiary(),
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.green),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: tertiary(), fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(value, style: TextStyle(fontSize: tertiary())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
