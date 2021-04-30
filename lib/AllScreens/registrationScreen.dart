import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/AllScreens/loginScreen.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:rider_app/AllWidgets/progressDialog.dart';
import 'package:rider_app/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatelessWidget {
  static const String idScreen = 'register';

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(

            children: [
              SizedBox(height: 20.0,),
              Image(
                image: AssetImage("images/Ridesafe.PNG"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0,),
              Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 28.0,fontFamily: "Brand Bold"),
                  textAlign: TextAlign.center
              ),
              Padding(padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                          fontSize: 25.0,fontFamily: "Brand Bold"
                        ),
                        hintStyle: TextStyle( color: Colors.grey, fontSize: 25.0,fontFamily: "Brand Bold"),

                      ),
                      style: TextStyle(fontSize: 25.0,fontFamily: "Brand Bold"),
                    ),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 25.0,fontFamily: "Brand Bold"
                        ),
                        hintStyle: TextStyle( color: Colors.grey, fontSize: 25.0,fontFamily: "Brand Bold"),

                      ),
                      style: TextStyle(fontSize: 25.0),
                    ),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        labelStyle: TextStyle(
                          fontSize: 25.0,fontFamily: "Brand Bold"
                        ),
                        hintStyle: TextStyle( color: Colors.grey, fontSize: 25.0,fontFamily: "Brand Bold"),

                      ),
                      style: TextStyle(fontSize: 25.0),
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 25.0,fontFamily: "Brand Bold"
                        ),
                        hintStyle: TextStyle( color: Colors.grey, fontSize: 25.0,fontFamily: "Brand Bold"),

                      ),
                      style: TextStyle(fontSize: 20.0,fontFamily: "Brand Bold"),
                    ),
                    SizedBox(height: 20.0,),
                    RaisedButton(
                      color: Colors.cyan,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Brand Bold",

                            ),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: ()
                      {
                        if (nameTextEditingController.text.length < 3){
                          displayToastMessage("The name must contain at least 3 characters.", context);
                        }
                        else if (!emailTextEditingController.text.contains('@')){
                          displayToastMessage("The entered E-mail address is not valid.", context);
                        }
                        else if (phoneTextEditingController.text.isEmpty){
                          displayToastMessage("The entered phone number is not valid.", context);
                        }
                        else if (passwordTextEditingController.text.length < 6){
                          displayToastMessage("Password must be at least 6 characters.", context);
                        }
                        registerNewUser(context);
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: 1.0,),
              TextButton(
                onPressed: ()
                {
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                },
                child: Text(
                    "Already have an account? Login Here!",
                  style: TextStyle(fontSize: 20,fontFamily: "Brand Bold"),
                ),
              ),
              SizedBox(height: 1.0,),

            ],
          ),
        ),
      ),
    );
  }

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

void registerNewUser(BuildContext context) async
{
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        ProgressDialog(message: "Registering, please wait...",);
        return Container(width: 0.0, height: 0.0);
      }
  );

  final User firebaseUser = (
      await _firebaseAuth
          .createUserWithEmailAndPassword(
          email: emailTextEditingController.text,
          password: passwordTextEditingController.text
      ).catchError((errMsg){
        Navigator.pop(context);
        displayToastMessage("Error: " + errMsg.toString(),context);
      })).user;
  if (firebaseUser != null) { //User Created
    //Save user info to database

    Map userDataMap ={
      "name" : nameTextEditingController.text.trim(),
      "email" : emailTextEditingController.text.trim(),
      "phone" : phoneTextEditingController.text.trim(),
    };

    usersRef.child(firebaseUser.uid).set(userDataMap);
    displayToastMessage("Congratulations! Your account has been created.", context);
    
    Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
  }
  else {
    Navigator.pop(context);
    //error occured
    displayToastMessage("The user has not been created.", context);
  }
}
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
