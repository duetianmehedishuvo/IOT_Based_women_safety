
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_safety/provider/auth_provider.dart';
import 'package:women_safety/provider/location_provider.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // Core

  // Repository
  // sl.registerLazySingleton(() => LanguageRepo());
  // sl.registerLazySingleton(() => AuthRepo(sharedPreferences: sl()));
  // sl.registerLazySingleton(() => SplashRepo());
  // sl.registerLazySingleton(() => AdminDashboardRepo());

  // Provider
  sl.registerFactory(() => AuthProvider());
  sl.registerFactory(() => LocationProvider());


  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
