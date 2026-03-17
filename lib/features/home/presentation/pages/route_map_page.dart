import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';

class RouteMapPage extends StatefulWidget {
  final LatLng pickup;
  final LatLng destination;
  final String pickupName;
  final String destinationName;

  const RouteMapPage({
    super.key,
    required this.pickup,
    required this.destination,
    required this.pickupName,
    required this.destinationName,
  });

  @override
  State<RouteMapPage> createState() => _RouteMapPageState();
}

class _RouteMapPageState extends State<RouteMapPage> {
  List<LatLng> routePoints = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.geoapify.com/v1/routing',
        queryParameters: {
          'waypoints': '${widget.pickup.latitude},${widget.pickup.longitude}|${widget.destination.latitude},${widget.destination.longitude}',
          'mode': 'drive',
          'apiKey': '985f8086ab654265beded7b969399a18',
        },
      );

      final features = response.data['features'] as List;
      if (features.isNotEmpty) {
        final List<LatLng> points = [];
        final geometry = features[0]['geometry'];
        final type = geometry['type'];
        
        if (type == 'MultiLineString') {
          final coordinates = geometry['coordinates'] as List;
          for (final line in coordinates) {
            for (final coord in line) {
              points.add(LatLng(coord[1] as double, coord[0] as double));
            }
          }
        }
        
        setState(() {
          routePoints = points;
          isLoading = false;
        });
      } else {
        _fallbackRoute();
      }
    } catch (e) {
      debugPrint('Routing error: $e');
      _fallbackRoute();
    }
  }

  void _fallbackRoute() {
    setState(() {
      routePoints = [widget.pickup, widget.destination];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Route', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCameraFit: CameraFit.bounds(
            bounds: LatLngBounds.fromPoints([widget.pickup, widget.destination]),
            padding: const EdgeInsets.all(50.0),
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://maps.geoapify.com/v1/tile/osm-carto/{z}/{x}/{y}.png?apiKey=985f8086ab654265beded7b969399a18',
            userAgentPackageName: 'com.example.yatriassginment',
          ),
          if (routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: routePoints,
                  color: Colors.blue,
                  strokeWidth: 4.0,
                ),
              ],
            ),
          MarkerLayer(
            markers: [
              Marker(
                point: widget.pickup,
                width: 40,
                height: 40,
                child: const Icon(Icons.location_on, color: Colors.green, size: 40),
              ),
              Marker(
                point: widget.destination,
                width: 40,
                height: 40,
                child: const Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
