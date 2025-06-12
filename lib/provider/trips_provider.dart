import 'dart:convert';
import 'package:abarat_app/component/search_trip_component/custom_calendar_screen.dart';
import 'package:abarat_app/model/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TripsProvider with ChangeNotifier {
  List<Trip> _trips = [];
  List<Trip> get trips => _trips;
  List<Trip> _searchResults = [];
  List<Trip> get searchResults => _searchResults;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;
  String _tripType = 'ذهاب';
  String get tripType => _tripType;
  String _departureCity = 'جيزان';
  String _arrivalCity = 'فرسان';
  String get departureCity => _departureCity;
  String get arrivalCity => _arrivalCity;
  String get passengerSummary {
  final total = _adults + _children;
  return "$total Passenger${total > 1 ? 's' : ''}, Guest Class";
}

  DateTime? _departingDate = DateTime.now().add(Duration(days: 1));
  DateTime? _returningDate;
  DateTime? get departingDate => _departingDate;
  DateTime? get returningDate => _returningDate;

  int _adults = 1;
  int _children = 0;
  int get totalPassengers => _adults + _children;
   void setAdults(int value) {
    _adults = value;
    notifyListeners();
  }

  void setChildren(int value) {
    _children = value;
    notifyListeners();
  }
  Future<void> fetchTrips(String token) async {
    final url = Uri.parse('http://192.168.8.42:3000/trips/GetAlltrips');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List decoded = jsonDecode(response.body);
      _trips = decoded.map((tripJson) => Trip.fromJson(tripJson)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load trips');
    }
  }

  Future<void> searchTrips({
    required String direction,
    required String departureCity,
    required String arrivalCity,
    required String tripDate,
    required String token,
  }) async {
    _isLoading = true;
    _error = null;
    _searchResults = [];
    notifyListeners();

    final url = Uri.parse(
      'http://192.168.8.42:3000/trips/search?direction=$direction&departure_city=$departureCity&arrival_city=$arrivalCity&trip_date=$tripDate',
    );

    try {
      final res = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        _searchResults = data.map((json) => Trip.fromJson(json)).toList();
      } else {
        _error = 'فشل في جلب الرحلات';
      }
    } catch (_) {
      _error = 'حدث خطأ في الاتصال بالخادم';
    }

    _isLoading = false;
    notifyListeners();
  }

  void setTripType(String value) {
    _tripType = value;
    notifyListeners();
  }

  void swapCities() {
    final temp = _departureCity;
    _departureCity = _arrivalCity;
    _arrivalCity = temp;
    notifyListeners();
  }

  void setDepartingDate(DateTime date) {
    _departingDate = date;
    notifyListeners();
  }

  void setReturningDate(DateTime date) {
    _returningDate = date;
    notifyListeners();
  }

  Future<void> pickDate(BuildContext context, bool isReturn) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (picked != null) {
      if (isReturn) {
        setReturningDate(picked);
      } else {
        setDepartingDate(picked);
      }
    }
  }

  void incrementAdults() {
    _adults++;
    notifyListeners();
  }

  void decrementAdults() {
    if (_adults > 1) {
      _adults--;
      notifyListeners();
    }
  }

  void incrementChildren() {
    _children++;
    notifyListeners();
  }

  void decrementChildren() {
    if (_children > 0) {
      _children--;
      notifyListeners();
    }
  }

  void showPassengerSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Passengers",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  // Adults
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Adults",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "12 years and up",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed:
                                _adults > 1
                                    ? () {
                                      decrementAdults();
                                      setSheetState(() {});
                                    }
                                    : null,
                            icon: Icon(Icons.remove_circle_outline),
                          ),
                          Text('$_adults', style: TextStyle(fontSize: 16)),
                          IconButton(
                            onPressed: () {
                              incrementAdults();
                              setSheetState(() {});
                            },
                            icon: Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Children
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Children",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Ages 2–11",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed:
                                _children > 0
                                    ? () {
                                      decrementChildren();
                                      setSheetState(() {});
                                    }
                                    : null,
                            icon: Icon(Icons.remove_circle_outline),
                          ),
                          Text('$_children', style: TextStyle(fontSize: 16)),
                          IconButton(
                            onPressed: () {
                              incrementChildren();
                              setSheetState(() {});
                            },
                            icon: Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("تم"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

Future<void> pickDates(BuildContext context, bool isReturn) async {
  final mockData = {
    DateTime(2025, 5, 22): 10,
    DateTime(2025, 5, 23): 8,
    DateTime(2025, 5, 24): 5,
  };

  final pickedDate = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CustomCalendarScreen(availableSeatsPerDay: mockData),
    ),
  );

  if (pickedDate != null && pickedDate is DateTime) {
    isReturn ? setReturningDate(pickedDate) : setDepartingDate(pickedDate);
  }
}
}
