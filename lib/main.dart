import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/AllScreens/loginScreen.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:rider_app/AllScreens/registrationScreen.dart';
import 'package:rider_app/AllScreens/searchScreen.dart';
import 'package:rider_app/DataHandler/appData.dart';
import 'package:rider_app/DataHandler/ApiData.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Secure Ride',
        theme: ThemeData(
          fontFamily: "Signatra",
          primarySwatch: Colors.blue,
        ),
        initialRoute: MainScreen.idScreen,//RegistrationScreen.idScreen,
        //initialRoute: LoginScreen.idScreen,
        routes: {
          RegistrationScreen.idScreen: (context) => RegistrationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),
          SearchScreen.idScreen: (context) => SearchScreen(),
          //SearchScreen.idScreen: (context) => SearchScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

