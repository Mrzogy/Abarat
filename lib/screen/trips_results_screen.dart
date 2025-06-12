import 'package:abarat_app/provider/trips_provider.dart';
import 'package:abarat_app/screen/booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TripsResultsScreen extends StatelessWidget {
  const TripsResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripsProvider>(context);
    final trips = tripProvider.searchResults;

    return Scaffold(
      appBar: AppBar(title: Text('الرحلات')),
      body:
          trips.isEmpty
              ? Center(child: Text('لا توجد رحلات'))
              : ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => BookingScreen(
                                passengerCount: tripProvider.totalPassengers, tripId: trip.tripId,
                              ),
                        ),
                      );
                    },
                    child: Card(
                      color: Color(0xff8B3C45),
                      margin: EdgeInsets.all(12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  trip.tripDate,
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  trip.tripNumber,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'مدة الرحلة: 1 ساعة',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'مقاعد الانتظار: ${trip.waitingListSeats}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${trip.departureTime} 🚢 ${trip.arrivalTime}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '${trip.departureCity} الى ${trip.arrivalCity}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'المقاعد المتاحة: ${trip.availableSeats}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
