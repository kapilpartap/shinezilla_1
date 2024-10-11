
import 'dart:convert';
import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/Model/api/ApiStrings.dart';
import 'package:carwash/Model/http/ApiClient.dart';
import 'package:carwash/model/Helper/categoriesServicesID.dart';
import 'package:carwash/model/Helper/nearest_fran.dart';
import 'package:carwash/model/locationapi/LocationConverter.dart';
import 'package:carwash/model/locationapi/LocationHandler.dart';
import 'package:carwash/model/sharedpre/userSharedPrefernces.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;




class UserServiceDetail extends StatefulWidget{
  @override
  createState()=> DetailPage();
}
class DetailPage extends State<UserServiceDetail> {

  String? id;
  DetailPage();

  ApiClient client = new ApiClient();

  Future<List<CategoriesServicesID>>? categoryServiceID;
  String currentAddress = "";

  Future<List<Franchise>>? fran;

  @override
  void didChangeDependencies() {
    final routeargs = ModalRoute.of(context)?.settings.arguments as Map;
    id = routeargs["id"].toString() != null ? routeargs["id"].toString() : "N/A";
    categoryServiceID = getCategoryServiceID(routeargs["id"].toString());
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    //  fran = fetchFranchise(latitude, longitude);
    //   categoryServiceID=  getCategoryServiceID(id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserSharedPrefernces.init();
    currentAddress = UserSharedPrefernces.getuserlocation().toString();
    setState(() {
      currentAddress = UserSharedPrefernces.getuserlocation().toString();
    });

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('Service Details',
                style: GoogleFonts.alkalami(fontWeight: FontWeight.bold, fontSize: 17,
                    color: ColorConverter.stringToHex(AppStrings.bg_color))),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            // actions: [
            //   Padding(
            //       padding: EdgeInsets.only(right: 10),
            //       child: IconButton(
            //         icon: Icon(Icons.location_on), onPressed: () {
            //         _showDialog();
            //       }, color: ColorConverter.stringToHex(AppStrings.bg_color),)),
            //               ]
        ),


        body: SingleChildScrollView(
            child: Column(
                children: [
                  // Container(
                  //   padding: EdgeInsets.only(top: 10),
                  //   child: currentAddress != "null" ? Text(
                  //     currentAddress.toString(),
                  //     style: TextStyle(
                  //         fontSize: 10, fontWeight: FontWeight.bold),)
                  //       : Text("select location onTap on location icon....",
                  //       style: TextStyle(color: Colors.grey)),
                  // ),
                  Container(
                      padding: EdgeInsets.only(top: 20),
                      child: FutureBuilder<List<CategoriesServicesID>>(
                          future: categoryServiceID,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              List<CategoriesServicesID> items = snapshot.data!;
                              return Column(
                                  children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: items.length,
                                  itemBuilder: (context, index ) {
                                    return Card(
                                      color: Colors.grey,
                                      child: SizedBox(height: 200,
                                          child:
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(8.0),
                                        child: Image.network(
                                          ApiStrings.image_url + "/" + items[index].folder.toString() +
                                              "/" + items[index].serviceLogo.toString(),
                                          fit: BoxFit.fill,
                                        ),
                                      ) ),);
                                  },
                                ),

                                Container(
                                  padding: EdgeInsets.only(
                                      top: 15, left: 10, right: 10),
                                  child: Text(items[0].serviceName.toString(),
                                    style: GoogleFonts.alkalami(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: ColorConverter.stringToHex(
                                            AppStrings.bg_color)),),
                                ),
                                Container(
                                  child: SizedBox(
                                    //height: 200,
                                    width: double.infinity,
                                    child: Card(
                                        margin: EdgeInsets.all(20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(20)
                                          ),),
                                        elevation: 5,
                                        child: Column(
                                          children: [
                                            Container(
                                                child: ListTile(
                                                  leading: Container(
                                                    child: Icon(
                                                      Icons.watch_later,
                                                      color: ColorConverter
                                                          .stringToHex(
                                                          AppStrings
                                                              .orange_color),),
                                                  ),
                                                  title: Text(items[0].timeTaken
                                                      .toString(),
                                                    style: TextStyle(
                                                        color: ColorConverter
                                                            .stringToHex(
                                                            AppStrings
                                                                .bg_color),
                                                        fontSize: 15),),
                                                  trailing: Padding(padding: EdgeInsets.only(top: 5),
                                                child:  Column(children:[
                                                  RichText(
                                                  text:  TextSpan(
                                                  text: "₹"+items[0].amount.toString(),
                                                  style:  TextStyle(color: Colors.grey,decoration: TextDecoration.lineThrough,
                                                   ) ),
                                                  ),Padding(padding: EdgeInsets.only(left: 5),
                                                  child:Text("₹"+items[0].discountAmount.toString())),
                                                  ])
                                                  ),)),
                                            ListTile(
                                                leading: Container(
                                                  child: Icon(
                                                    Icons.thumb_up_alt_outlined,
                                                    color: ColorConverter
                                                        .stringToHex(AppStrings
                                                        .orange_color),),
                                                ),
                                                title: Text(items[0].description
                                                    .toString(),
                                                  style: TextStyle(
                                                      fontSize: 11),)
                                            )
                                          ],
                                        )),
                                  ),
                                ),

                                Container(
                                    child: Card(
                                        margin: EdgeInsets.only(left: 20, right: 20),
                                        color: Colors.white,
                                        child: ListTile(
                                          leading: Container(
                                            child: Icon(
                                              Icons.star,
                                              color: ColorConverter.stringToHex(
                                                  AppStrings.orange_color),),
                                          ),
                                          title: Text(
                                            '* ' + items[0].feature.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: ColorConverter.stringToHex(
                                                  AppStrings.bg_color),
                                              fontSize: 11,),),
                                        ))),

                              //  Padding(padding: EdgeInsets.all(20),
                                     Container(
                                      margin: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 50),
                                        height: 40,
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    side: BorderSide(width: 1,
                                                        color: Colors.black26)
                                                )
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pushNamed(
                                                  context, '/locationAccess',
                                                  arguments: {
                                                    "id": items[0].id
                                                        .toString(),
                                                  });
                                              //  Navigator.pushNamed(context, '/UserSelectDate',arguments: {
                                              //    "id" : items[0].id.toString(),
                                              //  }) ;
                                            },
                                            child: Text(
                                              'Book Now ', style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: ColorConverter
                                                    .stringToHex(
                                                    AppStrings.orange_color)
                                            ),))
                                    )


                              ]);
                            } else {
                              return Container(
                                height: 200,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          }))
                ]))
    );
  }



  Future<List<CategoriesServicesID>> getCategoryServiceID(id) async {
    String url = ApiStrings.api_host + ApiStrings.service_ID;
    List<CategoriesServicesID> catService = [];
    var response = await http.post(Uri.parse(url),
        body: {
          'id': id
        }
    );

    if (response.statusCode == 200) {
     List<dynamic> jsondata = json.decode(response.body);
      catService = jsondata.map((data) => CategoriesServicesID.fromJson(data)).toList();
    }
    return catService;
  }


  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Container(
            child: AlertDialog(
              backgroundColor: Colors.grey.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text('Select Location',
                style: GoogleFonts.acme(color: Colors.black),),
              content: SingleChildScrollView(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        title: Text('Use Current Location',
                          style: GoogleFonts.abel(
                              color: Colors.black, fontSize: 15),),
                        leading: Icon(
                          Icons.my_location_sharp, color: Colors.black,),
                        onTap: () async {
                          var _locationData = await LocationHandler
                              .handleLocation();
                          List<Placemark> placemarks = await LocationConverter
                              .getAddressFromLatLng(
                              _locationData.latitude, _locationData.longitude);
                          if (!placemarks.isEmpty && placemarks != null) {
                            Placemark place = placemarks[0];
                            // print(place.locality);
                            // setState(() {
                            //   currentAddress=place.locality! +", "+place.country!;
                            // });
                            UserSharedPrefernces.setuserlocation(place
                                .locality! + ", " + place.country!);
                            setState(() {
                              currentAddress =
                                  UserSharedPrefernces.getuserlocation()
                                      .toString();
                            });
                          }
                          else {

                          }
                          Navigator.pop(context);
                        },
                      ),
                      // ListTile(
                      //   title: Text('Add Address',style: TextStyle(color: Colors.black,fontSize: 15),),
                      //   leading: Icon(Icons.add,color: Colors.black,),
                      //   onTap: (){
                      //  //   Navigator.push(context, MaterialPageRoute(builder: (context)=>LocationAccess()));
                      //   },
                      // ),
                    ],)
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Cancel', style: TextStyle(color: Colors.black),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
      },
    );
  }
}

  //
  //
  //
  // Future<void> _showAddListDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.white,
  //         title: Text('Select Vechile',style: TextStyle(color: Colors.black),),
  //         content: SingleChildScrollView(
  //           child: ElevatedButton.icon(
  //               onPressed: () {
  //                 Navigator.push(context,MaterialPageRoute(
  //                     builder: (context) => UserSelectVechile()));
  //               },
  //               style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.white),
  //               icon: Icon(
  //                 Icons.add,color:ColorConverter.stringToHex(AppStrings.bg_color),
  //                 size: 30,
  //               ),
  //               label: Text('Add New Vechile',style: TextStyle(color: ColorConverter.stringToHex(AppStrings.bg_color)),)),
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


