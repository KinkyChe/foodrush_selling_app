import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodrush_selling_app/global/global.dart';
import '../mainScreens/itemsScreen.dart';
import '../model/menus.dart';


class SellersDesignWidget extends StatefulWidget {
  Menus? model;
  BuildContext? context;

  SellersDesignWidget({
   this.model,
   this.context
});

  @override
  State<SellersDesignWidget> createState() => _SellersDesignWidgetState();
}


class _SellersDesignWidgetState extends State<SellersDesignWidget> {

  deleteMenu(String menuID){
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(menuID).delete();

    Fluttertoast.showToast(msg: "Menu deleted");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (c) => ItemsScreen(model: widget.model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              //margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration:  BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(width: 1.0, color: Colors.grey.shade200),
                //boxShadow:  const [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))],
              ),
              child: Row(
                children:<Widget> [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child:Image.network(
                      widget.model!.thumbnailURL!,
                      height: 150.0,
                      width: 150.0,
                      fit: BoxFit.cover,
                    ) ,
                  ),
                  /*Text(
                        widget.model!.menuInfo!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),*/

                  Text(
                    widget.model!.menuTitle!,
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontFamily: "Train",
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.right,
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.delete_sweep,
                      color: Colors.amberAccent,
                    ),
                    onPressed: (){
                      //delete menu
                      deleteMenu(widget.model!.menuID!);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
