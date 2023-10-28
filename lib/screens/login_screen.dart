import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../components/custom_text_field.dart';
import '../components/loading_dialog.dart';
import '../components/shared_prefs.dart';
import 'splash_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ///
  void validateForm() {
    if (emailTextEditingController.text.isNotEmpty && passwordTextEditingController.text.isNotEmpty) {
      loginNow();
    } else {
      Fluttertoast.showToast(msg: 'Please provide email and password.');
    }
  }

  ///
  Future<void> loginNow() async {
    await showDialog(
        context: context,
        builder: (c) {
          return const LoadingDialog(message: 'Checking credentials');
        });

    User? currentUser;

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        )
        .then((auth) => currentUser = auth.user)
        .catchError(
      // ignore: inference_failure_on_untyped_parameter, body_might_complete_normally_catch_error
      (errorMessage) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Error Occurred: \n $errorMessage');
      },
    );

    if (currentUser != null) {
      await checkIfSellerRecordExists(currentUser!);
    }
  }

  ///
  Future<void> checkIfSellerRecordExists(User currentUser) async {
    await FirebaseFirestore.instance.collection('sellers').doc(currentUser.uid).get().then((record) async {
      if (record.exists) //record exists
      {
        //status is approved
        if (record.data()!['status'] == 'approved') {
          await sharedPreferences!.setString('uid', record.data()!['uid']);
          await sharedPreferences!.setString('email', record.data()!['email']);
          await sharedPreferences!.setString('name', record.data()!['name']);
          await sharedPreferences!.setString('photoUrl', record.data()!['photoUrl']);

          //send seller to home screen
          // ignore: use_build_context_synchronously
          await Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
        } else //status is not approved
        {
          await FirebaseAuth.instance.signOut();
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          await Fluttertoast.showToast(msg: 'you have BLOCKED by admin.\ncontact Admin: admin@ishop.com');
        }
      } else //record not exists
      {
        await FirebaseAuth.instance.signOut();
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        await Fluttertoast.showToast(msg: "This seller's record do not exists.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/seller.png',
              height: MediaQuery.of(context).size.height * 0.40,
            ),
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                //email
                CustomTextField(
                  textEditingController: emailTextEditingController,
                  iconData: Icons.email,
                  hintText: 'Email',
                  isObsecre: false,
                  enabled: true,
                ),

                //pass
                CustomTextField(
                  textEditingController: passwordTextEditingController,
                  iconData: Icons.lock,
                  hintText: 'Password',
                  isObsecre: true,
                  enabled: true,
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              ),
              onPressed: validateForm,
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              emailTextEditingController.text = 'hide.toyoda@gmail.com';
              passwordTextEditingController.text = 'hidechy4819';
            },
            child: const Text('dummy'),
          ),
        ],
      ),
    );
  }
}
