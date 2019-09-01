import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  CustomBottomNavigationBar() {
    for (int i = 0; i < titles.length; i++) {
      bottomBarItems.add(
        BottomNavigationBarItem(
          icon: Icon(icons[i], color: Colors.black),
          title: Text(
            titles[i],
            style: TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
      );
    }
  }

  final List<BottomNavigationBarItem> bottomBarItems = [];
  final List<IconData> icons = [
    Icons.home,
    Icons.favorite,
    Icons.local_offer,
    Icons.notifications,
  ];
  final List<String> titles = [
    "Explore",
    "Watchlist",
    "Deals",
    "Notifications"
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12.0,
      child: BottomNavigationBar(
        items: bottomBarItems,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
