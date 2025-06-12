import 'package:abarat_app/provider/auth_provider.dart';
import 'package:abarat_app/provider/trips_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchTripButton extends StatelessWidget {
  const SearchTripButton({super.key, required this.tripProvider});

  final TripsProvider tripProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: Icon(Icons.search, color: Colors.white),
        label: Text("بحث عن الرحلات", style: TextStyle(color: Colors.white)),
        // ignore: use_full_hex_values_for_flutter_colors
        style: ElevatedButton.styleFrom(backgroundColor: Color(0xfff0033A0)),
        onPressed: () async {
          final direction = tripProvider.tripType;
          final departureCity = tripProvider.departureCity;
          final arrivalCity = tripProvider.arrivalCity;
          final tripDate =
              tripProvider.departingDate?.toIso8601String().split('T')[0] ?? '';
          final token =
              Provider.of<AuthProvider>(context, listen: false).token ?? '';

          if (departureCity == arrivalCity) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('لا يمكن أن تكون نفس المدينة كنقطة انطلاق ووصول'),
              ),
            );
            return;
          }

          await tripProvider.searchTrips(
            direction: direction,
            departureCity: departureCity,
            arrivalCity: arrivalCity,
            tripDate: tripDate,
            token: token,
          );

          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, '/trips'); // ✅ ينقله للنتائج
        },
      ),
    );
  }
}
