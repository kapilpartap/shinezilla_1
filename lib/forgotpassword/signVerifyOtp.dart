


import 'dart:convert';

import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/CustomWidget/CustomWidget.dart';
import 'package:carwash/model/sharedpre/userSharedPrefernces.dart';
import 'package:carwash/userHome/main.dart';
import 'package:carwash/userlogin/userSignin.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;



class SigninVerifyOtp extends StatefulWidget {
  SigninVerifyOtp();

  createState() => VerfiyOtpState();
}

class VerfiyOtpState extends State<SigninVerifyOtp>{
  String? phno;
  TextEditingController Otp_Controller = TextEditingController();

  VerfiyOtpState();

  bool isloading = false;

  @override
  void didChangeDependencies() {
    final routeargs = ModalRoute.of(context)?.settings.arguments as Map;
    phno = routeargs["phone_no"].toString()!=null ? routeargs["phone_no"].toString(): "N/A";

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
                          controller: Otp_Controller,keyboardType: TextInputType.number,
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

                              Otp_Verify( Otp_Controller.text);

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



  Otp_Verify(otp ) async {
    var response=await http.post(Uri.parse("https://shinezilla.in/app/public/api/verifyOTP"),
        body: {
          "otp":otp,
          "phno":phno,
          "otp_type":"login"

        });

     if (response.statusCode == 200) {
      final map_response = jsonDecode(response.body);
      print(map_response);
      print("anusha");
      if(map_response["success"]==1) {
        UserSharedPrefernces.setLogin(true);

        map_response['data']['token']!=null ? UserSharedPrefernces.setLoginToken(map_response['data']['token'].toString()) : (){
          CustomWidget.showSnackbar(context, "Something went wrong ! Please try again.") ;
          return;
        };
        // print(UserSharedPrefernces.getLoginToken());
        map_response['data']['username']!=null ? UserSharedPrefernces.setUserName(map_response['data']['username'].toString()) : (){
          CustomWidget.showSnackbar(context, "Something went wrong ! Please try again.") ;
          return;
        };
        print(UserSharedPrefernces.getUserName());
        map_response['data']['email']!=null ? UserSharedPrefernces.setUserEmail(map_response['data']['email'].toString()) : (){
          CustomWidget.showSnackbar(context, "Something went wrong ! Please try again.") ;
          return;
        };
        print("Check:"+UserSharedPrefernces.getUserEmail());
        map_response['data']['phone']!=null ? UserSharedPrefernces.setUserPhone(map_response['data']['phone'].toString()) : (){
          CustomWidget.showSnackbar(context, "Something went wrong ! Please try again.") ;
          return;
        };
        print(UserSharedPrefernces.getUserPhone());
        map_response['data']['user_id']!=null ? UserSharedPrefernces.setUserId(map_response['data']['user_id'].toString()) : (){
          CustomWidget.showSnackbar(context, "Something went wrong ! Please try again.") ;
          return;
        };
        print("Check:"+UserSharedPrefernces.getUserId());

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(map_response['message'].toString())));
        Navigator.push(context, MaterialPageRoute(builder: (context)=>UserHomeNav()));
      }
      else
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(map_response['message'].toString())));
      }
      return Otp_Verify;
    }


  }

}

