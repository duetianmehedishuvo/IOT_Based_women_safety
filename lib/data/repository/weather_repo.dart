import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:women_safety/data/datasource/remote/dio/dio_client.dart';
import 'package:women_safety/data/model/response/base/api_response.dart';

import '../datasource/remote/exception/api_error_handler.dart';

class WeatherRepo {
  final DioClient dioClient;

  WeatherRepo({required this.dioClient});

  Future<ApiResponse> getCurrentWeather(LatLng latLng) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get(
          'https://api.weatherbit.io/v2.0/current?lat=${latLng.latitude}&lon=${latLng.longitude}&key=3edaf5c79acf40c49995bc5b259220a0');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> getForecastWeather(LatLng latLng) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get(
          'https://api.weatherbit.io/v2.0/forecast/daily?lat=${latLng.latitude}&lon=${latLng.longitude}&key=3edaf5c79acf40c49995bc5b259220a0');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }
}
