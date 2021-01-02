import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;


class UploadPage extends StatefulWidget
{
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>
{
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptionTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _shortTextEditingController = TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false ;

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHomeScreen() : displayAdminUploadFormScreen();
  }
  displayAdminHomeScreen(){
    return Scaffold(
      appBar:AppBar(
        flexibleSpace:Container (
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors:[Colors.black,Colors.grey],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0) ,
              stops: [0.0, 1.0],
              tileMode:TileMode.clamp,
            ),
          ),
        ),
        // leading: IconButton(
        //   icon: Icon(Icons.border_color, color: Colors.white),
        //   onPressed: (){
        //     Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
        //     Navigator.pushReplacement(context, route);
        //   },
        // ),
        actions: [
          FlatButton(
              onPressed: (){
                Route route = MaterialPageRoute(builder: (c) => SplashScreen());
                Navigator.pushReplacement(context, route);
              },
              child: Text("Logout",style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold),))
        ],
      ),
      body: getAdminHomeScreenBody(),
    );

  }
  getAdminHomeScreenBody(){
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors:[Colors.black,Colors.grey],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0) ,
          stops: [0.0, 1.0],
          tileMode:TileMode.clamp,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shop_two,size: 200.0,color: Colors.white,),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
                child: Text("Add New Item",style: TextStyle(color: Colors.white,fontSize: 20.0,),),
                color: Colors.grey,
                onPressed: ()=> takeImg(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
  takeImg(mContext){
    return showDialog(
      context: mContext,
      builder: (con){
        return SimpleDialog(
          title: Text("Item Image",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
          children: [
            SimpleDialogOption(
              child: Text("Capture with camera",style: TextStyle(color: Colors.black,),),
              onPressed: ()=> capturePhotoWithCamera(),
            ),
            SimpleDialogOption(
              child: Text("Select from gallery",style: TextStyle(color: Colors.black,),),
              onPressed: ()=> pickPhotoFromGallery(),
            ),
            SimpleDialogOption(
              child: Text("Cancel",style: TextStyle(color: Colors.black,),),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }
  capturePhotoWithCamera() async {
    Navigator.pop(context);
    File imgFile = await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 680.0,maxWidth: 970.0);
    setState(() {
      file = imgFile;
    });
  }
  pickPhotoFromGallery() async {
    Navigator.pop(context);
    File imgFile = await ImagePicker.pickImage(source: ImageSource.gallery,);
    setState(() {
      file = imgFile;
    });
  }
  displayAdminUploadFormScreen(){
    return Scaffold(
      appBar:AppBar(
        flexibleSpace:Container (
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors:[Colors.black,Colors.grey],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0) ,
              stops: [0.0, 1.0],
              tileMode:TileMode.clamp,
            ),
          ),
        ),
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white),onPressed: clearFormInfo),
        title: Text("New Product",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24.0),),
        actions: [
          FlatButton(
              onPressed:uploading ? null : ()=> uploadImgAndSaveItemInfo(),
              child: Text("Add",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),))
        ],
      ),
      body: ListView(
        children: [
          uploading ? linearProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width*0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(image: FileImage(file),fit: BoxFit.cover)) ,
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0),),

          ListTile(
            leading: Icon(Icons.perm_device_info,color: Colors.black87,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.black54),
                controller: _shortTextEditingController,
                decoration: InputDecoration(
                  hintText: "Short Info like type , model etc..",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        Divider(color: Colors.black45),

          ListTile(
            leading: Icon(Icons.title,color: Colors.black87,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.black54),
                controller: _titleTextEditingController,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        Divider(color: Colors.black45),

          ListTile(
            leading: Icon(Icons.description,color: Colors.black87,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.black54),
                controller: _descriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        Divider(color: Colors.black45),

          ListTile(
            leading: Icon(Icons.monetization_on,color: Colors.black87,),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black54),
                controller: _priceTextEditingController,
                decoration: InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        Divider(color: Colors.black45),
        ],

      ),
    );
  }
  clearFormInfo(){
    setState(() {
      file = null;
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortTextEditingController.clear();
    });
  }
  uploadImgAndSaveItemInfo() async{
    setState(() {
      uploading=true;
    });
    String imgDownloadUrl = await uploadItemImg(file);
    saveItemInfo(imgDownloadUrl);
  }
  Future<String> uploadItemImg (mFileImg) async{
    final StorageReference storageReference = FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask storageUploadTask = storageReference.child("product_$productId.jpg").putFile(mFileImg);
    StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  saveItemInfo(String downloadUrl){
    final itemRef = FirebaseFirestore.instance.collection("item");
    itemRef.doc(productId).set({
      "shortInfo":_shortTextEditingController.text.trim(),
      "longDescription":_descriptionTextEditingController.text.trim(),
      "price":int.parse(_priceTextEditingController.text),
      "publishDate":DateTime.now(),
      "status":"available",
      "thumbnailUrl":downloadUrl,
      "title":_titleTextEditingController.text.trim(),
    });
    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortTextEditingController.clear();

    });

  }

}
