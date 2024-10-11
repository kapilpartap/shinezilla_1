
import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/CustomWidget/CustomWidget.dart';
import 'package:carwash/Model/Helper/CategoriesHelper.dart';
import 'package:carwash/Model/api/ApiStrings.dart';
import 'package:carwash/Model/http/ApiClient.dart';
import 'package:carwash/model/Helper/OffersHelper.dart';
import 'package:carwash/model/Helper/TrendingServices.dart';
import 'package:carwash/model/Helper/banner_img.dart';
import 'package:carwash/model/Helper/get_vechile.dart';
import 'package:carwash/model/Helper/rating_review.dart';
import 'package:carwash/model/locationapi/LocationConverter.dart';
import 'package:carwash/model/locationapi/LocationHandler.dart';
import 'package:carwash/model/sharedpre/userSharedPrefernces.dart';
import 'package:carwash/userHome/main.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;



class UserHome extends StatefulWidget {
  @override
  State<UserHome> createState() => UserHomeState();
}

class UserHomeState extends State<UserHome> {

  TextEditingController searchController = TextEditingController();
  ApiClient client = new ApiClient();
  var offers_list = [
    Image.asset('assets/images/img_1.png', fit: BoxFit.fill),
    Image.asset('assets/images/img_3.png', fit: BoxFit.fill),
    Image.asset('assets/images/img_2.png', fit: BoxFit.fill),
    Image.asset('assets/images/img_3.png', fit: BoxFit.fill),
  ];

  Future<List<OffersHelper>>? offers;
  Future<List<Categories>>? categories;
  Future<List<VechileAdded>>? vechileads;
  List<VechileAdded> vechileAd = [];
  Future<List<BannerIG>>? img;
  Future<List<TrendService>>? service;
  Future<List<RatingService>>? rating;

  IconData? _selectedIcon;
  bool _isVertical = false;
  double? _userRating = 3.0;
  String? vehstatusupdated="0";
  String currentAddress = "";

  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserSharedPrefernces.init();
    offers = client.getOffers();
    categories = client.getCategories();
    vechileads = getmyVechile();
    img = fetchbanner();
    service = fetchTrndSrv();
    rating = fetchRating();
    // Monitor connectivity changes
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        isDeviceConnected = result != ConnectivityResult.none;
      });
      if (isDeviceConnected) {
        reloadData();
      }
    });

    checkNetworkConnectivity();

  }
  Future<void> checkNetworkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isDeviceConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  void reloadData() {
    setState(() {
      offers = client.getOffers();
      categories = client.getCategories();
      vechileads = getmyVechile();
      img = fetchbanner();
      service = fetchTrndSrv();
      rating = fetchRating();
    });
  }


  @override
  Widget build(BuildContext context) {
    UserSharedPrefernces.init();

    currentAddress = UserSharedPrefernces.getuserlocation().toString();
    setState(() {
      currentAddress = UserSharedPrefernces.getuserlocation().toString();
    });

    return Scaffold(
         body:  SingleChildScrollView(
          child:
          isDeviceConnected
          ? Column(
            children: [

              Container(
                padding: EdgeInsets.only(top: 30,),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(padding: EdgeInsets.only(left: 15),
                        child: Row(children: [
                  CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/images/img_5.png',),
                    ),
                  Padding(padding: EdgeInsets.only(left: 10),
                  child:Text("Hi "+UserSharedPrefernces.getUserName(),
                      style: GoogleFonts.alkalami(fontWeight: FontWeight.bold,fontSize: 17,
                            color: ColorConverter.stringToHex(AppStrings.bg_color))
                  )),
                  ])),
                    Padding(padding: EdgeInsets.only(right: 15),
                     child:IconButton(
                          onPressed: () {
                                   showModal(context);
                                    },
                          icon: Icon(Icons.time_to_leave, size: 25,
                           color: ColorConverter.stringToHex(AppStrings.bg_color))),

                    )],
                )

              ),


              // Container(
              //   padding: EdgeInsets.only(top: 10),
              //   child: currentAddress != 'null'
              //       ? Text(currentAddress.toString(),
              //     style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),)
              //       : Text("select location onTap on location icon....",style: TextStyle(color: Colors.grey),),
              // ),

              Container(
                  padding: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: CustomWidget.getSlider(offers, context)),

              Container(
                  padding: EdgeInsets.only(top: 10),
                  child: CustomWidget.getCategories(categories)),

              Container(
                padding: EdgeInsets.only(top: 10,left: 5,right: 5),
                 child: FutureBuilder<List<BannerIG>>(
                  future: img,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      List<BannerIG> items = snapshot.data!;
                      return ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          // physics: NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (context, index,) {
                            return Container(
                              child:  Image.network(
                                ApiStrings.image_url +'/' +items[index].bannerFolder.toString() +'/' +items[index].bannerLogo.toString(),
                                fit: BoxFit.fill,
                              ),
                            );
                          }
                      );} else{
                      return Container(child: Text('Something wrong'),);
                    }
                  }
              )),
              Container(
                  padding: EdgeInsets.only(left: 15,top: 15),
                  child: Align(alignment: Alignment.topLeft,
                    child:Text('Trending Services ! ',
                      style: GoogleFonts.alkalami(fontWeight: FontWeight.bold,fontSize: 18),),
                  )),
             Container(
              // height: 200,
             //  color: Colors.grey,
               padding: EdgeInsets.only(top: 2),
               child: FutureBuilder<List<TrendService>>(
                  future: service,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Text('',style: GoogleFonts.acme(fontWeight: FontWeight.bold,fontSize: 20)));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      List<TrendService> items = snapshot.data!;
                      return CarouselSlider.builder(
                          itemBuilder: (context, index, realIndex) {
                            return Column(
                             children: [
                            Container(
                             child: Stack(
                              alignment: Alignment.bottomRight,
                               children: [
                                SizedBox(
                                  height: 230,
                                 width: double.infinity,
                                 child: GestureDetector(child:
                                 Card(
                                                //color: ColorConverter.stringToHex(AppStrings.bright_color),
                                                //margin: const EdgeInsets.all(10),
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
                                    child: Text('Trending',style: TextStyle(fontSize: 11,color: Colors.white),),),
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
                                  //  Navigator.push(context, MaterialPageRoute(builder: (context)=>UserServiceDetail()));
                                   } ),

                            Container(
                             padding: EdgeInsets.only(left: 20,top: 20),
                              child: Align(alignment: Alignment.topLeft,child:
                              Row(children:[
                                RichText(
                                  text:  TextSpan(
                                      text: "₹"+items[index].amount.toString(),
                                      style:  TextStyle(
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ) ),
                                ),Padding(padding: EdgeInsets.only(left: 5),
                                    child:Text("₹"+items[index].discountAmount.toString(),)),
                              ])
                                )  )]  ),),
                                ),onTap: (){
                                   // Navigator.pushNamed(context, '/userServiceDetail',arguments: {
                                   //   "id" : items[index].id.toString(),
                                   // });
                                 },
                                 ),

                                )]),
                           ),
                                  //  Divider()
                       ]);
                      },
                    options: CarouselOptions(
                      viewportFraction: 1,
                     autoPlayAnimationDuration:
                         const Duration(
                        milliseconds: 1000),
                        initialPage: 0,
                        autoPlay: true,
                        disableCenter: true,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                         height: 250,

                    ),
                         itemCount: items.length
                          ); } else{
                          return Container(
                           child: Text('wrong '),
                           );
                         }
                     } )),

              Container(
                padding: EdgeInsets.only(left: 15),
                child: Align(alignment: Alignment.topLeft,
                child:Text('Read what our customer say ! ',
                  style: GoogleFonts.alkalami(fontWeight: FontWeight.bold,fontSize: 18),),
                )),
              Container(
                  padding: EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 20),
                  child: FutureBuilder<List<RatingService>>(
                      future: rating,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          List<RatingService> items = snapshot.data!;
                                return GridView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  itemCount: items.length,
                                  itemBuilder: (context, index,) {
                                    _userRating = double.parse(items[index].rating.toString());
                                    return  Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(10),
                                       // border: Border.all(color: Colors.grey)
                                        ),
                                       child:SizedBox(
                                           width: double.infinity,
                                           child: Column(
                                        children: [
                                          Padding(padding: EdgeInsets.only(top: 10),
                                          child:RatingBarIndicator(
                                           rating: _userRating!,
                                            itemBuilder: (context, index) => Icon(
                                              _selectedIcon ?? Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 25.0,
                                            unratedColor: Colors.amber.withAlpha(50),
                                            direction: _isVertical ? Axis.vertical : Axis.horizontal,
                                          )),
                                           Chip(
                                          //backgroundColor: Style.Colors.secondColor,
                                             label: Text(
                                              'Rating: ' + _userRating.toString(),
                                              style: TextStyle(fontFamily: 'Raleway'),
                                            ),
                                          ),
                                        Padding(padding: EdgeInsets.only(top: 10,left: 5),
                                         child: Align(
                                         child: Text(items[index].description.toString(),maxLines: 5,
                                           style: GoogleFonts.acme(fontSize: 12), ))),
                                          Padding(padding: EdgeInsets.only(top: 5,left: 5),
                                          child: Align(alignment: Alignment.topLeft,child:
                                          Text(items[index].name.toString(),style: GoogleFonts.acme(fontWeight: FontWeight.bold),))),
                                            Padding(padding: EdgeInsets.only(top: 3,left: 5),
                                             child: Align(alignment: Alignment.topLeft,
                                              child:Text('Happy Customer !!!',
                                               style: GoogleFonts.abel(fontWeight: FontWeight.bold),))),
                                            ],
                                           )
                                       ) ) ;
                                    },
                                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                childAspectRatio: 5/7
                                ),
                                );
                              }
                           else{
                          return Container(child: Text('${snapshot.error}'),);
                        }
                      }
                  )),
               ],
          ) :Container(
            padding: EdgeInsets.only(top: 80),
            child: Column(
              children: [
                Container(child:
                Center(child: CircularProgressIndicator())),
                Container(
                  padding: EdgeInsets.only(top: 20),
                    child: Center(child:
                Text("Network Error !!!",style: TextStyle(fontWeight: FontWeight.bold),),))
              ],
            )

          ))
    );
  }

  // Rating Review
  Future<List<RatingService>> fetchRating() async {
    List<RatingService> rating = [];
    http.Response response = await http.get(
      Uri.parse(ApiStrings.api_host+ApiStrings.ratingReview),
    );
    print('Sinam Rating :'+ApiStrings.api_host+ApiStrings.ratingReview);
    List<dynamic> jsonData = json.decode(response.body);
    print(response.body);
    rating = jsonData.map((data) => RatingService.fromJson(data)).toList();
    return rating;
  }

  //Trending services
  Future<List<TrendService>> fetchTrndSrv() async {
    List<TrendService> service = [];
    http.Response response = await http.get(
      Uri.parse(ApiStrings.api_host+ApiStrings.trendService),
    );
    print('Sinam service :'+ApiStrings.base_url+ApiStrings.trendService);
    List<dynamic> jsonData = json.decode(response.body);
    service = jsonData.map((data) => TrendService.fromJson(data)).toList();
     return service;
  }

  //banner image
  Future<List<BannerIG>> fetchbanner() async {
    List<BannerIG> banner = [];
    http.Response response = await http.get(
        Uri.parse(ApiStrings.api_host+ApiStrings.getBanner),
       );
    print('Sinam Banner :'+ApiStrings.base_url+ApiStrings.getBanner);
    List<dynamic> jsonData = json.decode(response.body);
    banner = jsonData.map((data) => BannerIG.fromJson(data)).toList();


    if(vechileAd.isEmpty ==true || vehstatusupdated=="1")
    {
      setState(() {
        vehstatusupdated="0";
      });
      showModal(context);
    }

    return banner;
  }




//normal showdialog
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
          title: Text(
            'Select Location', style: GoogleFonts.acme(color: Colors.black),),
          content: SingleChildScrollView(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text('Use Current Location',
                      style: GoogleFonts.abel(color: Colors.black, fontSize: 15),),
                    leading: Icon(
                      Icons.my_location_sharp, color: Colors.black,),
                    onTap: () async {
                      var _locationData = await LocationHandler.handleLocation();
                      List<Placemark> placemarks = await LocationConverter
                          .getAddressFromLatLng(
                          _locationData.latitude, _locationData.longitude);
                      if (!placemarks.isEmpty && placemarks != null) {
                        Placemark place = placemarks[0];
                        print(place.locality);


                        UserSharedPrefernces.setuserlocation(
                            place.locality! + ", " + place.country!);
                        setState(() {
                          currentAddress = UserSharedPrefernces
                              .getuserlocation().toString();
                        });
                      }
                      else {

                      }
                      Navigator.pop(context);
                    },
                  ),
                  // ListTile(
                  //   title: Text('Add map location',
                  //     style: GoogleFonts.abel(color: Colors.black, fontSize: 15),),
                  //   leading: Icon(Icons.location_history, color: Colors.black,),
                  //   onTap: () {
                  //     Navigator.pushNamed(context, '/locationAccess');
                  //     // Navigator.push(context, MaterialPageRoute(builder: (context)=>LocationAccess()));
                  //   },
                  // ),
                ],)
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel', style: TextStyle(color: Colors.black),),
              onPressed: () {

                Navigator.pop(context);
              },
            ),
          ],
       ) );
      },
    );
  }




  Future<List<VechileAdded>> getmyVechile() async {
    var response = await http.post(
        Uri.parse(ApiStrings.api_host + ApiStrings.getVechile),

        body: {
          "user_id": UserSharedPrefernces.getUserId(),
        }
    );

    List<dynamic> jsonData = json.decode(response.body);
    vechileAd = jsonData.map((data) => VechileAdded.fromJson(data)).toList();
    return vechileAd;
  }


  ActiveVechile(id, type) async {
    var response = await http.post(
        Uri.parse(ApiStrings.api_host + ApiStrings.updateVechile),

        body: {
          "user_id": UserSharedPrefernces.getUserId(),
          "type": type,
          "vehicle_id": id,
        }
    );

    if(response.statusCode==200)
    {
      var data = jsonDecode(response.body);

       if(data["success"]==1) {
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          content: Text(data['message']),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.only(
              bottom: 500,
              right: 20,
              left: 20),
        ));
        setState(() {
          vehstatusupdated="1";
        });
     print(vehstatusupdated.toString()+'gfgfhgfgfgfgh');
      Navigator.push(context, MaterialPageRoute(builder: (context)=>UserHomeNav()));
        //open popup
        // showModal(context);

      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:Text(data['message']) ));
      }
    }
    else
    {
      print("Network Problem...");
    }
  }




  showModal(context) {
    return showModalBottomSheet(
        context: context,
        //  backgroundColor: Colors.pinkAccent,
        builder: (BuildContext context) {
          return Container(
              height: 400,
               child: Column(
                  children: [
                    Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(padding: EdgeInsets.only(
                                  left: 15),
                                  child: Text('select vehicle',
                                      style: GoogleFonts.alkalami(
                                          fontWeight: FontWeight
                                              .bold,
                                          fontSize: 18))),
                              Padding(padding: EdgeInsets.only(
                                  right: 10),
                                child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/UserSelectVechile');
                                      // Navigator.push(context,  MaterialPageRoute( builder: (context) =>UserSelectVechile()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                            width: 1,
                                            color: Colors.black26)
                                    ),
                                    icon: Icon(Icons.add,
                                        color: ColorConverter
                                            .stringToHex(
                                            AppStrings
                                                .bg_color),
                                        size: 20),
                                    label: Text(
                                      'Add New Vehicle',
                                      style: TextStyle(
                                          color: ColorConverter
                                              .stringToHex(
                                              AppStrings
                                                  .bg_color),
                                          fontWeight: FontWeight
                                              .bold,
                                          fontSize: 12),
                                    )),
                              )
                            ])),
                    Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text('Saved Vechiles',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),),
                            ))),
                    Container(
                      height: 280,
                      child:
                      FutureBuilder<List<VechileAdded>>(
                        future: vechileads,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            List<VechileAdded> items = snapshot.data!;
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              itemBuilder: (context, index,) {

                                if(items[index].status==1)
                                  {
                                    return ListTile(
                                      title: InkWell(
                                        child: Column(children: [
                                          Container(child:
                                          Text(
                                            items[index].model.toString() + ' , ' +
                                                items[index].brandName.toString(),
                                            style: GoogleFonts.acme(color: Colors.deepOrange),),
                                          ), Divider(),
                                        ]),
                                        onTap: () {
                                          UserSharedPrefernces.init();
                                          ActiveVechile(items[index].id.toString(), "1");
                                        },
                                      ),
                                      leading: Icon(Icons.time_to_leave,
                                          color: ColorConverter.stringToHex(
                                              AppStrings.bg_color)),
                                      trailing: IconButton(
                                        onPressed: () {
                                          // _showAddListDialog();
                                          UserSharedPrefernces.init();
                                          ActiveVechile(items[index].id.toString(), "0");
                                        },
                                        icon: Icon(Icons.delete, color: Colors.red,
                                          size: 20,),
                                      ),
                                      onTap: () {},
                                    );
                                  }
                                else
                                  {
                                    return ListTile(
                                      title: InkWell(
                                        child: Column(children: [
                                          Container(child:
                                          Text(
                                            items[index].model.toString() + ' , ' +
                                                items[index].brandName.toString(),
                                            style: GoogleFonts.acme(),),
                                          ), Divider(),
                                        ]),
                                        onTap: () {
                                          UserSharedPrefernces.init();
                                          ActiveVechile(items[index].id.toString(), "1");
                                        },
                                      ),
                                      leading: Icon(Icons.time_to_leave,
                                          color: ColorConverter.stringToHex(
                                              AppStrings.bg_color)),
                                      trailing: IconButton(
                                        onPressed: () {
                                          // _showAddListDialog();
                                          UserSharedPrefernces.init();
                                          ActiveVechile(items[index].id.toString(), "0");
                                        },
                                        icon: Icon(Icons.delete, color: Colors.red,
                                          size: 20,),
                                      ),
                                      onTap: () {},
                                    );
                                  }


                              },);
                          } else {
                            return Center(child: Text('${snapshot.error}'));
                          }
                        },
                      ),
                    ),
                  ]));
        });
  }


  // Future<List<DateAdd>> fetchSearchBar() async {
  //   List<DateAdd> adddate = [];
  //
  //   http.Response response = await http.get(
  //       Uri.parse(ApiStrings.base_url+ApiStrings.searchBar));
  //   print('Anushaaaa :'+ApiStrings.base_url+ApiStrings.searchBar);
  //   List<dynamic> jsonData = json.decode(response.body);
  //   print(response.body);
  //   adddate = jsonData.map((data) => DateAdd.fromJson(data)).toList();
  //
  //   return adddate;
  // }

}
 








