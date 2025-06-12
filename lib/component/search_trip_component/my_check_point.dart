import 'package:abarat_app/provider/trips_provider.dart';
import 'package:flutter/material.dart';

class MyCheckpoint extends StatelessWidget {
  const MyCheckpoint({super.key, required this.tripProvider});

  final TripsProvider tripProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
     _buildOption(context, 'ذهاب وعودة'),
        SizedBox(width: 40),
       
          _buildOption(context, 'ذهاب'),
      ],
    );
  }

  Widget _buildOption(BuildContext context, String value) {
    final isSelected = tripProvider.tripType == value;
    return GestureDetector(
      onTap: () => tripProvider.setTripType(value),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4),
          AnimatedContainer(
            duration: Duration(milliseconds: 250),
            height: 3,
            width: isSelected ? value.length * 12.0 : 0,
            // ignore: use_full_hex_values_for_flutter_colors
            color: isSelected ? Color(0xfff8B3C45) : Colors.transparent,
          )
        ],
      ),
    );
  }
}