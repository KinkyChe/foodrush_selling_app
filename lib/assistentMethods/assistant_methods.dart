import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodrush_selling_app/global/global.dart';


separateOrderItemIDs(orderIDs) {
  List<String> separateItemIDsList = [],  defaultItemList = [];
  int i=0;

  defaultItemList = List<String>.from(orderIDs);

  for(i; i<defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemID = (pos != -1) ? item.substring(0, pos) : item;
    print("\nThis is ItemID now = " + getItemID);

    separateItemIDsList.add(getItemID);
  }
  print("\nThis is Item List now = " );
  print(separateItemIDsList);

  return separateItemIDsList;
}

separateItemIDs() {
  List<String> separateItemIDsList = [],  defaultItemList = [];
  int i=0;

  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for(i; i<defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemID = (pos != -1) ? item.substring(0, pos) : item;
    print("\nThis is ItemID now = " + getItemID);

    separateItemIDsList.add(getItemID);
  }
  print("\nThis is Item List now = " );
  print(separateItemIDsList);

  return separateItemIDsList;
}

addItemToCart(String? foodItemID, BuildContext context, int itemCounter) {
  List<String>? tempList = sharedPreferences!.getStringList("userCart");
  tempList!.add(foodItemID! + ":$itemCounter");

  FirebaseFirestore.instance.collection("users")
      .doc(firebaseAuth.currentUser!.uid).update({
    "userCart": tempList,
  }).then((value) {
    Fluttertoast.showToast(msg: "Item Added Successfully");
    sharedPreferences!.setStringList("userCart", tempList);

    //update the badge

  });

}

separateOrderItemQuantities(orderIDs) {
  List<String> separateItemQuantityList = [];
  List<String> defaultItemList = [];
  int i=1;

  defaultItemList = List<String>.from(orderIDs);

  for(i; i<defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    //var pos = item.lastIndexOf(":");
    //String getItemID = (pos != -1) ? item.substring(0, pos) : item;
    List<String> listItemCharaters = item.split(":").toList();
    var quantityNumber = int.parse(listItemCharaters[1].toString());
    print("\nThis is ItemID now = " + quantityNumber.toString());
    separateItemQuantityList.add(quantityNumber.toString());
  }
  print("\nThis is Quantity List now = " );
  print(separateItemQuantityList);

  return separateItemQuantityList;
}

separateItemQuantities() {
  List<int> separateItemQuantityList = [];
  List<String> defaultItemList = [];
  int i=1;

  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for(i; i<defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    //var pos = item.lastIndexOf(":");
    //String getItemID = (pos != -1) ? item.substring(0, pos) : item;
    List<String> listItemCharaters = item.split(":").toList();
    var quantityNumber = int.parse(listItemCharaters[1].toString());
    print("\nThis is ItemID now = " + quantityNumber.toString());

    separateItemQuantityList.add(quantityNumber);
  }
  print("\nThis is Quantity List now = " );
  print(separateItemQuantityList);

  return separateItemQuantityList;
}

clearCartNow(context){
  sharedPreferences!.setStringList("userCart", ['garbageValue']);
  List<String>? emptyList = sharedPreferences!.getStringList('userCart');

  FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .update({'userCart': emptyList}).then((value) {
    sharedPreferences!.setStringList("userCart", emptyList!);

  });
}