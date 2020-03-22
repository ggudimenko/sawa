import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackPage extends StatefulWidget {
  static const String route = '/feedback';


  @override
  FeedbackPageState createState() => FeedbackPageState();
}

class FeedbackPageState extends State<FeedbackPage> {
  Stream<QuerySnapshot> _codivPointsStores;

  @override
  void initState() {
    super.initState();
    _codivPointsStores = Firestore.instance
        .collection('codivPoints')
        .orderBy('name')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Get feedback')),
      drawer: buildDrawer(context, FeedbackPage.route),
      body: StreamBuilder<QuerySnapshot>(
        stream: _codivPointsStores,
        builder: (context, snapshot){
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}}'));
          if (!snapshot.hasData) return Center(child: Text('Loading...'));

          final storesCount=snapshot.data.documents.length;
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text('Please send feedback + $storesCount'),
                  )
                ]
            ),);
    }
    ),
    );
  }
}
