import 'dart:convert';
import 'dart:math';
import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/CustomWidget/CustomWidget.dart';
import 'package:carwash/Model/api/ApiStrings.dart';
import 'package:carwash/model/Helper/DateAdd.dart';
import 'package:carwash/model/Helper/bookingtime.dart';
import 'package:carwash/model/locationapi/LocationConverter.dart';
import 'package:carwash/model/locationapi/LocationHandler.dart';
import 'package:carwash/model/sharedpre/userSharedPrefernces.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class UserSelectDate extends StatefulWidget {
  @override
  State<UserSelectDate> createState() => UserSelectDateState();
}

class UserSelectDateState extends State<UserSelectDate> {
  String? id, baddress;
  String? franchises_id,time_id;
  String? google_location = "location";
  double? latitude, longitude;
  String? selected_time = "", selected_date = "";
  String? selectedunitid;
  String? timeselected;
  bool isPressed = false;
  bool? isdateselected, istimeselected = false;
  String selected_time_slots = "";
  String schedule_selected_date = "";
  String currentAddress = "";
  String? Radiusfranchid;


  Future<List<DateAdd>>? showDate;
  Future<List<UserBookingtime>>? showtime;

  TextEditingController time_controller = TextEditingController();
  TextEditingController address_controller = TextEditingController();
  TextEditingController landmark_controller = TextEditingController();
  TextEditingController location_controller = TextEditingController();

  @override
  void didChangeDependencies() {
    final routeargs = ModalRoute.of(context)?.settings.arguments as Map;
    print("Yaar" + routeargs["baddress"]);
    print("Yaar" + routeargs["id"]);

    Radiusfranchid = routeargs["franch_id"].toString()!=null ? routeargs["franch_id"].toString(): "N/A";
        id =  routeargs["id"].toString() != null ? routeargs["id"].toString() : "N/A";
       baddress = routeargs["baddress"].toString() != null ? routeargs["baddress"].toString() : "N/A";
       latitude = routeargs['latitude'];
      longitude = routeargs["longitude"];
      google_location = baddress;
    showDate = fetchDate(latitude, longitude);
    // showDate=  fetchDate();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
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
          title: Text(
            'Select Date & Time',
            style: GoogleFonts.alkalami(
                color: ColorConverter.stringToHex(AppStrings.bg_color),
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // actions: [
          //   Padding(
          //       padding: EdgeInsets.only(right: 5),
          //       child: IconButton(
          //         icon: Icon(Icons.location_on),
          //         onPressed: () {
          //           _showDialog();
          //         },
          //         color: ColorConverter.stringToHex(AppStrings.bg_color),
          //       )),
          // ],
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          // Container(
          //   padding: EdgeInsets.only(top: 10),
          //   child: currentAddress != "null"
          //       ? Text(currentAddress.toString(),
          //           style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          //         )
          //       : Text("select location onTap on location icon....",
          //           style: TextStyle(color: Colors.black26),
          //         ),
          // ),

          Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.black26)),
            child: InkWell(
              child: TextFormField(
                  textInputAction: TextInputAction.next,
                  enabled: false,
                  minLines: 1,
                  maxLines: 3,
                  controller: location_controller,
                  decoration: InputDecoration(
                    hintText: baddress,
                    hintStyle: TextStyle(color: Colors.black),
                    contentPadding: EdgeInsets.all(5),
                    border: InputBorder.none,
                    //suffixIcon: Icon(Icons.home,color: ColorConverter.stringToHex(AppStrings.bg_color),)),
                  )),
              onTap: () {

              },
            ),
          ),


          Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.black26)),
            child: InkWell(
              child: TextFormField(
                  textInputAction: TextInputAction.next,
                  minLines: 1,
                  maxLines: 3,
                  controller: address_controller,
                  decoration: InputDecoration(
                    hintText: "Full address", contentPadding: EdgeInsets.all(5),
                    border: InputBorder.none,

                  )),
              onTap: () {},
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.black26)),
            child: TextFormField(
                textInputAction: TextInputAction.next,
                minLines: 1,
                maxLines: 2,
                controller: landmark_controller,
                decoration: InputDecoration(
                  hintText: "landmark", contentPadding: EdgeInsets.all(5),
                  border: InputBorder.none,

                )),
          ),


          Container(
              child: Center(
            child: SizedBox(
                child: Card(
              margin: EdgeInsets.all(10),

              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 20, left: 15),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Select the Date for your Service',
                              style: GoogleFonts.alkalami(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ))),
                    FutureBuilder<List<DateAdd>>(
                        future: showDate,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            List<DateAdd> items = snapshot.data!;
                            return Container(
                                //  height: 100,
                                child: GridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              //scrollDirection: Axis.horizontal,
                              itemCount: items.length,
                              itemBuilder: (context, index ) {
                                 return Container(
                                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                                  child: Card(
                                  //  color: Colors.grey,
                                  color: isdateselected == true && selectedunitid == items[index].uniId.toString()
                                       ? Colors.black: Colors.grey,
                                        child: InkWell(
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(items[index].month.toString(),
                                                    style: TextStyle(fontSize: 8, color: Colors.white)),
                                                Text(items[index].day.toString(),
                                                    style: TextStyle(fontSize: 10,fontWeight:FontWeight.bold,color: Colors.white)),
                                                Text(items[index].dayname.toString(),
                                                    style: TextStyle(fontSize: 8,color: Colors.white)),
                                              ]),
                                          onTap: () {
                                          print("omg "+items[index].uniId.toString());
                                            setState(() {
                                              isdateselected = true;
                                              selectedunitid = items[index].uniId.toString();
                                              showtime = fetchtime(items[index].uniId.toString(),items[index].date.toString());
                                              selected_date = "";
                                              selected_time = "";
                                            });
                                            schedule_selected_date = items[index].date.toString();
                                          },
                                        )));
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: 10 / 7),
                            ));
                          } else {
                            return Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        }),
                    Divider(
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Container(
                        child: ListTile(
                            title: Text(
                              'Select the Start Time for your service',
                              style: GoogleFonts.alkalami(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Align(
                                alignment: Alignment.topLeft,
                                child: Column(children: [
                                  Text(
                                    'Your service will take approximately 120 minutes',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  Text("\n" +selected_date.toString()+'\n\n' +  selected_time.toString(),
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold), ),
                                ])))),
                    FutureBuilder<List<UserBookingtime>>(
                        future: showtime,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            List<UserBookingtime> items = snapshot.data!;
                            return GridView.builder(
                              padding: EdgeInsets.all(15),
                              shrinkWrap: true,
                              primary: false,
                              itemCount: items.length,
                              itemBuilder: ( context,  index,  ) {
                                return Center(
                                    child: InkWell(
                                  child: Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          // color: _containerColor,
                                       color: istimeselected == true && timeselected == items[index].time.toString()
                                              ? Colors.black: Colors.grey,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2)),
                                          border: Border.all(width: 1.0)),
                                      child: Text(
                                        items[index].time.toString(),
                                        style: TextStyle(color: Colors.white),
                                      )),
                                  onTap: () {
                                    istimeselected = true;
                                    setState(() {
                                      timeselected = items[index].time.toString();
                                      selected_date = "Selected Date: " + schedule_selected_date;
                                      selected_time = "Selected Time: " +items[index].time.toString();
                                      selected_time_slots = items[index].time.toString();
                                      time_id = items[index].timeId.toString();
                                    });
                                  },
                                ));
                              },
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 3,
                                childAspectRatio: 27 / 7,
                              ),
                            );
                          } else {
                            return Container(
                              child: Center(
                                child: Text(
                                  'Please select date for your service',
                                  style: GoogleFonts.actor(color: Colors.black,fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ),
            )),
          )),


              Container(
                padding: EdgeInsets.only(left: 15,right: 15,bottom: 40),
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: isPressed == true
                              ? Colors.black
                              : Colors.black,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Colors.black26))),
                      onPressed: () {
                        print(isdateselected);
                        print(istimeselected);

                        if(landmark_controller.text.length>5 && address_controller.text.length>5) {
                          setState(() {
                            isPressed = !isPressed;
                          });
                          // String user_id=UserSharedPrefernces.getUserId();
                          if (isdateselected != true) {
                            CustomWidget.showSnackbar(
                                context, "Booking date is not selected !");
                            return;
                          } else if (istimeselected != true) {
                            CustomWidget.showSnackbar(
                                context, "Time Slot is not selected !");
                            return;
                          }

                          fetchBook(
                              address_controller.text,
                              landmark_controller.text);
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Enter a valid landmark and address')));
                            }
                      },
                      child: Text(
                        'Proceed to Book',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )))
        ])));
  }

// Dialogue box
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
            'Select Location',
            style: GoogleFonts.acme(color: Colors.black),
          ),
          content: SingleChildScrollView(
              child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text('Use Current Location',
                    style: GoogleFonts.abel(color: Colors.black, fontSize: 15)),
                leading: Icon(
                  Icons.my_location_sharp,
                  color: Colors.black,
                ),
                onTap: () async {
                  var _locationData = await LocationHandler.handleLocation();
                  List<Placemark> placemarks =
                      await LocationConverter.getAddressFromLatLng(
                          _locationData.latitude, _locationData.longitude);
                  if (!placemarks.isEmpty && placemarks != null) {
                    Placemark place = placemarks[0];
                    print(place.locality);

                    UserSharedPrefernces.setuserlocation(
                        place.locality! + ", " + place.country!);
                    setState(() {
                      currentAddress =
                          UserSharedPrefernces.getuserlocation().toString();
                    });
                  } else {}
                  Navigator.pop(context);
                },
              ),

            ],
          )),
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
        ));
      },
    );
  }

  fetchBook(  String address,  String landmark, ) async {

    var date = DateTime.now();
    final year = formatDate(date, [yyyy]);
    final month = formatDate(date, [mm]);
    final day = formatDate(date, [d]);
    final hours = formatDate(date, [HH]);
    final min = formatDate(date, [m]);
    final sec = formatDate(date, [ss]);

    Random random = new Random();
    int randomNumber = random.nextInt(100);
    var bookingid = year + month + day + hours + min + sec + randomNumber.toString() + id.toString();

    var data = {
      "service_id": id,
      "user_id": UserSharedPrefernces.getUserId(),
      "landmark": landmark,
      "google_location": google_location,
      "address": address,
      "latitude" : latitude.toString(),
      "longitude" : longitude.toString(),
      "franch_id": franchises_id,
      'time_id':time_id,
      "schedule_date": schedule_selected_date,
      "schedule_time": selected_time_slots,
      "booking_id": bookingid,
    };
    print(data);
    print("url: " + ApiStrings.base_url + ApiStrings.addbooking);

    http.Response response = await http.post(
        Uri.parse(ApiStrings.base_url + ApiStrings.addbooking),
        body: data);
    print("Bhabhi :" + response.body);

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      print(jsondata);
      var buid = jsondata['id'];
      print(buid);
      //print("aja bhai ");

      if (jsondata['success'] == 1) {
        CustomWidget.showSnackbar(context, jsondata['message'].toString());
        Navigator.pop(context);
        Navigator.pushNamed(context, '/UserBooking', arguments: {
          "buid": buid,
          "booking_id": bookingid,
        });
      } else if (jsondata['success'] == 2) {

        Navigator.pushNamed(context, '/userHomeNav');

      } else {
        CustomWidget.showSnackbar(context, jsondata['message'].toString());
        Navigator.pushNamed(context, '/userHomeNav');
       // CustomWidget.showSnackbar(context, jsondata['Hey Kapil Sir'].toString());
      }
    } else {
      print('something went wrong ! ' + response.body);
    }
  }


  // Date webservice
  Future<List<DateAdd>> fetchDate(latitude, longitude) async {
    print("Hi sir");
    List<DateAdd> adddate = [];
    http.Response response =
         await http.post(Uri.parse(ApiStrings.base_url + ApiStrings.addDate),
         body: {
          // "latitude"  : latitude.toString(),
          // "longitude" : longitude.toString(),
           "franch_id" : Radiusfranchid
            }
        );
    print('Anush :' + ApiStrings.base_url + ApiStrings.addDate);
    List<dynamic> jsonData = json.decode(response.body);
    print(response.body);
     print(jsonData[0]['franch_id']);
    franchises_id=jsonData[0]['franch_id'].toString();
    adddate = jsonData.map((data) => DateAdd.fromJson(data)).toList();
    return adddate;
  }

  // Time webservice
  Future<List<UserBookingtime>> fetchtime(uni_id,schedule_selected_date) async {
  //  print(uni_id);
    List<UserBookingtime> addtime = [];
    http.Response response = await http
        .post(Uri.parse(ApiStrings.base_url + ApiStrings.addTime), body: {
       "uni_id": uni_id,
      "book_date":schedule_selected_date
    });
   // print('Dhanola :' + schedule_selected_date);
    List<dynamic> jsonData = json.decode(response.body);
    //print(response.body);
    addtime = jsonData.map((data) => UserBookingtime.fromJson(data)).toList();

    return addtime;
  }
}
