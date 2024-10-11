
import 'dart:convert';
import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/Model/api/ApiStrings.dart';
import 'package:carwash/calculation/Calculation.dart';
import 'package:carwash/model/Helper/booking_detail.dart';
import 'package:carwash/model/Helper/coupon.dart';
import 'package:carwash/model/Helper/paymentkey.dart';
import 'package:carwash/model/sharedpre/userSharedPrefernces.dart';
import 'package:carwash/userHome/main.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class UserBooking extends StatefulWidget {
  // String? buid ,booking_id;
  // UserBooking({required this.buid, required this.booking_id});

  @override
  State<UserBooking> createState() => _UserBookingState( );
}

class _UserBookingState extends State<UserBooking> {

  String? booking_id;
  int? buid;
  String? paymentapikey;
  String? gst_amount;
  int special_offer=0;
  bool _isCouponApplied = false;
  int _discountAmount = 0;
 // double? payamount;
  String? paid_dis_amount;
  String? coupon_msg;
  var coupon_offer;
  double? amountToPay;
  int couponID=0;


  _UserBookingState();

  Future<List<BookingDetail>>? showBookId;
  Future<List<PaymentKey>>? pay;
  Future<List<CouponFile>>? CouponAval;

  TextEditingController coupon_controller = TextEditingController();

  void didChangeDependencies() {
    final routeargs = ModalRoute.of(context)?.settings.arguments as Map;
    buid = routeargs["buid"] != null ? routeargs["buid"] : "N/A";
    booking_id =  routeargs["booking_id"].toString() != null ? routeargs["booking_id"].toString() : "N/A";
    showBookId = fetchBookingDetail(routeargs["buid"].toString());
    pay = fetchpayKey();
    CouponAval = fetchCouponOffers();

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAlertDialog();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("recieved id is: " + buid.toString());
    print("recieved booking_id is: " + booking_id.toString());

    UserSharedPrefernces.init();
    String usernamme = UserSharedPrefernces.getUserName();
    print(usernamme);
    return   WillPopScope(
        onWillPop: () async {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => UserHomeNav()),
            (Route<dynamic> route) => false,
      );
      return false;
    },

      child:Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Booking', style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 17,
              color: ColorConverter.stringToHex(AppStrings.bg_color)),),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: FutureBuilder<List<BookingDetail>>(
            future: showBookId,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(),);
              }
              else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              }
              else if (snapshot.hasData) {
                List<BookingDetail> items = snapshot.data!;
                print(items);
                return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      DateTime dt = DateTime.parse(items[index].scheduleDate.toString());
                      print(dt.month);
                      print(dt.day);
                      print(dt.weekday);
                      print(dt.year);
                      double non_gst_amount = double.parse(items[index].discountAmount.toString());
                    //  payamount = Calculation.getGstAmt(non_gst_amount, 18) * 100;
                      coupon_offer = Calculation.getAfterSpecialOfferGstAmt(
                          non_gst_amount, 18,special_offer);
                      //  double originalAmount = double.parse(items[index].discountAmount.toString());
                      // var total_amount=originalAmount*18/100;
                      // total_amount=total_amount+originalAmount;
                      return Column(
                          children: [
                            Card(margin: EdgeInsets.only(top: 20),
                              child:
                              ListTile(
                                  title: Text('Location',
                                      style: GoogleFonts.acme(fontSize: 17)),
                                  subtitle: Text(items[index].googleLocation
                                      .toString(),
                                      style: GoogleFonts.acme(fontSize: 10)),
                                  leading: Container(
                                      width: 50.0,
                                      height: 40.0,
                                      child: Icon(Icons.location_on,
                                        color: Colors.orange,),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1.0,
                                          )))),
                            ),
                            Card(child:
                            ListTile(
                              textColor: Colors.black,
                              title: Text('Address',
                                  style: GoogleFonts.acme(fontSize: 17)),
                              subtitle: items[index].address.toString()
                                  .toString() != "null"
                                  ? Text(items[index].address.toString(),
                                  style: GoogleFonts.acme(fontSize: 10)) : Text(
                                  "N/A"),
                              leading: Container(
                                  width: 50.0,
                                  height: 40.0,
                                  child: Icon(Icons.home, color: ColorConverter
                                      .stringToHex(AppStrings.orange_color)),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1.0,
                                      ))),
                            )),

                            Card(child:
                            ListTile(
                                textColor: Colors.black,
                                title: Text(
                                    items[index].categoryName.toString(),
                                    style: GoogleFonts.acme(fontSize: 17)),
                                subtitle: Text(items[index].serviceName
                                    .toString(),
                                  style: TextStyle(fontSize: 10),),
                                leading: Container(
                                    width: 50.0,
                                    height: 40.0,
                                    child: Icon(Icons.time_to_leave,
                                        color: ColorConverter
                                            .stringToHex(
                                            AppStrings.orange_color)),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1.0,
                                        )))),
                            ),
                            Card(child:
                            ListTile(
                                textColor: Colors.black,
                                title: Text('Date',
                                    style: GoogleFonts.acme(fontSize: 17)),
                                subtitle: Text(items[index].scheduleDate
                                    .toString(),
                                  style: TextStyle(fontSize: 10),),
                                trailing: Text(items[index].scheduleTime
                                    .toString(), style: TextStyle(fontSize: 10,
                                    fontWeight: FontWeight.bold),),
                                leading: Container(
                                    width: 50.0,
                                    height: 40.0,
                                    child: Icon(
                                        Icons.date_range, color: ColorConverter
                                        .stringToHex(AppStrings.orange_color)),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        border: Border.all(
                                          //   color: Colors.pinkAccent,
                                          width: 1.0,
                                        )))),
                            ),
                            Card(
                             //color: Colors.white.withOpacity(0.7),
                              margin: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              child:
                            ListTile(
                                textColor: Colors.black,
                                title:
                                 Text('Apply Coupons',
                                 style: GoogleFonts.acme(fontSize: 17)),

                                 // coupon_msg !=null ? Text(coupon_msg.toString(),
                                 // style: GoogleFonts.acme(fontSize: 17))
                                 //  :Container(),

                                trailing: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.red))),
                                  label:Text(_isCouponApplied ?"APPLIED" :"CHECK"),
                                  icon: Icon(Icons.celebration_outlined),
                                  onPressed: (){
                                    _showDialog();
                                  },),
                                leading:  Icon(
                                        Icons.discount, color: ColorConverter
                                        .stringToHex(AppStrings.bg_color)),
                                    ),
                            ),


                            Card(
                                child: ListTile(
                              textColor: Colors.black,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                               Text("Total Bill :",
                                style: GoogleFonts.acme(fontSize: 17),),
                                    Wrap(
                                     spacing: 12,
                                     children: <Widget>[
                                     RichText(
                                     text:  TextSpan(
                                     text: "₹"+items[index].amount.toString(),
                                     style:  TextStyle(
                                     color: Colors.grey,
                                     decoration: TextDecoration.lineThrough,
                                      ) ),
                                      ),Text("₹"+items[index].discountAmount.toString(),),
                                     ],
                                   ),
                              ]),
                              subtitle: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Coupon Discount : ",style: TextStyle(fontWeight: FontWeight.bold)),
                                            Text("$_discountAmount"+"%")
                                          ])
                                      //Text("Coupon Discount : $_discountAmount"+"%" ,style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                    Container(alignment: Alignment.bottomLeft,
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                Text("CGST : 9% + SGST :9%",style: TextStyle(color: Colors.black,fontSize: 10),),
                                          Text("18%")
                                ])),
                                Container(
                                // color: Colors.blue,
                                   child:  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  Text("Grand Total :",style: GoogleFonts.acme(fontSize: 17),),
                                   Container(
                                     alignment: Alignment.bottomLeft,
                                      child: special_offer ==0
                                          ? Text("₹"+Calculation.getFormattedGstAmt(non_gst_amount, 18),
                                       style: TextStyle(fontWeight: FontWeight.bold), )
                                          : Text("₹"+Calculation.getAfterSpecialOfferGstAmt(
                                          non_gst_amount, 18,special_offer),
                                        style: TextStyle(fontWeight: FontWeight.bold), ))
                                 ],)
                               // Text("Incl. taxes and charges for prepaid services",
                                // style: TextStyle(fontSize: 10),)
                                )]),
                              leading: Container(
                                  width: 50.0,
                                  height: 40.0,
                                  child: Icon(Icons.currency_rupee,
                                      color: ColorConverter
                                          .stringToHex(AppStrings.orange_color)),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      border: Border.all(
                                        //  color: Colors.black,
                                        width: 1.0,
                                      ))),
                                   )),



                            Container(
                              padding: EdgeInsets.only(top: 30),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                                10)),

                                        width: 150.0,
                                        height: 50.0,
                                        child: InkWell(child:
                                        Center(
                                          child: Text("Pay Later" + '\n' + '₹ ' +
                                            coupon_offer.toString(),
                                           //Calculation.getFormattedGstAmt(non_gst_amount, 18).toString(),
                                          style: GoogleFonts.acme(
                                              color: Colors.black),),
                                        ), onTap: () {
                                          fetchCod('2');

                                        })),

                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(10)),
                                      //color: Colors.grey.withOpacity(0.1)),
                                      width: 150.0,
                                      height: 50.0,
                                      child: InkWell(
                                          onTap: () {
                                            print(UserSharedPrefernces.getUserPhone());
                                            print(UserSharedPrefernces.getUserEmail());
                                            Razorpay razorpay = Razorpay();

                                            // Calculate the amount after special offer
                                            if (special_offer == 0) {
                                              amountToPay = Calculation.getGstAmt(non_gst_amount, 18);
                                            }
                                            else {
                                             amountToPay = double.parse(
                                               Calculation.getAfterSpecialOfferGstAmt(non_gst_amount, 18, special_offer));
                                            }

                                            int payamount = (amountToPay! * 100).round(); // Convert to paise
                                            // payamount = Calculation.getGstAmt(non_gst_amount, 18) * 100;
                                             paid_dis_amount = items[index].discountAmount ;
                                            // coupon_offer= special_offer ==0
                                            //    ? Text("₹"+Calculation.getFormattedGstAmt(non_gst_amount, 18),
                                            //  style: TextStyle(fontWeight: FontWeight.bold), )
                                            //    : Text("₹"+Calculation.getAfterSpecialOfferGstAmt(
                                            //    non_gst_amount, 18,special_offer));

                                            var options = {
                                              'key': paymentapikey,
                                              // 'rzp_test_A1vaCWavxUpkmp',
                                              'amount': payamount.toString(),
                                              'currency': 'INR',
                                              'image': ApiStrings
                                                  .asset_image_url +
                                                  'assets/img/logo/logo.jpeg',
                                              'name': UserSharedPrefernces.getUserName(),
                                              // 'orderId': order_id,
                                              'description': "Category:  " +
                                                  items[index].serviceName
                                                      .toString() +
                                                  '  ServiceName: ' +
                                                  items[index].serviceName
                                                      .toString(),
                                              'retry': {
                                                'enabled': true,
                                                'max_count': 1
                                              },
                                              'send_sms_hash': true,
                                              'prefill': {
                                                'name': UserSharedPrefernces
                                                    .getUserName(),
                                                'contact': UserSharedPrefernces
                                                    .getUserPhone(),
                                                'email': UserSharedPrefernces
                                                    .getUserEmail(),
                                              },
                                              'notes': {
                                                'booking_id': booking_id,
                                              },
                                              'external': {
                                                'wallets': ['paytm']
                                              },
                                              'theme': {
                                                'color': '#F07951',
                                              }
                                            };
                                            razorpay.on(
                                                Razorpay.EVENT_PAYMENT_ERROR,
                                                handlePaymentErrorResponse);
                                            razorpay.on(
                                                Razorpay.EVENT_PAYMENT_SUCCESS,
                                                handlePaymentSuccessResponse);
                                            razorpay.on(
                                                Razorpay.EVENT_EXTERNAL_WALLET,
                                                handleExternalWalletSelected);
                                            razorpay.open(options);
                                          },
                                          // style: ElevatedButton.styleFrom(
                                          //     backgroundColor: Colors.white,
                                          //     shape: RoundedRectangleBorder(
                                          //         side: BorderSide(width: 1)
                                          //     )
                                          // ),
                                          child: Center(
                                            child: Text(
                                                "Pay Now" + '\n' + '₹ ' +
                                                    coupon_offer,
                                                style: GoogleFonts.acme(
                                                    color: Colors.white)),
                                          )),

                                    ),

                                  ]
                              ),
                            ),
                          ]);
                    }
                );
              }
              else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            })
      ));
  }

  //coupon Showdialog
  _showDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'APPLY COUPON',
                style: GoogleFonts.acme(color: Colors.black),
              ),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
             children: [
              //  SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<List<CouponFile>>(
                    future: CouponAval,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        List<CouponFile> items = snapshot.data!;
                        if(items.length>0) {
                          return ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            primary: false,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.zero
                                  ),
                                  child: SizedBox(
                                    // height: 180,
                                      width: double.infinity,
                                      child:
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            title: Container(
                                                alignment: Alignment.topLeft,
                                                child:
                                                Column(children: [
                                                  DottedBorder(
                                                    color: Colors.black,
                                                    strokeWidth: 2,
                                                    child: Text(
                                                      items[index].couponCode
                                                          .toString(),
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 5)),
                                                  Text(items[index].name
                                                      .toString(),
                                                    style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .w400,
                                                        color: Colors.red,
                                                        fontSize: 15),),
                                                ],)),


                                            subtitle: Column(children: [
                                              Container(
                                                  alignment: Alignment.topLeft,
                                                  child:
                                                  Text("Discount: " +
                                                      items[index].discount
                                                          .toString() + "%")),
                                              Text("Expires on:  ${items[index]
                                                  .endDate.toString()}"),
                                            ],),

                                            trailing: TextButton(
                                                onPressed: () {
                                                  fetchAddCoupon(items[index].id
                                                      .toString());

                                                  setState(() {
                                                    _isCouponApplied = true;
                                                    _discountAmount =
                                                    items[index].discount!;
                                                  });
                                                  Navigator.pop(context, true);
                                                },
                                                child: DottedBorder(
                                                  color: Colors.red,
                                                  strokeWidth: 2,
                                                  child: Text("APPLY",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                )
                                            ),

                                          )
                                        ],
                                      )));
                            },
                          );
                        }
                        else
                          {
                            return Container(
                              child: Text(
                                '${snapshot.error}',
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            );
                          }
                      }
                      else {
                        return Container(
                          child: Text(
                            '${snapshot.error}',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close !'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }



  //ApplyCoupon Api
  Future<List<CouponFile>> fetchCouponOffers()async{
    List<CouponFile> coupon = [];
    var response = await http.get(Uri.parse(ApiStrings.base_url+ApiStrings.get_coupon));
    print(ApiStrings.base_url+ApiStrings.get_coupon);
    List<dynamic> jsondata = json.decode(response.body);
    print("shruti"+response.body);
    coupon = jsondata.map((data)=>CouponFile.fromJson(data)).toList();
    return coupon;
  }


    // Fill ADDCoupon Api
 fetchAddCoupon(coupon_id)async{
    var response = await http.post(Uri.parse(ApiStrings.api_host+ApiStrings.add_Coupon),
        body: {
          "coupon_id" : coupon_id,
          "booking_id": booking_id.toString(),
          "service_id": buid.toString(),
          "user_id": UserSharedPrefernces.getUserId(),
        });
    print("hn hn hn "+ApiStrings.api_host+ApiStrings.add_Coupon);
    if(response.statusCode==200){
      var jsonData = json.decode(response.body);

      //couponID = jsonData["coupon_id"].toString();
      print("Nikil");

       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(jsonData["succ_mssg"]),
         backgroundColor: Colors.orangeAccent,
         behavior:SnackBarBehavior.floating,
         action: SnackBarAction(
           label: "Wohoo",
           onPressed: () {  },),
       ),);
      setState(() {
        couponID = jsonData["coupon_id"];
        //coupon_msg= jsonData["succ_mssg"];
        special_offer = jsonData["discount"];
      });
    }
    else{
      print("Not Working");
    }
  }




  //warning
   _showAlertDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text('Alert !',style: TextStyle(color: Colors.red),),
          content:
          Text('Please take all of your useful material with yourself before services its your responsibility  !!',
          style: GoogleFonts.abel(fontWeight: FontWeight.bold,fontSize: 15),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close !'),
              onPressed: () {
           Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }




  Future<List<BookingDetail>> fetchBookingDetail(buid) async {
    String url = ApiStrings.base_url + ApiStrings.bookingId;
   // print(url);
    List<BookingDetail> catService = [];
    var response = await http.post(Uri.parse(url),
        body: {
          'id': buid
        }
    );
    if (response.statusCode == 200) {
    //  print(response.body);
      List<dynamic> jsondata = json.decode(response.body);
      catService =  jsondata.map((data) => BookingDetail.fromJson(data)).toList();
    }

    return catService;
  }

  //Dynamic payment key
  Future<List<PaymentKey>> fetchpayKey() async {
    String url = ApiStrings.base_url + ApiStrings.payKey;
  //  print(url);
    List<PaymentKey> payService = [];
    var response = await http.post(Uri.parse(url),
        body: {
          'key_name': "1",
          "type": "1"
        }
    );
    if (response.statusCode == 200) {
      var myapidata = jsonDecode(response.body);
      paymentapikey = myapidata['api_key'];
    }
    return payService;
  }

// cash on service
  fetchCod(payment_type) async {
    print("Biggboss abc");
print(couponID.toString());

    //http.Response responsive =await http.post(Uri.parse("https://shinezilla.in/app/public/api/update_transaction?user_id=KQO04OPHI4&booking_id=202408221682942124&transaction_id&tnx_status=0&tnx_amount=0&payment_type=2&coupon_id=4"));
    http.Response responsive = await http.post(
        Uri.parse(ApiStrings.api_host + ApiStrings.updateTransaction+"?"),
        body: {
          "user_id": UserSharedPrefernces.getUserId(),
          "booking_id": booking_id,
          "transaction_id": "",
          "tnx_status": "0",
          "tnx_amount": "0",
          "payment_type": payment_type,
          "coupon_id" : couponID.toString()
        }
    );
print (UserSharedPrefernces.getUserId());
print(booking_id);
print(payment_type);
    print("COS: " + ApiStrings.api_host + ApiStrings.updateTransaction);
    //print('cod1: ' +
    print(responsive.statusCode);
    if (responsive.statusCode == 200) {

      var data = jsonDecode(responsive.body);
      print("body : " + responsive.body);
      print("status " + responsive.statusCode.toString());
      if (data["success"] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['message'])));
        Navigator.pop(context);
        Navigator.pushNamed(context, '/UserBookingStatus');
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['message'])));
      }
    }
    else {
      print("Network Problem...");
    }
  }


  void handlePaymentErrorResponse(PaymentFailureResponse response) async {
    http.Response responsive = await http.post(
        Uri.parse(ApiStrings.api_host + ApiStrings.updateTransaction),
        body: {
          "user_id": UserSharedPrefernces.getUserId(),
          "booking_id": booking_id,
          "transaction_id": "",
          "tnx_status": "4",
          "tnx_amount": "0",
        }
    );
    if (responsive.statusCode == 200) {
      print("bewkoof" + responsive.statusCode.toString());
      print(ApiStrings.api_host + ApiStrings.updateTransaction);
      showAlertDialog(context, "Payment Failed",
          "Code: ${response.code}\nDescription: ${response
              .message}\nMetadata:${response.error.toString()}");
    }
  }


  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    http.Response res = await http.post(
        Uri.parse(ApiStrings.api_host + ApiStrings.updateTransaction),
        body: {
          "user_id": UserSharedPrefernces.getUserId(),
          "booking_id": booking_id.toString(),
          "transaction_id": response.paymentId,
          "tnx_status": "1",
          "tnx_amount": paid_dis_amount,
          "coupon_id" : couponID.toString()
        }
    );

    if (res.statusCode == 200) {
      showAlertDialog(
          context, "Payment Successful",
          "Payment ID: ${response.paymentId}");
      Navigator.pop(context);
      Navigator.pushNamed(context, '/UserBookingStatus');
    }
    else {
      showAlertDialog(
          context, "Something Went Wrong...",
          "Payment ID: ${response.paymentId}");
    }
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>UserBookingStatus()));

  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    // print(response);
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
  }
}
