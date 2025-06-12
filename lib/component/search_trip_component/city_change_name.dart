import 'package:abarat_app/provider/trips_provider.dart';
import 'package:flutter/material.dart';

class Citychangename extends StatelessWidget {
  const Citychangename({
    super.key,
    required this.tripProvider,
  });

  final TripsProvider tripProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildCard("من", tripProvider.departureCity, () {}),
        IconButton(
          onPressed: tripProvider.swapCities,
          icon: Icon(Icons.swap_horiz),
        ),
        _buildCard("إلى", tripProvider.arrivalCity, () {}),
      ],
    );
  }
}

Widget _buildCard(String title, String value, VoidCallback onTap) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 100,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          // ignore: use_full_hex_values_for_flutter_colors
          color: Color(0xfff8B3C45),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontSize: 12, color: Colors.white)),
            SizedBox(height: 2),
            Text(value, style: TextStyle(fontSize: 14, color: Colors.white)),
          ],
        ),
      ),
    ),
  );
}
