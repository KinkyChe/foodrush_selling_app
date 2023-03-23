import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodrush_selling_app/global/global.dart';
import 'package:foodrush_selling_app/model/items.dart';
import 'package:foodrush_selling_app/splashScreen/splash_screen.dart';
import 'package:foodrush_selling_app/widgets/simple_app_bar.dart';


class ItemDetailScreen extends StatefulWidget {
  final Items? model;

  ItemDetailScreen({
    this.model
});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  deleteItem(String itemID){
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(widget.model!.menuID)
        .collection("items")
        .doc(itemID)
        .delete().then((value) {
      FirebaseFirestore.instance
          .collection("items")
          .doc(itemID)
          .delete();

      Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
      Fluttertoast.showToast(msg: "Item deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.white,
      appBar: SimpleAppBar(title: sharedPreferences!.getString('name'),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5,),
          Container(
            decoration: const BoxDecoration(
              //color: Colors.blueGrey,
              boxShadow:  [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))],
            ),
            child: ClipRRect(
              borderRadius:  BorderRadius.circular(15.0),
              child: Image.network(widget.model!.thumbnailURL.toString(),
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),

            margin: const EdgeInsets.symmetric(horizontal: 1.0),

          ),

          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              widget.model!.title.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              widget.model!.longDescription.toString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              "GH₵ " + widget.model!.price.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          const SizedBox(height: 10,),
          Center(
            child: InkWell(
              onTap: () {
                //delete item
                deleteItem(widget.model!.itemID!);
              },
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
                    )
                ),
                width: MediaQuery.of(context).size.width - 12,
                height: 50,
                child: const Center(
                  child: Text(
                    "Delete Item",
                    style: TextStyle(color: Colors.black87, fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
