import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

                // //to make the row scrollable
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,

                //   //Row to display weather cards
                //   child: Row(
                //     children: [
                //       //using for loop to iterate through the list and display the required data that we need
                //       for (int i = 0; i < 38; i++)
                //         HourlyForecastItems(
                //           //below statement means that in the data go to list and as the loop is at i=0 so start from i+1 meaning that skip the first index in the list and from the next index get the 'dt'
                //           time: data['list'][i + 1]['dt'].toString(),

                //           //going to the list skipping the first index moving on to the next and checking if that is equals to clouds or rain then display the clouds icon otherwise display the sun icon
                //           icon: data['list'][i + 1]['weather'][0]['main'] ==
                //                       'Clouds' ||
                //                   data['list'][i + 1]['weather'][0]['main'] ==
                //                       'Rain'
                //               ? Icons.cloud
                //               : Icons.sunny,

                //               //going to the list skipping the first index and from the next index getting the temperature and displaying it on the hourly forecast weather
                //           value: data['list'][i + 1]['main']['temp'].toString(),
                //         ),
                //     ],
                //   ),
                // ),

                //the above mentioned code is using for loop in which we are referring to the data in our api and from there through the loop we are getting our data for hourly forecast weather but it is building 39 widgets at the same time which is effecting our app's performance therefore we are using another approach below.

                //using sized box because the listview builder just like the text takes up the whole screen so we are using sized box to restrict it on using just the height of 120.
                SizedBox(
                  height: 120,
                  //listview.builder will build on demand, accepts item builder which requires a widget to be returned
                  child: ListView.builder(
                    //we gave the itemcount of 5 so that it knows how much on demand widget we need to build
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      //storing the data into variables
                      final hourlyForecast = data['list'][index + 1];
                      final hourlyForecastSky =
                          data['list'][index + 1]['weather'][0]['main'];

                      //we are using the intl package of the dart to format our time so therefore we are parsing the text related to time that we are getting from the data and then storing it in the time variable.
                      final time = DateTime.parse(hourlyForecast['dt_txt']);

                      //returing the hourly forecast weather data
                      return HourlyForecastItems(
                        //here we are using the intl package provided by the dart to format the time in a way we want, in this case we want the time to be like 00(hours):00(minutes) so therefore we used the .Hm (hour,minutes) and passed the time in which our data is stored. in this way the text from the api is parsed and stored in the time variable and here it is formatted into hours and minutes format.
                        time: DateFormat.Hm().format(time),
                        icon: hourlyForecastSky == 'Clouds' ||
                                hourlyForecastSky == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                        temp: hourlyForecast['main']['temp'].toString(),
                      );
                    },
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
