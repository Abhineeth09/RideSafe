import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:rider_app/AllWidgets/Divider.dart';
import 'package:rider_app/Assistants/requestAssistant.dart';
import 'package:rider_app/DataHandler/appData.dart';
import 'package:rider_app/Models/placePredictions.dart';
import 'package:rider_app/configMaps.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  List<PlacePredictions> placesPredictionList = [];

  @override
  Widget build(BuildContext context) {

    String placeAddress = Provider.of<AppData>(context).pickUpLocation.placeName ?? "";
    pickUpTextEditingController.text = placeAddress;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 240.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7,0.7),

              )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(left:25.0, top:40.0, right:25.0, bottom:20.0),
              child: Column(
                children: [
                  SizedBox(height: 5.0,),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap:(){
                          Navigator.pop(context);
                        },
                          child: Icon(Icons.arrow_back),
                      ),
                      Center(
                        child: Text("Set Drop Off", style: TextStyle(fontSize: 25.0, fontFamily: "Brand-Bold")),
                      )
                    ],
                  ),

                  SizedBox(height: 16.0,),
                  Row(
                    children: [
                      Image.asset("images/pickicon.png", height: 16.0, width: 16.0,),

                      SizedBox(width: 18.0,),
                      
                      Expanded(child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: TextField(
                            controller: pickUpTextEditingController,
                            style: TextStyle(fontSize: 20.0, fontFamily: "Brand-Bold"),
                            decoration: InputDecoration(
                              hintText: "Start Location",
                              fillColor: Colors.grey[400],
                              filled: true,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),

                            ),
                          ),
                        ),
                      ))
                    ],
                  ),

                  SizedBox(height: 10.0,),
                  Row(
                    children: [
                      Image.asset("images/desticon.png", height: 16.0, width: 16.0,),

                      SizedBox(width: 18.0,),

                      Expanded(child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: TextField(
                            onChanged: (val){
                              findPlace(val);
                            },
                            controller: dropOffTextEditingController,
                            style: TextStyle(fontSize: 20.0, fontFamily: "Brand-Bold"),
                            decoration: InputDecoration(
                              hintText: "Where to?",
                              fillColor: Colors.grey[400],
                              filled: true,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),

                            ),
                          ),
                        ),
                      ))
                    ],
                  )

                ],
              ),
            ),
          ),

          //tile for predictions
          placesPredictionList.length > 0 ? Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListView.separated(
              padding: EdgeInsets.all(0.0),
              itemBuilder: (context,index){
                return PredictionTile(placePredictions: placesPredictionList[index],);
              },
              separatorBuilder: (BuildContext context, int index) => DividerWidget(),
              itemCount: placesPredictionList.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),

            ),

          ) : Container(),
        ],
      ),
    );
  }

  void findPlace(String placeName) async {
    if(placeName.length >1){
      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:us";
      var res = await RequestAssistant.getRequest(autoCompleteUrl);

      if (res=='failed'){
        return;
      }
      if (res['status'] == "OK"){
        var predictions = res['predictions'];
        var placesList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();
        setState(() {
          placesPredictionList = placesList;
        });
      }
    }
  }

}

class PredictionTile extends StatelessWidget {

   final PlacePredictions placePredictions;

  PredictionTile({Key key, PlacePredictions this.placePredictions}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            SizedBox(width: 10.0,),
             Row(
              children : [
                Icon(Icons.add_location_alt),
                SizedBox(width: 14.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(placePredictions.main_text,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 22.0, fontFamily: "Bold-Regular"),),
                      SizedBox(height: 3.0),
                      Text(placePredictions.secondary_text,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 18.0,fontFamily: "Bold-Regular",color: Colors.grey),),


                    ],

                  ),
                ),
              ],

            ),
            SizedBox(width: 10.0,),
          ],
        ),
    );
  }
}
