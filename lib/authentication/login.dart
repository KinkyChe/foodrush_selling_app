import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodrush_selling_app/global/global.dart';
import 'package:foodrush_selling_app/mainScreens/home_screen.dart';
import 'package:foodrush_selling_app/widgets/error_dialog.dart';
import 'package:foodrush_selling_app/widgets/loading_dialog.dart';

import '../widgets/custom_text_field.dart';
import 'auth_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation() {
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
      //Login
        loginUser();
    }
    else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: "Please provide email and password!",);
          }
      );
    }
  }
  loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(message: "Authenticating user, ",);
        }
    );
    User? currentUser;
    await firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim()
    ).then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: error.message.toString(),
            );
          }
      );
    });
    if(currentUser != null) {
      readDataAndSetDataLocally(currentUser!);
    }
  }

  Future readDataAndSetDataLocally(User currentUser) async {
    await FirebaseFirestore.instance.collection("sellers")
        .doc(currentUser.uid)
        .get().then((snapshot) async {
          if(snapshot.exists){
            await sharedPreferences!.setString("uid", currentUser.uid);
            await sharedPreferences!.setString("email", snapshot.data()!["sellerEmail"]);
            await sharedPreferences!.setString("name", snapshot.data()!["sellerName"]);
            await sharedPreferences!.setString("photoUrl", snapshot.data()!["sellerAvatarUrl"]);

            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
          }
          else{
            firebaseAuth.signOut();
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));

            showDialog(
                context: context,
                builder: (c) {
                  return ErrorDialog(message: "Sorry seller account do not exist!",
                  );
                }
            );
          }
         });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                  "images/seller.png",
                  height: 270,
              ),

            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
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
              ],
            ),
          ),
          const SizedBox(height: 30,),
          ElevatedButton(
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.amber[500],
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            ),
            onPressed: () {
              formValidation();
            },
          ),
        ],
      ),
    );
  }
}

