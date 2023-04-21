import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:women_safety/data/model/response/Forecast_weather_model.dart';
import 'package:women_safety/data/model/response/base/api_response.dart';
import 'package:women_safety/data/model/response/current_weather_model.dart';
import 'package:women_safety/data/repository/weather_repo.dart';
import 'package:women_safety/widgets/snackbar_message.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherRepo weatherRepo;

  WeatherProvider({required this.weatherRepo});

  double distance = 0.00;
  LatLng childInitializeLatLng = const LatLng(0.00000, 0.00000);
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  calculateDistance(LatLng latLng) {
    distance =
        Geolocator.distanceBetween(childInitializeLatLng.latitude, childInitializeLatLng.longitude, latLng.latitude, latLng.longitude);

    if (distance > 1000) {
      childInitializeLatLng = latLng;
      getCurrentWeather(latLng);
      // notifyListeners();
    }
  }

// for Current Weather
  CurrentWeatherModel currentWeatherModel = CurrentWeatherModel();

  getCurrentWeather(LatLng latLng) async {
    _isLoading = true;
    currentWeatherModel = CurrentWeatherModel();
    //notifyListeners();
    ApiResponse apiResponse1 = await weatherRepo.getCurrentWeather(latLng);
    if (apiResponse1.response.statusCode == 200) {
      for (var element in apiResponse1.response.data['data']) {
        currentWeatherModel = CurrentWeatherModel.fromJson(element);
      }
      getForecastWeather(latLng);
      notifyListeners();
    } else {
      String errorMessage = apiResponse1.error.toString();
      showMessage(message: errorMessage);
    }
  }

// for Forecast Weather
  List<ForecastWeatherModel> forecastWeatherList = [];

  getForecastWeather(LatLng latLng) async {
    forecastWeatherList.clear();
    forecastWeatherList = [];
    notifyListeners();
    ApiResponse apiResponse1 = await weatherRepo.getForecastWeather(latLng);
    _isLoading = false;
    notifyListeners();
    if (apiResponse1.response.statusCode == 200) {
      for (var element in apiResponse1.response.data['data']) {
        forecastWeatherList.add(ForecastWeatherModel.fromJson(element));
      }
    } else {
      String errorMessage = apiResponse1.error.toString();
      showMessage(message: errorMessage);
    }
    notifyListeners();
  }
}
