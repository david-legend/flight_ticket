import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatCurrency = NumberFormat.simpleCurrency();

final Color firstColor = Color(0xFFF47D15);
final Color secondColor = Color(0xFFEF772C);
final Color discountBacgroundColor = Color(0xFFFFE08D);
final Color flightBorderColor = Color(0xFFE6E6E6);
final Color chipBacgroundColor = Color(0xFFF6F6F6);

ThemeData appTheme =
    ThemeData(primaryColor: Color(0xFFF3791A), fontFamily: 'Oxygen');

List<String> locations = [];

const TextStyle whiteHeadingTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16.0,
);

const TextStyle blackHeadingTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 16.0,
);

const TextStyle newPriceTextStyle =
    TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0);

const TextStyle oldPriceTextStyle = TextStyle(
    color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 12.0);

var viewAllStyle = TextStyle(fontSize: 14.0, color: appTheme.primaryColor);

var cardTitleTextStyle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0);
var cardSubTextStyle = TextStyle(
    color: Colors.white, fontWeight: FontWeight.normal, fontSize: 14.0);
