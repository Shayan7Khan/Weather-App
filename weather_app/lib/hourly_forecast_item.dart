import 'package:flutter/material.dart';

//creating a separate class for them as they are being reused again.
class HourlyForecastItems extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;

  const HourlyForecastItems(
      {super.key, required this.time, required this.icon, required this.temp});

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
              //restricting this text to just one line because our listview builder is given 120 height and if the text wants more space or exceeds this height it will give error
              maxLines: 1,

              //this gives us that '...' after the text limited to one line to tell that it includes more text.
              overflow: TextOverflow.ellipsis,
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
              temp,
            ),
          ],
        ),
      ),
    );
  }
}
