

import 'dart:convert';
import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:carwash/Model/api/ApiStrings.dart';

class UserCustomer extends StatefulWidget {
  const UserCustomer({super.key});

  @override
  State<UserCustomer> createState() => _UserCustomerState();
}

class _UserCustomerState extends State<UserCustomer> {

  String? customerCall;

  @override
  void initState() {
    fetchCall();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Help No ",style: GoogleFonts.alkalami(color:ColorConverter.stringToHex(AppStrings.bg_color),
        fontWeight: FontWeight.bold,fontSize: 17,),
        )),
      body: Container(
        padding: EdgeInsets.all(20),
        child: customerCall != null
            ? Text(customerCall!)
            :Text("Unavailable"),
      ),
    );
  }

  // customer call ontap Api
  fetchCall()async{
    String url = ApiStrings.base_url + ApiStrings.call_no;
    print(url);
    var response = await http.post(Uri.parse(url),
        body: {
          "key_name" : '3',
          "type" :'1'
        }
    );

    print("KP Sir" +response.toString());
    if(response.statusCode==200){
      var mycall = jsonDecode(response.body);
      setState(() {
        customerCall = mycall["api_key"];
      });

    }
  }
}
