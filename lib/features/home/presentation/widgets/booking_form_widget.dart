import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';

class BookingFormWidget extends StatelessWidget {
  const BookingFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildFormFieldRow(
            iconWidget: Image.asset('assets/pickup_icon.png', height: 24),
            title: 'Pick-up City', 
            subtitle: 'Type City Name',
            showClearIcon: true,
          ),
          const SizedBox(height: 12),
          _buildFormFieldRow(
            iconWidget: SvgPicture.asset('assets/drop_city_icon.svg', height: 24),
            title: 'Drop City', 
            subtitle: 'Type City Name',
            showClearIcon: true,
          ),
          const SizedBox(height: 12),
          _buildFormFieldRow(
            iconWidget: SvgPicture.asset('assets/pickupdate_icon.svg', height: 24),
            title: 'Pick-up Date', 
            subtitle: 'DD-MM-YYYY',
            showClearIcon: false,
          ),
          const SizedBox(height: 12),
          _buildFormFieldRow(
            iconWidget: SvgPicture.asset('assets/timer_icon.svg', height: 24),
            title: 'Time', 
            subtitle: 'HH:MM',
            showClearIcon: false,
          ),
          const SizedBox(height: 24),
          _buildExploreButton(),
        ],
      ),
    );
  }

  Widget _buildFormFieldRow({
    required Widget iconWidget, 
    required String title, 
    required String subtitle,
    required bool showClearIcon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE2F4D7), // Extracted approximate color
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.white,
            radius: 16,
            child: iconWidget,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen, fontSize: 13)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
          if (showClearIcon)
            const Icon(Icons.close, color: AppColors.black, size: 20),
        ],
      ),
    );
  }

  Widget _buildExploreButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {},
        child: const Text('Explore Cabs', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
