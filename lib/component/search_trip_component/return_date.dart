import 'package:abarat_app/provider/trips_provider.dart';
import 'package:flutter/material.dart';

class ReturnDate extends StatelessWidget {
  const ReturnDate({
    super.key,
    required this.tripProvider,
  });

  final TripsProvider tripProvider;

  @override
  Widget build(BuildContext context) {
    // 👇 توليد النص حسب نوع الرحلة والتواريخ
    String value = '';
    if (tripProvider.departingDate != null) {
      value = tripProvider.departingDate!.toLocal().toString().split(' ')[0];
    }

    if (tripProvider.tripType == 'ذهاب وعودة' &&
        tripProvider.returningDate != null) {
      value += ' - ${tripProvider.returningDate!.toLocal().toString().split(' ')[0]}';
    }

    if (value.isEmpty) value = 'اختر التاريخ';

    return GestureDetector(
      onTap: () async {
        await tripProvider.pickDate(context, false); // تاريخ المغادرة
        if (tripProvider.tripType == 'ذهاب وعودة') {
          // ignore: use_build_context_synchronously
          await tripProvider.pickDate(context, true); // تاريخ العودة
        }
      },
      child: Container(
        height: 57,
        width: double.infinity,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("تاريخ السفر",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            SizedBox(height: 2),
            Text(value, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
