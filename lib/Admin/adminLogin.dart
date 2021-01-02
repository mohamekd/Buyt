import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';




class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          title: Text(
            "Buyt",
            style: TextStyle(color: Colors.white,fontSize: 55.0,fontFamily: "Signatra"),
          ),
          centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{
  final TextEditingController _adminIdTextEditingController = TextEditingController();
  final TextEditingController _passwordTEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width
    ,_screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors:[Colors.black,Colors.grey],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0) ,
            stops: [0.0, 1.0],
            tileMode:TileMode.clamp,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset("images/admin.png") ,
              height: 240.0,
              width: 240.0,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child:Text("Admin",
                  style: TextStyle(color: Colors.white),),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIdTextEditingController,
                    data: Icons.person,
                    hintText: "ID",
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
              color: Colors.black45,
              child: Text("Sign in",style: TextStyle(color: Colors.white),),
              onPressed: (){
                _adminIdTextEditingController.text.isNotEmpty
                    && _passwordTEditingController.text.isNotEmpty
                    ?loginAdmin()
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
              height: 20.0,
            ),
            FlatButton.icon(
                onPressed: ()=>Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>AuthenticScreen()))
                , icon:Icon(Icons.not_interested_rounded , color: Colors.white,)
                , label: Text("I'm not the Admin" , style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
            ),
            SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
  loginAdmin(){
    FirebaseFirestore.instance.collection("admins").get().then((snapshot){
      snapshot.docs.forEach((result) {
        if(result.data()["id"]!=_adminIdTextEditingController.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your id isn't correct"),));
        }
        else if(result.data()["password"]!=_passwordTEditingController.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your password isn't correct"),));
        }
        else{
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Welcome Dear Admin"+result.data()["name"]),));
          setState(() {
            _adminIdTextEditingController.text="";
            _passwordTEditingController.text="";
          });
          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
