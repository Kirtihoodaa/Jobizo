import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import '../../Design contraints/FontSizes.dart';
import '../AppBar/commonAppBar.dart';

class Labourlocalities extends StatefulWidget {
  const Labourlocalities({super.key});

  @override
  State<Labourlocalities> createState() => _LabourlocalitiesState();
}

class _LabourlocalitiesState extends State<Labourlocalities> {
  // categories for the chip list
  final List<String> _categories = [
    'All',
    'Construction',
    'Painting',
    'Plumbing',
    'Electrical',
    'Carpentry',
  ];
  int _selectedCategory = 0;

  final TextEditingController _searchCtrl = TextEditingController();

  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _allWorkers = [];  // raw data
  List<Map<String, dynamic>> _filtered = [];    // filtered list

  @override
  void initState() {
    super.initState();
    _fetchWorkers();
  }

  Future<void> _fetchWorkers() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token') ?? '';
      if (!token.startsWith('Bearer ')) token = 'Bearer $token';

      final resp = await Dio(BaseOptions(headers: {'Authorization': token}))
          .get('https://backend.jobizoindia.com/api/labour/localities',
          options: Options(validateStatus: (s) => s! < 500));

      final data = resp.data as Map<String, dynamic>;
      if (resp.statusCode == 200 && data['status'] == true) {
        _allWorkers =
        List<Map<String, dynamic>>.from(data['data'] as List<dynamic>);
        _applyFilter();
      } else {
        throw data['message'] ?? 'Failed to load';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() => _loading = false);
    }
  }

  void _applyFilter() {
    final term = _searchCtrl.text.trim().toLowerCase();
    final prof = _selectedCategory > 0
        ? _categories[_selectedCategory].toLowerCase()
        : null;

    _filtered = _allWorkers.where((w) {
      final p = (w['profession'] as String? ?? '').toLowerCase();
      final addr = (w['address'] as String? ?? '').toLowerCase();
      final matchProf = prof != null && prof != 'all' && p == prof;
      final matchSearch = term.isNotEmpty && (p.contains(term) || addr.contains(term));
      if (prof != null && prof != 'all') {
        return matchProf || matchSearch;
      }
      if (term.isNotEmpty) {
        return matchSearch;
      }
      return true;
    }).toList();

    setState(() {});
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: const Commonappbar(title: 'Labour Localities'),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.green))
          : _error != null
          ? Center(child: Text(_error!))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchCtrl,
                textInputAction: TextInputAction.search,
                onChanged: (_) => _applyFilter(),
                decoration: InputDecoration(
                  hintText: 'Search by profession or address…',
                  prefixIcon: Icon(Icons.search, color: AppColors.green),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),
                    borderSide: BorderSide(color: AppColors.gold, width: 2),
                  ),
                ),
              ),
            ),


            const SizedBox(height: 16),

            // Category chips
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final selected = index == _selectedCategory;
                  return GestureDetector(
                    onTap: () {
                      _selectedCategory = index;
                      _applyFilter();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.gold : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: selected
                              ? Colors.transparent
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        _categories[index],
                        style: TextStyle(
                          fontSize: tertiary(),
                          color: selected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Worker cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: _filtered.map(_buildWorkerCard).toList(),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerCard(Map<String, dynamic> w) {
    final avatarUrl = w['image'] != null
        ? "https://backend.jobizoindia.com/storage/${w['image'] as String}"
        : null;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl)
                  : const AssetImage('Assets/Customer_Images/person.png')
              as ImageProvider,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        w['name'] as String? ?? '',
                        style: TextStyle(
                            fontSize: secondary(), fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: AppColors.gold),
                          const SizedBox(width: 4),
                          Text(
                            ((w['rating'] as num?) ?? 0).toStringAsFixed(1),
                            style: TextStyle(fontSize: tertiary()),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Profession
                  Text(
                    w['profession'] as String? ?? '',
                    style: TextStyle(fontSize: tertiary()),
                  ),

                  const SizedBox(height: 4),

                  // Address
                  Text(
                    w['address'] as String? ?? '',
                    style: TextStyle(fontSize: tertiary() - 1),
                  ),

                  const SizedBox(height: 8),

                  // Availability badge
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (w['availability'] as String? ?? '') == 'Available'
                          ? Colors.lightGreen
                          : AppColors.brown,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      w['availability'] as String? ?? '',
                      style: TextStyle(
                        fontSize: tertiary() - 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
