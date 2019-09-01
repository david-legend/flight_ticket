import 'package:cloud_firestore/cloud_firestore.dart';

class FlightDetails {
  final String airlines;
  final String date;
  final String discount;
  final String rating;
  final int oldPrice;
  final int newPrice;

  FlightDetails.fromMap(Map<String, dynamic> map)
      : assert(map['airlines'] != null),
        assert(map['date'] != null),
        assert(map['discount'] != null),
        assert(map['rating'] != null),
        airlines = map['airlines'],
        date = map['date'],
        discount = map['discount'],
        rating = map['rating'],
        oldPrice = map['oldPrice'],
        newPrice = map['newPrice'];

  FlightDetails.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);
}
