import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'package:e_shop/Config/config.dart';


class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.lock,color:Colors.white),
                text: "Login",
              ),
              Tab(
                icon: Icon(Icons.perm_contact_calendar,color:Colors.white),
                text: "Register",

              )
            ],
            indicatorColor: Colors.white38,
            indicatorWeight: 5.0,
            labelColor: Colors.white,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: new LinearGradient(
            colors:[Colors.black,Colors.grey],
            begin:Alignment.topRight,
            end: Alignment.bottomLeft ,

          ),
        ),
          child: TabBarView(
            children: [
              Login(),
              Register(),
            ],
          ),
      ),
    ));
  }
}
