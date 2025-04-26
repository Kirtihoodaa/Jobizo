import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import '../../Design contraints/app color.dart';
import '../AppBar/commonAppBar.dart';

class Customerrequest extends StatefulWidget {
  const Customerrequest({super.key});

  @override
  State<Customerrequest> createState() => _CustomerrequestState();
}

class _CustomerrequestState extends State<Customerrequest> {
  List<String> departmentList = [
    'Construction',
    'Electrical',
    'Plumbing',
    'Painting',
    'Carpentry',
    'Labour'
  ];

  String? selectedDepartment;

  // Create TextEditingControllers for each department
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(departmentList.length, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Commonappbar(
        title: 'Labour Requirements',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Labour Requirements",
              style: TextStyle(
                color: AppColors.green,
                fontWeight: FontWeight.bold,
                fontSize: secondary(),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Department",
              style: TextStyle(
                fontSize: secondary(),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: selectedDepartment == null
                        ? AppColors.green
                        : Colors.yellow,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: selectedDepartment == null
                        ? AppColors.green
                        : Colors.yellow,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              value: selectedDepartment,
              hint: const Text("Select Department"),
              dropdownColor: Colors.white,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              items: departmentList.map((dept) {
                return DropdownMenuItem<String>(
                  value: dept,
                  child: Text(
                    dept,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDepartment = value!;
                });
              },
            ),
            const SizedBox(height: 15),
            Text(
              "Number of Workers Needed",
              style: TextStyle(
                fontSize: secondary(),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            GridView.builder(
              itemCount: departmentList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      departmentList[index],
                      style: TextStyle(
                        fontSize: tertiary(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: controllers[index],
                      decoration: InputDecoration(
                        hintText: 'eg. 20',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.gold,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: secondary()),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Site Manager Details",
              style: TextStyle(
                color: AppColors.green,
                fontWeight: FontWeight.bold,
                fontSize: secondary(),
              ),
            ),
            const SizedBox(height: 10),
            _textField("Site Manager Name", "eg. Wilton"),
            _textField("Phone Number", "+91 8899008877"),
            _textField("Email", "eg. ZIUghn@gmail.com"),

            const SizedBox(height: 20),
            Text(
              "Work Details",
              style: TextStyle(
                color: AppColors.green,
                fontWeight: FontWeight.bold,
                fontSize: secondary(),
              ),
            ),
            const SizedBox(height: 10),
            _textField("Work Description", "Enter work description", minLines: 4, maxLines: 5),
            _textField("Work Address", "Enter work address"),
            _textField("Start Date", "12-04-2025"),
            _textField("Duration Days", "eg. 10"),

            const SizedBox(height: 20),
            Text(
              "Contact Information",
              style: TextStyle(
                color: AppColors.green,
                fontWeight: FontWeight.bold,
                fontSize: secondary(),
              ),
            ),
            const SizedBox(height: 10),
            _textField("Full Name", "Murali Manohar"),
            _textField("Phone Number", "+91 7787654532"),
            _textField("Email Address", "muraimanohar@gmail.com"),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child:  Text(
                  'Submit Request',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: primary(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    print('Selected Department: $selectedDepartment');
    for (int i = 0; i < departmentList.length; i++) {
      print('${departmentList[i]}: ${controllers[i].text}');
    }
    // Add your API call or next step here
  }
}
Widget _textField(String label, String hint, {int minLines = 1, int maxLines = 1}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: tertiary(),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          minLines: minLines,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.gold),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    ),
  );
}
