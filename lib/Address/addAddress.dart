import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Models/address.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatelessWidget {

  final formKey =GlobalKey<FormState>();
  final scaffoldKey =GlobalKey<ScaffoldState>();
  final cName =TextEditingController();
  final cPhoneNum =TextEditingController();
  final cFlatNum =TextEditingController();
  final cCity =TextEditingController();
  final cState =TextEditingController();
  final cPinCode =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("Done"),
          backgroundColor: Colors.black45,
          icon: Icon(Icons.check),
          onPressed: (){
            if(formKey.currentState.validate()){
              final model = AddressModel(
                name: cName.text.trim(),
                state: cState.text.trim(),
                pincode: cPinCode.text,
                phoneNumber: cPhoneNum.text,
                flatNumber: cFlatNum.text,
                city: cCity.text.trim(),
              ).toJson();
              //add to firestore
              EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
                .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
                .collection(EcommerceApp.subCollectionAddress)
                .doc(DateTime.now().millisecondsSinceEpoch.toString())
                .set(model)
                .then((value){
                 final snack = SnackBar(content: Text("New Address Added"));
                 scaffoldKey.currentState.showSnackBar(snack);
                 FocusScope.of(context).requestFocus(FocusNode());
                 formKey.currentState.reset();
              });
              Route route = MaterialPageRoute(builder: (c) => StoreHome());
              Navigator.pushReplacement(context, route);
            }
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.center ,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Add new address",
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0),),

                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "Name" ,
                      controller: cName ,
                    ),
                    Divider(thickness: 6.0,color: Colors.black87,),
                    MyTextField(
                      hint:"Phone Number" ,
                      controller: cPhoneNum,
                    ),
                    Divider(thickness: 6.0,color: Colors.black87,),
                    MyTextField(
                      hint:"Flat Number / House Number" ,
                      controller: cFlatNum,
                    ),
                    Divider(thickness: 6.0,color: Colors.black87,),
                    MyTextField(
                      hint: "City",
                      controller:cCity ,
                    ),
                    Divider(thickness: 6.0,color: Colors.black87,),
                    MyTextField(
                      hint:"State / Country" ,
                      controller: cState,
                    ),
                    Divider(thickness: 6.0,color: Colors.black87,),
                    MyTextField(
                      hint: "Pin Code",
                      controller: cPinCode,
                    ),
                    Divider(thickness: 6.0,color: Colors.black87,),
                  ],
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}

class MyTextField extends StatelessWidget {

  final String hint;
  final TextEditingController controller;

  MyTextField({Key key,this.hint,this.controller,}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val)=>val.isEmpty?"Field can not be empty":null,
      ),

    );
  }
}
