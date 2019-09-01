import 'package:cached_network_image/cached_network_image.dart';
import 'package:flight_ticket/custom_bottom_navigation_bar.dart';
import 'package:flight_ticket/custom_shape_clipper.dart';
import 'package:flight_ticket/flight_listing_screen.dart';
import 'package:flight_ticket/models/locations.dart';
import 'package:flutter/material.dart';
import 'package:flight_ticket/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flight_ticket/models/city_details.dart';

void main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'flight_ticket',
    options: const FirebaseOptions(
      googleAppID: '1:74387999005:android:c8624881cbdf0df6',
      apiKey: 'AIzaSyDdpBPH1_oq5q3YA6vrAXC1V4tyloT-jr0',
      databaseURL: 'https://flight-app-98e75.firebaseio.com/',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flight List Mock Up',
      theme: appTheme,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            HomeScreenTopPart(),
            homeScreenBottomPart,
          ],
        ),
      ),
    );
  }
}

class HomeScreenTopPart extends StatefulWidget {
  @override
  _HomeScreenTopPartState createState() => _HomeScreenTopPartState();
}

class _HomeScreenTopPartState extends State<HomeScreenTopPart> {
  int selectedLocationIndex = 0;
  bool isFlightSelected = true;
  final TextEditingController _searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: 400.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [firstColor, secondColor],
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                ),
                StreamBuilder(
                  stream:
                      Firestore.instance.collection('locations').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      addLocations(context, snapshot.data.documents);
                    }
                    return !snapshot.hasData
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                PopupMenuButton(
                                  onSelected: (index) {
                                    setState(() {
                                      selectedLocationIndex = index;
                                    });
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        locations[selectedLocationIndex],
                                        style: whiteHeadingTextStyle,
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                  itemBuilder: (BuildContext context) =>
                                      _buildPopupMenuItem(),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          );
                  },
                ),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'Where would\nyou want to go ?',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    child: TextField(
                      controller: _searchFieldController,
                      style: blackHeadingTextStyle,
                      cursorColor: appTheme.primaryColor,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 14.0),
                        suffixIcon: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InheritedFlightListing(
                                    pickUpLocation:
                                        locations[selectedLocationIndex],
                                    destination: _searchFieldController.text,
                                    child: FlightListingScreen(),
                                  ),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          isFlightSelected = true;
                        });
                      },
                      child: ChoiceChip(
                        icon: Icons.flight_takeoff,
                        text: "Flights",
                        isSelected: isFlightSelected,
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isFlightSelected = false;
                        });
                      },
                      child: ChoiceChip(
                        icon: Icons.hotel,
                        text: "Hotels",
                        isSelected: !isFlightSelected,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  List<PopupMenuItem> _buildPopupMenuItem() {
    List<PopupMenuItem<int>> popupMenuItems = [];
    for (var i = 0; i < locations.length; i++) {
      popupMenuItems.add(
        PopupMenuItem(
          child: Text(
            locations[i],
            style: blackHeadingTextStyle,
          ),
          value: i,
        ),
      );
    }

    return popupMenuItems;
  }

  void addLocations(BuildContext context, List<DocumentSnapshot> snapshots) {
    for (var i = 0; i < snapshots.length; i++) {
      final Location location = Location.fromSnapshot(snapshots[i]);
      locations.add(location.name);
    }
  }
}

class ChoiceChip extends StatefulWidget {
  ChoiceChip({
    @required this.text,
    @required this.icon,
    @required this.isSelected,
  });

  final IconData icon;
  final String text;
  final bool isSelected;

  @override
  _ChoiceChipState createState() => _ChoiceChipState();
}

class _ChoiceChipState extends State<ChoiceChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: widget.isSelected
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            )
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            widget.icon,
            size: 20.0,
            color: Colors.white,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}

var homeScreenBottomPart = Column(
  children: <Widget>[
    Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Currently watched items',
            style: blackHeadingTextStyle,
          ),
          Spacer(),
          Text(
            'VIEW ALL(2)',
            style: viewAllStyle,
          ),
        ],
      ),
    ),
    Container(
        height: 210.0,
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('cities')
              .orderBy('newPrice')
              .snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _buildCitiesList(context, snapshot.data.documents);
          },
        )),
  ],
);

Widget _buildCitiesList(
    BuildContext context, List<DocumentSnapshot> snapshots) {
  return ListView.builder(
    itemCount: snapshots.length,
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index) {
      return CityCard(
        cityDetails: CityDetails.fromSnapshot(snapshots[index]),
      );
    },
  );
}

class CityCard extends StatelessWidget {
  CityCard({this.cityDetails});

  final CityDetails cityDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      margin: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 210.0,
                    width: 160.0,
                    child: CachedNetworkImage(
                      imageUrl: '${cityDetails.imagePath}',
                      fit: BoxFit.cover,
                      fadeInDuration: Duration(milliseconds: 500),
                      fadeInCurve: Curves.easeIn,
                      placeholder: (context, url) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: 0.0,
                    bottom: 0.0,
                    width: 160.0,
                    height: 60.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black,
                            Colors.black.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10.0,
                    bottom: 10.0,
                    right: 10.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              cityDetails.cityName,
                              style: cardTitleTextStyle,
                            ),
                            Text(
                              cityDetails.monthYear,
                              style: cardSubTextStyle,
                            )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Text(cityDetails.discount),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 5.0,
              ),
              Text('${formatCurrency.format(cityDetails.newPrice).toString()}',
                  style: newPriceTextStyle),
              SizedBox(
                width: 5.0,
              ),
              Text(
                "(${formatCurrency.format(cityDetails.oldPrice).toString()})",
                style: oldPriceTextStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
