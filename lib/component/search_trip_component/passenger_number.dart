import 'package:abarat_app/provider/trips_provider.dart';
import 'package:flutter/material.dart';

class PassengerNumber extends StatelessWidget {
  const PassengerNumber({
    super.key,
    required this.tripProvider,
  });

  final TripsProvider tripProvider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => tripProvider.showPassengerSelector(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        margin: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade100,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tripProvider.passengerSummary,
              style: TextStyle(fontSize: 14),
            ),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}
