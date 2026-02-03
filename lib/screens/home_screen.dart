import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/trip.dart';
import '../services/carbon_calculator.dart';

import '../theme/app_theme.dart';
import 'result_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  VehicleType _selectedVehicle = VehicleType.car;
  FuelType _selectedFuel = FuelType.gasoline;
  final _efficiencyController = TextEditingController();
  final _distanceController = TextEditingController();

  @override
  void dispose() {
    _efficiencyController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final efficiency = double.parse(_efficiencyController.text);
      final distance = double.parse(_distanceController.text);
      
      final emissions = CarbonCalculator.calculateEmissions(
        fuelType: _selectedFuel,
        efficiency: efficiency,
        distance: distance,
      );
 //
      final trip = Trip(
        id: const Uuid().v4(),
        vehicleType: _selectedVehicle,
        fuelType: _selectedFuel,
        efficiency: efficiency,
        distance: distance,
        date: DateTime.now(),
        co2Emissions: emissions,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(trip: trip),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carbon Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildVehicleSelector(),
                const SizedBox(height: 24),
                _buildFuelSelector(),
                const SizedBox(height: 24),
                _buildInputs(),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: _calculate,
                  child: const Text('Calculate Footprint'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Let\'s calculate your impact',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.darkNavy,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your trip details to see your CO₂ footprint.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Vehicle Type', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: VehicleType.values.map((type) {
            final isSelected = _selectedVehicle == type;
            return GestureDetector(
              onTap: () => setState(() => _selectedVehicle = type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryGreen : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryGreen : Colors.grey[300]!,
                  ),
                  boxShadow: isSelected 
                    ? [BoxShadow(color: AppTheme.primaryGreen.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))]
                    : [],
                ),
                child: Column(
                  children: [
                    Icon(
                      _getVehicleIcon(type),
                      color: isSelected ? Colors.white : AppTheme.slateGray,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      type.name[0].toUpperCase() + type.name.substring(1),
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : AppTheme.slateGray,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFuelSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Fuel Type', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        DropdownButtonFormField<FuelType>(
          initialValue: _selectedFuel,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          items: FuelType.values.map((fuel) {
            return DropdownMenuItem(
              value: fuel,
              child: Text(fuel.name[0].toUpperCase() + fuel.name.substring(1)),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedFuel = value!),
        ),
      ],
    );
  }

  Widget _buildInputs() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Efficiency (km/unit)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _efficiencyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'e.g. 15.5',
                  prefixIcon: const Icon(Icons.bolt),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Distance (km)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _distanceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'e.g. 50',
                  prefixIcon: const Icon(Icons.add_location),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getVehicleIcon(VehicleType type) {
    switch (type) {
      case VehicleType.car: return Icons.directions_car;
      case VehicleType.motorcycle: return Icons.motorcycle;
      case VehicleType.bus: return Icons.directions_bus;
      case VehicleType.truck: return Icons.local_shipping;
    }
  }
}
