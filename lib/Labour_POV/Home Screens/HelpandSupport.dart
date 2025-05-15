import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../SnackBar/Snackbar.dart';
import '../All_app_bars/normal_app_bar.dart';


/// Simple model for each FAQ entry
class Faq {
  final int id;
  final String question;
  final String answer;

  Faq({required this.id, required this.question, required this.answer});

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      id: json['id'] as int,
      question: json['question'] as String,
      answer: json['answer'] as String,
    );
  }
}

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  List<Faq> _faqItems = [];
  Map<int, bool> _expanded = {}; // key by id, not question text
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFaq();
  }

  Future<void> _fetchFaq() async {
    setState(() {
      _isLoading = true;
      _faqItems.clear();
      _expanded.clear();
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      if (token.isEmpty) {
        SnackbarHelper.showError(context, 'Not authenticated. Please login.');
        return;
      }

      final dio = Dio(BaseOptions(headers: {'Authorization': token}));
      final resp = await dio.get(
        'https://backend.jobizoindia.com/api/helpSupport',
      );
      final root = resp.data as Map<String, dynamic>;

      if (resp.statusCode == 200 && root['status'] == true) {
        // root['data'] is a List<dynamic>
        final List<dynamic> rawList = root['data'] as List<dynamic>;
        final faqs = rawList
            .map((e) => Faq.fromJson(e as Map<String, dynamic>))
            .toList();

        setState(() {
          _faqItems = faqs;
          for (var f in faqs) {
            _expanded[f.id] = false;
          }
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
        itemCount: _faqItems.length,
        itemBuilder: (ctx, i) {
          final faq = _faqItems[i];
          final isExpanded = _expanded[faq.id] ?? false;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question header
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
                          faq.question,
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
                            _expanded[faq.id] = !isExpanded;
                          });
                        },
                        child: Icon(
                          isExpanded ? Icons.close : Icons.add,
                          color: AppColors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Answer
              if (isExpanded)
                Center(
                  child: Container(
                    margin:  EdgeInsets.only(bottom: 12),
                    padding:  EdgeInsets.all(22),
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
                      faq.answer,
                      style:  TextStyle(
                        fontSize: tertiary(),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
