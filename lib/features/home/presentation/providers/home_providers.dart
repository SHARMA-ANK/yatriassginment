import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

enum TripCategory { outstation, local, airport }

enum TripMode { oneWay, roundTrip }

final tripCategoryProvider = StateProvider<TripCategory>(
  (ref) => TripCategory.outstation,
);
final tripModeProvider = StateProvider<TripMode>((ref) => TripMode.oneWay);
