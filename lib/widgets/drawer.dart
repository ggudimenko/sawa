import 'package:flutter/material.dart';

import '../pages/map.dart';
import '../pages/feedback.dart';

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        const DrawerHeader(
          child: Center(
            child: Text('SafeZone app'),
          ),
        ),
        ListTile(
          title: const Text('Codiv map'),
          selected: currentRoute == MapPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, MapPage.route);
          },
        ),
        ListTile(
          title: const Text('Get feedback'),
          selected: currentRoute == FeedbackPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, FeedbackPage.route);
          },
        ),
      ],
    ),
  );
}
