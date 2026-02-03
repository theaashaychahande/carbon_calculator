import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trip.dart';

class TripProvider with ChangeNotifier {
  List<Trip> _trips = [];
  bool _isLoading = true;

  List<Trip> get trips => _trips;
  bool get isLoading => _isLoading;

  TripProvider() {
    loadTrips();
  }

  Future<void> loadTrips() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? tripsJson = prefs.getString('trips');
      
      if (tripsJson != null) {
        final List<dynamic> decoded = json.decode(tripsJson);
        _trips = decoded.map((item) => Trip.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('Error loading trips: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTrip(Trip trip) async {
    _trips.insert(0, trip);
    notifyListeners();
    await _saveTrips();
  }

  Future<void> deleteTrip(String id) async {
    _trips.removeWhere((trip) => trip.id == id);
    notifyListeners();
    await _saveTrips();
  }

  Future<void> _saveTrips() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = json.encode(_trips.map((trip) => trip.toJson()).toList());
      await prefs.setString('trips', encoded);
    } catch (e) {
      debugPrint('Error saving trips: $e');
    }
  }

  double get totalEmissions => _trips.fold(0, (sum, trip) => sum + trip.co2Emissions);
  
  Map<VehicleType, double> get emissionsByVehicleType {
    Map<VehicleType, double> data = {};
    for (var trip in _trips) {
      data[trip.vehicleType] = (data[trip.vehicleType] ?? 0) + trip.co2Emissions;
    }
    return data;
  }
}
