import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/app_logo.png',
          width: screenWidth * 0.55, // Responsive and larger
          fit: BoxFit.contain,
        ),
        Stack(
          children: [
            const Icon(Icons.notifications_none, color: AppColors.white, size: 32),
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 12,
                  minHeight: 12,
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
