
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers_app/brands/home_screen.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/splashScreen/my_splash_screen.dart';
import 'dart:io';

import 'package:sellers_app/widgets/progress_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

class UploadBrandsScreen extends StatefulWidget {
  const UploadBrandsScreen({Key? key}) : super(key: key);

  @override
  State<UploadBrandsScreen> createState() => _UploadBrandsScreenState();
}

class _UploadBrandsScreenState extends State<UploadBrandsScreen> {
  // get imagePicker => null;
  XFile? imageXFile;
  ImagePicker imagePicker = ImagePicker();

  TextEditingController brandController=TextEditingController();
  TextEditingController titleController=TextEditingController();
  String? downloadUrlImage;



  bool isUpload=false;

  String brandUniqueId=DateTime.now().millisecondsSinceEpoch.toString();
  saveBrandInfo(){
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(sharedPreferences!.getString('uid'))
        .collection('brands')
        .doc(brandUniqueId)
        .set({
           'brandId':brandUniqueId,
           'sellerUid':sharedPreferences!.getString('uid'),
           'brandInfo':brandController.text.trim(),
            'brandTitle':titleController.text.trim(),
      'publishDate':DateTime.now(),
      'status':'available',
      'thumbnailUrl':downloadUrlImage,
         });
    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
  }

  validateUploadForm() async{

    if(imageXFile != null)
      {
         if(brandController.text.isNotEmpty && titleController.text.isNotEmpty)
           {
             setState((){
               isUpload=true;
             });

             // save the image to fireStorage
             String fileName = DateTime.now().millisecondsSinceEpoch.toString();

             fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
                 .ref()
                 .child('sellersBrandImages')
                 .child(fileName);

             fStorage.UploadTask uploadImageTask =
             storageRef.putFile(File(imageXFile!.path));

             fStorage.TaskSnapshot taskSnapshot =
                 await uploadImageTask.whenComplete(() {});

             await taskSnapshot.ref.getDownloadURL().then((url) {
               downloadUrlImage = url;
             });

             saveBrandInfo();
           }
         else
             {
               Fluttertoast.showToast(msg: 'please complete data',backgroundColor: Colors.redAccent);
             }
      }
    else
      {
        Fluttertoast.showToast(msg: 'please select image',backgroundColor: Colors.redAccent);

      }

  }

  uploadFormScreen(){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:const Icon(Icons.arrow_back_rounded),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MySplashScreen()));
          },
        ),
        flexibleSpace: Container(
          decoration:const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.pinkAccent,
                  Colors.purpleAccent
                ],
                begin: FractionalOffset(0.0 ,0.0),
                end: FractionalOffset(1.0,0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp
            ),
          ),
        ),
        title:const Text('Upload New Brand'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: (){
                 isUpload ? null: validateUploadForm();
            }, icon: Icon(Icons.cloud_upload)),
          )
        ],

      ),
      body: ListView(
        children: [
          isUpload ?linearProgressBar():Container() ,
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width *0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image:DecorationImage(image:FileImage(File(imageXFile!.path)))
                  ),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pinkAccent,
            thickness: 2,
         ),
          ListTile(
            leading:const Icon(Icons.perm_device_info,color: Colors.deepPurple,),
            title: SizedBox(
              width: 250,
              child:  TextField(
                controller: brandController,
              decoration: InputDecoration(
                hintText: 'brand info',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pinkAccent,
            thickness: 2,
          ),
          ListTile(
            leading:const Icon(Icons.title,color: Colors.deepPurple,),
            title: SizedBox(
              width: 250,
              child:  TextField(
                controller: titleController,
                decoration: InputDecoration(
                    hintText: 'title',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none
                ),
              ),
            ),
          ),

          Divider(
            color: Colors.pinkAccent,
            thickness: 2,
          ),

        ],
      ),

    );
  }


  @override
  Widget build(BuildContext context) {
    return imageXFile == null? defaultScreen() : uploadFormScreen();
  }

  defaultScreen(){
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration:const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.pinkAccent,
                  Colors.purpleAccent
                ],
                begin: FractionalOffset(0.0 ,0.0),
                end: FractionalOffset(1.0,0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp
            ),
          ),
        ),
        title: Text('Add new brand'),
        centerTitle: true,

      ),
      body: Container(
        decoration:const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.pinkAccent,
                Colors.purpleAccent
              ],
              begin: FractionalOffset(0.0 ,0.0),
              end: FractionalOffset(1.0,0.0),
              stops: [0.0,1.0],
              tileMode: TileMode.clamp
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate_outlined,color: Colors.white,size: 200,),
              ElevatedButton(onPressed: (){
                obtainImageDialogBox();
              }
                  ,style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                      primary: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                      )
                  )
                  , child: Text('add new brand'))
            ],
          ),
        ),
      ),
    );
  }

  obtainImageDialogBox(){
    return showDialog(context: context, builder: (context){
      return SimpleDialog(
        title: Text('Brand Image',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),),
        children: [
          SimpleDialogOption(
            onPressed: (){
              getImageFromCamera();
            },
            child: const Text('Capture with camera',style: TextStyle(color: Colors.grey),),
          ),
          SimpleDialogOption(
            onPressed: (){
              getImageFromGallery();
            },
            child: const Text('Select Image with gallery',style: TextStyle(color: Colors.grey),),
          ),
          SimpleDialogOption(
            onPressed: (){
            },
            child: const Text('Cancel',style: TextStyle(color: Colors.red),),
          ),


        ],
      );
    });
  }



  Future<void> getImageFromGallery() async {
    Navigator.pop(context);
    imageXFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  Future<void> getImageFromCamera() async {
    Navigator.pop(context);
    imageXFile = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageXFile;
    });
  }

}
