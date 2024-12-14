import 'package:flutter/material.dart';

//creating a separate class for them as they are being reused again.
class HourlyForecastItems extends StatelessWidget {
  const HourlyForecastItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: const Column(
          children: [
            Text(
              '5:00',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            Icon(
              Icons.cloud,
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              '200.12',
            ),
          ],
        ),
      ),
    );
  }
}
