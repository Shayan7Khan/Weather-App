import 'package:flutter/material.dart';

//creating a separate class for them as they are being reused again.
class HourlyForecastItems extends StatelessWidget {
  final String time;
  final IconData icon;
  final String value;

  const HourlyForecastItems(
      {super.key, required this.time, required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
            ),
          ],
        ),
      ),
    );
  }
}
