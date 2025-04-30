import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class LabourManagementScreen extends StatefulWidget {
  const LabourManagementScreen({Key? key}) : super(key: key);

  @override
  State<LabourManagementScreen> createState() => _LabourManagementScreenState();
}

class _LabourManagementScreenState extends State<LabourManagementScreen> {
  List<Labour> availableLabours = [
    Labour(
        name: 'Michael Thompson',
        role: 'Carpenter, 6 years exp.',
        status: 'Available'),
    Labour(
        name: 'Sarah Martinez',
        role: 'Electrician, 5 years exp.',
        status: 'Available'),
    Labour(
        name: 'James Wilson', role: 'Mason, 6 years exp.', status: 'Assigned'),
  ];

  final siteDetailsController = TextEditingController();
  final dateController = TextEditingController();
  final shiftController = TextEditingController();
  final workersController = TextEditingController();

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.amber,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _pickShiftTime(BuildContext context) async {
    final TimeOfDay? start = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 6, minute: 0),
    );

    final TimeOfDay? end = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 14, minute: 0),
    );

    if (start != null && end != null) {
      shiftController.text =
          '${start.format(context)} - ${end.format(context)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: "Manage Labours"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Available Labourers
            WhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Available Laborers",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.green,
                          fontSize: secondary())),
                  const SizedBox(height: 12),
                  ...List.generate(availableLabours.length, (index) {
                    final labour = availableLabours[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 2),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                value: labour.isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    labour.isSelected = value ?? false;
                                  });
                                },
                                activeColor: AppColors.gold,
                                title: Text(labour.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: tertiary())),
                                subtitle: Text(labour.role,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: tertiary())),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: labour.status == 'Available'
                                      ? Colors.green
                                      : Colors.brown,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  labour.status,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Assignment Form
            WhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Assignment Details",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.green,
                          fontSize: secondary())),
                  const SizedBox(height: 12),
                  Text("Site Details",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: tertiary())),
                  const SizedBox(height: 4),
                  _buildAmberTextField(
                    controller: siteDetailsController,
                    hintText: 'Enter site-specific details or instructions',
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  Text("Assignment Date",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: tertiary())),
                  const SizedBox(height: 4),
                  _buildAmberTextField(
                    controller: dateController,
                    hintText: 'Select assignment date',
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                    readOnly: true,
                    onTap: () => _pickDate(context),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  const SizedBox(height: 12),
                  Text("Shift",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: tertiary())),
                  const SizedBox(height: 4),
                  _buildAmberTextField(
                    controller: shiftController,
                    hintText: 'Select shift time',
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                    readOnly: true,
                    onTap: () => _pickShiftTime(context),
                    suffixIcon: const Icon(Icons.access_time),
                  ),
                  const SizedBox(height: 12),
                  Text("Workers Needed",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: tertiary())),
                  const SizedBox(height: 4),
                  _buildAmberTextField(
                    controller: workersController,
                    hintText: 'Enter number of workers needed',
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Assign logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Assign Selected Workers",
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Current Assignments
            WhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Current Assignments",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.green,
                          fontSize: secondary())),
                  const SizedBox(height: 16),
                  _buildAssignmentItem(
                      title: "Downtown High-rise Project",
                      date: "Mar 15, 2024",
                      shift: "Morning",
                      workers: 3),
                  const SizedBox(height: 12),
                  _buildAssignmentItem(
                      title: "Riverside Commercial Complex",
                      date: "Mar 16, 2024",
                      shift: "Evening",
                      workers: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmberTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    bool readOnly = false,
    void Function()? onTap,
    required TextStyle hintStyle,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildAssignmentItem({
    required String title,
    required String date,
    required String shift,
    required int workers,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: tertiary())),
          const SizedBox(height: 4),
          Text("$workers workers assigned",
              style:
                  TextStyle(fontWeight: FontWeight.w400, fontSize: tertiary())),
          Text("Date: $date",
              style:
                  TextStyle(fontWeight: FontWeight.w400, fontSize: tertiary())),
          Text("Shift: $shift",
              style:
                  TextStyle(fontWeight: FontWeight.w400, fontSize: tertiary())),
        ],
      ),
    );
  }
}

class WhiteCard extends StatelessWidget {
  final Widget child;

  const WhiteCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
        ],
      ),
      child: child,
    );
  }
}

class Labour {
  final String name;
  final String role;
  final String status;
  bool isSelected;

  Labour({
    required this.name,
    required this.role,
    required this.status,
    this.isSelected = false,
  });
}
