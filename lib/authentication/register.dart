import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodrush_selling_app/mainScreens/home_screen.dart';
import 'package:foodrush_selling_app/widgets/custom_text_field.dart';
import 'package:foodrush_selling_app/widgets/loading_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

import '../global/global.dart';
import '../widgets/error_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placemarks;

  String sellerImageUrl = "";
  String completeAddress = "";

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }

  getCurrentLocation() async {
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    position = newPosition;
    placemarks = await placemarkFromCoordinates(
      position!.latitude, position!.longitude
    );

    Placemark pMark = placemarks![0];

    completeAddress = '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.postalCode}, ${pMark.country}';
    locationController.text = completeAddress;
  }

  Future<void> signupFormValidation() async {
    if(imageXFile == null) {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: "Please select an image!",
          );
        }
      );
    }
    else {
      if(passwordController.text == confirmPasswordController.text) {

        if (confirmPasswordController.text.isNotEmpty &&
            emailController.text.isNotEmpty && nameController.text.isNotEmpty &&
            locationController.text.isNotEmpty && phoneController.text.isNotEmpty) {
          //upload data to database
          showDialog(
              context: context,
              builder: (c) {
                return LoadingDialog(
                  message: ("Registering Account"),
                );
              }
          );

          String fileName = DateTime.now().microsecondsSinceEpoch.toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("Sellers").child(fileName);
          fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

          await taskSnapshot.ref.getDownloadURL().then((url) {
            sellerImageUrl = url;

            //save information to firestore database

            authenticateSellerAndSignUp();

          });

        }
        else {
          showDialog(
              context: context,
              builder: (c) {
                return ErrorDialog(
                  message: "Please complete required information for registration!",
                );
              }
          );
        }
      }
      else {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Passswords do not match!",
              );
            }
        );
      }
    }
  }

  void authenticateSellerAndSignUp() async{
    User? currentUser;
    await firebaseAuth.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((auth) {
      currentUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          }
      );
    });

    if(currentUser != null) {
      saveDataToFireStore(currentUser!).then((value) {
        Navigator.pop(context);
        //send user to homepage
        Route newRoute = MaterialPageRoute(builder: (c) => HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future saveDataToFireStore(User currentuser) async {
    FirebaseFirestore.instance.collection("sellers").doc(currentuser.uid).set(
        {
          "sellerUID": currentuser.uid,
          "sellerEmail": currentuser.email,
          "sellerName": nameController.text.trim(),
          "sellerAvatarUrl": sellerImageUrl,
          "phone": phoneController.text.trim(),
          "address": completeAddress,
          "status": "approved",
          "earnings": 0.0,
          "lat": position!.latitude,
          "lng": position!.longitude,
        });

    //save data locally
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("uid", currentuser.uid);
    await sharedPreferences.setString("name", nameController.text.trim());
    await sharedPreferences.setString("email", currentuser.email.toString());
    await sharedPreferences.setString("photoUrl", sellerImageUrl);

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10,),
            InkWell(
              onTap: () {
                _getImage();
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundColor: Colors.white,
                backgroundImage: imageXFile==null ? null : FileImage(File(imageXFile!.path)),
                child: imageXFile == null ? Icon(
                  Icons.add_photo_alternate,
                  size: MediaQuery.of(context).size.width * 0.20,
                  color: Colors.grey,
                ) : null,
              ),
            ),
            const SizedBox(height: 10,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: nameController,
                    hintText: "Name",
                    isObscure: false,
                  ),
                  CustomTextField(
                    data: Icons.email,
                    controller: emailController,
                    hintText: "Email",
                    isObscure: false,

                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: passwordController,
                    hintText: "Password",
                    isObscure: true,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    isObscure: true,
                  ),
                  CustomTextField(
                    data: Icons.phone,
                    controller: phoneController,
                    hintText: "Phone",
                    isObscure: false,
                  ),
                  CustomTextField(
                    data: Icons.my_location,
                    controller: locationController,
                    hintText: "Resturant Addtress",
                    isObscure: false,
                    enabled: false,
                  ),
                  Container(
                    width: 400,
                    height: 40,
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      label: const Text(
                        "Get my current location",
                        style: TextStyle(color: Colors.black54),
                      ),
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        getCurrentLocation();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )
                      ),
                    ),
                  )
                ],
              ),

            ),
            const SizedBox(height: 30,),
            ElevatedButton(
              child: const Text(
                "Sign Up",
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.amber[500],
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              onPressed: () {
                signupFormValidation();
              },
            ),
          ],
        ),
      ),
    );
  }
}
