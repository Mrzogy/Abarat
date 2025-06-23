import 'package:abarat_app/component/search_trip_component/search_trips.dart';
import 'package:abarat_app/provider/auth_provider.dart';
import 'package:abarat_app/provider/trips_provider.dart';
import 'package:abarat_app/screen/home_screen.dart';
import 'package:abarat_app/screen/login_screen.dart';
import 'package:abarat_app/screen/new_serch_screen.dart';
import 'package:abarat_app/screen/trips_results_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => TripsProvider()),
  ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      home: NewSerchScreen(),
      routes: {
        '/products': (_) => SearchTrips(), 
        '/trips': (context) => const TripsResultsScreen(),
      },
    );
  }
}

