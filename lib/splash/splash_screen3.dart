import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:jobizo/splash/new_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<OnboardingData> pages = [
    OnboardingData(
      image: 'Assets/jobizo/onboard1.png',
      title: 'Connecting Hands That\nBuild Dreams',
      description:
          "Whether you're hiring skilled labour or\nlooking for your next job — Jobizo is here\nto help.",
    ),
    OnboardingData(
      image: 'Assets/jobizo/onboard2.png',
      title: 'Need Help? Hire Verified\nLabour Instantly!',
      description:
          "From plumbers to painters or other\nworkers, find reliable workers nearby in\njust a few taps.",
    ),
    OnboardingData(
      image: 'Assets/jobizo/onboard3.png',
      title: 'Be a Labourer. Start\nEarning Today.',
      description:
          "Join as a verified worker, explore more\nopportunities, choose your jobs, and get\npaid on time.",
    ),
    OnboardingData(
      image: 'Assets/jobizo/onboard4.png',
      title: 'Join Jobizo – A Trusted\nLabour Network',
      description:
          "Safe. Simple. Supportive. Become part of\na growing work community that values\nyour skills.",
    ),
  ];
  void _onNextPressed() {
    if (_currentPage < pages.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      // Last page: Navigate to JobizoInfoSection
      Get.off(() => const JobizoInfoSection());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: () {
                print("Skip tapped");
                Get.off(() => const JobizoInfoSection());
              },
              child: Text(
                'Skip →',
                style: TextStyle(
                  fontSize: secondary(),
                  fontWeight: FontWeight.w500,
                  color: AppColors.green,
                ),
              ),
            ),
          ),
          PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final page = pages[index];
              return OnboardingContent(
                image: page.image,
                title: page.title,
                description: page.description,
                currentPage: _currentPage,
                totalPages: pages.length,
                onNext: _onNextPressed,
              );
            },
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String image;
  final String title;
  final String description;

  OnboardingData({
    required this.image,
    required this.title,
    required this.description,
  });
}

class OnboardingContent extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;

  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Center image
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Image.asset(
            image,
            height: 250,
            fit: BoxFit.contain,
          ),
        ),

        // Yellow curve background
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipPath(
            clipper: BottomCurveClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.78,
              width: double.infinity,
              color: AppColors.gold,
            ),
          ),
        ),

        // White foreground content
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(70),
                topRight: Radius.circular(70),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: secondary(),
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 40,
                    ),
                  ),
                  child: Text(
                    'Next',
                    style:
                        TextStyle(fontSize: secondary(), color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(totalPages, (index) {
                    final isSelected = index == currentPage;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.green : AppColors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 11,
                                      height: 11,
                                      decoration: BoxDecoration(
                                        color: AppColors.green,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : null,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.25);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.53,
      size.width,
      size.height * 0.25,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
