import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import '../widgets/drawer.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import '../widgets/drawer.dart';
import '../widgets/mapMarker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapMarker extends StatefulWidget {
  final DocumentSnapshot x;

  MapMarker(this.x);

  String get death {
    return x['death'].toString();
  }

  @override
  _MapMarkerState createState() => _MapMarkerState();
}

class _MapMarkerState extends State<MapMarker> {
  final key = new GlobalKey();

  final style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24.0,
      color: Colors.red);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final dynamic tooltip = key.currentState;
        tooltip.ensureTooltipVisible();
      },
      child: Tooltip(
        key: key,
        message: widget.x['name'] + widget.x['death'].toString(),
        textStyle: style,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Container(
          child:  FloatingActionButton(
            heroTag: null,
            child: Text( widget.x['death'].toString()),
            onPressed: null
          ),
        ),
      ),
    );
  }
}