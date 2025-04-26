import 'package:flutter/material.dart';
import '../../Design contraints/app color.dart';
import '../../Design contraints/FontSizes.dart';
import '../AppBar/commonAppBar.dart';

class Companydetails extends StatefulWidget {
  const Companydetails({super.key});

  @override
  State<Companydetails> createState() => _CompanydetailsState();
}

class _CompanydetailsState extends State<Companydetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: 'Company Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Information
            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Company Information'),
                  _infoRow('Company Name', 'TechVision Solutions Ltd.'),
                  SizedBox(height: 8),
                  _infoRow('Registration Number', 'REG123456789'),
                  SizedBox(height: 8),
                  _infoRow('Year of Establishment', '2024'),
                  SizedBox(height: 8),
                  _infoRow('Company Type', 'Private Limited Company'),
                ],
              ),
            ),

            // GST Information
            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('GST Information'),
                  _infoRow('GST Number', '22AAAAA0000A1Z5'),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.picture_as_pdf,
                      color: AppColors.green,
                    ),
                    label: Text(
                      'View GST Certificate',
                      style: TextStyle(
                        fontSize: secondary(),
                        color: AppColors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Address Information
            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Address Information'),
                  _infoRow('Street Address', '123 Innovation Park'),
                  Row(
                    children: [
                      Expanded(child: _infoSimple('City', 'Mumbai')),
                      const SizedBox(width: 16),
                      Expanded(child: _infoSimple('State', 'Maharashtra')),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _infoSimple('Country', 'India')),
                      const SizedBox(width: 16),
                      Expanded(child: _infoSimple('PIN Code', '94105')),
                    ],
                  ),
                ],
              ),
            ),

            // Director Information
            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Director Information'),
                  _infoRow('Director Name', 'Sarah Anderson'),
                  SizedBox(height: 8),
                  _infoRow('DIN Number', '00123456'),
                  SizedBox(height: 8),
                  _infoRow('Contact Email', 'sarah.anderson@techvision.com'),
                   SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.picture_as_pdf,
                      color: AppColors.green,
                    ),
                    label: Text(
                      'View ID Proof',
                      style: TextStyle(
                        fontSize: secondary(),
                        color: AppColors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Project Categories
            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Project Categories'),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _bulletText('IT Services & Consulting'),
                      SizedBox(height: 8),
                      _bulletText('Cloud Solutions'),
                      SizedBox(height: 8),
                      _bulletText('Digital Transformation'),
                      SizedBox(height: 8),
                      _bulletText('Cybersecurity'),
                    ],
                  ),
                ],
              ),
            ),

            // Documents
            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Documents'),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.insert_drive_file_outlined, size: 20),
                    title: Text('View Company Registration', style: TextStyle(fontSize: secondary())),
                    onTap: () {},
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.insert_drive_file_outlined, size: 20),
                    title: Text('View PAN Card', style: TextStyle(fontSize: secondary())),
                    onTap: () {},
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.insert_drive_file_outlined, size: 20),
                    title: Text('View Other Documents', style: TextStyle(fontSize: secondary())),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit_note, size: 25, color: Colors.white),
                label: Text('Edit', style: TextStyle(fontSize: secondary(), color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brown,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            SizedBox(height: 50)
          ],
        ),
      ),

    );
  }

  Widget _sectionContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: primary(),
          fontWeight: FontWeight.bold,
          color: AppColors.green,
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: tertiary(),  fontWeight: FontWeight.w700,color: Colors.black)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: secondary(), color: Colors.black, fontWeight: FontWeight.w500)),
        ],

      ),
    );
  }

  Widget _infoSimple(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: tertiary(), color: Colors.black54)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: secondary(), color: Colors.black)),
        ],
      ),
    );
  }

  Widget _bulletText(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, size: 16, color: AppColors.gold),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: secondary(), color: Colors.black)),
      ],
    );
  }
}
