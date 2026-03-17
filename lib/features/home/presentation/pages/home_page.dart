import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/home_providers.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_header_info.dart';
import '../widgets/trip_selectors_widget.dart';
import '../widgets/booking_form_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeAppBar(),
              const SizedBox(height: 20),
              const HomeHeadline(),
              const SizedBox(height: 20),
              const PromotionalBanner(),
              const SizedBox(height: 20),
              const TripTypeSelector(),
              const SizedBox(height: 16),

              Consumer(
                builder: (context, ref, child) {
                  final category = ref.watch(tripCategoryProvider);
                  // Hide mode toggle (One-way/Round) when Local is selected
                  if (category == TripCategory.local) {
                    return const SizedBox.shrink();
                  }

                  return const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: TripModeToggle(),
                  );
                },
              ),

              const BookingFormWidget(),
              const SizedBox(height: 24),
              const BottomIllustration(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primaryGreen,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.black,
        unselectedItemColor: AppColors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/home_icon.svg',
              width: 24,
              colorFilter: ColorFilter.mode(
                _currentIndex == 0 ? AppColors.black : AppColors.white,
                BlendMode.srcIn,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/mytrip_icon.svg',
              width: 24,
              colorFilter: ColorFilter.mode(
                _currentIndex == 1 ? AppColors.black : AppColors.white,
                BlendMode.srcIn,
              ),
            ),
            label: 'My Trip',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/Group 31.svg',
              width: 24,
              colorFilter: ColorFilter.mode(
                _currentIndex == 2 ? AppColors.black : AppColors.white,
                BlendMode.srcIn,
              ),
            ),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/more_icon.svg',
              width: 24,
              colorFilter: ColorFilter.mode(
                _currentIndex == 3 ? AppColors.black : AppColors.white,
                BlendMode.srcIn,
              ),
            ),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
