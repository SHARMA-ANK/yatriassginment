import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/home_providers.dart';

class BookingFormWidget extends ConsumerStatefulWidget {
  const BookingFormWidget({super.key});

  @override
  ConsumerState<BookingFormWidget> createState() => _BookingFormWidgetState();
}

class _BookingFormWidgetState extends ConsumerState<BookingFormWidget> {
  final Dio _dio = Dio();
  Timer? _debounce;
  Completer<Iterable<String>>? _completer;

  TextEditingController? _pickupController;
  TextEditingController? _destinationController;

  DateTime? _pickupDate;
  DateTime? _fromDate;
  DateTime? _toDate;
  TimeOfDay? _pickupTime;

  String _formatDate(DateTime? date) {
    if (date == null) return 'DD-MM-YYYY';
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'HH:MM AM/PM';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  Future<void> _selectDate(BuildContext context, {required bool isRoundTrip, bool isFrom = false}) async {
    final DateTime initialDate = isFrom ? (_fromDate ?? DateTime.now()) : (!isFrom && isRoundTrip ? (_toDate ?? _fromDate ?? DateTime.now()) : (_pickupDate ?? DateTime.now()));
    final DateTime firstDateDate = (!isFrom && isRoundTrip && _fromDate != null) ? _fromDate! : DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDateDate,
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: AppColors.white,
              onSurface: AppColors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryGreen,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isRoundTrip) {
          if (isFrom) {
            _fromDate = picked;
            if (_toDate != null && _toDate!.isBefore(_fromDate!)) {
              _toDate = null;
            }
          } else {
            _toDate = picked;
          }
        } else {
          _pickupDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _pickupTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: AppColors.white,
              onSurface: AppColors.black,
              surfaceTint: AppColors.white,
            ),
            timePickerTheme: TimePickerThemeData(
              dialHandColor: AppColors.primaryGreen,
              hourMinuteColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected) ? AppColors.primaryGreen : const Color(0xFFE2F4D7)),
              hourMinuteTextColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected) ? AppColors.white : AppColors.black),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryGreen,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _pickupTime = picked;
      });
    }
  }

  Future<Iterable<String>> _fetchLocations(String query) async {
    if (query.isEmpty || query.length < 3) return const Iterable<String>.empty();

    // Cancel the previous timer if the user is still typing
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
      // Complete the previous future with an empty list so Autocomplete doesn't hang
      if (_completer != null && !_completer!.isCompleted) {
        _completer!.complete(const Iterable<String>.empty());
      }
    }

    _completer = Completer<Iterable<String>>();

    // Wait for 800 milliseconds of pause before firing the request
    _debounce = Timer(const Duration(milliseconds: 800), () async {
      try {
        final response = await _dio.get(
          'https://api.geoapify.com/v1/geocode/autocomplete',
          queryParameters: {
            'text': query,
            'apiKey': '985f8086ab654265beded7b969399a18',
          },
        );
        
        final data = response.data['features'] as List;
        final results = data.map((e) {
          final properties = e['properties'] as Map<String, dynamic>;
          return properties['formatted']?.toString() ?? properties['city']?.toString() ?? 'Unknown Location';
        }).toSet().toList();
        
        if (_completer != null && !_completer!.isCompleted) {
          _completer!.complete(results);
        }
      } catch (e) {
        if (_completer != null && !_completer!.isCompleted) {
          _completer!.complete(const Iterable<String>.empty());
        }
      }
    });

    return _completer!.future;
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(tripModeProvider);
    final category = ref.watch(tripCategoryProvider);

    final bool isRoundTrip = mode == TripMode.roundTrip;
    final bool isLocal = category == TripCategory.local;
    final bool isAirport = category == TripCategory.airport;

    String pickupLabel = 'Pick-up City';
    if (isAirport) pickupLabel = 'Pickup Airport';

    String destinationLabel = 'Destination';
    if (isRoundTrip && !isLocal && !isAirport) {
      destinationLabel = 'Destination';
    } else if (!isRoundTrip && !isLocal && !isAirport) {
      destinationLabel = 'Drop City';
    } else if (isAirport) {
      destinationLabel = 'Drop City';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFormFieldRow(
            iconWidget: Image.asset('assets/pickup_icon.png', height: 24),
            title: pickupLabel,
            hint: 'Type City Name',
            trailingWidget: !isLocal
                ? GestureDetector(
                    onTap: () {
                      _pickupController?.clear();
                    },
                    child: const Icon(Icons.close, color: AppColors.black, size: 20),
                  )
                : null,
            isAutocomplete: true,
            onControllerReady: (c) => _pickupController = c,
          ),
          const SizedBox(height: 12),

          if (!isLocal) ...[
            _buildFormFieldRow(
              iconWidget: SvgPicture.asset(
                'assets/drop_city_icon.svg',
                height: 24,
              ),
              title: destinationLabel,
              hint: 'Type City Name',
              trailingWidget: isRoundTrip
                  ? const Icon(Icons.add, color: AppColors.black, size: 24)
                  : GestureDetector(
                      onTap: () {
                        _destinationController?.clear();
                      },
                      child: const Icon(Icons.close, color: AppColors.black, size: 20),
                    ),
              isAutocomplete: true,
              onControllerReady: (c) => _destinationController = c,
            ),
            const SizedBox(height: 12),
          ],

          if (isRoundTrip && !isLocal && !isAirport)
            _buildRoundTripDateSelector()
          else ...[
            _buildFormFieldRow(
              iconWidget: SvgPicture.asset(
                'assets/pickupdate_icon.svg',
                height: 24,
              ),
              title: isLocal ? 'Pickup Date' : 'Pick-up Date',
              hint: _formatDate(_pickupDate),
              onTap: () => _selectDate(context, isRoundTrip: false),
            ),
            const SizedBox(height: 12),
          ],

          _buildFormFieldRow(
            iconWidget: SvgPicture.asset('assets/timer_icon.svg', height: 24),
            title: 'Time',
            hint: _formatTime(_pickupTime),
            onTap: () => _selectTime(context),
          ),
          const SizedBox(height: 24),

          _buildExploreButton(),
        ],
      ),
    );
  }

  Widget _buildRoundTripDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE2F4D7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _selectDate(context, isRoundTrip: true, isFrom: true),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  Text(
                    _formatDate(_fromDate),
                    style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: AppColors.white,
            radius: 24,
            child: SvgPicture.asset('assets/pickupdate_icon.svg', height: 28),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _selectDate(context, isRoundTrip: true, isFrom: false),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  Text(
                    _formatDate(_toDate),
                    style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFieldRow({
    required Widget iconWidget,
    required String title,
    required String hint,
    Widget? trailingWidget,
    bool isAutocomplete = false,
    void Function(TextEditingController)? onControllerReady,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE2F4D7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          iconWidget,
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                    fontSize: 13,
                  ),
                ),
                if (isAutocomplete)
                  SizedBox(
                    height: 24,
                    child: Autocomplete<String>(
                      optionsBuilder:
                          (TextEditingValue textEditingValue) async {
                            if (textEditingValue.text == '') {
                              return const Iterable<String>.empty();
                            }
                            return await _fetchLocations(textEditingValue.text);
                          },
                      onSelected: (String selection) {
                        debugPrint('You just selected ');
                      },
                      fieldViewBuilder:
                          (
                            context,
                            textEditingController,
                            focusNode,
                            onFieldSubmitted,
                          ) {
                            if (onControllerReady != null) {
                              // We use a post-frame callback to avoid state issues if updating during build
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                onControllerReady(textEditingController);
                              });
                            }
                            return TextField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                              decoration: InputDecoration(
                                hintText: hint,
                                hintStyle: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            );
                          },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 250,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final String option = options.elementAt(
                                    index,
                                  );
                                  return InkWell(
                                    onTap: () {
                                      onSelected(option);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(option),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else ...[
                  const SizedBox(height: 4),
                  Text(
                    hint,
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          trailingWidget ?? const SizedBox.shrink(),
        ],
      ),
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
          elevation: 0,
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
