import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}





class _LoginState extends State<Login>
{

  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width
    ,_screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset("images/login.png") ,
              height: 240.0,
              width: 240.0,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child:
              Text("Login to your Account",style: TextStyle(color: Colors.white),),
              ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTEditingController ,
                    data: Icons.vpn_key,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              color: Colors.black54,
              child: Text("Sign in",style: TextStyle(color: Colors.white),),
              onPressed: (){
                _emailTextEditingController.text.isNotEmpty
                    && _passwordTEditingController.text.isNotEmpty
                    ?loginUserToAcc()
                    :showDialog(
                    context: context,
                    builder: (c){
                      return ErrorAlertDialog(message: "Please , fill the empty fields");
                    }
                );
              },
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              height: 8.0,
              color: Colors.grey[500],
              width: _screenWidth * 0.8,
            ),
            SizedBox(
              height: 10.0,
            ),
            FlatButton.icon(
                onPressed: ()=>Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>AdminSignInPage()))
                , icon:Icon(Icons.nature_people , color: Colors.white,)
                , label: Text("I'm Admin" , style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
            )

          ],
        ),
      ),
    );
  }

  FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  void loginUserToAcc() async {
    showDialog(
        context: context,
        builder: (c){
          return LoadingAlertDialog(message: "Authenticating, Please wait...");
        }
    );
    User firebaseUser;
    await _firebaseAuth.signInWithEmailAndPassword(
        email: _emailTextEditingController.text.trim(),
        password: _passwordTEditingController.text.trim())
        .then((authUser){
          firebaseUser =authUser.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c){
            return ErrorAlertDialog(message: error.message.toString());
          }
      );
    });
    if(firebaseUser!=null){
      readData(firebaseUser).then((s){
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);

      });
    }
  }

  Future readData(User fUser) async{

      FirebaseFirestore.instance.collection("Users").doc(fUser.uid).get().then((dataSnapshot) async{
        await EcommerceApp.sharedPreferences.setString("uid", dataSnapshot.data()[EcommerceApp.userUID]);
        await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, dataSnapshot.data()[EcommerceApp.userName]);
        await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, dataSnapshot.data()[EcommerceApp.userEmail]);
        await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, dataSnapshot.data()[EcommerceApp.userAvatarUrl]);
        List<String> cartList = dataSnapshot.data()[EcommerceApp.userCartList].cast<String>();
        await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, cartList);

      });

  }
}
