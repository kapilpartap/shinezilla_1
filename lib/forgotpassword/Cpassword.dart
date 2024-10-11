
import 'dart:convert';

import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/Model/api/ApiStrings.dart';
import 'package:carwash/userlogin/userSignin.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;


class Cpsswrd extends StatefulWidget {
  String? email;
  Cpsswrd(this.email);

  createState() => CpsswrdState(email);
}

class CpsswrdState extends State<Cpsswrd>{
  String? email;
  CpsswrdState(this.email);

  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPsswrd = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isObscure2 = true;

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
          key: _formKey,
          child:
        Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color:ColorConverter.stringToHex(AppStrings.bg_color),
              child: const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 22),
                child: Text(
                  'Enter new\n Password',
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
                          textInputAction: TextInputAction.next,
                          obscureText: _isObscure,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (onChanged){},
                          onSaved: (String? value) {
                            value!=newPassword;
                          },
      //                      validator: (value) {
      //                       if (value == null || value.isEmpty)
      //                         return 'Field is required.';
      //                       String pattern =
      //                           r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
      //                       if (!RegExp(pattern).hasMatch(value))
      //                         return '''
      // Password must be at least 8 characters,
      // include an uppercase letter, number and symbol.
      // ''';
      //                       return null;
      //                     },
      //                     onChanged: (onChanged){},
      //                     onSaved: (String? value) {
      //                       value!=newPassword;
      //                     },
                          controller: newPassword,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                color:ColorConverter.stringToHex(AppStrings.bg_color),
                                icon: Icon(
                                  _isObscure ? Icons.visibility_off : Icons.visibility, color:ColorConverter.stringToHex(AppStrings.bg_color),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },),
                              label: Text('password',style: TextStyle(
                                fontWeight: FontWeight.bold,

                              ),)
                          ),
                        ),
                        TextFormField(
                          controller: confirmPsswrd,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: _isObscure2,
                          onChanged: (onChanged){},
                          //cursorColor: kPrimaryColor,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Field is required.';
                            String pattern ='';
                            if (!RegExp(pattern).hasMatch(value))
                              return '''
                                         ''';
                            if(value!=newPassword.text)
                              return 'Password does not match';
                            return null;
                          },  onSaved: (String? value) {
                          value!=confirmPsswrd;
                        },
      //                     onChanged: (onChanged){},
      //                     //cursorColor: kPrimaryColor,
      //                     validator: (value) {
      //                       if (value == null || value.isEmpty)
      //                         return 'Field is required.';
      //                       String pattern =
      //                           r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
      //                       if (!RegExp(pattern).hasMatch(value))
      //                         return '''
      // Password must be at least 8 characters,
      // include an uppercase letter, number and symbol.
      // ''';
      //                       if(value!=newPassword.text)
      //                         return 'Password does not match';
      //                       return null;
      //                     },  onSaved: (String? value) {
      //                     value!=confirmPsswrd;
      //                   },
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                color:ColorConverter.stringToHex(AppStrings.bg_color),
                                icon: Icon(
                                  _isObscure2 ? Icons.visibility_off : Icons.visibility, color:ColorConverter.stringToHex(AppStrings.bg_color),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure2 = !_isObscure2;
                                  });
                                },),
                              label: Text('confirm Password',style: TextStyle(
                                fontWeight: FontWeight.bold,

                              ),)
                          ),
                        ),

                        const SizedBox(height: 70,),
                        GestureDetector(
                            onTap: (){

                          if (_formKey.currentState!.validate()) {
                           _formKey.currentState!.save();
                              showLoaderDialog(context);
                               ResetPsswrd(email, newPassword.text);
                                }
                            },

                            child: Container(
                              height: 55,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color:ColorConverter.stringToHex(AppStrings.bg_color),
                              ),
                              child: const Center(child: Text('Submit',style: TextStyle(
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
        )));
  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(

      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child:Text("")),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }


  ResetPsswrd(email,password)async{
   String url = ApiStrings.api_host+ApiStrings.reset_pass;
   print(email);
   print(url);
    var response = await http.post(Uri.parse(url),
      body: {
        'email':email ,
       'password': password,

      });

    if(response.statusCode==200){
      final data = jsonDecode(response.body);
      print(data);
      if(data['success']==1){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:Text(data['message']) ));
        Navigator.push(context, MaterialPageRoute(builder: (context)=>UserSignin()));
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:Text(data['message']) ));
      }
      return ResetPsswrd;
    }
    else {
      throw Exception('Unable to connect');
    }
  }



}

//
