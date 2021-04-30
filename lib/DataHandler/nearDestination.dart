import 'dart:async';
import 'dart:convert';
import 'package:rider_app/AllScreens/mainscreen.dart' as mainScr;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
String safe="Not Set";
Future<Album> fetchAlbum() async {
  var uid = mainScr.uid;
  var startLatitude = mainScr.currentPosition.latitude.toString();
  var startLongitude = mainScr.currentPosition.longitude.toString();
  var endLatitude = mainScr.finalPos.latitude.toString();
  var endLongitude = mainScr.finalPos.longitude.toString();
  print("From the ETA:"+startLatitude+" "+startLongitude+" "+endLatitude+" "+endLongitude+" UID:"+uid);
  print('https://round-office-312023.wn.r.appspot.com/locationservice?start_latitude='+startLatitude+'&start_longitude='+startLongitude+'&end_latitude='+endLatitude+'&end_longitude='+endLongitude+'&userID=0');
  final response =
  await http.get(Uri.parse('https://round-office-312023.wn.r.appspot.com/geofenceservice?start_latitude='+startLatitude+'&start_longitude='+startLongitude+'&end_latitude='+endLatitude+'&end_longitude='+endLongitude+'&userID=0'+"&time_tolerance=5"));
  //                            https://round-office-312023.wn.r.appspot.com/geofenceservice?start_latitude=33.72638&start_longitude=-112.17878&end_latitude=42.360081&end_longitude=-71.058884&userID=0&time_tolerance=5
  // Appropriate action depending upon the
  // server response
  if (response.statusCode == 200) {
    return Album.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      //userId: json['userId'],
      //id: json['id'],
      title: json['dest_check'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
    print(futureAlbum);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetching Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('GeeksForGeeks'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.title=="Safe")
                  mainScr.isSafe = true;
                else
                  mainScr.isSafe=false;
                safe = snapshot.data.title;
                return Text(snapshot.data.title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}