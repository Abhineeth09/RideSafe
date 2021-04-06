import "package:flutter/cupertino.dart";
import 'package:rider_app/Models/address.dart';

class AppData extends ChangeNotifier{
    Address pickUpLocation;

    void updatePickUpLocationAddress(Address pickUpAddress){
      pickUpLocation = pickUpAddress;
      notifyListeners();
    }
}