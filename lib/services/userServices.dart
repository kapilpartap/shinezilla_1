
import 'dart:convert';

import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/CustomWidget/CustomWidget.dart';
import 'package:carwash/Model/api/ApiStrings.dart';
import 'package:carwash/Model/http/ApiClient.dart';
import 'package:carwash/model/Helper/categoriesServices.dart';
import 'package:carwash/model/Helper/get_vechile.dart';
import 'package:carwash/model/locationapi/LocationConverter.dart';
import 'package:carwash/model/locationapi/LocationHandler.dart';
import 'package:carwash/model/sharedpre/userSharedPrefernces.dart';
import 'package:carwash/userVechile/UserSelectVechile.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class UserServices extends StatefulWidget {
  @override
  State<UserServices> createState() => _UserServicesState();
}

class _UserServicesState extends State<UserServices> {
  String? id ,category_name,catfolder,catimage ,name;
  _UserServicesState();

  ApiClient client = new ApiClient();

  Future<List<CategoriesServices>>? categoryService;

  String currentAddress="";
  double? discountAmount;

  Future<List<VechileAdded>>? vechileads;
  List<VechileAdded> vechileAd = [];

  @override
  void didChangeDependencies() {
  final routeargs = ModalRoute.of(context)?.settings.arguments as Map;

    id = routeargs["id"].toString() != null ? routeargs["id"].toString() : '0';
    category_name = routeargs["category_name"].toString() != null ? routeargs["category_name"].toString() : "All Service";
    catfolder = routeargs["catfolder"].toString() != null ? routeargs["catfolder"].toString() : "category_logo";
    catimage = routeargs["catimage"].toString() != null ? routeargs["catimage"].toString() : "";
    categoryService=  getCategoryServices(id);

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
   @override
  void initState() {
     getmyVechile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     UserSharedPrefernces.init();
    setState(() {
      currentAddress=UserSharedPrefernces.getuserlocation().toString();
    });
    return Scaffold (
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor:Colors.white,
          title: Text('Services',style: GoogleFonts.alkalami(fontWeight: FontWeight.bold,fontSize: 17,
              color: ColorConverter.stringToHex(AppStrings.bg_color)),),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, '/userHomeNav');
              //Navigator.push(context,MaterialPageRoute(builder: (context)=>UserHome()));
              },
          ),
            // actions: [
            //   Padding(
            //       padding: EdgeInsets.only(right: 10),
            //       child: IconButton(icon: Icon(Icons.location_on),onPressed: (){
            //         _showDialog();
            //       }, color:ColorConverter.stringToHex(AppStrings.bg_color ),)),
            // ]
        ),
        body:  SingleChildScrollView(
            child: Column(
              children: [
                // Container(
                //   padding: EdgeInsets.only(top: 10),
                //   child: currentAddress!="null" ? Text(currentAddress.toString(),
                //     style: TextStyle(fontSize: 10 ,fontWeight: FontWeight.bold),)
                //       : Text("select location onTap on location icon....",style: TextStyle(color: Colors.grey)),
                // ),
                 Padding(padding: EdgeInsets.only(top: 5,left: 12,right: 12,bottom: 20),

            child: Container(
               child: Column(children: [
                  Padding(padding: EdgeInsets.only(top: 10),
                 child: Image.asset('assets/images/slide.png',
                   //height:120,width:double.infinity,fit: BoxFit.cover,
                 )),
                  Padding(padding: EdgeInsets.only(top: 10),
                    child: Text(category_name.toString(),
                              style: GoogleFonts.alkalami(fontWeight: FontWeight.bold,
                                fontSize: 15,color: Colors.black),textAlign: TextAlign.center,),),
                 ],)
            )),


         FutureBuilder<List<CategoriesServices>>(
              future:  categoryService,
              builder: (context ,snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }
                else if( snapshot.hasError ){
                  return Center(child: Text('${snapshot.error}'));
                }
                else if(snapshot.hasData){
                 List<CategoriesServices> items = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: items.length,
                      itemBuilder: (context , index){
                      //  discountAmount = double.parse(items[index].discountAmount.toString());
                         return Column(
                           children: [
                              Container(
                           child: Stack(
                          alignment: Alignment.bottomRight,
                           children: [
                             SizedBox(
                         // height: 240,
                          width: double.infinity,
                           child:  Card(
                           //color: ColorConverter.stringToHex(AppStrings.bright_color),
                             margin: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 5,
                             child: Container(
                         child: Column(
                           children:[
                             Container(
                                 padding: EdgeInsets.only(left: 10),
                                 child: Align(
                                     alignment: Alignment.topLeft,
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         ElevatedButton(onPressed: (){},
                                           style: ElevatedButton.styleFrom(
                                             backgroundColor: ColorConverter.stringToHex(AppStrings.orange_color),
                                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)
                                           ),
                                           child: Text('Recomended',style: TextStyle(fontSize: 11,color: Colors.white),),),
                                         Padding(padding: EdgeInsets.only(right: 15),
                                             child:  TextButton(onPressed: (){ },
                                                 child: Text(items[index].timeTaken.toString(),
                                                   style:TextStyle(color: ColorConverter.stringToHex(AppStrings.orange_color)
                                                   ,fontSize: 13) ,)))
                                       ],)
                                 )),
                          ListTile(
                           title: Padding(padding: EdgeInsets.only(top: 2),
                        child:Text(items[index].serviceName.toString(),
                           style: GoogleFonts.acme(color: ColorConverter.stringToHex(AppStrings.bg_color),fontSize: 15,fontWeight: FontWeight.bold))),
                            subtitle: Padding(padding: EdgeInsets.only(top: 12),
                            child:Text(overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                softWrap: false,
                                '* '+ items[index].feature.toString(),style: TextStyle(color: Colors.black45,fontSize: 11))),
                             trailing:  ConstrainedBox(
                                 constraints: BoxConstraints(
                                   minWidth: 100,
                                   minHeight: 260,
                                   maxWidth: 104,
                                   maxHeight: 264,
                                 ),
                                // width:100,
                                 child: Card(
                               shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                               clipBehavior: Clip.antiAliasWithSaveLayer,
                               elevation: 5,
                               child:
                              Image.network(ApiStrings.image_url+"/"+items[index].folder.toString()+"/"
                               +items[index].serviceLogo.toString(),fit: BoxFit.cover,),
                             ) ),
                           onTap: (){
                              //Navigator.push(context, MaterialPageRoute(builder: (context)=>UserServiceDetail()));
                                        } ),

                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                               padding: EdgeInsets.only(left: 15),
                                  child: Row(children:[
                                  RichText(
                                    text:  TextSpan(
                                      text: "₹"+items[index].amount.toString(),
                                      style:  TextStyle(
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ) ),
                                  ),Padding(padding: EdgeInsets.only(left: 5),
                                    child:Text("₹"+items[index].discountAmount.toString(),)),
                                  ])),

                                  Padding(padding: EdgeInsets.only(right: 20),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorConverter.stringToHex(AppStrings.orange_color),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)
                                      ),
                                      child: Text('View',style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold,color: Colors.white),),
                                    onPressed: (){
                                        Navigator.pop(context);
                                       Navigator.pushNamed(context, '/userServiceDetail',arguments: {
                                         "id" : items[index].id.toString(),
                                       });
                                      //   Navigator.push(context, MaterialPageRoute(
                                      //       builder: (context)=>UserServiceDetail(id: items[index].id.toString())));
                                    },)
                                  )],
                              ),
                            )
                           ]  ),),
                         )),
                       ]),
                        ),
                     ]);
                      }
                  );
                }else{
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
           ),
          ],)
        )
     );
  }

  // bool isVehicalAdded() {
  //   return catService.isEmpty ? true : false;
  // }

  Future<List<CategoriesServices>>getCategoryServices(id)async{
    String url = ApiStrings.api_host+ApiStrings.category_service;
      List<CategoriesServices> catService = [];
    var response = await http.post(Uri.parse(url),
      body: {
        'cat_id': id,
        "userid": UserSharedPrefernces.getUserId(),
      }
       );
    if(response.statusCode==200){
        List<dynamic> jsondata = json.decode(response.body);
        print(response.body);
        catService = jsondata.map((data) => CategoriesServices.fromJson(data)).toList();
        }
      return catService;
    }

  getmyVechile() async {
    var response = await http.post(
        Uri.parse(ApiStrings.api_host + ApiStrings.getVechile),
        body: {
          "user_id": UserSharedPrefernces.getUserId(),
        }
    );
    List<dynamic> jsonData = json.decode(response.body);
    if(jsonData.isEmpty){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>UserSelectVechile()));
      CustomWidget.showSnackbar(context, "Please select the vechile");
    }
  }
}






