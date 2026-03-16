import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/home_providers.dart';

class BookingFormWidget extends ConsumerWidget {
  const BookingFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripMode = ref.watch(tripModeProvider);

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
            title: tripMode == TripMode.roundTrip
                ? 'Pickup City'
                : 'Pick-up City',
            subtitle: 'Type City Name',
            trailingWidget: const Icon(
              Icons.close,
              color: AppColors.black,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          _buildFormFieldRow(
            iconWidget: SvgPicture.asset(
              'assets/drop_city_icon.svg',
              height: 24,
            ),
            title: tripMode == TripMode.roundTrip ? 'Destination' : 'Drop City',
            subtitle: 'Type City Name',
            trailingWidget: tripMode == TripMode.roundTrip
                ? const Icon(Icons.add, color: AppColors.black, size: 24)
                : const Icon(Icons.close, color: AppColors.black, size: 20),
          ),
          const SizedBox(height: 12),
          if (tripMode == TripMode.roundTrip)
            _buildRoundTripDateSelector()
          else
            _buildFormFieldRow(
              iconWidget: SvgPicture.asset(
                'assets/pickupdate_icon.svg',
                height: 24,
              ),
              title: 'Pick-up Date',
              subtitle: 'DD-MM-YYYY',
            ),
          const SizedBox(height: 12),
          _buildFormFieldRow(
            iconWidget: SvgPicture.asset('assets/timer_icon.svg', height: 24),
            title: 'Time',
            subtitle: 'HH:MM',
          ),
          const SizedBox(height: 24),
          _buildExploreButton(),
        ],
      ),
    );
  }

  Widget _buildRoundTripDateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            children: [
              const Text(
                'From Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'DD-MM-YYYY',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            ],
          ),
        ),
        CircleAvatar(
          backgroundColor: const Color(0xFFE2F4D7),
          radius: 28,
          child: SvgPicture.asset('assets/pickupdate_icon.svg', height: 32),
        ),
        Expanded(
          child: Column(
            children: [
              const Text(
                'To Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'DD-MM-YYYY',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormFieldRow({
    required Widget iconWidget,
    required String title,
    required String subtitle,
    Widget? trailingWidget,
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
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          if (trailingWidget != null) trailingWidget,
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
        child: const Text(
          'Explore Cabs',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
