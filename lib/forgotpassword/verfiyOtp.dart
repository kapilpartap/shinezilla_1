
import 'dart:convert';

import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/userlogin/userSignin.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

import '../Model/api/ApiStrings.dart';
import 'Cpassword.dart';


class VerifyOtp extends StatefulWidget {


  VerifyOtp();

  createState() => VerfiyOtpState();
}

class VerfiyOtpState extends State<VerifyOtp>{
  TextEditingController OtpController = TextEditingController();
  String? phno;
  VerfiyOtpState();

  bool isloading = false;

  @override
  void didChangeDependencies() {
    final routeargs = ModalRoute.of(context)?.settings.arguments as Map;
    phno = routeargs["phno"].toString()!=null ? routeargs["phno"].toString(): "N/A";

    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color:ColorConverter.stringToHex(AppStrings.bg_color),
              child: const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 22),
                child: Text(
                  'Verify OTP',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                  color: Colors.white,
                ),
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0,right: 18),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isloading ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Center(child: CircularProgressIndicator())):Text(""),
                        TextFormField(
                          enabled: true,
                          controller: OtpController,keyboardType: TextInputType.number,
                          //cursorColor: kPrimaryColor,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            prefixIcon: Padding(
                              padding:  EdgeInsets.all(5),
                              child: Icon(Icons.lock_outline,
                                color:ColorConverter.stringToHex(AppStrings.bg_color),),
                            ),
                            suffixIcon: Padding(
                              padding:  EdgeInsets.all(5),
                              child: Icon(Icons.info_outline, color:ColorConverter.stringToHex(AppStrings.bg_color),),
                            ),
                          //  hintText: "Enter OTP (XXXXXX)",
                            labelText: 'Enter OTP (XXXXXX)',labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder:  UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:Colors.grey),
                            ),
                          ),
                        ),


                        SizedBox(height: 20,),
                        GestureDetector(
                            onTap: () {

                              OtpVerify(phno, OtpController.text.toString());

                            },
                            child: Container(
                              height: 55,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color:ColorConverter.stringToHex(AppStrings.bg_color),
                              ),
                              child:  Center(child: Text(
                                'Verify OTP', style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white
                              ),),),
                            )),

                      ],
                    ),
                  ),
                ),
              ),
            ) ],
        ));
  }



  OtpVerify( ph_no,otp ) async {
    String url = ApiStrings.api_host+ApiStrings.verify_otp;
    print(ph_no);
    print(url);

    var response=await http.post(Uri.parse(url),
        body: {
          "otp":otp,
          "phno":ph_no,
          "otp_type":"register"

        });
    print('Sir :' + response.body );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      if(data["success"]==1) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'].toString())));
        Navigator.push(context, MaterialPageRoute(builder: (context)=>UserSignin()));
      }
      else
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['message'].toString())));
      }
     return OtpVerify;
    }
    else {
      throw Exception('Unable to connect');
    }

  }

}

