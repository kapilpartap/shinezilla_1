

import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';

class RegphnNo extends StatefulWidget {
  const RegphnNo({super.key});

  @override
  State<RegphnNo> createState() => RegphnNoState();
}

class RegphnNoState extends State<RegphnNo> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController phone_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 50, left: 20),
                  child: Text("Forgot Password !", style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                  )),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 20),
                child: Text("Enter your registered phone number",
                  style: TextStyle(color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 10),),
              ),
              Container(
                 //color: Colors.white,
                  padding: EdgeInsets.only(top: 25, left: 15, right: 15),
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'phone_no is required.';
                      String pattern =
                          r'(^(?:[+0]9)?[0-9]{10}$)';
                      if (!RegExp(pattern).hasMatch(value))
                        return '''
                please enter valid 10 digit phone_no
                                             ''';
                      return null;
                    },
                    onChanged: (onChanged) {},
                    onSaved: (String? value) {
                      value != phone_controller;
                    },
                    controller: phone_controller,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      suffixIcon: IconButton(onPressed: () {

                      }, icon: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                  color: Colors.white,
                                ))),
                        child: Icon(Icons.call, size: 27, color: Colors.white,),
                      )),
                      label: Text('phone number', style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),),
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
                  child: Center(child: Text("Send otp", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black
                  ),),),
                ),
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    phnOtp(phone_controller.text);
                  }

                },
              )

            ],
          ),

        ));
  }

  phnOtp(phn)async{
    var response=await http.post(Uri.parse("https://shinezilla.in/app/public/api/forget_Password"),
        body: {
      "phone_no" : phn

        });
    print('Sir :' + response.body );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      if (data['success'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'].toString())));
        Navigator.pushNamed(context, "/phVerifyOtp",
        arguments: {
          "user_id" : data['user_id']
        }
        );
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'].toString())));
      }
      return phnOtp;
    }
    else {
      throw Exception('Unable to connect');
  }

}

}