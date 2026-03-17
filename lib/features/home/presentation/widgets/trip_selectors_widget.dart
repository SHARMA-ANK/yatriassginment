import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/home_providers.dart';

class TripTypeSelector extends ConsumerWidget {
  const TripTypeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(tripCategoryProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTripTypeCard(
          ref: ref,
          category: TripCategory.outstation, 
          assetPath: 'assets/OutstationIcon.svg', 
          label: 'Outstation Trip', 
          isSelected: selectedCategory == TripCategory.outstation,
          isSvg: true,
        ),
        _buildTripTypeCard(
          ref: ref,
          category: TripCategory.local, 
          assetPath: 'assets/LocalTrip_icon.png', 
          label: 'Local Trip',
          isSelected: selectedCategory == TripCategory.local,
          isSvg: false,
        ),
        _buildTripTypeCard(
          ref: ref,
          category: TripCategory.airport,
          assetPath: 'assets/AirportTransfer_icon.png',
          label: 'Airport Transfer',
          isSelected: selectedCategory == TripCategory.airport,
          isSvg: false,
        ),
      ],
    );
  }

  Widget _buildTripTypeCard({
    required WidgetRef ref,
    required TripCategory category,
    required String assetPath,
    required String label,
    required bool isSelected,
    required bool isSvg,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(tripCategoryProvider.notifier).state = category,  
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryGreen : AppColors.white,       
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSvg)
                SvgPicture.asset(
                  assetPath,
                  height: 32,
                  colorFilter: ColorFilter.mode(
                    isSelected ? AppColors.white : AppColors.black,
                    BlendMode.srcIn,
                  ),
                )
              else
                Image.asset(
                  assetPath,
                  height: 32,
                  color: isSelected ? AppColors.white : AppColors.black,
                ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? AppColors.white : AppColors.black,        
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TripModeToggle extends ConsumerWidget {
  const TripModeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(tripModeProvider);
    final category = ref.watch(tripCategoryProvider);

    final bool isAirport = category == TripCategory.airport;
    final String leftText = isAirport ? 'To The Airport' : 'One-way';
    final String rightText = isAirport ? 'From The Airport' : 'Round Trip';

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => ref.read(tripModeProvider.notifier).state = TripMode.oneWay,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: mode == TripMode.oneWay ? AppColors.primaryGreen : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: mode == TripMode.oneWay ? null : Border.all(color: AppColors.primaryGreen, width: 1),
              ),
              alignment: Alignment.center,
              child: Text(
                leftText,
                style: TextStyle(
                  color: mode == TripMode.oneWay ? AppColors.white : AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => ref.read(tripModeProvider.notifier).state = TripMode.roundTrip,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: mode == TripMode.roundTrip ? AppColors.primaryGreen : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: mode == TripMode.roundTrip ? null : Border.all(color: AppColors.primaryGreen, width: 1),
              ),
              alignment: Alignment.center,
              child: Text(
                rightText,
                style: TextStyle(
                  color: mode == TripMode.roundTrip ? AppColors.white : AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
