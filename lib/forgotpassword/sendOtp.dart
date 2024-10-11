

import 'dart:convert';

import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/Model/api/ApiStrings.dart';
import 'package:carwash/forgotpassword/verfiyOtp.dart';
import 'package:carwash/values/AppStrings.dart';

import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';
import 'package:http/http.dart'as http;

import 'Cpassword.dart';

class SendOtp extends StatefulWidget {
  const SendOtp({super.key});

  @override
  State<SendOtp> createState() => SendOtpState();
}

class SendOtpState extends State<SendOtp> {

  TextEditingController emailController = TextEditingController();
  TextEditingController OtpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
        key: _formKey,
         child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                color:ColorConverter.stringToHex(AppStrings.bg_color),
                child: Padding(
                  padding: EdgeInsets.only(top: 80, left: 25),
                  child: Text('Enter your\n Email !',
                    style: TextStyle(fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 300),
                  child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40)
                          ),
                          color: Colors.white
                      ),
                      child: SingleChildScrollView(child:
                      Padding(
                          padding: EdgeInsets.only(left: 18, right: 18),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  textInputAction: TextInputAction.done,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  onChanged: (onChanged){},
                                  //cursorColor: kPrimaryColor,
                                  validator: (String? value){
                                    if(value!.isEmpty){
                                      return 'Please enter email';
                                    }
                                    if(!RegExp(
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                        .hasMatch(value)){
                                      return 'Please enter valid email';
                                    }
                                    return null;
                                  },            onSaved: (String? value) {
                                  value!=emailController;
                                },
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      label: Text('Email', style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),),
                                      suffixIcon: Icon(Icons.mail_outline,
                                        color:ColorConverter.stringToHex(AppStrings.bg_color),)
                                  ),
                                ),
                                SizedBox(height: 20,),
                                GestureDetector(
                                    onTap: () {
                                     if (_formKey.currentState!.validate()) {
                                       _formKey.currentState!.save();

                                       OtpSend(emailController.text);
                                     }
                                   },
                                    child: Container(
                                      height: 55,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color:ColorConverter.stringToHex(AppStrings.bg_color),
                                      ),
                                      child: const Center(child: Text(
                                        'SEND OTP', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white
                                      ),),),
                                    )),

                                // TextFormField(
                                //   enabled: true,
                                //   controller: OtpController,keyboardType: TextInputType.number,
                                //   //cursorColor: kPrimaryColor,
                                //   decoration: InputDecoration(
                                //     fillColor: Colors.white,
                                //     prefixIcon: Padding(
                                //       padding:  EdgeInsets.all(5),
                                //       child: Icon(Icons.lock_outline, color: Color(0xff0089B6)),
                                //     ),
                                //     suffixIcon: Padding(
                                //       padding:  EdgeInsets.all(5),
                                //       child: Icon(Icons.info_outline),
                                //     ),
                                //     hintText: "Enter OTP (XXXXXX)",
                                //     labelText: 'Enter OTP (XXXXXX)',labelStyle: TextStyle(color: Colors.grey),
                                //     enabledBorder:  UnderlineInputBorder(
                                //       borderSide: BorderSide(color: Colors.grey),
                                //     ),
                                //     focusedBorder: UnderlineInputBorder(
                                //       borderSide: BorderSide(color:Colors.grey),
                                //     ),
                                //   ),
                                // ),


                                // SizedBox(height: 20,),
                                // GestureDetector(
                                //     onTap: () {
                                //       VerifyOtp(emailController.text, OtpController.text.toString());
                                //
                                //     },
                                //     child: Container(
                                //       height: 55,
                                //       width: 150,
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(30),
                                //         color: Color(0xff0089B6),
                                //       ),
                                //       child:  Center(child: Text(
                                //         'Verify OTP', style: TextStyle(
                                //           fontWeight: FontWeight.bold,
                                //           fontSize: 20,
                                //           color: Colors.white
                                //       ),),),
                                //     )),
                                //    Text('Resend Verification Code',style: TextStyle(fontSize:16,fontWeight: FontWeight.bold),)

                              ])))))
            ])));
  }

  OtpSend(email) async {
    String url = ApiStrings.api_host + ApiStrings.otp_url;
    print(email);
    print(url);
    var response = await http.post(Uri.parse(url),
        body: {
          'email': email
        }
    );
    print("Helo : "+ response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      if (data['success'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'].toString())));
        //Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyOtp(email)));
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'].toString())));
      }
      return SendOtp;
    }
    else {
      throw Exception('Unable to connect');
    }

  }



  // VerifyOtp( email,otp  ) async {
  //   var response=await http.post(Uri.parse(ApiStrings.api_host+ApiStrings.verify_otp),
  //       body: {
  //         "otp":otp,
  //         "email":email,
  //
  //       });
  //   print('Sir :' + ApiStrings.api_host+ApiStrings.verify_otp );
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     print(data);
  //     if(data["success"]==1) {
  //       SnackBar snackBar = new SnackBar(
  //           content: Text(data["message"].toString()));
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //       Navigator.push(context, MaterialPageRoute(builder: (context)=>Cpsswrd()));
  //     }
  //     else
  //     {
  //       SnackBar snackBar=new SnackBar(
  //           duration: const Duration(seconds: 2),content: Text(data["message"].toString()));
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     }
  //     return VerifyOtp;
  //   }
  //   else {
  //     throw Exception('Unable to connect');
  //   }
  //
  // }


}
