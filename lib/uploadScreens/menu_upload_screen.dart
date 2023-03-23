import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodrush_selling_app/global/global.dart';
import 'package:foodrush_selling_app/mainScreens/home_screen.dart';
import 'package:foodrush_selling_app/widgets/progress_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

import '../widgets/error_dialog.dart';

class MenuUploadScreen extends StatefulWidget {

  @override
  State<MenuUploadScreen> createState() => _MenuUploadScreenState();
}

class _MenuUploadScreenState extends State<MenuUploadScreen> {

  XFile? imageXFile;
  final ImagePicker _imagePicker = ImagePicker();

  bool uploading = false;
  String uniqueIdName = DateTime.now().microsecondsSinceEpoch.toString();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();

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
          "Add New Menu",
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
                  "Add New Menu",
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

  menusUploadFormScreen() {
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
          "Uploading New Menu",
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
                  hintText: "menu information",
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
                  hintText: "menu title",
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
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    if(imageXFile != null){
      if(shortInfoController.text.isNotEmpty && titleController.text.isNotEmpty) {
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
        .collection("menus");

    ref.doc(uniqueIdName).set({
      "menuID": uniqueIdName,
      "sellerUID": sharedPreferences!.getString("uid"),
      "menuInfo": shortInfoController.text.toString(),
      "menuTitle":titleController.text.toString(),
      "publishedDate": DateTime.now(),
      "satus": "available",
      "thumbnailURL": downLoadUrl,
    });

    clearMenuUploadForm();

    setState(() {
      uniqueIdName = DateTime.now().microsecondsSinceEpoch.toString();
      uploading = false;
    });
  }

  uploadUmage(mImageFile) async {
    storageRef.Reference reference = storageRef.FirebaseStorage
        .instance
        .ref()
        .child("menus");

    storageRef.UploadTask uploadTask = reference.child(uniqueIdName + ".jpg").putFile(mImageFile);
    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }


  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : menusUploadFormScreen();
  }
}
