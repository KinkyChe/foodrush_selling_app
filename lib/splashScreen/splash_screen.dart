import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodrush_selling_app/authentication/auth_screen.dart';
import 'package:foodrush_selling_app/global/global.dart';
import 'package:foodrush_selling_app/mainScreens/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen>
{
  startTimer() {
    Timer(const Duration(seconds: 8), () async {
      //check currentuser's authentication status
      if(firebaseAuth.currentUser != null) {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
      }
      else{
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          decoration: const BoxDecoration(
          gradient: LinearGradient(
          colors: [
          Colors.amberAccent,
          Colors.amber,
          ],
          begin:  FractionalOffset(0.0, 0.0),
          end:  FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
               CircleAvatar(
                 radius: 200,
                 backgroundImage: AssetImage("images/splash.jpg"),
              ),

             SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "Sell Food Online",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 40,
                    fontFamily: "Signatra",
                    letterSpacing: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


