import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_header_info.dart';
import '../widgets/trip_selectors_widget.dart';
import '../widgets/booking_form_widget.dart';
import 'my_trip_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _HomeTabView(),
    const MyTripPage(),
    const Center(child: Text('Account', style: TextStyle(color: Colors.white, fontSize: 24))),
    const Center(child: Text('More', style: TextStyle(color: Colors.white, fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: _pages[_currentIndex],
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
            icon: SvgPicture.asset('assets/home_icon.svg', width: 24, colorFilter: ColorFilter.mode(_currentIndex == 0 ? AppColors.black : AppColors.white, BlendMode.srcIn)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/mytrip_icon.svg', width: 24, colorFilter: ColorFilter.mode(_currentIndex == 1 ? AppColors.black : AppColors.white, BlendMode.srcIn)),
            label: 'My Trip',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/Group 31.svg', width: 24, colorFilter: ColorFilter.mode(_currentIndex == 2 ? AppColors.black : AppColors.white, BlendMode.srcIn)),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/more_icon.svg', width: 24, colorFilter: ColorFilter.mode(_currentIndex == 3 ? AppColors.black : AppColors.white, BlendMode.srcIn)),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

class _HomeTabView extends StatelessWidget {
  const _HomeTabView();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeAppBar(),
          SizedBox(height: 20),
          HomeHeadline(),
          SizedBox(height: 20),
          PromotionalBanner(),
          SizedBox(height: 20),
          TripTypeSelector(),
          SizedBox(height: 16),
          TripModeToggle(),
          SizedBox(height: 16),
          BookingFormWidget(),
          SizedBox(height: 24),
          BottomIllustration(),
        ],
      ),
    );
  }
}
