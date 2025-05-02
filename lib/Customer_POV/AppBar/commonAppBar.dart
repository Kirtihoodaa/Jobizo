import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Design contraints/FontSizes.dart';
import '../../Design contraints/app color.dart';

class Commonappbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const Commonappbar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.gold,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            debugPrint('⚠️ No screen to pop. You may have used pushReplacement.');
          }
        },
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: primary(),
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
