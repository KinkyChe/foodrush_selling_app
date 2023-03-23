import 'package:flutter/material.dart';
import 'package:foodrush_selling_app/mainScreens/home_screen.dart';
import 'package:foodrush_selling_app/mainScreens/new_orders_screen.dart';

import '../authentication/auth_screen.dart';
import '../global/global.dart';


class MyDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueGrey,
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child: Column(
              children: [
                //header drawer
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: SizedBox(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          sharedPreferences!.getString("photoUrl")!
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Text(
                  sharedPreferences!.getString("name")!,
                  style: const TextStyle(color: Colors.black54, fontSize: 20, fontFamily: "Train"),
                )
              ],
            ),
          ),
          const SizedBox(height: 12,),
          //body drawer
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            child: Column(
              children: [
                const Divider(
                  height: 10,
                  color: Colors.black54,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.black87,),
                  title: const Text(
                    "Home",
                    style: TextStyle(color: Colors.black87),
                  ),
                  onTap: () {
                    //on Click
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.monetization_on, color: Colors.black87,),
                  title: const Text(
                    "My Earnings",
                    style: TextStyle(color: Colors.black87),
                  ),
                  onTap: () {
                    //on Click
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.reorder, color: Colors.black87,),
                  title: const Text(
                    "New Orders",
                    style: TextStyle(color: Colors.black87),
                  ),
                  onTap: () {
                    //new orders
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> NewOrdersScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.local_shipping, color: Colors.black87,),
                  title: const Text(
                    "History - Oders",
                    style: TextStyle(color: Colors.black87),
                  ),
                  onTap: () {
                    //on Click
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.black87,),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.black87),
                  ),
                  onTap: () {
                    //on Click
                    firebaseAuth.signOut().then((value) {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}




