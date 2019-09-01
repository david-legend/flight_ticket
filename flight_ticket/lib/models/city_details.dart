import 'package:cloud_firestore/cloud_firestore.dart';

class CityDetails {
  final String cityName;
  final String monthYear;
  final String discount;
  final String imagePath;
  final int oldPrice;
  final int newPrice;

  CityDetails.fromMap(Map<String, dynamic> map)
      : assert(map['cityName'] != null),
        assert(map['monthYear'] != null),
        assert(map['discount'] != null),
        assert(map['imagePath'] != null),
        cityName = map['cityName'],
        monthYear = map['monthYear'],
        discount = map['discount'],
        imagePath = map['imagePath'],
        oldPrice = map['oldPrice'],
        newPrice = map['newPrice'];

  CityDetails.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);
}
