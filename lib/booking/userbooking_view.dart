
import 'dart:convert';
import 'dart:io';
import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/Model/api/ApiStrings.dart';
import 'package:carwash/calculation/Calculation.dart';
import 'package:carwash/model/Helper/coupon.dart';
import 'package:carwash/model/Helper/paymentkey.dart';
import 'package:carwash/model/Helper/transaction_Allservice.dart';
import 'package:carwash/model/sharedpre/userSharedPrefernces.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class UserBookingView extends StatefulWidget {

  // String? booking_id;
  //  UserBookingView({ required this.booking_id});


  @override
  State<UserBookingView> createState() => _UserBookingViewState();
}

class _UserBookingViewState extends State<UserBookingView> {
  String? booking_id;
  String? paymentapikey;

  String? paid_dis_amount;
  String? payment_status;
  int special_offer=0;
  double? amountToPay;
  Future<List<PaymentKey>>? payment;
  String title="Download Pdf";
   String? url,filename;
  _UserBookingViewState();
  Future<List<TransactionAllService>>? bookAllTrans;


  @override
  void didChangeDependencies() {
    final routeargs = ModalRoute.of(context)?.settings.arguments as Map;
    print(routeargs);
    booking_id = routeargs["booking_id"].toString()!=null ? routeargs["booking_id"].toString(): "N/A";
    payment_status = routeargs["payment_status"].toString()!=null ? routeargs["payment_status"].toString(): "N/A";
    bookAllTrans = fetchbookingTransaction(booking_id);
    super.didChangeDependencies();
  }

  @override
  void initState() {
   payment = fetchpaymentKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("ANusha : "+"https://app.shinezilla.in/public/download_invoice/"+UserSharedPrefernces.getUserId()+"/"+booking_id.toString());
    return WillPopScope(
        onWillPop: () {
          Navigator.pushNamed(context, "/UserBookingStatus");
          return Future.value(false);
        },
     child:  Scaffold(
      appBar: AppBar(
        title: Text('Bookings Detail ',style: GoogleFonts.alkalami(color:ColorConverter.stringToHex(AppStrings.bg_color),
          fontWeight: FontWeight.bold,fontSize: 17, ),),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/UserBookingStatus');
          },
        ),
      ),

      body: SingleChildScrollView(
       child: Column(
             children: [
               payment_status== "Success"
             ? Padding(padding: EdgeInsets.only(right: 15,top: 10),
                 child:Align(alignment: Alignment.topRight,
                child:  ElevatedButton.icon(
                 style: ElevatedButton.styleFrom(
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                   backgroundColor: ColorConverter.stringToHex(AppStrings.orange_color), ),
                 onPressed: (){
                  launchUrl(Uri.parse(
                      "https://app.shinezilla.in/public/download_invoice/"+UserSharedPrefernces.getUserId()+"/"+booking_id.toString()));
                    },
                 label: Text("Invoice",style: TextStyle(color: Colors.white),),
                 icon: Icon(Icons.download,color: Colors.white,)
                )))
               : Text(""),

      Container(
          child: FutureBuilder<List<TransactionAllService>>(
    future: bookAllTrans,
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
    return Center(child: Text('${snapshot.error}'));
    } else if (snapshot.hasData) {
    List<TransactionAllService> items = snapshot.data!;

    return ListView.builder(
    shrinkWrap: true,
    primary: false,
    itemCount: items.length,
    itemBuilder: (context, index,) {
      double non_gst_amount=double.parse(items[index].discountAmount.toString());
     // payamount = Calculation.getGstAmt(non_gst_amount, 18) * 100;
      if(items[index].couponDiscountPer==null)
        {
          special_offer=0;
        }
      else {
        special_offer = items[index].couponDiscountPer!;
      }
    return Container(
      child: SingleChildScrollView(child:
      Column(children: [
        Container(
         width: double.infinity,
          child: Card(
              margin: EdgeInsets.all(10),
              elevation: 5,
              child: Column(
                children: [
                  Container(
                     child: Column(
                      children: [
                        ListTile(
                          visualDensity: VisualDensity(horizontal: 0,vertical:-4),
                          leading: Icon(Icons.time_to_leave,color: ColorConverter.stringToHex(AppStrings.orange_color)),
                            title: Text(items[index].serviceName.toString(),
                            style: TextStyle(color: ColorConverter.stringToHex(AppStrings.bg_color),fontSize: 15,
                            fontWeight: FontWeight.bold)),
                              ),
                        ListTile( visualDensity: VisualDensity(horizontal: 0,vertical:-4),
                            leading: Icon(Icons.home,color: ColorConverter.stringToHex(AppStrings.orange_color)),
                            title: items[index].address!=null ?Text("Address: "+items[index].address.toString(),
                                style: TextStyle(color: ColorConverter.stringToHex(AppStrings.bg_color),fontSize: 15)):Text("Address: N/A")),
                        ListTile( visualDensity: VisualDensity(horizontal: 0,vertical:-4),
                            leading: Icon(Icons.calendar_month,color: ColorConverter.stringToHex(AppStrings.orange_color)),
                          title: Text("Date: "+items[index].scheduleDate.toString(),
                            style: TextStyle(color: ColorConverter.stringToHex(AppStrings.bg_color),fontSize: 15))),
                        ListTile( visualDensity: VisualDensity(horizontal: 0,vertical:-4),
                          leading: Icon(Icons.alarm,color: ColorConverter.stringToHex(AppStrings.orange_color)),
                            title: Text("Time: "+items[index].scheduleTime.toString(),
                                style: TextStyle(color: ColorConverter.stringToHex(AppStrings.bg_color),fontSize: 15))),
                        ListTile( visualDensity: VisualDensity(horizontal: 0,vertical:-4),
                         leading: Icon(Icons.book,color: ColorConverter.stringToHex(AppStrings.orange_color)),
                         title: Text("BId: "+items[index].bookingId.toString(),
                          style: TextStyle(color: ColorConverter.stringToHex(AppStrings.bg_color),fontSize: 15))),
                        ListTile( visualDensity: VisualDensity(horizontal: 0,vertical:-4),
                          leading: Icon(Icons.trending_up,color: ColorConverter.stringToHex(AppStrings.orange_color)),
                          title: Text("TnxId: "+items[index].transactionId.toString(),
                            style: TextStyle(color: ColorConverter.stringToHex(AppStrings.bg_color),fontSize: 15))),
                        ListTile( visualDensity: VisualDensity(horizontal: 0,vertical:-4),
                          leading: Container(
                            child: Icon(
                              Icons.watch_later, color: ColorConverter.stringToHex(AppStrings.orange_color),),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(items[index].timeTaken.toString(),
                                style: TextStyle(color: ColorConverter.stringToHex(AppStrings.bg_color),fontSize: 15),),
                  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text: "₹" + items[index].amount.toString(),
                          style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                      Text("₹" + items[index].discountAmount.toString()),
                    ],
                  ),
                  // Padding(padding: EdgeInsets.only(top: 3)),
                  // Text("₹" + Calculation.getFormattedGstAmt(non_gst_amount, 18).toString()),

                ],
              ),
                            ],
                          ),


                          subtitle: Column(children: [
                            Row(
                             children: [
                              Text("Coupon Discount :"),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(special_offer.toString()+"%"),
                            ),
                          ),]),

                           Container(alignment: Alignment.topLeft,child:
                              Text("including CGST and SGST(18%)",style: TextStyle(fontSize: 10),),
                           ),
                            Row(
                                children: [
                                  Text("Total Amount :",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: special_offer ==0
                                          ? Text("₹"+Calculation.getFormattedGstAmt(non_gst_amount, 18),
                                        style: TextStyle(fontWeight: FontWeight.bold), )
                                          : Text("₹"+Calculation.getAfterSpecialOfferGstAmt(
                                          non_gst_amount, 18,special_offer),
                                        style: TextStyle(fontWeight: FontWeight.bold), )
                                    ),
                                  ),]),
                          ],),

                          // trailing: SingleChildScrollView(
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Wrap(
                          //         spacing: 8,
                          //         children: <Widget>[
                          //           RichText(
                          //             text: TextSpan(
                          //               text: "₹" + items[index].amount.toString(),
                          //               style: TextStyle(
                          //                 color: Colors.grey,
                          //                 decoration: TextDecoration.lineThrough,
                          //               ),
                          //             ),
                          //           ),
                          //           Text("₹" + items[index].discountAmount.toString()),
                          //         ],
                          //       ),
                          //       Padding(padding: EdgeInsets.only(top: 3)),
                          //       Text("₹" + Calculation.getFormattedGstAmt(non_gst_amount, 18).toString()),
                          //
                          //     ],
                          //   ),
                          // ),
                        )   ,
                        ListTile( visualDensity: VisualDensity(horizontal: 0,vertical:-4),
                            leading: Icon(Icons.stacked_bar_chart,color: ColorConverter.stringToHex(AppStrings.orange_color)),
                            title: Text("BookingStatus: "+items[index].bookingStatus.toString(),
                                style: TextStyle(color: ColorConverter.stringToHex(AppStrings.bg_color),fontSize: 15))),

                        ListTile( visualDensity: VisualDensity(horizontal: 0,vertical:-4),
                            leading: Icon(Icons.stacked_bar_chart,color: ColorConverter.stringToHex(AppStrings.orange_color)),
                            title: Text("PayStatus: "+items[index].payStatus.toString(),
                              style: TextStyle(
                                color: _getStatusColor(items[index].payStatus.toString()),
                                fontSize: 15,
                              ),),
                         trailing: items[index].payStatus=="Pending" ? ElevatedButton(
                           style: ElevatedButton.styleFrom(
                             backgroundColor: ColorConverter.stringToHex(AppStrings.orange_color),
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)
                           ),
                           child: Text('Pay Now',
                             style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold,color: Colors.white),),
                           onPressed: (){
                             print(UserSharedPrefernces.getUserPhone());
                             print(UserSharedPrefernces.getUserEmail());
                             Razorpay razorpay = Razorpay();
                            // payamount = Calculation.getGstAmt(non_gst_amount, 18) * 100;
                             paid_dis_amount = items[index].discountAmount.toString();

                             // Calculate the amount after special offer
                             if (special_offer == 0) {
                               amountToPay = Calculation.getGstAmt(non_gst_amount, 18);
                             }
                             else {
                               amountToPay = double.parse(
                                   Calculation.getAfterSpecialOfferGstAmt(non_gst_amount, 18, special_offer));
                             }

                             int payamount = (amountToPay! * 100).round(); // Convert to paise
                             // var date = DateTime.now();
                             // final year = formatDate(date,[yyyy]);
                             // final month = formatDate(date,[mm]);
                             // final day = formatDate(date,[d]);
                             // final hours = formatDate(date,[HH]);
                             // final min = formatDate(date,[m]);
                             // final sec = formatDate(date,[ss]);
                             // String? order_id=year+month+day+hours+min+sec+'-'+UserSharedPrefernces.getUserId()+buid.toString();
                             var options = {
                               'key': paymentapikey,
                               'amount': payamount,
                               'currency':'INR',
                               'image':ApiStrings.asset_image_url+'assets/img/logo/logo.jpeg',
                               'name': UserSharedPrefernces.getUserName(),
                               // 'orderId': order_id,
                               'description': "Category:  " +
                                   items[index].serviceName
                                       .toString() + '  ServiceName: ' +
                                   items[index].serviceName
                                       .toString(),
                               'retry': {
                                 'enabled': true,
                                 'max_count': 1
                               },
                               'send_sms_hash': true,
                               'prefill': {
                                 'name': UserSharedPrefernces.getUserName(),
                                 'contact': UserSharedPrefernces.getUserPhone(),
                                 'email': UserSharedPrefernces.getUserEmail(),
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

                           },):Text(""),
                        ),
                       ],
                    ),
                  )],
              )),
               ),


      Container(
      //color: Colors.black26,
          child: Card(
              margin: EdgeInsets.all(10),
              color:  Colors.white,
              child:  Column(children: [
              ListTile(
                  leading: Container(
                    child: Icon(Icons.thumb_up_alt_outlined,
                      color: ColorConverter.stringToHex(AppStrings.orange_color),),
                  ),
                  title: Text(items[index].description.toString(),style: TextStyle(fontSize: 11),)
              ),
              ListTile(
                leading: Container(
                  child: Icon(
                    Icons.star, color: ColorConverter.stringToHex(AppStrings.orange_color),),
                ),
                title: Text(". "+items[index].feature.toString() ,
                  style: TextStyle(fontWeight: FontWeight.bold,
                    color: ColorConverter.stringToHex(AppStrings.bg_color),fontSize: 11,),),
              )]) ))

    ])));


    });

    } else{
      return Container(child: Text("${snapshot.data}"),);
    }
    }
  ))]))));
  }




  Color _getStatusColor(String? status) {
    if (status == null) {
      return Colors.grey;
    }
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'unpaid':
        return Colors.cyanAccent;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  Future<List<TransactionAllService>> fetchbookingTransaction(booking_id) async {
    List<TransactionAllService> bookAlltransaction = [];
    http.Response response = await http.post(
        Uri.parse(ApiStrings.api_host+ApiStrings.AllTransService),
      body: {
          "user_id"  : UserSharedPrefernces.getUserId(),
          "booking_id": booking_id,
      }
   );
    print("BOOKing id "+booking_id);
    print("user_id "+UserSharedPrefernces.getUserId());
    print('Sinam :'+ApiStrings.base_url+ApiStrings.AllTransService);
    List<dynamic> jsonData = json.decode(response.body);
    print("one "+response.body);
    bookAlltransaction = jsonData.map((data) => TransactionAllService.fromJson(data)).toList();
    return bookAlltransaction;
  }

  //Dynamic payment key
  Future<List<PaymentKey>> fetchpaymentKey() async {
    String url = ApiStrings.base_url + ApiStrings.payKey;
    print("xcg "+url);
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


  //Payment Gateway
  void handlePaymentErrorResponse(PaymentFailureResponse response) async {

    http.Response responsive = await http.post(
        Uri.parse(ApiStrings.api_host + ApiStrings.updateTransaction),
        body: {
          "user_id": UserSharedPrefernces.getUserId(),
          "booking_id": booking_id,
          "transaction_id":"",
          "tnx_status": "4",
          "tnx_amount": "0",
        }
    );
    if (responsive.statusCode == 200) {
      print("bewkoof"+responsive.statusCode.toString());
      print(ApiStrings.api_host + ApiStrings.updateTransaction);
      showAlertDialog(context, "Payment Failed",
          "Code: ${response.code}\nDescription: ${response
              .message}\nMetadata:${response.error.toString()}");
    }
  }



  void  handlePaymentSuccessResponse(PaymentSuccessResponse response) async{
    http.Response responsive = await http.post( Uri.parse(ApiStrings.api_host+ApiStrings.updateTransaction),
        body: {
          "user_id"        : UserSharedPrefernces.getUserId(),
          "booking_id"     : booking_id.toString(),
          "transaction_id" : response.paymentId,
          "tnx_status"     : "1",
          "tnx_amount"     : paid_dis_amount,
        }
    );
    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
    Navigator.pushNamed(context, '/UserBookingStatus');
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  fetchInvoice()async{
   var response = await http.get(Uri.parse("https://app.shinezilla.in/public/download_invoice/1/5"));
   print("Invoice: "+response.body);
  }

  //Alert Box download booking invoice
  // PdfDownload(){
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context ){
  //         return AlertDialog(
  //           title: Text("Give Permission!"),
  //           content: Text('Allow ShineZilla to access your File manager for download the pdf. '),
  //           actions: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 TextButton(onPressed: ()async{
  //                   var status = await Permission.storage.status;
  //                   if (!status.isGranted) {
  //                     status = await Permission.storage.request();
  //                     if (!status.isGranted) {
  //                       Fluttertoast.showToast(msg: "Storage permission not granted");
  //                       return;
  //                     }
  //                   }
  //
  //                   Directory? directory;
  //                   try {
  //                     if (defaultTargetPlatform == TargetPlatform.android) {
  //                       directory = Directory('/storage/emulated/0/Download');
  //                     } else {
  //                       directory = await getApplicationDocumentsDirectory();
  //                     }
  //                     if (!await directory.exists()) {
  //                       await directory.create(recursive: true);
  //                     }
  //                   } catch (e) {
  //                     debugPrint(e.toString());
  //                     Fluttertoast.showToast(msg: "Failed to get download directory");
  //                     return;
  //                   }
  //
  //                   final task = DownloaderTask(
  //                     downloadPath: directory!.path,
  //                     url: url,
  //                     fileName: filename,
  //                     bufferSize: 1024,
  //                   );
  //                   final _downloader = SimpleDownloader.init(task: task);
  //                   _downloader.callback.addListener(() {
  //                     setState(() {
  //                       title = _downloader.callback.status == DownloadStatus.running ? "Wait..." : "Download Pdf";
  //                     });
  //                     if (_downloader.callback.status == DownloadStatus.failed) {
  //                       Fluttertoast.showToast(msg: "Download failed");
  //                     }
  //                     if (_downloader.callback.status == DownloadStatus.completed) {
  //                       Fluttertoast.showToast(msg: "Download complete");
  //                     }
  //                     print(_downloader.callback.progress);
  //                   });
  //                   try {
  //                     await _downloader.download();
  //                   } catch (e) {
  //                     Fluttertoast.showToast(msg: "Download failed");
  //                     debugPrint(e.toString());
  //                   }
  //                   Navigator.pop(context, true);
  //                 },
  //                     child: Text("Yes",style: TextStyle(fontSize: 20,color: Colors.black),)),
  //
  //                 TextButton(onPressed: (){
  //                   Navigator.of(context, rootNavigator: true).pop();
  //                 }, child: Text("No",style: TextStyle(fontSize: 20,color: Colors.black),)),
  //               ],
  //             )
  //           ],
  //         );

//        });
 // }

}


