import 'package:cloud_firestore/cloud_firestore.dart';

class Items {
  String? menuID;
  String? sellerUID;
  String? itemID;
  String? title;
  String? shortInfo;
  Timestamp? publishedDate;
  String? thumbnailURL;
  String? longDescription;
  String? status;
  int? price;

  Items({
    this.menuID,
    this.title,
    this.status,
    this.thumbnailURL,
    this.publishedDate,
    this.sellerUID,
    this.shortInfo,
    this.itemID,
    this.longDescription,
    this.price
  });

  Items.fromJson(Map<String, dynamic> json){
    menuID = json["menuID"];
    title = json["title"];
    status = json["status"];
    thumbnailURL = json["thumbnailURL"];
    publishedDate = json["publishedDate"];
    sellerUID = json["sellerUID"];
    shortInfo = json["shortInfo"];
    itemID = json["itemID"];
    longDescription = json["longDescription"];
    price = json["price"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["menuID"] = menuID;
    data["title"] = title;
    data["status"] = status;
    data["thumbnailURL"] = thumbnailURL;
    data["publishedDate"] = publishedDate;
    data["sellerUID"] = sellerUID;
    data["shortInfo"] = shortInfo;
    data["itemID"] = itemID;
    data["longDescription"] = longDescription;
    data["price"] = price;

    return data;
  }
}