import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import '../../Design contraints/FontSizes.dart';
import '../AppBar/commonAppBar.dart';

class AddCompanyDetails extends StatefulWidget {
  const AddCompanyDetails({super.key});

  @override
  State<AddCompanyDetails> createState() => _AddCompanyDetailsState();
}

class _AddCompanyDetailsState extends State<AddCompanyDetails> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: 'View Company Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Details
            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Company Details'),
                  _textField('Company Name', 'TechVision Solutions Ltd.'),
                  _textField('Registration Number', 'REG123456789'),
                  _textField('Year of Establishment', '2024'),
                  _dropdownField(
                    'Company Type',
                    ['Private Limited Company', 'Public Limited Company'],
                  ),
                ],
              ),
            ),

            // GST Information
            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('GST Information'),
                  _textField('GST Number', '22AAAAA0000A1Z5'),
                  _sectionTitle('GST Certificate'),
                  _uploadButton('Upload Certificate'),
                ],
              ),
            ),

            // Address Information
            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Address Information'),
                  _textField('Street Address', '123 Innovation Park'),
                  Row(
                    children: [
                      Expanded(child: _textField('City', 'San Francisco')),
                      const SizedBox(width: 8),
                      Expanded(child: _textField('State', 'California')),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _textField('Country', 'United States')),
                      const SizedBox(width: 8),
                      Expanded(child: _textField('PIN Code', '94105')),
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.gold),
                        foregroundColor: AppColors.gold,
                      ),
                      child: Text(
                        '+ Add Director',
                        style: TextStyle(
                          fontSize: tertiary(),
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                  ),
                  _textField('Director Name', 'Sarah Anderson'),
                  _textField('DIN Number', '00123456'),
                  _textField('Contact Email', 'sarah.anderson@techvision.com'),
                  Text("ID Proof", style:
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: secondary(),
                    ),),
                  SizedBox(height: 8),
                  _uploadIDButton('Upload ID Proof'),
                ],
              ),
            ),

            // Project Categories
            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Project Categories'),
                  _categoryCheckbox('IT Services & Consulting'),
                  _categoryCheckbox('Appartment Building'),
                  _categoryCheckbox('Cloud Solutions'),
                  _categoryCheckbox('Digital Transformation'),
                  _categoryCheckbox('Cybersecurity'),
                ],
              ),
            ),

            // Document Upload
            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Document Upload'),
                  SizedBox(height: 15),
                  Text("Company Registration", style:
                  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: secondary(),
                  ),
                  ),
                  _uploadDocumentButton('Company Registration'),
                  SizedBox(height: 8,),

                  Text("PAN Card", style:
                  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: secondary(),
                  ),
                  ),
                  _uploadDocumentButton('PAN Card'),
                  SizedBox(height: 8,),

                  Text("Other Documents", style:
                  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: secondary(),
                  ),
                  ),
                  _uploadDocumentButton('Other Documents'),
                  SizedBox(height: 5),

                ],
              ),
            ),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                child: Text(
                  'Submit Company Profile',
                  style: TextStyle(
                    fontSize: secondary(),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50)
          ],
        ),
      ),
    );
  }

  /// White rounded container for each form section
  Widget _sectionContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: primary(),
          fontWeight: FontWeight.bold,
          color: AppColors.green,
        ),
      ),
    );
  }

  /// Label above and TextField with hint and gold focus border
  Widget _textField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: secondary(),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: secondary()),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.gold),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownField(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: secondary(),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: items.first,
            items: items
                .map((v) => DropdownMenuItem(
              value: v,
              child: Text(v, style: TextStyle(fontSize: secondary())),
            ))
                .toList(),
            onChanged: (_) {},
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.gold),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _uploadButton(String label) {
    return Center(
      child: Padding(
        padding:  EdgeInsets.only(bottom: 12.0),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon:  Icon(Icons.upload, size: 22,),
          label: Text(label, style: TextStyle(fontSize: tertiary())),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          ),
        ),
      ),
    );
  }


  Widget _uploadIDButton(String label) {
    return Center(
      child: Padding(
        padding:  EdgeInsets.only(bottom: 12.0),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon:  Icon(Icons.drive_folder_upload_rounded, size: 22,),
          label: Text(label, style: TextStyle(fontSize: tertiary())),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _uploadDocumentButton(String label) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.upload_file_rounded,
            size: 22,
            color: Colors.black,
          ),
          label: Text(
            label,
            style: TextStyle(fontSize: tertiary()),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.grey,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            minimumSize:  Size(300, 48),
          ),
        ),
      ),
    );
  }


  Widget _categoryCheckbox(String title) {
    return CheckboxListTile(
      value: _selectedCategory == title,
      onChanged: (v) {
        setState(() {
          _selectedCategory = v! ? title : null;
        });
      },
      activeColor: AppColors.gold,
      title: Text(title, style: TextStyle(fontSize: tertiary())),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
