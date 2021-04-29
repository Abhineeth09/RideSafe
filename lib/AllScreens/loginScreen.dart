import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:rider_app/AllScreens/registrationScreen.dart';
import 'package:rider_app/AllWidgets/progressDialog.dart';
import 'package:rider_app/main.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = 'login';

  TextEditingController emailTextEditingController = TextEditingController();
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
              SizedBox(height: 35.0,),
              Image(
                  image: AssetImage("images/Ridesafe-3.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0,),
              Text(
                "Login",
              style: TextStyle(fontSize: 24.0,fontFamily: "Brand Bold"),
              textAlign: TextAlign.center
              ),
              Padding(padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                        fontSize: 20.0,
                      ),
                      hintStyle: TextStyle( color: Colors.grey, fontSize: 10.0),

                    ),
                    style: TextStyle(fontSize: 20.0),
                  ),
                  TextField(
                    controller: passwordTextEditingController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                        fontSize: 20.0,
                      ),
                      hintStyle: TextStyle( color: Colors.grey, fontSize: 10.0),

                    ),
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 2.0,),
                  RaisedButton(
                    color: Colors.yellow,
                    textColor: Colors.white,
                    child: Container(
                      height: 50.0,
                      child: Center(
                        child: Text(
                          "Login",
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
                      if (!emailTextEditingController.text.contains('@')){
                        displayToastMessage("The entered E-mail address is not valid.", context);
                      }
                      else if (passwordTextEditingController.text.isEmpty){
                        displayToastMessage("Password cannot be empty!", context);
                      }
                      else{
                        loginAndAuthenticateUser(context);
                      }
                    },
                  )
                ],
              ),
              ),
              SizedBox(height: 1.0,),
              TextButton(
                onPressed: ()
                {
                  Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Do not have an account? Register Here!",
                  style: TextStyle(fontSize: 25.0),
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

  loginAndAuthenticateUser(BuildContext context) async {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
      {
        ProgressDialog(message: "Authenticating, please wait...",);
        return Container(width: 0.0, height: 0.0);
      }
    );

    final User firebaseUser = (
        await _firebaseAuth
            .signInWithEmailAndPassword(
            email: emailTextEditingController.text,
            password: passwordTextEditingController.text
        ).catchError((errMsg){
          Navigator.pop(context);
          displayToastMessage("Error: " + errMsg.toString(),context);
        })).user;

    if (firebaseUser != null) { //User Created
      //Save user info to database


      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap){
        if(snap.value != null){
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
          displayToastMessage("You are logged in!", context);
        }
        else{
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage("User not found! Please create a new account.", context);
        }
      });
      displayToastMessage("Login Successful", context);

      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
    }
    else {
      Navigator.pop(context);
      //error occured
      displayToastMessage("Error occured! Cannot be signed in.", context);

    }
  }
}
