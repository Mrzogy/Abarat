import 'package:abarat_app/component/search_trip_component/city_change_name.dart';
import 'package:abarat_app/component/search_trip_component/my_check_point.dart';
import 'package:abarat_app/component/search_trip_component/passenger_number.dart';
import 'package:abarat_app/component/search_trip_component/return_date.dart';
import 'package:abarat_app/component/search_trip_component/search_trip_button.dart';
import 'package:abarat_app/provider/trips_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchTrips extends StatelessWidget {
  const SearchTrips({super.key});

  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white
          ),
          margin: EdgeInsets.all(20),
          // padding: EdgeInsets.all(16),
          // decoration: BoxDecoration(
          //   color: Colors.white, // لون المربع الداخلي
          //   borderRadius: BorderRadius.circular(12),
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.black26,
          //       blurRadius: 10,
          //       offset: Offset(0, 4),
          //     ),
          //   ],
          // ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MyCheckpoint(tripProvider: tripProvider),
              Citychangename(tripProvider: tripProvider),
              SizedBox(height: 20),
              ReturnDate(
                // departDateText: departDateText,
                tripProvider: tripProvider,
                // returnDateText: returnDateText,
              ),
              SizedBox(height: 10),
              PassengerNumber(tripProvider: tripProvider),
              SizedBox(height: 20),
              SearchTripButton(tripProvider: tripProvider),
            ],
          ),
        ),
      ),
    );
  }
}
