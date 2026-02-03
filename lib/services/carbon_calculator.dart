import '../models/trip.dart';

class CarbonCalculator {
  // Emission factors in kg CO2 per liter/unit
  // Sources approximate: EPA, UK Government GHG Conversion Factors
  static const Map<FuelType, double> emissionFactors = {
    FuelType.gasoline: 2.31,
    FuelType.diesel: 2.68,
    FuelType.lpg: 1.51,
    FuelType.electric: 0.4, // kg CO2 per kWh (depends on grid, using a global average)
  };

  static double calculateEmissions({
    required FuelType fuelType,
    required double efficiency,
    required double distance,
  }) {
    if (efficiency <= 0) return 0;
    
    final factor = emissionFactors[fuelType] ?? 0;
    
    // Emissions = (Distance / Efficiency) * Emission Factor
    // For electric, efficiency is usually km/kWh
    return (distance / efficiency) * factor;
  }
  
  static String getImpactLevel(double emissions) {
    if (emissions < 5) return 'Low Impact';
    if (emissions < 20) return 'Moderate Impact';
    return 'High Impact';
  }
}
