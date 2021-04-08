import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/AllScreens/searchScreen.dart';
import 'package:rider_app/AllWidgets/Divider.dart';
import 'package:rider_app/AllWidgets/progressDialog.dart';
import 'package:rider_app/Assistants/assistantMethods.dart';
import 'package:rider_app/DataHandler/appData.dart';
//import 'package:flutter/firebase'
class MainScreen extends StatefulWidget {
  static const String idScreen = 'main';
  @override
  _MainScreenState createState() => _MainScreenState();
}



class _MainScreenState extends State<MainScreen> {

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;

  void locatePosition() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 14);

    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistantMethods.searchCoordinateAddress(position, context);
    print("This is your address ::"+ address);

  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Main Screen',style: TextStyle(fontSize: 35),),
      ),
      drawer: Container(
        color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                    Image.asset("images/user_icon.png", height: 65.0, width: 65.0,),
                      SizedBox(width: 16.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Text("Profile Name", style: TextStyle(fontSize: 18.0, fontFamily: "Brand-Bold"),),
                          SizedBox(height: 6.0,),
                          Text("Visit Profile", style: TextStyle(fontSize: 16.0, fontFamily: "Brand-Bold")),
                        ],
                      ),
                  ]
                  ),
                ),
              ),
              DividerWidget(),

              SizedBox(height: 12.0,),

              //Drawer Body Controllers
              ListTile(
                leading: Icon(Icons.history),
                title: Text("History", style: TextStyle(fontSize: 20.0, fontFamily: "Brand-Bold"),),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Visit Profile", style: TextStyle(fontSize: 20.0,fontFamily: "Brand-Bold"),),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("About", style: TextStyle(fontSize: 20.0,fontFamily: "Brand-Bold"),),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
          myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                setState(() {
                  bottomPaddingOfMap = 350.0;
                });

                locatePosition();
            },
          ),

          //Hamburger Button for Drawer
          Positioned(
            top:45.0,
            left: 22.0,
            child: GestureDetector(
              onTap: (){
                scaffoldKey.currentState.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [ BoxShadow(
                    color: Colors.black,
                    blurRadius: 6.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7,0.7),
                    
                  )
                  ]
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.menu),
                  radius: 20.0,
                ),
              ),
            ),
          ),
          
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Padding(
              padding: const EdgeInsets.only(bottom:30.0),
              child: Container(
                height: 350.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(18.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7,0.7),
                    )
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start ,
                    children: [
                      SizedBox(height: 20.0,),
                      Text("Hi there!", style: TextStyle(fontSize: 25.0,fontFamily: "Brand-Bold"),),
                      Text("Where to?", style: TextStyle(fontSize: 25.0, fontFamily: "Brand-Bold"),),
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () async{
                          var res = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));

                          if (res == "obtainDirection"){
                            await getPlaceDirection();
                          }
                        },

                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 6.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.7,0.7),
                                )
                              ]
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(Icons.search,color: Colors.blueAccent,),
                                SizedBox(width: 10.0,),
                                Text("Search Drop Off",style: TextStyle(fontSize: 20.0,fontFamily: "Brand-Bold"))
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0,),
                      Row(
                        children: [
                          Icon(Icons.home, color: Colors.grey ),
                          SizedBox(width: 12.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Provider.of<AppData>(context).pickUpLocation != null
                                    ? Provider.of<AppData>(context).pickUpLocation.placeName
                                    : "Add Home",style: TextStyle(fontSize: 21.0,fontFamily: "Brand-Bold")
                              ),



                              SizedBox(height:4.0,),
                              Text("Your Home Address", style: TextStyle(color: Colors.black54,fontSize: 18.0,fontFamily: "Brand-Bold"),),

                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10.0,),

                      DividerWidget(),

                      SizedBox(height: 16.0,),

                      Row(
                        children: [
                          Icon(Icons.work, color: Colors.grey ),
                          SizedBox(width: 12.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Add Work",style: TextStyle(fontSize: 21.0,fontFamily: "Brand-Bold")),
                              SizedBox(height:4.0,),
                              Text("Your Office Address", style: TextStyle(color: Colors.black54,fontSize: 18.0,fontFamily: "Brand-Bold"),),

                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),

            ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    var initialPos = Provider.of<AppData>(context, listen: false,).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false,).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(message: "Please wait...",),


    );

    var details = await AssistantMethods.obtainDirectionDetails(pickUpLatLng, dropOffLatLng);

    Navigator.pop(context);

    print("This is Encoded Points ::");
    print(details.encodedPoints);
  }

}
