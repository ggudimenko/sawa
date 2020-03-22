import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import '../widgets/drawer.dart';
import '../widgets/mapMarker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class MapPage extends StatefulWidget {
  static const String route = '/';

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  List<Marker> markers;
  int pointIndex;
  List points = [
    LatLng(51.5, -0.09),
    LatLng(49.8566, 3.3522),
  ];
  Stream<QuerySnapshot> _codivPointsStores;

  @override
  void initState() {
    /*
    pointIndex = 0;
    markers = [
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: points[pointIndex],
        builder: (ctx) => MapMarker(10),
      ),
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: LatLng(53.3498, -6.2603),
        builder: (ctx) => MapMarker(10),
      ),
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: LatLng(53.3488, -6.2613),
        builder: (ctx) => MapMarker(10),
      ),
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: LatLng(53.3488, -6.2613),
        builder: (ctx) => MapMarker(10),
      ),
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: LatLng(48.8566, 2.3522),
        builder: (ctx) => MapMarker(10),
      ),
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: LatLng(49.8566, 3.3522),
        builder: (ctx) => MapMarker(10),
      ),
    ];
*/
    _codivPointsStores = Firestore.instance
        .collection('codivPoints')
        .orderBy('name')
        .snapshots();

    super.initState();
  }

  int sum(List<Marker> markers)
  {
    int s = 0;
    markers.forEach((e){s += (e as MMarker).death;});
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.refresh),
        onPressed: () {
          pointIndex++;
          if (pointIndex >= points.length) {
            pointIndex = 0;
          }
          setState(() {
            markers[0] = Marker(
              point: points[pointIndex],
              anchorPos: AnchorPos.align(AnchorAlign.center),
              height: 30,
              width: 30,
              builder: (ctx) => Icon(Icons.pin_drop),
            );

            // one of this
            markers = List.from(markers);
            // markers = [...markers];
            // markers = []..addAll(markers);
          });
        },
      ),
      appBar: AppBar(title: Text('Home')),
      drawer: buildDrawer(context, MapPage.route),
      body:  StreamBuilder<QuerySnapshot>(
        stream: _codivPointsStores,
        builder: (context, snapshot) {
        if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}}'));
        if (!snapshot.hasData) return Center(child: Text('Loading...'));

        final codivPoints=snapshot.data.documents;

    return Padding(
        padding: EdgeInsets.all(0.0),
        child: Column(
          children: [
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(51.5, -0.09),
                  minZoom: 2,
                  maxZoom: 10,
                  zoom: 5.0,
                  plugins: [
                    MarkerClusterPlugin(),
                  ],
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                    'http://mt0.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}&s=Ga',
                    //'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    //subdomains: ['a', 'b', 'c'],
                    // For example purposes. It is recommended to use
                    // TileProvider with a caching and retry strategy, like
                    // NetworkTileProvider or CachedNetworkTileProvider
                    tileProvider: NonCachingNetworkTileProvider(),
                    backgroundColor: Colors.lightBlueAccent[200],
                  ),
                  MarkerClusterLayerOptions(
                    maxClusterRadius: 120,
                    anchor: AnchorPos.align(AnchorAlign.center),
                    fitBoundsOptions: FitBoundsOptions(
                      padding: EdgeInsets.all(50),
                    ),
                    markers: codivPoints
                    .map(
                            (document) => MMarker(
                              anchorPos: AnchorPos.align(AnchorAlign.center),
                              x:document,
                              height: 30+2*log(document['cases'].toDouble())/log(10),
                              width: 30+2*log(document['cases'].toDouble())/log(10),
                              point: LatLng(
                                document['geopoint'].latitude,
                                document['geopoint'].longitude,
                                  ),
                              builder: (ctx) => MapMarker(document),
                      ),
                    ).toList(),
                    computeSize: (markers) {
                      var l=40+2*log(sum(markers))/log(10);
                      print(l);
                      return Size(l, l);
                    },
                    polygonOptions: PolygonOptions(
                        borderColor: Colors.blueAccent,
                        color: Colors.black12,
                        borderStrokeWidth: 3),
                    builder: (context, markers) {
                      return FloatingActionButton(
                        heroTag: null,
                        child: Text(sum(markers).toString()),
                        onPressed: null,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }),
    );
  }
}



class MMarker extends Marker {
  final DocumentSnapshot x;
  final LatLng point;
  final WidgetBuilder builder;
  final double width;
  final double height;

  int get death {
    return x['death'];
  }

  MMarker({
    this.point,
    this.builder,
    this.x,
    this.width = 30.0,
    this.height = 30.0,
    AnchorPos anchorPos,
  }) : super();
}
