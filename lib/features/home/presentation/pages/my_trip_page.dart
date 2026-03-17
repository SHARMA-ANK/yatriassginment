import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';

class MyTripPage extends StatefulWidget {
  const MyTripPage({super.key});

  @override
  State<MyTripPage> createState() => _MyTripPageState();
}

class _MyTripPageState extends State<MyTripPage> {
  bool _isTracking = false;
  double _distanceInMeters = 0.0;
  Position? _lastPosition;
  StreamSubscription<Position>? _positionStream;

  Future<void> _toggleTracking() async {
    if (_isTracking) {
      // Stop tracking
      _positionStream?.cancel();
      setState(() {
        _isTracking = false;
      });
    } else {
      // Start tracking
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location services are disabled.')),
          );
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')),
            );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are permanently denied.'),
            ),
          );
        return;
      }

      try {
        final position = await Geolocator.getCurrentPosition();
        setState(() {
          _isTracking = true;
          _distanceInMeters = 0.0;
          _lastPosition = position;
        });

        _positionStream =
            Geolocator.getPositionStream(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high,
                distanceFilter: 2,
              ),
            ).listen((Position newPosition) {
              if (_lastPosition != null) {
                final distance = Geolocator.distanceBetween(
                  _lastPosition!.latitude,
                  _lastPosition!.longitude,
                  newPosition.latitude,
                  newPosition.longitude,
                );
                if (mounted) {
                  setState(() {
                    _distanceInMeters += distance;
                    _lastPosition = newPosition;
                  });
                }
              } else {
                _lastPosition = newPosition;
              }
            });
      } catch (e) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error getting location: ${e.toString()}')),
          );
      }
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_car, size: 64, color: AppColors.primaryGreen),
            const SizedBox(height: 16),
            const Text(
              'Realtime Trip Distance',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _distanceInMeters >= 1000
                  ? '${(_distanceInMeters / 1000).toStringAsFixed(2)} km'
                  : '${_distanceInMeters.toStringAsFixed(0)} m',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isTracking
                      ? Colors.red.shade400
                      : AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: _toggleTracking,
                child: Text(
                  _isTracking ? 'Stop Tracking' : 'Start Trip Tracker',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
