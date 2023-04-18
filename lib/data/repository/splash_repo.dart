
import 'package:dio/dio.dart';
import 'package:women_safety/data/datasource/remote/dio/dio_client.dart';

import '../datasource/remote/exception/api_error_handler.dart';

class SplashRepo{
  final DioClient dioClient;

  SplashRepo({required this.dioClient});

  // Future<ApiResponse> getCurrentAppVersion() async {
  //   Response response = Response(requestOptions: RequestOptions(path: '22222'));
  //   try {
  //     response = await dioClient.get(AppConstant.latestVersionUri);
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
  //   }
  // }
}