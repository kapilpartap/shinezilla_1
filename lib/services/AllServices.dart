
import 'dart:convert';
import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/CustomWidget/CustomWidget.dart';
import 'package:carwash/Model/api/ApiStrings.dart';
import 'package:carwash/Model/http/ApiClient.dart';
import 'package:carwash/booking/userSelectDate.dart';
import 'package:carwash/model/Helper/categoriesServices.dart';
import 'package:carwash/model/Helper/get_vechile.dart';
import 'package:carwash/model/sharedpre/userSharedPrefernces.dart';
import 'package:carwash/userVechile/UserSelectVechile.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AllServices extends StatefulWidget {
  @override
  State<AllServices> createState() => _AllServicesState();
}

class _AllServicesState extends State<AllServices> {
  ApiClient client = new ApiClient();

  Future<List<CategoriesServices>>? categoryService;

  List<VechileAdded> vechileAd = [];
  String currentAddress = "";
  String? Vechile;

  @override
  void initState() {

     getmyVechile();
    categoryService = getAllServices();
       super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserSharedPrefernces.init();
    setState(() {
      currentAddress = UserSharedPrefernces.getuserlocation().toString();
    });
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'All Services',
            style: GoogleFonts.alkalami(
              color: ColorConverter.stringToHex(AppStrings.bg_color),
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),

          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/userHomeNav');
              //Navigator.push(context,MaterialPageRoute(builder: (context)=>UserHome()));
            },
          ),
          // actions: [
          //   Padding(
          //       padding: EdgeInsets.only(right: 10),
          //       child: IconButton(icon: Icon(Icons.location_on),onPressed: (){
          //         //_showDialog();
          //
          //       }, color:ColorConverter.stringToHex(AppStrings.bg_color ),)),
          //
          //   // Padding(
          //   //     padding: EdgeInsets.only(right: 10),
          //   //     child: IconButton(
          //   //         onPressed: () {
          //   //           _showAddListDialog();
          //   //         },
          //   //         icon: Icon(Icons.time_to_leave,size: 25, color: ColorConverter.stringToHex(AppStrings.bg_color),))),
          // ]
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            // Container(
            //   padding: EdgeInsets.only(top: 10),
            //   child: currentAddress!=null ? Text(currentAddress.toString(),
            //     style: TextStyle(fontSize: 10 ,fontWeight: FontWeight.bold),) : Text("fetching location...."),
            // ),


            Padding(
                padding:
                    EdgeInsets.only(top: 5, left: 12, right: 12, bottom: 10),
                child: Container(
                    child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Image.asset(
                          'assets/images/slide.png',
                          //height:120,width:double.infinity,fit: BoxFit.cover,
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'All Services'.toString(),
                        style: GoogleFonts.alkalami(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ))),

            FutureBuilder<List<CategoriesServices>>(
                future: categoryService,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List<CategoriesServices> items = snapshot.data!;
                    return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          //  print('HLOO'+   ApiStrings.image_url+catfolder.toString()+'/'+catimage.toString());
                          //  print(ApiStrings.image_url+"/"+items[index].folder.toString()+"/"+items[index].serviceLogo.toString());
                          return Column(children: [
                            Container(
                              child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    SizedBox(
                                        // height: 240,
                                        width: double.infinity,
                                        child: Card(
                                          //color: ColorConverter.stringToHex(AppStrings.bright_color),
                                          margin: const EdgeInsets.all(10),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          elevation: 5,
                                          child: Container(
                                            child: Column(children: [
                                              Container(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          ElevatedButton(
                                                            onPressed: () {},
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    ColorConverter.stringToHex(
                                                                        AppStrings
                                                                            .orange_color),
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)
                                                            ),
                                                            child: Text(
                                                              'Recomended',
                                                              style: TextStyle(
                                                                  fontSize: 11,color: Colors.white),
                                                            ),
                                                          ),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          15),
                                                              child: TextButton(
                                                                  onPressed:
                                                                      () {},
                                                                  child: Text(
                                                                    items[index]
                                                                        .timeTaken
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: ColorConverter.stringToHex(AppStrings
                                                                            .orange_color),
                                                                        fontSize:
                                                                            13),
                                                                  )))
                                                        ],
                                                      ))),
                                              ListTile(
                                                  title: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 2),
                                                      child: Text(items[index].serviceName.toString(),
                                                          style: GoogleFonts.acme(
                                                              color: ColorConverter.stringToHex(
                                                                  AppStrings
                                                                      .bg_color),
                                                              fontSize: 15,
                                                              fontWeight: FontWeight
                                                                  .bold))),
                                                  subtitle: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 12),
                                                      child: Text(
                                                          overflow:
                                                              TextOverflow.ellipsis,
                                                          maxLines: 3,
                                                          softWrap: false,
                                                          '* ' + items[index].feature.toString(),
                                                          style: TextStyle(color: Colors.black45, fontSize: 11))),
                                                  trailing: ConstrainedBox(
                                                      constraints: BoxConstraints(
                                                        minWidth: 100,
                                                        minHeight: 260,
                                                        maxWidth: 104,
                                                        maxHeight: 264,
                                                      ),
                                                      // width:100,
                                                      child: Card(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        elevation: 5,
                                                        child: Image.network(
                                                          ApiStrings.image_url +
                                                              "/" +
                                                              items[index]
                                                                  .folder
                                                                  .toString() +
                                                              "/" +
                                                              items[index]
                                                                  .serviceLogo
                                                                  .toString(),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )),
                                                  onTap: () {
                                                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>UserServiceDetail()));
                                                  }),
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
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
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 20),
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                ColorConverter
                                                                    .stringToHex(
                                                                        AppStrings
                                                                            .orange_color),
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)
                                                          ),
                                                          child: Text(
                                                            'View',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,color: Colors.white),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pushNamed(
                                                                context,
                                                                '/userServiceDetail',
                                                                arguments: {
                                                                  "id": items[index].id.toString(),
                                                                });
                                                            //   Navigator.push(context, MaterialPageRoute(
                                                            //       builder: (context)=>UserServiceDetail(id: items[index].id.toString())));
                                                          },
                                                        ))
                                                  ],
                                                ),
                                              )
                                            ]),
                                          ),
                                        )),
                                  ]),
                            ),
                            //  Divider()
                          ]);
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ],
        )));
  }



  //fetch AllServices Api
  Future<List<CategoriesServices>>getAllServices()async{
    String url = ApiStrings.api_host+ApiStrings.category_service;
    List<CategoriesServices> catService = [];
    var response = await http.post(Uri.parse(url),
        body: {
          'cat_id': '0',
          "userid": UserSharedPrefernces.getUserId(),
        }
    );
     if(response.statusCode==200){
      List<dynamic> jsondata = json.decode(response.body);
      print("HI"+response.body);
      catService = jsondata.map((data) => CategoriesServices.fromJson(data)).toList();

      // if(vechileAd.isEmpty ==true){
      //   Navigator.push(context, MaterialPageRoute(builder: (context)=>UserSelectDate()));
      // }
      // else{
      //   Navigator.push(context, MaterialPageRoute(builder: (context)=>AllServices()));
      // }

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





  // Future<void> _showDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.white,
  //         title: Text('Select Location',style: TextStyle(color: Colors.black),),
  //         content: SingleChildScrollView(
  //             child: ListView(
  //               shrinkWrap: true,
  //               children: [
  //                 ListTile(
  //                   title: Text('Use Current Location',style: TextStyle(color: Colors.black,fontSize: 15),),
  //                   leading: Icon(Icons.my_location_sharp,color: Colors.black,),
  //                   onTap: ()async{
  //                     var _locationData= await LocationHandler.handleLocation();
  //                     List<Placemark> placemarks=  await LocationConverter.getAddressFromLatLng(_locationData.latitude,_locationData.longitude);
  //                     if(!placemarks.isEmpty && placemarks!=null)
  //                     {
  //                       Placemark place = placemarks[0];
  //
  //                       UserSharedPrefernces.setuserlocation(place.locality! +", "+place.country!);
  //                       setState(() {
  //                         currentAddress=UserSharedPrefernces.getuserlocation().toString();
  //                       });
  //                     }
  //                     else
  //                     {
  //
  //                     }
  //                   },
  //                 ),
  //                 ListTile(
  //                   title: Text('Add Address',style: TextStyle(color: Colors.black,fontSize: 15),),
  //                   leading: Icon(Icons.add,color: Colors.black,),
  //                   onTap: (){
  //                     Navigator.pushNamed(context, '/LocationAccess');
  //                     // Navigator.push(context, MaterialPageRoute(builder: (context)=>LocationAccess()));
  //                   },
  //                 ),
  //               ],)
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Cancel',style: TextStyle(color: Colors.black),),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> _showAddListDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Select Vechile',
            style: TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserSelectVechile()));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                icon: Icon(
                  Icons.add,
                  color: ColorConverter.stringToHex(AppStrings.bg_color),
                  size: 30,
                ),
                label: Text(
                  'Add New Vechile',
                  style: TextStyle(
                      color: ColorConverter.stringToHex(AppStrings.bg_color)),
                )),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
