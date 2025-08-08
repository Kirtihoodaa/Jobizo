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
  // Categories for the chip list
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
  List<Map<String, dynamic>> _allWorkers = [];  // Raw data
  List<Map<String, dynamic>> _filtered = [];    // Filtered list

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
          .get(
        'https://backend.jobizoindia.com/api/localities',
        options: Options(validateStatus: (s) => s! < 500),
      );

      final data = resp.data as Map<String, dynamic>;
      print('resp.data: ${resp.data.runtimeType}');
      print('resp.data content: ${resp.data}');
      if (resp.statusCode == 200 && data['status'] == true) {
        _allWorkers = List<Map<String, dynamic>>.from(
          data['data'] as List<dynamic>,
        );
        print('resp.data: ${resp.data.runtimeType}');
        print('resp.data content: ${resp.data}');
        _applyFilter();
      } else {
        throw data['message'] ?? 'Failed to load';
      }
    } catch (e) {
      print(e.toString());
      _error = e.toString();
    } finally {
      setState(() => _loading = false);
    }
  }

  /// Apply both category‐based filtering and search‐term filtering.
  /// Search now includes: profession, address, and name.
  void _applyFilter() {
    final term = _searchCtrl.text.trim().toLowerCase();
    final prof = _selectedCategory > 0
        ? _categories[_selectedCategory].toLowerCase()
        : null;

    _filtered = _allWorkers.where((w) {
      // Lowercased fields for comparison
      final p = (w['profession'] as String? ?? '').toLowerCase();
      final addr = (w['address'] as String? ?? '').toLowerCase();
      final name = (w['name'] as String? ?? '').toLowerCase();

      // Category‐matching: if a category is selected other than "All"
      final matchProf = prof != null && prof != 'all' && p == prof;

      // Search‐term matching: now checks profession, address, OR name
      final matchSearch = term.isNotEmpty &&
          (p.contains(term) || addr.contains(term) || name.contains(term));

      if (prof != null && prof != 'all') {
        // If a specific profession is chosen, include workers whose profession matches
        // OR whose profession/address/name matches the search term.
        return matchProf || matchSearch;
      }

      if (term.isNotEmpty) {
        // If no specific category but search term is present,
        // include any worker whose profession, address, or name contains that term.
        return matchSearch;
      }

      // If neither category nor search term, show all.
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
          ? const Center(
        child: CircularProgressIndicator(color: AppColors.gold),
      )
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
                  hintText: 'Search by name, profession or address…',
                  prefixIcon: Icon(Icons.search, color: AppColors.green),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),
                    borderSide: BorderSide(
                        color: Colors.grey.shade300, width: 1.5),
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

  /// Helper to uppercase only the first character of a non-empty string.
  String capitalizeFirst(String? input) {
    if (input == null || input.isEmpty) return '';
    return input[0].toUpperCase() + input.substring(1);
  }

  Widget _buildWorkerCard(Map<String, dynamic> w) {
    // Build the avatar URL if an image path exists.
    final rawImagePath = w['image'] as String?;
    final avatarUrl = rawImagePath != null
        ? "https://backend.jobizoindia.com/storage/$rawImagePath"
        : null;

    // Safely capitalize first letters.
    final name = capitalizeFirst(w['name'] as String?);
    final profession = capitalizeFirst(w['profession'] as String?);
    final address = capitalizeFirst(w['address'] as String?);
    final availability = capitalizeFirst(w['availability'] as String?);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Avatar circle (network or placeholder)
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
                  // — Name + Rating Row —
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Name (capitalized)
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: secondary(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Rating star + value
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
                  // — Profession (capitalized) —
                  Text(
                    profession,
                    style: TextStyle(fontSize: tertiary()),
                  ),
                  const SizedBox(height: 4),
                  // — Address (capitalized) —
                  Text(
                    address,
                    style: TextStyle(fontSize: tertiary() - 1),
                  ),
                  const SizedBox(height: 8),
                  // — Availability Badge (capitalized) —
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: availability == 'Available'
                          ? Colors.lightGreen
                          : AppColors.brown,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      availability,
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
