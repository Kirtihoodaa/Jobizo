import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../SnackBar/Snackbar.dart';
import '../All_app_bars/normal_app_bar.dart';

/// Models
class EmergencyContact {
  final int id;
  final String name;
  final String relation;
  final String phone;
  EmergencyContact({
    required this.id,
    required this.name,
    required this.relation,
    required this.phone,
  });
  factory EmergencyContact.fromJson(Map<String, dynamic> j) => EmergencyContact(
      id: j['id'], name: j['name'], relation: j['relation'], phone: j['phone']);
}

class EmergencyNumbers {
  final String police, fire, hospital, ambulance;
  EmergencyNumbers({
    required this.police,
    required this.fire,
    required this.hospital,
    required this.ambulance,
  });
  factory EmergencyNumbers.fromJson(Map<String, dynamic> j) => EmergencyNumbers(
        police: j['police_number'],
        fire: j['fire_number'],
        hospital: j['hospital_number'],
        ambulance: j['ambulance_number'],
      );
}

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({Key? key}) : super(key: key);
  @override
  _EmergencyPageState createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  bool _loading = true;
  String _error = '';
  List<EmergencyContact> _contacts = [];
  EmergencyNumbers? _numbers;
  String _address = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token') ?? '';
      if (token.isEmpty) {
        SnackbarHelper.showError(context, 'Please login first.');
        return;
      }
      if (!token.startsWith('Bearer ')) token = 'Bearer $token';

      final dio = Dio(BaseOptions(headers: {'Authorization': token}));
      final resp = await dio.get(
        'https://backend.jobizoindia.com/api/emergency-contacts',
        options: Options(validateStatus: (s) => s != null && s < 500),
      );

      if (resp.statusCode == 200 && resp.data['status'] == true) {
        final json = resp.data as Map<String, dynamic>;
        final addr = json['user_address'];
        _address =
            (addr is String && addr.isNotEmpty) ? addr : 'Location unavailable';
        final contactsJson = json['data'] as List<dynamic>;
        _contacts = contactsJson
            .map((e) => EmergencyContact.fromJson(e as Map<String, dynamic>))
            .toList();

        // parse the emergency numbers
        _numbers = EmergencyNumbers.fromJson(
          json['emergency_numbers'] as Map<String, dynamic>,
        );
      } else {
        _error = 'Failed to load emergency data';
        SnackbarHelper.showError(context, _error);
      }
    } on DioError catch (e) {
      final msg = e.response?.data['message'] ?? e.message;
      _error = 'Network error: $msg';
      SnackbarHelper.showError(context, _error);
    } catch (e) {
      _error = 'Unexpected error: $e';
      SnackbarHelper.showError(context, _error);
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _dial(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      SnackbarHelper.showError(context, 'Could not launch dialer');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: CustomBackAppBar(title: 'Emergency'),
        body: const Center(
            child: CircularProgressIndicator(
          color: AppColors.gold,
        )),
      );
    }
    if (_error.isNotEmpty || _numbers == null) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: CustomBackAppBar(title: 'Emergency'),
        body: Center(child: Text(_error.isEmpty ? 'No data' : _error)),
      );
    }

    final nums = _numbers!;
    final actions = [
      _ActionItem(
          icon: Icons.local_police,
          label: 'Police',
          onTap: () => _dial(nums.police)),
      _ActionItem(
          icon: Icons.local_fire_department,
          label: 'Fire',
          onTap: () => _dial(nums.fire)),
      _ActionItem(
          icon: Icons.local_hospital,
          label: 'Hospital',
          onTap: () => _dial(nums.hospital)),
      _ActionItem(
          icon: Icons.emergency,
          label: 'Ambulance',
          onTap: () => _dial(nums.ambulance)),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomBackAppBar(title: 'Emergency'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.location_on, size: 24, color: Colors.grey[700]),
            const SizedBox(width: 8),
            Text(_address,
                style: TextStyle(
                    fontSize: secondary(), fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 25),
          GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 16,
              childAspectRatio: 1.9,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: actions),
          const SizedBox(height: 10),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Emergency Contacts',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: secondary(),
                      color: AppColors.gold)),
              const SizedBox(height: 15),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _contacts.length,
                  itemBuilder: (ctx, i) {
                    final c = _contacts[i];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      title: Text(c.name,
                          style: TextStyle(
                              fontSize: secondary(),
                              fontWeight: FontWeight.w600,
                              color: AppColors.green)),
                      subtitle: Text(c.relation,
                          style: TextStyle(
                              fontSize: tertiary(), color: Colors.grey[700])),
                      trailing: CircleAvatar(
                        backgroundColor: AppColors.gold,
                        radius: 20,
                        child: IconButton(
                          icon: const Icon(Icons.call, color: Colors.white),
                          onPressed: () => _dial(c.phone),
                        ),
                      ),
                    );
                  }),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionItem(
      {required this.icon, required this.label, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
                color: AppColors.gold, borderRadius: BorderRadius.circular(12)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, size: 32, color: Colors.white),
              const SizedBox(height: 8),
              Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: tertiary(),
                      fontWeight: FontWeight.w600)),
            ])));
  }
}
