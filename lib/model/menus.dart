import 'package:cloud_firestore/cloud_firestore.dart';

class Menus {
  String? menuID;
  String? sellerUID;
  String? menuTitle;
  String? menuInfo;
  Timestamp? publishedDate;
  String? thumbnailURL;
  String? status;

  Menus({
   this.menuID,
   this.sellerUID,
   this.menuInfo,
   this.menuTitle,
   this.publishedDate,
   this.status,
   this.thumbnailURL
});

  Menus.fromjson(Map<String, dynamic> json){
    menuID = json["menuID"];
    sellerUID = json["sellerUID"];
    menuTitle = json["menuTitle"];
    menuInfo = json["menuInfo"];
    publishedDate = json["publishedDate"];
    thumbnailURL = json["thumbnailURL"];
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["menuID"] = menuID;
    data["sellerUID"] = sellerUID;
    data["menuTitle"] = menuTitle;
    data["menuInfo"] = menuInfo;
    data["publishedDate"] = publishedDate;
    data["thumbnailURL"] = thumbnailURL;
    data["status"] = status;

    return data;
  }
}