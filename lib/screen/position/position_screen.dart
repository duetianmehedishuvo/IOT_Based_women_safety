import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:women_safety/data/model/response/Forecast_weather_model.dart';
import 'package:women_safety/helper/message_dao.dart';
import 'package:women_safety/provider/location_provider.dart';
import 'package:women_safety/provider/weather_provider.dart';
import 'package:women_safety/screen/dashboard/dashboard_screen.dart';
import 'package:women_safety/util/theme/app_colors.dart';
import 'package:women_safety/util/theme/text.styles.dart';

class PositionScreen extends StatelessWidget {
  final LatLng latLng;
  const PositionScreen(this.latLng,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Position Wise Response')),
      body: Consumer2<LocationProvider, WeatherProvider>(
        builder: (context, locationProvider, weatherProvider, child) => StreamBuilder(
            stream: MessageDao.messagesRef.onValue,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (!snapshot.hasData || locationProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }


              weatherProvider.calculateDistance(latLng);


              return ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                children: [
                  deviceWeatherResult(snapshot, context),
                  const SizedBox(height: 15),
                  childPositionWiseWeatherWidget(weatherProvider),
                  const SizedBox(height: 15),
                  childPositionWiseForecastWeatherWidget(weatherProvider, context),

                ],
              );
            }),
      ),
    );
  }



  Widget deviceWeatherResult(AsyncSnapshot<DatabaseEvent> snapshot, BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: colorPrimary.withOpacity(.2), blurRadius: 3.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))],
          border: Border.all(color: colorPrimary, width: 4)),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text('Device Result:', style: sfProStyle600SemiBold.copyWith(fontSize: 16), textAlign: TextAlign.center),
          const Text('---------------------------------------------------------------------------------------------------',
              maxLines: 1, style: TextStyle(color: colorPrimary, wordSpacing: 2)),
          rowWidget(
              'Last Updated At:',
              '${snapshot.data!.snapshot.child('WeatherEye').children.singleWhere((element) => element.key == 'Date').value} ${snapshot.data!.snapshot.child('WeatherEye').children.singleWhere((element) => element.key == 'Time').value}',
              0),
          rowWidget('Temperature:',
              '${snapshot.data!.snapshot.child('WeatherEye').children.singleWhere((element) => element.key == 'Temperature').value} ºC', 1),
          rowWidget('Humidity:',
              '${snapshot.data!.snapshot.child('WeatherEye').children.singleWhere((element) => element.key == 'Humidity').value}%', 2),
        ],
      ),
    );
  }

  Widget childPositionWiseForecastWeatherWidget(WeatherProvider weatherProvider, BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: colorPrimary.withOpacity(.2), blurRadius: 3.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))],
          border: Border.all(color: colorPrimary, width: 4)),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text('CHILD POSITION WISE NEXT 16 DAYS FORECAST WEATHER:',
              style: sfProStyle600SemiBold.copyWith(fontSize: 16), textAlign: TextAlign.center),
          const Text('---------------------------------------------------------------------------------------------------',
              maxLines: 1, style: TextStyle(color: colorPrimary, wordSpacing: 2)),
          SizedBox(
            height: 230,
            child: ListView.builder(
                itemCount: weatherProvider.forecastWeatherList.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  ForecastWeatherModel forecastWeatherModel = weatherProvider.forecastWeatherList[index];
                  return SizedBox(
                    width: 180,
                    child: Column(
                      children: [
                        Text('${forecastWeatherModel.datetime}',
                            style: sfProStyle600SemiBold.copyWith(fontSize: 16), textAlign: TextAlign.center),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.network('https://www.weatherbit.io/static/img/icons/${forecastWeatherModel.weather!.icon}.png',
                                width: 40, height: 40),
                            Expanded(
                                child:
                                Text(forecastWeatherModel.weather!.description!, style: sfProStyle400Regular.copyWith(fontSize: 16))),
                          ],
                        ),
                        rowWidget('Max Temp:', '${forecastWeatherModel.highTemp} ºC', 0),
                        rowWidget('Min Temp:', '${forecastWeatherModel.lowTemp} ºC', 1),
                        rowWidget('Ozone:', '${forecastWeatherModel.ozone} Du', 2),
                        rowWidget('Wind speed:', '${forecastWeatherModel.windSpd} m/s', 3),
                        rowWidget('Wind direction:', '${forecastWeatherModel.windDir} º', 4),
                        rowWidget('Visibility:', '${forecastWeatherModel.vis} KM', 5),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget childPositionWiseWeatherWidget(WeatherProvider weatherProvider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: colorPrimary.withOpacity(.2), blurRadius: 3.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))],
          border: Border.all(color: colorPrimary, width: 4)),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text('CHILD POSITION WISE WEATHER:', style: sfProStyle600SemiBold.copyWith(fontSize: 16), textAlign: TextAlign.center),
          const Text('---------------------------------------------------------------------------------------------------',
              maxLines: 1, style: TextStyle(color: colorPrimary, wordSpacing: 2)),
          weatherProvider.currentWeatherModel.weather == null
              ? const SizedBox.shrink()
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              weatherProvider.currentWeatherModel.weather == null
                  ? const SizedBox.shrink()
                  : Image.network(
                  'https://www.weatherbit.io/static/img/icons/${weatherProvider.currentWeatherModel.weather!.icon}.png',
                  width: 80,
                  height: 80),
              Text(weatherProvider.currentWeatherModel.weather!.description!, style: sfProStyle400Regular.copyWith(fontSize: 16)),
              Text('${weatherProvider.currentWeatherModel.temp.toString()} ºC',
                  style: sfProStyle800ExtraBold.copyWith(fontSize: 17, color: colorPrimary)),
            ],
          ),
          const Text('---------------------------------------------------------------------------------------------------',
              maxLines: 1, style: TextStyle(color: colorPrimary, wordSpacing: 2)),
          rowWidget('Pressure:', '${weatherProvider.currentWeatherModel.pres} mb', 0),
          rowWidget('Wind speed:', '${weatherProvider.currentWeatherModel.windSpd} m/s', 1),
          rowWidget('Wind direction:', '${weatherProvider.currentWeatherModel.windDir} º', 2),
          rowWidget('Humidity:', '${weatherProvider.currentWeatherModel.rh} %', 3),
          rowWidget('Cloud coverage:', '${weatherProvider.currentWeatherModel.clouds} %', 4),
          rowWidget('Visibility:', '${weatherProvider.currentWeatherModel.vis} KM', 5),
          rowWidget('Air Quality:', '${weatherProvider.currentWeatherModel.aqi}', 6),
        ],
      ),
    );
  }


}
