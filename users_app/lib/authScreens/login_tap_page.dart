import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/widgets/custome_text_field.dart';

import '../global/global.dart';
import '../splashScreen/my_splash_screen.dart';
import '../widgets/loading_dialog.dart';

class LoginTapPage extends StatefulWidget {
  @override
  State<LoginTapPage> createState() => _LoginTapPageState();
}

class _LoginTapPageState extends State<LoginTapPage> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  formValidate() {
    if (emailTextEditingController.text.isNotEmpty &&
        passwordTextEditingController.text.isNotEmpty) {
      loginUser();
    }
    else {
      Fluttertoast.showToast(msg: 'please complete your data');
    }
  }

  loginUser() async{
    showDialog(
        context: context,
        builder: (c)
        {
          return LoadingDialog(
            message: "Checking credentials",
          );
        }
    );

    User? currentUser;
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim()).then((value) {
          currentUser=value.user;
          print('login success');
    }).catchError((e){
      Navigator.pop(context);
      Fluttertoast.showToast(msg: '${e.toString()}');
    });
    
    if(currentUser != null)
    {
      checkIfUserRecordExists(currentUser!);
    }

  }

  checkIfUserRecordExists(User currentUser) async
  {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get()
        .then((record) async
    {
      if(record.exists) //record exists
          {
        //status is approved
        if(record.data()!["status"] == "approved")
        {
          await sharedPreferences!.setString("uid", record.data()!["uid"]);
          await sharedPreferences!.setString("email", record.data()!["email"]);
          await sharedPreferences!.setString("name", record.data()!["name"]);
          await sharedPreferences!.setString("photoUrl", record.data()!["photoUrl"]);

          List<String> userCartList = record.data()!["userCart"].cast<String>();
          await sharedPreferences!.setStringList("userCart", userCartList);

          //send user to home screen
          Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));

        }
        else //status is not approved
            {
          FirebaseAuth.instance.signOut();
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "you have BLOCKED by admin.\ncontact Admin: admin@ishop.com");
        }
      }
      else //record not exists
          {
        FirebaseAuth.instance.signOut();
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "This user's record do not exists.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(
            'images/login.png',
            height: MediaQuery.of(context).size.height * 0.35,
          ),
          // email
          Form(
            key: formKey,
            child: Column(
              children: [
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
              formValidate();
            },
            child: const Text(
              'Login',
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
