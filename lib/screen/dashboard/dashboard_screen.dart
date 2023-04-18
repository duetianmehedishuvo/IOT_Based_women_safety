import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:women_safety/data/model/response/Forecast_weather_model.dart';
import 'package:women_safety/helper/message_dao.dart';
import 'package:women_safety/provider/location_provider.dart';
import 'package:women_safety/provider/weather_provider.dart';
import 'package:women_safety/screen/home/range_select_screen.dart';
import 'package:women_safety/screen/home_screen.dart';
import 'package:women_safety/util/helper.dart';
import 'package:women_safety/util/theme/app_colors.dart';
import 'package:women_safety/util/theme/text.styles.dart';
import 'package:women_safety/widgets/custom_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMART Child Care'),
      ),
      body: Consumer2<LocationProvider, WeatherProvider>(
        builder: (context, locationProvider, weatherProvider, child) => StreamBuilder(
            stream: MessageDao.messagesRef.onValue,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (!snapshot.hasData || locationProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              LatLng latLng = LatLng(double.parse(snapshot.data!.snapshot.child('Location').children.elementAt(7).value.toString()),
                  double.parse(snapshot.data!.snapshot.child('Location').children.elementAt(2).value.toString()));
              weatherProvider.calculateDistance(latLng);
              locationProvider.initializeRange(
                double.parse(snapshot.data!.snapshot.child('Location').children.elementAt(3).value.toString()),
                double.parse(snapshot.data!.snapshot.child('Location').children.elementAt(1).value.toString()),
                double.parse(snapshot.data!.snapshot.child('Location').children.elementAt(4).value.toString()),
                double.parse(snapshot.data!.snapshot.child('Location').children.elementAt(0).value.toString()),
                latLng.latitude,
                latLng.longitude,
                snapshot.data!.snapshot.child('Location').children.elementAt(6).value.toString(),
                snapshot.data!.snapshot.child('Location').children.elementAt(5).value.toString(),
              );

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                children: [
                  userPositionWidget(snapshot, locationProvider, latLng),
                  const SizedBox(height: 15),
                  childPositionWiseWeatherWidget(weatherProvider),
                  const SizedBox(height: 15),
                  childPositionWiseForecastWeatherWidget(weatherProvider, context)
                ],
              );
            }),
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

  Widget rowWidget(String title, String value, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: index % 2 == 0 ? colorGreenLight.withOpacity(.05) : colorGreenLight.withOpacity(.1)),
      child: Row(
        children: [
          Text(title, style: sfProStyle500Medium.copyWith(fontSize: 15)),
          const SizedBox(width: 10),
          Expanded(child: Text(value, style: sfProStyle400Regular.copyWith(fontSize: 15))),
        ],
      ),
    );
  }

  Widget userPositionWidget(AsyncSnapshot<DatabaseEvent> snapshot, LocationProvider locationProvider, LatLng latLng) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: colorPrimary.withOpacity(.2), blurRadius: 3.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))],
          border: Border.all(color: colorPrimary, width: 4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Helper.toScreen(const RangeSelectScreen(hasFromStartRange: true));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 5),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(.2), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
                        ],
                        borderRadius: BorderRadius.circular(4)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Start Range', style: sfProStyle500Medium.copyWith(fontSize: 15)),
                            const SizedBox(width: 8),
                            const Icon(Icons.edit, color: Colors.green, size: 17)
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(snapshot.data!.snapshot.child('Location').children.elementAt(6).value.toString(),
                            style: sfProStyle600SemiBold.copyWith(fontSize: 12), textAlign: TextAlign.center),
                        const SizedBox(height: 5),
                        Text('${locationProvider.startRangeLat.toStringAsFixed(5)}, ${locationProvider.startRangeLon.toStringAsFixed(5)}',
                            style: sfProStyle600SemiBold.copyWith(fontSize: 13), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ),
              Container(width: 4, height: 100, decoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(3))),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Helper.toScreen(const RangeSelectScreen(hasFromStartRange: false));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 5),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(.2), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
                        ],
                        borderRadius: BorderRadius.circular(4)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('End Range', style: sfProStyle500Medium.copyWith(fontSize: 15)),
                            const SizedBox(width: 8),
                            const Icon(Icons.edit, color: Colors.green, size: 17)
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(snapshot.data!.snapshot.child('Location').children.elementAt(5).value.toString(),
                            style: sfProStyle600SemiBold.copyWith(fontSize: 12), textAlign: TextAlign.center),
                        const SizedBox(height: 5),
                        Text('${locationProvider.endRangeLat.toStringAsFixed(5)}, ${locationProvider.endRangeLon.toStringAsFixed(5)}',
                            style: sfProStyle600SemiBold.copyWith(fontSize: 13), textAlign: TextAlign.center)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // SizedBox(height: 10),
          Container(height: 4, decoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(10))),
          const SizedBox(height: 10),
          Text('Child Detect Position:', style: sfProStyle700Bold.copyWith(fontSize: 16)),
          const SizedBox(height: 4),
          Text('${latLng.latitude}, ${latLng.longitude}', style: sfProStyle500Medium.copyWith(fontSize: 16)),
          const SizedBox(height: 4),
          Text(locationProvider.locationLists.isEmpty ? "Trying to find location..." : locationProvider.locationLists[0],
              style: sfProStyle500Medium.copyWith(fontSize: 16)),
          const SizedBox(height: 10),
          Container(height: 4, decoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(10))),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(.2), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
                      ],
                      borderRadius: BorderRadius.circular(4)),
                  child: Column(
                    children: [
                      Text('Start Range', style: sfProStyle500Medium.copyWith(fontSize: 16)),
                      const SizedBox(height: 5),
                      Text('Distance', style: sfProStyle500Medium.copyWith(fontSize: 16)),
                      const SizedBox(height: 5),
                      Text(
                          locationProvider.distanceInMetersForStartRange > 999
                              ? "${(locationProvider.distanceInMetersForStartRange / 1000.00).toStringAsFixed(2)} KM"
                              : "${locationProvider.distanceInMetersForStartRange.toStringAsFixed(2)} M",
                          style: sfProStyle700Bold.copyWith(fontSize: 17))
                    ],
                  ),
                ),
              ),
              Container(width: 4, height: 80, decoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(3))),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(.2), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
                      ],
                      borderRadius: BorderRadius.circular(4)),
                  child: Column(
                    children: [
                      Text('End Range', style: sfProStyle500Medium.copyWith(fontSize: 16)),
                      const SizedBox(height: 5),
                      Text('Distance', style: sfProStyle500Medium.copyWith(fontSize: 16)),
                      const SizedBox(height: 5),
                      Text(
                          locationProvider.distanceInMetersForEndRange > 999
                              ? "${(locationProvider.distanceInMetersForEndRange / 1000.00).toStringAsFixed(2)} KM"
                              : "${locationProvider.distanceInMetersForEndRange.toStringAsFixed(2)} M",
                          style: sfProStyle700Bold.copyWith(fontSize: 17))
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(height: 4, decoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(10))),
          const SizedBox(height: 10),
          CustomButton(
              btnTxt: 'Go To Full Map',
              onTap: () {
                Helper.toScreen(const HomeScreen());
              })
        ],
      ),
    );
  }
}
