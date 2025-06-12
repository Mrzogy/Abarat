// import 'package:abarat_app/model/trip_model.dart';
// import 'package:abarat_app/provider/auth_provider.dart';
// import 'package:abarat_app/provider/trips_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'booking_screen.dart';
// import 'package:provider/provider.dart';

// class TripsScreen extends StatefulWidget {
//   @override
//   State<TripsScreen> createState() => _TripsScreenState();
// }

// class _TripsScreenState extends State<TripsScreen> {
//   final _cities = ['جيزان', 'فرسان'];
//   String _tripType = 'ذهاب'; // أو "ذهاب وعودة"
//   String _departureCity = 'جيزان';
//   String _arrivalCity = 'فرسان';
//   DateTime? _departingDate = DateTime.now().add(Duration(days: 1));
//   DateTime? _returningDate;
//   int _passengerCount = 1;

//   List<Trip> _searchResults = [];
//   bool _isLoading = false;
//   String? _error;
//   int _adults = 1;
//   int _children = 0;

//   String get passengerSummary {
//     final total = _adults + _children;
//     return "$total Passenger${total > 1 ? 's' : ''}, Guest Class";
//   }

//   void _swapCities() {
//     setState(() {
//       final temp = _departureCity;
//       _departureCity = _arrivalCity;
//       _arrivalCity = temp;
//     });
//   }

//   Future<void> _pickDate(bool isReturn) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now().add(Duration(days: 1)),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(Duration(days: 30)),
//     );

//     if (picked != null) {
//       setState(() {
//         if (isReturn) {
//           _returningDate = picked;
//         } else {
//           _departingDate = picked;
//         }
//       });
//     }
//   }

//   Future<void> _searchTrips() async {
//     if (_departureCity == _arrivalCity) {
//       setState(() => _error = 'لا يمكن أن تكون نفس المدينة كنقطة انطلاق ووصول');
//       return;
//     }

//     final token = Provider.of<AuthProvider>(context, listen: false).token;
//     if (_departingDate == null) return;

//     setState(() {
//       _isLoading = true;
//       _error = null;
//       _searchResults = [];
//     });

//     final dateStr = _departingDate!.toIso8601String().split('T')[0];
//     final url = Uri.parse(
//       'http://localhost:3000/trips/search?direction=$_tripType&departure_city=$_departureCity&arrival_city=$_arrivalCity&trip_date=$dateStr',
//     );

//     final res = await http.get(
//       url,
//       headers: {'Authorization': 'Bearer ${token ?? ""}'},
//     );

//     if (res.statusCode == 200) {
//       final List data = jsonDecode(res.body);
//       _searchResults =
//           data.map((json) => Trip.fromJson(json)).toList().cast<Trip>();
//     } else {
//       _error = 'حدث خطأ أثناء البحث';
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   Widget _buildCard(String title, String value, VoidCallback onTap) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           height: 55,
//           margin: EdgeInsets.all(5),
//           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade100,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title, style: TextStyle(fontSize: 12, color: Colors.grey)),
//               SizedBox(height: 2),
//               Text(value, style: TextStyle(fontSize: 14)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showPassengerSelector() {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) {
//         return StatefulBuilder(
//           builder: (context, setSheetState) {
//             return Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "Passengers",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 20),

//                   // Adults
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Adults",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             "12 years and up",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           IconButton(
//                             onPressed:
//                                 _adults > 1
//                                     ? () => setSheetState(() => _adults--)
//                                     : null,
//                             icon: Icon(Icons.remove_circle_outline),
//                           ),
//                           Text('$_adults', style: TextStyle(fontSize: 16)),
//                           IconButton(
//                             onPressed: () => setSheetState(() => _adults++),
//                             icon: Icon(Icons.add_circle_outline),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),

//                   // Children
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Children",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             "Ages 2–11",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           IconButton(
//                             onPressed:
//                                 _children > 0
//                                     ? () => setSheetState(() => _children--)
//                                     : null,
//                             icon: Icon(Icons.remove_circle_outline),
//                           ),
//                           Text('$_children', style: TextStyle(fontSize: 16)),
//                           IconButton(
//                             onPressed: () => setSheetState(() => _children++),
//                             icon: Icon(Icons.add_circle_outline),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: Text("تم"),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     ).then((_) {
//       setState(() {}); // لإعادة عرض ملخص الركاب
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final departDateText =
//         _departingDate != null
//             ? '${_departingDate!.toLocal()}'.split(' ')[0]
//             : 'اختر التاريخ';

//     final returnDateText =
//         _returningDate != null
//             ? '${_returningDate!.toLocal()}'.split(' ')[0]
//             : 'اختر تاريخ العودة';

//     return Scaffold(
//       appBar: AppBar(title: Text('حجز الرحلات')),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // نوع الرحلة
//             Row(
//               children: [
//                 Radio(
//                   value: 'ذهاب',
//                   groupValue: _tripType,
//                   onChanged: (val) {
//                     setState(() {
//                       _tripType = val!;
//                       _returningDate = null;
//                     });
//                   },
//                 ),
//                 Text('ذهاب'),
//                 Radio(
//                   value: 'ذهاب وعودة',
//                   groupValue: _tripType,
//                   onChanged: (val) {
//                     setState(() {
//                       _tripType = val!;
//                     });
//                   },
//                 ),
//                 Text('ذهاب وعودة'),
//               ],
//             ),

//             // المدن
//             Row(
//               children: [
//                 _buildCard("من", _departureCity, () {}),
//                 IconButton(
//                   onPressed: _swapCities,
//                   icon: Icon(Icons.swap_horiz),
//                 ),
//                 _buildCard("إلى", _arrivalCity, () {}),
//               ],
//             ),

//             SizedBox(height: 10),

//             // التاريخ
//             Row(
//               children: [
//                 _buildCard("المغادرة", departDateText, () => _pickDate(false)),
//                 if (_tripType == 'ذهاب وعودة')
//                   _buildCard("العودة", returnDateText, () => _pickDate(true)),
//               ],
//             ),

//             SizedBox(height: 10),

//             // عدد الركاب
//             GestureDetector(
//               onTap: _showPassengerSelector,
//               child: Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
//                 margin: EdgeInsets.only(top: 12),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade400),
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey.shade100,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(passengerSummary, style: TextStyle(fontSize: 14)),
//                     Icon(Icons.keyboard_arrow_down),
//                   ],
//                 ),
//               ),
//             ),

//             SizedBox(height: 20),

//             // زر بحث
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton.icon(
//                 icon: Icon(Icons.search),
//                 label: Text("بحث عن الرحلات"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green.shade800,
//                 ),
//                 onPressed: _searchTrips,
//               ),
//             ),

//             Divider(height: 40),

//             // النتائج
//             if (_isLoading)
//               CircularProgressIndicator()
//             else if (_error != null)
//               Text(_error!, style: TextStyle(color: Colors.red))
//             else if (_searchResults.isEmpty)
//               Text('لا توجد رحلات')
//             else
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: _searchResults.length,
//                 itemBuilder: (ctx, i) {
//                   final trip = _searchResults[i];
//                   return ListTile(
//                     title: Text('${trip.departureCity} → ${trip.arrivalCity}'),
//                     subtitle: Text('${trip.tripDate} - ${trip.departureTime}'),
//                     trailing: Text('مقاعد: ${trip.availableSeats}'),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => BookingScreen(trip: trip),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
