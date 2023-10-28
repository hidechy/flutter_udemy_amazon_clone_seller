import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fire_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/custom_text_field.dart';
import '../components/loading_dialog.dart';
import '../components/shared_prefs.dart';
import 'splash_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String downloadUrlImage = '';

  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();

  ///
  Future<void> getImageFromGallery() async {
    imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      // ignore: unnecessary_statements
      imgXFile;
    });
  }

  ///
  Future<void> formValidation() async {
    if (imgXFile == null) //image is not selected
    {
      await Fluttertoast.showToast(msg: 'Please select an image.');
    } else {
      //password is equal to confirm password
      if (passwordTextEditingController.text == confirmPasswordTextEditingController.text) {
        //check email, pass, confirm password & name text fields
        if (nameTextEditingController.text.isNotEmpty &&
            emailTextEditingController.text.isNotEmpty &&
            passwordTextEditingController.text.isNotEmpty &&
            confirmPasswordTextEditingController.text.isNotEmpty) {
          await showDialog(
              context: context,
              builder: (c) {
                return const LoadingDialog(message: 'Registering your account');
              });

          final fileName = DateTime.now().millisecondsSinceEpoch.toString();
          final storageRef = fire_storage.FirebaseStorage.instance.ref().child('sellersImages').child(fileName);
          final uploadImageTask = storageRef.putFile(File(imgXFile!.path));
          final taskSnapshot = await uploadImageTask.whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((urlImage) => downloadUrlImage = urlImage);

          await saveInformationToDatabase();
        } else {
          Navigator.pop(context);
          await Fluttertoast.showToast(msg: 'Please complete the form. Do not leave any text field empty.');
        }
      } else {
        await Fluttertoast.showToast(msg: 'Password and Confirm Password do not match.');
      }
    }
  }

  ///
  Future<void> saveInformationToDatabase() async {
    //authenticate the user first
    User? currentUser;

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
        .then(
      (auth) {
        currentUser = auth.user;
      },
    ).catchError(
      // ignore: inference_failure_on_untyped_parameter
      (errorMessage) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Error Occurred: \n $errorMessage');
      },
    );

    if (currentUser != null) {
      //save info to database and save locally
      await saveInfoToFirestoreAndLocally(currentUser!);
    }
  }

  ///
  Future<void> saveInfoToFirestoreAndLocally(User currentUser) async {
    //save to firestore
    await FirebaseFirestore.instance.collection('sellers').doc(currentUser.uid).set({
      'uid': currentUser.uid,
      'email': currentUser.email,
      'name': nameTextEditingController.text.trim(),
      'photoUrl': downloadUrlImage,
      'status': 'approved',
      'earnings': 0.0,
    });

    //save locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString('uid', currentUser.uid);
    await sharedPreferences!.setString('email', currentUser.email!);
    await sharedPreferences!.setString('name', nameTextEditingController.text.trim());
    await sharedPreferences!.setString('photoUrl', downloadUrlImage);

    // ignore: use_build_context_synchronously
    await Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
  }

  ///
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 12),

          //get-capture image
          GestureDetector(
            onTap: getImageFromGallery,
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.20,
              backgroundColor: Colors.white,
              backgroundImage: imgXFile == null ? null : FileImage(File(imgXFile!.path)),
              child: imgXFile == null
                  ? Icon(
                      Icons.add_photo_alternate,
                      color: Colors.grey,
                      size: MediaQuery.of(context).size.width * 0.20,
                    )
                  : null,
            ),
          ),

          const SizedBox(height: 12),

          //inputs form fields
          Form(
            key: formKey,
            child: Column(
              children: [
                //name
                CustomTextField(
                  textEditingController: nameTextEditingController,
                  iconData: Icons.person,
                  hintText: 'Name',
                  isObsecre: false,
                  enabled: true,
                ),

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

                //confirm pass
                CustomTextField(
                  textEditingController: confirmPasswordTextEditingController,
                  iconData: Icons.lock,
                  hintText: 'Confirm Password',
                  isObsecre: true,
                  enabled: true,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              ),
              onPressed: formValidation,
              child: const Text(
                'Sign Up',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
