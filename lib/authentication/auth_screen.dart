import 'package:flutter/material.dart';
import 'package:foodrush_selling_app/authentication/login.dart';
import 'package:foodrush_selling_app/authentication/register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
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
              )
            ),
          ),
          automaticallyImplyLeading: false,
          title: const Text(
              "iFood",
            style: TextStyle(
              fontSize: 60,
              color: Colors.black54,
              fontFamily: "Lobster"
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.lock, color: Colors.black54,),
                  text: "Login",
                ),
                Tab(
                  icon: Icon(Icons.person, color: Colors.black54,),
                  text: "Register",
                ),
              ],
            indicatorColor: Colors.black54,
            indicatorWeight: 6,
            labelColor: Colors.black54,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.amber,
                Colors.amberAccent
              ]
            )
          ),
          child: const TabBarView(
            children: [
              LogInScreen(),
              RegisterScreen(),
            ],
          ),
        ),
      ) ,

    );
  }
}
