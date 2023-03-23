import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodrush_selling_app/global/global.dart';
import 'package:foodrush_selling_app/mainScreens/home_screen.dart';
import 'package:foodrush_selling_app/widgets/progress_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

import '../model/menus.dart';
import '../widgets/error_dialog.dart';

class ItemsUploadScreen extends StatefulWidget {
  final Menus? model;

  ItemsUploadScreen({this.model});

  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {

  XFile? imageXFile;
  final ImagePicker _imagePicker = ImagePicker();

  bool uploading = false;
  String uniqueIdName = DateTime.now().microsecondsSinceEpoch.toString();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber,
                  Colors.amberAccent,
                ],
                begin:  FractionalOffset(0.0, 0.0),
                end:  FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        title: const Text(
          "Add New Item",
          style: TextStyle(fontSize: 30, fontFamily: "Lobster", color: Colors.black54),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
          },
        ),
      ),
      body: Container(
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shop_two, color: Colors.black54, size: 200.0,),
                ElevatedButton(
                  child: const Text(
                    "Add New Item",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.amberAccent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      ),
                    ),
                  ),
                  onPressed: () {
                    takeImage(context);
                  },
                ),
              ],
            ),
          )
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return  SimpleDialog(
          title: const Text(
            "Menu Image",
            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
          ),
          children: [
            SimpleDialogOption(
              child: const Text(
                "Capture With Camera",
                style: TextStyle(
                    color: Colors.grey
                ),
              ),
              // Call to the capture image with camera function
              onPressed: captureImageWithCanera,
            ),
            SimpleDialogOption(
              child: const Text(
                "Select Image From Gallery",
                style: TextStyle(
                    color: Colors.grey
                ),
              ),
              //Call to the pick image from gallery function
              onPressed: pickImageFromGallery,
            ),
            SimpleDialogOption(
              child: const Text(
                "Cancel",
                style: TextStyle(
                    color: Colors.red
                ),
              ),
              onPressed: ()=> Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  //Implementing the capture image with the device camera function
  Future<void> captureImageWithCanera() async {
    Navigator.pop(context);
    imageXFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });

  }

  //Implementing the pick image from device gallery
  Future<void> pickImageFromGallery() async {
    Navigator.pop(context);
    imageXFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  itemsUploadFormScreen() {
    return Scaffold(
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
        title: const Text(
          "Uploading New Item",
          style: TextStyle(fontSize: 30, fontFamily: "Lobster", color: Colors.black54),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54,),
          onPressed: () {
            clearMenuUploadForm();
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              "Add",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            onPressed: uploading ? null : ()=> validateUploadForm(),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading == true ? linearProgress() : Text(""),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.3,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(
                            File(imageXFile!.path)
                        ),
                        fit: BoxFit.cover,
                      )
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.cyan,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.perm_device_information, color: Colors.cyan,),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: shortInfoController,
                decoration: const InputDecoration(
                  hintText: "information",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.cyan,
            thickness: 1,
          ),

          ListTile(
            leading: const Icon(Icons.title, color: Colors.cyan,),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "title",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const Divider(
            color: Colors.cyan,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.description, color: Colors.cyan,),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: "description",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const Divider(
            color: Colors.cyan,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.camera, color: Colors.cyan,),
            title: Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                controller: priceController,
                decoration: const InputDecoration(
                  hintText: "price",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const Divider(
            color: Colors.cyan,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  clearMenuUploadForm() {
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      priceController.clear();
      descriptionController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    if(imageXFile != null){
      if(shortInfoController.text.isNotEmpty &&
          titleController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          priceController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });

        //upload amd save meny details to forestore
        //upload image
        String downloadURL = await uploadUmage(File(imageXFile!.path));

        //Save menu details to firestore
        saveInfo(downloadURL);
      }else{
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Provide tittle and other menu information!",
              );
            }
        );
      }
    } else{
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Pick an image for menu!",
            );
          }
      );
    }
  }

  saveInfo(String downLoadUrl) {
    final ref = FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus").doc(widget.model!.menuID)
        .collection("items");

    ref.doc(uniqueIdName).set({
      "itemID": uniqueIdName,
      "menuID": widget.model!.menuID,
      "sellerUID": sharedPreferences!.getString("uid"),
      "sellerName": sharedPreferences!.getString("name"),
      "shortInfo": shortInfoController.text.toString(),
      "longDescription": descriptionController.text.toString(),
      "price": int.parse(priceController.text.toString()) ,
      "title":titleController.text.toString(),
      "publishedDate": DateTime.now(),
      "satus": "available",
      "thumbnailURL": downLoadUrl,
    }).then((value) {
      final itemsRef = FirebaseFirestore.instance
          .collection("items");

      itemsRef.doc(uniqueIdName).set({
        "itemID": uniqueIdName,
        "menuID": widget.model!.menuID,
        "sellerUID": sharedPreferences!.getString("uid"),
        "sellerName": sharedPreferences!.getString("name"),
        "shortInfo": shortInfoController.text.toString(),
        "longDescription": descriptionController.text.toString(),
        "price": int.parse(priceController.text.toString()) ,
        "title":titleController.text.toString(),
        "publishedDate": DateTime.now(),
        "satus": "available",
        "thumbnailURL": downLoadUrl,
      });
    }).then((value) {
      clearMenuUploadForm();

      setState(() {
        uniqueIdName = DateTime.now().microsecondsSinceEpoch.toString();
        uploading = false;
      });
    });
  }

  uploadUmage(mImageFile) async {
    storageRef.Reference reference = storageRef.FirebaseStorage
        .instance
        .ref()
        .child("items");

    storageRef.UploadTask uploadTask = reference.child(uniqueIdName + ".jpg").putFile(mImageFile);
    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }


  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : itemsUploadFormScreen();
  }
}
