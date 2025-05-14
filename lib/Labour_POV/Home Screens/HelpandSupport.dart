import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../SnackBar/Snackbar.dart';
import '../All_app_bars/normal_app_bar.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  List<Map<String, String>> faqItems = [];
  Map<String, bool> expandedState = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFaq();
  }

  Future<void> _fetchFaq() async {
    setState(() {
      _isLoading = true;
      faqItems.clear();
      expandedState.clear();
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      if (token.isEmpty) {
        SnackbarHelper.showError(context, 'Not authenticated. Please login.');
        return;
      }

      final dio = Dio(BaseOptions(headers: {'Authorization': token}));
      final resp = await dio.get('https://backend.jobizoindia.com/api/helpSupport');
      final root = resp.data as Map<String, dynamic>;

      if (resp.statusCode == 200 && root['status'] == true) {
        final raw = root['data'];
        // build a fresh list
        List<Map<String, String>> items;
        if (raw is List) {
          items = raw.map<Map<String, String>>((e) {
            return {
              'question': e['question'] as String,
              'answer':   e['answer']   as String,
            };
          }).toList();
        } else if (raw is Map<String, dynamic>) {
          items = [
            {
              'question': raw['question'] as String,
              'answer':   raw['answer']   as String,
            }
          ];
        } else {
          items = [];
        }

        // debug: how many did we get?
        debugPrint('🔹 fetched ${items.length} FAQ items: $items');

        setState(() {
          faqItems = items;
          expandedState = { for (var it in items) it['question']!: false };
        });
      } else {
        SnackbarHelper.showError(
          context,
          root['message'] ?? 'Failed to load FAQ.',
        );
      }
    } on DioError catch (e) {
      final msg = e.response?.data['message'] ?? e.message;
      SnackbarHelper.showError(context, 'Error: $msg');
    } catch (e) {
      SnackbarHelper.showError(context, 'Unexpected error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomBackAppBar(title: 'Help & Support'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqItems.length,
        itemBuilder: (ctx, i) {
          final q = faqItems[i]['question']!;
          final a = faqItems[i]['answer']!;
          final expanded = expandedState[q] ?? false;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question
              Container(
                height: 55,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          q,
                          style: TextStyle(
                            fontSize: tertiary(),
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            expandedState[q] = !expanded;
                          });
                        },
                        child: Icon(
                          expanded ? Icons.close : Icons.add,
                          color: const Color(0xFF415202),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Answer
              if (expanded)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    a,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
