enum FuelType {
  gasoline,
  diesel,
  electric,
  lpg,
}

enum VehicleType {
  car,
  motorcycle,
  bus,
  truck,
}

class Trip {
  final String id;
  final VehicleType vehicleType;
  final FuelType fuelType;
  final double efficiency; // km/l or km/kWh
  final double distance; // km
  final DateTime date;
  final double co2Emissions; // kg

  Trip({
    required this.id,
    required this.vehicleType,
    required this.fuelType,
    required this.efficiency,
    required this.distance,
    required this.date,
    required this.co2Emissions,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleType': vehicleType.index,
      'fuelType': fuelType.index,
      'efficiency': efficiency,
      'distance': distance,
      'date': date.toIso8601String(),
      'co2Emissions': co2Emissions,
    };
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      vehicleType: VehicleType.values[json['vehicleType']],
      fuelType: FuelType.values[json['fuelType']],
      efficiency: json['efficiency'],
      distance: json['distance'],
      date: DateTime.parse(json['date']),
      co2Emissions: json['co2Emissions'],
    );
  }
}
