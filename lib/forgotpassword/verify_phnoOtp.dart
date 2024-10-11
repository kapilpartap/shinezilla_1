

import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';

class PhNoOtp extends StatefulWidget {
    @override
  State<PhNoOtp> createState() => _PhNoOtpState();
}

class _PhNoOtpState extends State<PhNoOtp> {
  String? user_id;
  TextEditingController otpController = TextEditingController();


  void didChangeDependencies() {
    final routeargs = ModalRoute.of(context)?.settings.arguments as Map;
    user_id = routeargs["user_id"].toString()!=null ? routeargs["user_id"].toString(): "N/A";

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(top: 50,left: 20),
              child: Text("Forgot Password !",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),
              )),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 20),
            child: Text("Enter OTP",
              style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 10),),
          ),
          Container(
            // color: Colors.black,
              padding: EdgeInsets.only(top: 25,left: 15,right: 15),
              child:  TextFormField(
                textInputAction: TextInputAction.done,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                controller: otpController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),

                  label: Text('Enter OTP (XXXX)',style: TextStyle(
                      fontWeight: FontWeight.bold,color: Colors.white),),
                ),
              )),


          Padding(padding: EdgeInsets.only(top: 20)),
          GestureDetector(
            child: Container(
              height: 55,
              width: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white
              ),
              child:  Center(child: Text("Verify otp",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black
              ),),),
            ),
            onTap: (){
              phnVerifyOtp(otpController.text);

            },
          )

        ],
      ),
    );
  }

  phnVerifyOtp(otp)async{
    var response=await http.post(Uri.parse("https://shinezilla.in/app/public/api/verifyForgotOTP"),
        body: {
          "otp":otp,
          "user_id":  user_id,


        });
    print('verify  :' + response.body );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      if(data["success"]==1) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'].toString())));
        Navigator.pushNamed(context, "/phnPassword",
        arguments: {
          "user_id" : data['user_id']
        }

        );
      }
      else
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['message'].toString())));
      }
      return phnVerifyOtp;
    }
    else {
      throw Exception('Unable to connect');
    }

  }

}
