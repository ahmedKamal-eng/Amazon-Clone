import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import '../global/global.dart';
import '../splashScreen/my_splash_screen.dart';
import '../widgets/custome_text_field.dart';
import '../widgets/loading_dialog.dart';


class RegistrationTapPage extends StatefulWidget {
  @override
  State<RegistrationTapPage> createState() => _RegistrationTapPageState();
}

class _RegistrationTapPageState extends State<RegistrationTapPage> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();

  // get image from gallery
  XFile? imageXFile;
  ImagePicker imagePicker = ImagePicker();
  String? downloadUrlImage;

  Future<void> getImageFromGallery() async {
    imageXFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  formValidation() async {
    if (imageXFile == null) {
      Fluttertoast.showToast(
          msg: 'please select image', backgroundColor: Colors.redAccent);
      Navigator.pop(context);
    } else if (confirmPasswordTextEditingController.text !=
        passwordTextEditingController.text) {
      Fluttertoast.showToast(
          msg: 'password not equal confirmed password',
          backgroundColor: Colors.redAccent);
      Navigator.pop(context);
    } else if (confirmPasswordTextEditingController.text.isEmpty ||
        passwordTextEditingController.text.isEmpty ||
        emailTextEditingController.text.isEmpty ||
        nameTextEditingController.text.isEmpty ||
        phoneTextEditingController.text.isEmpty ||
        locationTextEditingController.text.isEmpty
    ) {
      Fluttertoast.showToast(
          msg: 'please complete your data', backgroundColor: Colors.redAccent);
      Navigator.pop(context);

    } else {

      showDialog(context: context, builder: (context) =>  LoadingDialog(message: 'Registering your account',));
      // Upload the image to firebase Storage

      // we used time as fileName because time is unique
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
          .ref()
          .child('sellersImages')
          .child(fileName);

      fStorage.UploadTask uploadImageTask =
          storageRef.putFile(File(imageXFile!.path));

      fStorage.TaskSnapshot taskSnapshot =
          await uploadImageTask.whenComplete(() {});

      await taskSnapshot.ref.getDownloadURL().then((url) {
        downloadUrlImage = url;
      });
      saveTheInformationToDataBase();
    }
  }

  saveTheInformationToDataBase() async {
    User? currentUser;

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passwordTextEditingController.text.trim())
        .then((auth) {
      currentUser = auth.user;
    }).catchError((e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'error : ${e.toString()}');
    });

    if (currentUser != null) {
      saveInfoToFirestoreAndLocally(currentUser);
    }
  }

  saveInfoToFirestoreAndLocally(User? currentUser)  async{
    //Save to firestore
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(currentUser!.uid)
        .set({
      'uid':currentUser.uid,
      'email':currentUser.email,
      'name':nameTextEditingController.text.trim(),
      'photoUrl':downloadUrlImage,
      'phone':phoneTextEditingController.text.trim(),
      'location':locationTextEditingController.text.trim(),
      'status':'approved',
      'earnings':0.0,

    });

    //save locally
    sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences!.setString('uid', currentUser.uid);
    await sharedPreferences!.setString('email', currentUser.email!);
    await sharedPreferences!.setString('name', nameTextEditingController.text.trim());
    await sharedPreferences!.setString('photoUrl', downloadUrlImage!);
    await sharedPreferences!.setString('status', 'approved');

    Navigator.push(context, MaterialPageRoute(builder: (context)=>MySplashScreen()));
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              getImageFromGallery();
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage:
                  imageXFile == null ? null : FileImage(File(imageXFile!.path)),
              radius: MediaQuery.of(context).size.width * 0.2,
              child: imageXFile == null
                  ? Icon(
                      Icons.add_photo_alternate,
                      color: Colors.grey,
                      size: MediaQuery.of(context).size.width * 0.2,
                    )
                  : null,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                //name
                CustomTextField(
                  textEditingController: nameTextEditingController,
                  iconData: Icons.person,
                  hintText: 'name',
                  isObsecre: false,
                  enabled: true,
                ),
                // email
                CustomTextField(
                  textEditingController: emailTextEditingController,
                  iconData: Icons.email,
                  hintText: 'email',
                  isObsecre: false,
                  enabled: true,
                ),
                //password
                CustomTextField(
                  textEditingController: passwordTextEditingController,
                  iconData: Icons.password_outlined,
                  hintText: 'password',
                  isObsecre: true,
                  enabled: true,
                ),
                //confirm password
                CustomTextField(
                  textEditingController: confirmPasswordTextEditingController,
                  iconData: Icons.password,
                  hintText: 'confirm password',
                  isObsecre: true,
                  enabled: true,
                ),
                CustomTextField(
                  textEditingController: phoneTextEditingController,
                  iconData: Icons.phone,
                  hintText: 'phone',
                  isObsecre: false,
                  enabled: true,
                ),
                CustomTextField(
                  textEditingController: locationTextEditingController,
                  iconData: Icons.location_city,
                  hintText: 'location',
                  isObsecre: false,
                  enabled: true,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
            onPressed: () {
              formValidation();
            },
            child: const Text(
              'sign Up',
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
