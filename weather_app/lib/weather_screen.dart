import 'dart:convert';
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
  //dynamic in generics because stuff keeps on changing on the value side, sometimes it is integer, string etc
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      //the cityname was in the api but we got it out in separate variable to clear my concept
      String cityName = 'London';
      //Uri stands for "uniform resource identifier" and URL stands for "Unified Resource Locater"
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherApiKey',
        ),
      );
      //jsonDecode converts the data from api into list/maps which we can use to show and res.body mean accessing just the data present in the body of the api not the header and anything else.
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
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
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        //snapshot is a class that allows us to handle states in our app like loading, error, data states etc
        builder: (context, snapshot) {
          //to handle loading state
          //we are saying over here that if the app is running and the api is being called and it is in waiting state so show the loading indicator. ConnectionState is a enum.
          if (snapshot.connectionState == ConnectionState.waiting) {
            //the ".adaptive" actually changes the progress bar according to the OS we are using, if we are using IOS it will show its loading screen and if we are using android it will show android's loading screen.
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          //to handle error state
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          //to handle data state
          final data = snapshot.data!;
          final currentWeather = data['list'][0];
          //to get the current Temperature
          final currentTemp = currentWeather['main']['temp'];
          //to get the current info if its raining or cloudy or sunny etc
          final currentSky = currentWeather['weather'][0]['main'];

          //to get the additional information.
          //1. Pressure
          final currentPressure = currentWeather['main']['pressure'];
          //2.Windspeed
          final currentWindSpeed = currentWeather['wind']['speed'];
          //3.Humidity
          final currentHumidity = currentWeather['main']['humidity'];

          return Padding(
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
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp K ',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Icon(
                                //condition to check if its cloudy or raining then show the cloud icon, otherwise show the sunny icon.
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                currentSky,
                                style: const TextStyle(fontSize: 20),
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
                  'Hourly Forecast',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: currentWindSpeed.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: currentPressure.toString(),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
