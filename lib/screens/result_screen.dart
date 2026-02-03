import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trip.dart';
import '../providers/trip_provider.dart';
import '../services/carbon_calculator.dart';
import '../theme/app_theme.dart';

class ResultScreen extends StatelessWidget {
  final Trip trip;

  const ResultScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final impact = CarbonCalculator.getImpactLevel(trip.co2Emissions);
    final color = _getImpactColor(impact);

    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildResultCard(context, impact, color),
            const Spacer(),
            _buildDetailsCard(),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                context.read<TripProvider>().addTrip(trip);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Trip saved to history!')),
                );
              },
              child: const Text('Save to History'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, String impact, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 24),
          Text(
            '${trip.co2Emissions.toStringAsFixed(2)} kg',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.darkNavy,
            ),
          ),
          Text(
            'CO₂ Emissions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.slateGray,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              impact,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildDetailRow('Vehicle', trip.vehicleType.name.toUpperCase()),
            const Divider(height: 24),
            _buildDetailRow('Fuel', trip.fuelType.name.toUpperCase()),
            const Divider(height: 24),
            _buildDetailRow('Distance', '${trip.distance} km'),
            const Divider(height: 24),
            _buildDetailRow('Efficiency', '${trip.efficiency} km/unit'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
// 
  Color _getImpactColor(String impact) {
    switch (impact) {
      case 'Low Impact': return AppTheme.lowEmissionColor;
      case 'Moderate Impact': return AppTheme.moderateEmissionColor;
      default: return AppTheme.highEmissionColor;
    }
  }
}
