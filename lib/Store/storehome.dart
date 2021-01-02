import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
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
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Buyt",
            style: TextStyle(color: Colors.white,fontSize: 55.0,fontFamily: "Signatra"),
          ),

          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.white),
                  onPressed: (){
                    Route route = MaterialPageRoute(builder: (c) => StoreHome());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Positioned(child:
                  Stack(
                    children: [
                      Icon(Icons.brightness_1,size: 20.0,color: Colors.white,),
                      Positioned(
                        top: 3.0,
                        bottom: 4.0,
                        left: 3.0,
                        child: Consumer<CartItemCounter>(
                          builder: (context,counter,_){
                            return Text(
                                (EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length-1).toString(),
                                style: TextStyle(color: Colors.red,fontSize: 12.0,fontWeight: FontWeight.w500),
                            );
                          },
                        ),

                      )

                    ],

                ))
              ],
            )
          ],
        ),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(delegate: SearchBoxDelegate(),pinned: true,),
            StreamBuilder<QuerySnapshot>(
              stream:FirebaseFirestore.instance.collection("item").limit(15).orderBy("publishDate",descending: true).snapshots(),
              builder: (BuildContext context,dataSnapshot){
                return !dataSnapshot.hasData
                    ? SliverToBoxAdapter (child: Center(child: circularProgress(),),)
                    : SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 1,
                        staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                        itemBuilder: (context,index){
                          ItemModel model = ItemModel.fromJson(dataSnapshot.data.docs[index].data());
                          return sourceInfo(model,context);
                        } ,
                  itemCount: dataSnapshot.data.docs.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}



Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  width = MediaQuery.of(context).size.width;
  return InkWell(
    onTap:(){
      Route route = MaterialPageRoute(builder: (c)=>ProductPage(itemModel: model));
      Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.black38,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 190.0,
        width: width,
        child: Row(
          children: [
            Image.network(model.thumbnailUrl,width: 140.0,height: 140.0,),
            SizedBox(width: 4.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.0,),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Text(model.title,style: TextStyle(color: Colors.black,fontSize: 14.0),)),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0,),Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Text(model.shortInfo,style: TextStyle(color: Colors.black54,fontSize: 12.0),)
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.black,
                        ),
                        alignment: Alignment.topLeft,
                        width: 40.0,
                        height: 43.0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text(
                              "50%",style: TextStyle(color: Colors.white70,fontSize: 15.0,fontWeight: FontWeight.normal),
                            ),
                            Text(
                              "OFF",style: TextStyle(color: Colors.white70,fontSize: 12.0,fontWeight: FontWeight.normal),
                            ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text(
                                  r"Orignal Price : $ ",style: TextStyle(color: Colors.grey,fontSize: 14.0,decoration: TextDecoration.lineThrough),
                                ),
                                Text(
                                  (model.price+model.price).toString(),style: TextStyle(color: Colors.grey,fontSize: 15.0,decoration: TextDecoration.lineThrough),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  "New Price :",style: TextStyle(color: Colors.grey,fontSize: 14.0,),
                                ),
                                Text(
                                  r"$ ",style: TextStyle(color: Colors.redAccent,fontSize: 16.0,),
                                ),
                                Text(
                                  (model.price).toString(),style: TextStyle(color: Colors.grey,fontSize: 15.0,),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Flexible(
                    child: Container(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: removeCartFunction ==null
                      ? IconButton(
                        icon: Icon(Icons.add_shopping_cart,color: Colors.grey,),
                        onPressed: (){
                          checkItemInCart(model.shortInfo, context);
                        },
                      )
                      : IconButton(
                        icon: Icon(Icons.delete,color: Colors.grey,),
                        onPressed: (){
                          removeCartFunction();
                        } ,
                      ),
                  ),
                  Divider(
                    height: 5.0,
                    color: Colors.black45,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}



Widget card({Color primaryColor = Colors.white70, String imgPath}) {
  return Container(
    height: 150,
    width: width*.34,
    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      boxShadow: <BoxShadow>[
        BoxShadow(offset:Offset(0,5),blurRadius: 10.0,color: Colors.grey[200]),
      ]
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Image.network(
        imgPath,
        height: 150,
        width: width*.34,
        fit: BoxFit.fill,
      ),
    ),
  );
}



void checkItemInCart(String shortInfoAsID, BuildContext context) {
  EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).contains(shortInfoAsID)
      ? Fluttertoast.showToast(msg: "Item is already in the cart")
      : addItemToCart(shortInfoAsID,context);
}
addItemToCart(String shortInfoAsID,BuildContext context){
  List tempCartList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  tempCartList.add(shortInfoAsID);

  EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
    .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
    .set({
        EcommerceApp.userCartList:tempCartList,
      }).then((v) {
        Fluttertoast.showToast(msg: "Item Added To Cart");
        EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,tempCartList);
        Provider.of<CartItemCounter>(context,listen: false).displayResult();
  });
}
