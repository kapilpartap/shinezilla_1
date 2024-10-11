

import 'dart:convert';

import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/Model/api/ApiStrings.dart';
import 'package:carwash/model/Helper/transaction_service.dart';
import 'package:carwash/model/sharedpre/userSharedPrefernces.dart';
import 'package:carwash/userHome/main.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;


class UserBookingStatus extends StatefulWidget {
  const UserBookingStatus({super.key});

  @override
  State<UserBookingStatus> createState() => _UserBookingStatusState();
}

class _UserBookingStatusState extends State<UserBookingStatus> {
  Future<List<TransactionService>>? bookTrans;

  @override
  void initState() {
    bookTrans = fetchbookingTransaction();
        super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserSharedPrefernces.init();
    print(UserSharedPrefernces.getUserId());
    return     WillPopScope(
        onWillPop: () async {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => UserHomeNav()),
            (Route<dynamic> route) => false,
      );
      return false;
    },


     child: Scaffold(
      appBar: AppBar(
        title: Text('Bookings ',style: GoogleFonts.alkalami(color:ColorConverter.stringToHex(AppStrings.bg_color),
          fontWeight: FontWeight.bold,fontSize: 17, ),),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/userHomeNav');

          },
        ),
      ),
      body:
    FutureBuilder<List<TransactionService>>(
    future: bookTrans,
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: Text("No Booking !",style: GoogleFonts.alkalami(fontSize: 20),));
    } else if (snapshot.hasError) {
    return Center(child: Text('${snapshot.error}'));
    } else if (snapshot.hasData) {

    List<TransactionService> items = snapshot.data!;
     return   ListView.builder(
      shrinkWrap: true,
      primary: false,
    //  physics: NeverScrollableScrollPhysics(),
       itemCount: items.length,
       itemBuilder: (context, index,) {
        double non_gst_amount=double.parse(items[index].discountAmount.toString());
         double total_amount=
             (double.parse(items[index].discountAmount.toString())*18/100)+double.parse(items[index].discountAmount.toString());

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
                                       height: 50,
                                       decoration: BoxDecoration(
                                      //   borderRadius: BorderRadius.circular(20),
                                         color: Colors.grey.withOpacity(0.1)
                                       ),
                                         child:  ListTile(
                                       visualDensity: VisualDensity(horizontal: 0,vertical:-4),
                                         title: Padding(padding: EdgeInsets.only(top: 2),
                                             child:Text(items[index].serviceName.toString(),
                                                 style: TextStyle(color: ColorConverter.stringToHex(AppStrings.bg_color),fontSize: 15,fontWeight: FontWeight.bold))),
                                     )),

                                     ListTile(
                                      visualDensity: VisualDensity(horizontal: 0,vertical:-4),
                                         title: Text(items[index].bookingId.toString().length>0 ?"Booking Id : "+ items[index].bookingId.toString():"Booking Id : N/A",
                                             style: TextStyle(color: ColorConverter.stringToHex(AppStrings.bg_color),fontSize: 15))),
                                     ListTile(
                                         visualDensity: VisualDensity(horizontal: 0,vertical:-4),
                                         title: Text(items[index].transactionId.toString().length>0 ?"Payment Id : "+ items[index].transactionId.toString():"Payment Id : N/A" ,
                                             style: TextStyle(color: ColorConverter.stringToHex(AppStrings.bg_color),fontSize: 15))),

                                     ListTile(
                                         visualDensity: VisualDensity(horizontal: 0,vertical:-4),
                                         title: Text(items[index].bookingStatus.toString()!=null
                                             ?"Booking status : "+ items[index].bookingStatus.toString():"N/A",
                                             style: TextStyle(color: ColorConverter.stringToHex(AppStrings.bg_color),fontSize: 15))),
                                     ListTile(
                                       visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                       leading: Text("Pay status : ",style: TextStyle(color: ColorConverter.stringToHex(AppStrings.bg_color),fontSize: 15),),
                                       title: Text(
                                         items[index].payStatus != null
                                             ? items[index].payStatus.toString()
                                             : "N/A",
                                         style: TextStyle(
                                           color: _getStatusColor(items[index].payStatus),
                                           fontSize: 15,
                                         ),
                                       ),
                                     ),

                                     // ListTile(
                                     //     visualDensity: VisualDensity(horizontal: 0,vertical:-4),
                                     //     title:Text(items[index].status.toString()!=null
                                     //         ?"pay status : "+ items[index].status.toString()
                                     //         :"N/A",
                                     //         style: TextStyle(color: ColorConverter.stringToHex(AppStrings.bg_color),fontSize: 15))),

                                     ListTile(
                                         visualDensity: VisualDensity(horizontal: 0,vertical:-4),
                                         title:Row(
                                             children: [
                                         Container(
                                         padding: EdgeInsets.only(left: 15),
                                         child: Align(alignment: Alignment.topCenter,child:
                                         Row(children:[
                                           RichText(
                                             text:  TextSpan(
                                                 text: "₹"+items[index].amount.toString(),
                                                 style:  TextStyle(
                                                   color: Colors.grey,
                                                   decoration: TextDecoration.lineThrough,
                                                 ) ),
                                           ),Padding(padding: EdgeInsets.only(left: 5),
                                               child:Text("₹"+non_gst_amount.toString(),)),
                                         ])))]),
                                     trailing:  Padding(padding: EdgeInsets.only(right: 5),
                                                       child: ElevatedButton(
                                                         style: ElevatedButton.styleFrom(
                                                           backgroundColor: ColorConverter.stringToHex(AppStrings.orange_color),
                                                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)
                                                         ),
                                                         child: Text('View',style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold,color: Colors.white),),
                                                         onPressed: (){
                                                          print( items[index].bookingId.toString());
                                                          Navigator.pop(context);
                                                         Navigator.pushNamed(context, '/UserBookingView',arguments: {
                                                           "booking_id" : items[index].bookingId.toString(),
                                                           "payment_status":items[index].payStatus.toString(),
                                                         });
                                                    // Navigator.push(context, MaterialPageRoute(
                                                    //    builder: (context)=>UserBookingView(booking_id:items[index].bookingId.toString())));
                                                         },),
                                     ),

                               //       Container(
                               //         child: Row(
                               //           mainAxisAlignment: MainAxisAlignment.end,
                               //           children: [
                               //             // Padding(padding: EdgeInsets.only(left: 20),
                               //             //     child:Text('₹'+items[index].amount.toString(),style: TextStyle(fontWeight: FontWeight.bold))),
                               //
                               // // items[index].status.toString()=="Pending" ?    Padding(padding: EdgeInsets.only(right: 5),
                               // //     child: ElevatedButton(
                               // //       style: ElevatedButton.styleFrom(
                               // //         backgroundColor: ColorConverter.stringToHex(AppStrings.orange_color),
                               // //       ),
                               // //       child: Text('Pay Now',style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),),
                               // //       onPressed: (){
                               // //         print( items[index].bookingId.toString());
                               // //         Navigator.pushNamed(context, '/UserBookingView',arguments: {
                               // //           "booking_id" : items[index].bookingId.toString(),
                               // //         });
                               // //         // Navigator.push(context, MaterialPageRoute(
                               // //         //    builder: (context)=>UserBookingView(booking_id:items[index].bookingId.toString())));
                               // //       },)
                               // // ):Text(""),
                               //             Padding(padding: EdgeInsets.only(right: 5),
                               //                 child: ElevatedButton(
                               //                   style: ElevatedButton.styleFrom(
                               //                     backgroundColor: ColorConverter.stringToHex(AppStrings.orange_color),
                               //                   ),
                               //                   child: Text('View',style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),),
                               //                   onPressed: (){
                               //                    print( items[index].bookingId.toString());
                               //                   Navigator.pushNamed(context, '/UserBookingView',arguments: {
                               //                     "booking_id" : items[index].bookingId.toString(),
                               //                   });
                               //              // Navigator.push(context, MaterialPageRoute(
                               //              //    builder: (context)=>UserBookingView(booking_id:items[index].bookingId.toString())));
                               //                   },)
                               //             )],
                               //         ),
                               //       ),


                                     )]  ),),
                           )),

                     ]),
               ),
               //  Divider()
             ]);

    });
    }else{
      return Container(
        child: Text('You Have no bookings ! '),
      );
    }

    })

     ) );
  }



  Color _getStatusColor(String? status) {
    if (status == null) {
      return Colors.grey;
    }
    switch (status.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }


  Future<List<TransactionService>> fetchbookingTransaction() async {
    List<TransactionService> booktransaction = [];

    http.Response response = await http.post(
        Uri.parse(ApiStrings.api_host+ApiStrings.bookingTransaction),
      body: {
          "user_id" : UserSharedPrefernces.getUserId(),
      }

    );
    print('Manpreet :'+ApiStrings.base_url+ApiStrings.bookingTransaction);
    List<dynamic> jsonData = json.decode(response.body);
    print(response.body);
    print(UserSharedPrefernces.getUserId());
    booktransaction = jsonData.map((data) => TransactionService.fromJson(data)).toList();

    return booktransaction;
  }

}
