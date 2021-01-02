import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register> {
  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTEditingController = TextEditingController();
  // final TextEditingController _confirmPasswordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImgUrl = "";
  File _imgFile;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery
        .of(context)
        .size
        .width
    ,
        _screenHeight = MediaQuery
            .of(context)
            .size
            .height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 10.0),
            InkWell(
              onTap: _selectAndPickImg,
              child: CircleAvatar(
                  radius: _screenWidth * 0.15,
                  backgroundColor: Colors.white,
                  backgroundImage: _imgFile == null ? null : FileImage(
                      _imgFile),
                  child: _imgFile == null
                      ? Icon(Icons.add_photo_alternate, color: Colors.grey,
                      size: _screenWidth * 0.15)
                      : null
              ),
            ),
            SizedBox(height: 8.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameTextEditingController,
                    data: Icons.person,
                    hintText: "Name",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTEditingController,
                    data: Icons.vpn_key,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                  // CustomTextField(
                  //   controller: _confirmPasswordTextEditingController,
                  //   data: Icons.vpn_key_outlined,
                  //   hintText: "Confirm Password",
                  //   isObsecure: true,
                  // )
                ],
              ),
            ),
            RaisedButton(
              color: Colors.black54,
              child: Text("Sign up", style: TextStyle(color: Colors.white),),
              onPressed: () {
                uploadAndSaveImg();
              },
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 8.0,
              color: Colors.grey[500],
              width: _screenWidth * 0.8,
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndPickImg() async {
    _imgFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadAndSaveImg() async {
    if (_imgFile == null){
      showDialog(
        context: context,
        builder: (c){
          return ErrorAlertDialog(message: "Please pick an img");
        }
      );
    }
    else{
          // _passwordTEditingController==_confirmPasswordTextEditingController?
          _emailTextEditingController.text.isNotEmpty
              && _passwordTEditingController.text.isNotEmpty
              // && _confirmPasswordTextEditingController.text.isNotEmpty
              &&_nameTextEditingController.text.isNotEmpty
              ? saveToStorage()
              : displayDialog("Please fill up the registration complete form..");
              // :displayDialog("password do not match.");
    }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c){
          return ErrorAlertDialog(message: msg);
        }
    );
  }

  saveToStorage() async {
    showDialog(
        context: context,
        builder: (c){
          return LoadingAlertDialog(message: "Registration, Please wait...");
        }
    );
    String imgFileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference = FirebaseStorage.instance.ref().child(imgFileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(_imgFile);
    StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;
    await storageTaskSnapshot.ref.getDownloadURL().then((urlImage){
      userImgUrl = urlImage;
      _registerUser();
    });
  }

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void _registerUser() async {
    User firebaseUser;
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: _emailTextEditingController.text.trim(),
        password: _passwordTEditingController.text.trim())
    .then((auth){
      firebaseUser = auth.user;
    }).catchError((error){
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (c){
          return ErrorAlertDialog(message: error.message.toString());
        }
    );
    });
    if  (firebaseUser != null){
      saveUserInfoToFirestore(firebaseUser).then((value){
    Navigator.pop(context);
    Route route = MaterialPageRoute(builder: (c) => StoreHome());
    Navigator.pushReplacement(context, route);

    });
    }
    
  }

  Future saveUserInfoToFirestore(User fUser) async{
    FirebaseFirestore.instance.collection("Users").doc(fUser.uid).set({
      "uid":fUser.uid,
      "email":fUser.email,
      "name":_nameTextEditingController.text.trim(),
      "url":userImgUrl,
      EcommerceApp.userCartList: ["garbageValue"]
     });

    await EcommerceApp.sharedPreferences.setString("uid",fUser.uid );
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, _nameTextEditingController.text.trim());
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, fUser.email);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, userImgUrl);
    await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, ["garbageValue"]);
  }
}

