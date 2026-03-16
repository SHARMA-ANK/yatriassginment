import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_colors.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() {
  runApp(const ProviderScope(child: YatriApp()));
}

class YatriApp extends StatelessWidget {
  const YatriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yatri Cabs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundDark,
        primaryColor: AppColors.primaryGreen,
        fontFamily: 'Roboto', 
      ),
      home: const HomePage(),
    );
  }
}
