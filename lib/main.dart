import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Counters/ItemQuantity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EcommerceApp.auth=FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = FirebaseFirestore.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c)=> CartItemCounter()),
        ChangeNotifierProvider(create: (c)=> ItemQuantity()),
        ChangeNotifierProvider(create: (c)=> AddressChanger()),
        ChangeNotifierProvider(create: (c)=> TotalAmount()),
      ], child: MaterialApp(
        title: 'Buyt',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.grey,
        ),
        home: SplashScreen()
    ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen>
{
  @override
  void initState() {
    super.initState();
    displaySplash();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/welcome.png"),
              SizedBox(height: 20),
              Text("World's Largest Online Shop",
              style: TextStyle(color:Colors.white))
            ],
          ),
        ),
      ),
    );
  }

  displaySplash() {
    Timer(Duration(seconds:5),() async{
    if(await EcommerceApp.auth.currentUser != null){
      Route route = MaterialPageRoute(builder: (_)=>StoreHome());
      Navigator.pushReplacement(context, route);
    }else{
      Route route = MaterialPageRoute(builder: (_)=>AuthenticScreen());
      Navigator.pushReplacement(context, route);
    }
    });
  }
}
