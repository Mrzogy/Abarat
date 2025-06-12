class Trip {
  final String tripId;
  final String tripNumber;
  final String direction;
  final String departureCity;
  final String arrivalCity;
  final String tripDate;
  final String boardingTime;
  final String departureTime;
  final String arrivalTime;
  final int availableSeats;
  final int waitingListSeats;

  Trip({
    required this.tripId,
    required this.tripNumber,
    required this.direction,
    required this.departureCity,
    required this.arrivalCity,
    required this.tripDate,
    required this.boardingTime,
    required this.departureTime,
    required this.arrivalTime,
    required this.availableSeats,
    required this.waitingListSeats,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tripId: json['trip_id'],
      tripNumber: json['trip_number'],
      direction: json['direction'],
      departureCity: json['departure_city'],
      arrivalCity: json['arrival_city'],
      tripDate: json['trip_date'],
      boardingTime: json['boarding_time'],
      departureTime: json['departure_time'],
      arrivalTime: json['arrival_time'],
      availableSeats: json['available_seats'],
      waitingListSeats: json['waiting_list_seats'],
    );
  }
}