import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HomeHeadline extends StatelessWidget {
  const HomeHeadline({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.white, height: 1.4),
        children: [
          TextSpan(text: "India's Leading "),
          TextSpan(text: "Inter-City\n", style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
          TextSpan(text: "One Way ", style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
          TextSpan(text: "Cab Service Provider"),
        ],
      ),
    );
  }
}

class PromotionalBanner extends StatelessWidget {
  const PromotionalBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/topImage.png',
        fit: BoxFit.cover,
      ),
    );
  }
}

class BottomIllustration extends StatelessWidget {
  const BottomIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/belowImage.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
