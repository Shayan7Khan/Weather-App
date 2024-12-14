import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:weather_app/secrets.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future getCurrentWeather() async {
    //the cityname was in the api but we got it out in separate variable to clear my concept
    String cityName = 'London';
    //Uri stands for "uniform resource identifier" and URL stands for "Unified Resource Locater"
    final res = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&APPID=$openWeatherApiKey',
      ),
    );
    print(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              print('refresh');
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Main Card
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                //using widget ClipRRect to add some border radius because with the backdrop filter the elevation of our card totally vanishes
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    //blurs the background
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '300°K ',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Icon(
                            Icons.cloud,
                            size: 64,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Rain',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            //weather cards
            //using the Align widget to align our text where ever we want it to be aligned.
            // const Align(
            //   alignment: Alignment.topLeft,
            //   child:
            const Text(
              'Weather Forecast',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),

            //to make the row scrollable
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              //Row to display weather cards
              child: Row(
                children: [
                  HourlyForecastItems(
                    time: '5:00',
                    icon: Icons.cloud,
                    value: '200.12',
                  ),
                  HourlyForecastItems(
                    time: '5:00',
                    icon: Icons.cloud,
                    value: '200.12',
                  ),
                  HourlyForecastItems(
                    time: '5:00',
                    icon: Icons.cloud,
                    value: '200.12',
                  ),
                  HourlyForecastItems(
                    time: '5:00',
                    icon: Icons.cloud,
                    value: '200.12',
                  ),
                  HourlyForecastItems(
                    time: '5:00',
                    icon: Icons.cloud,
                    value: '200.12',
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            //additional Information
            const Text(
              'Additional Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditionalInfoItem(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '91',
                ),
                AdditionalInfoItem(
                  icon: Icons.air,
                  label: 'Wind Speed',
                  value: '7.5',
                ),
                AdditionalInfoItem(
                  icon: Icons.beach_access,
                  label: 'Pressure',
                  value: '1000',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
