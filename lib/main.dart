import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:women_safety/bloc/application_bloc.dart';
import 'package:women_safety/provider/auth_provider.dart';
import 'package:women_safety/provider/location_provider.dart';
import 'package:women_safety/screen/splash_screen.dart';
import 'package:women_safety/util/helper.dart';

import 'di_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyADd2JSSzNQvGCztaJ7-BAOl1bHiWtSKAY",
      appId: "1:261316311673:android:84db47ceac70d2587f32a8",
      messagingSenderId: "261316311673",
      projectId: "women-safety-93296",
    ),
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocationProvider>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => ApplicationBloc(),
        child: MaterialApp(
          title: 'Women Safety',
          navigatorKey: Helper.navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.red),
          home: const SplashScreen(),
        ));
  }
}
