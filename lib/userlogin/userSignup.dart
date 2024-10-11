
import 'dart:convert';

import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/CustomWidget/CustomWidget.dart';
import 'package:carwash/Model/http/ApiClient.dart';
import 'package:carwash/model/sharedpre/userSharedPrefernces.dart';
import 'package:carwash/userHome/main.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;

class UserSignup extends StatefulWidget {
  createState() => UserSignupState();
}
class UserSignupState extends State<UserSignup>{

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phNoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cnfrmpswrdController = TextEditingController();
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isObscure1 = true;
 bool val_status=false;
  @override
  Widget build(BuildContext context) {
// nameController.text = "kkp";
// emailController.text = "kkp@gmail.com";
// phNoController.text = "9856743325";
// passwordController.text = "kkp";
// cnfrmpswrdController.text= "kkp";
    return Scaffold(
        body: Form(
        key: _formKey,
       child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color:ColorConverter.stringToHex(AppStrings.bg_color),
              child: const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 22),
                child: Text('Create Your\nAccount!',
                  style: TextStyle(fontSize: 30,
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
                child: SingleChildScrollView(child:
                Padding(
                  padding: const EdgeInsets.only(left: 18.0,right: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isloading ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Center(child: CircularProgressIndicator())):Text(""),

                       TextFormField(
                         textInputAction: TextInputAction.done,
                         autovalidateMode: AutovalidateMode.onUserInteraction,
                         onChanged: (onChanged){},
                         //cursorColor: kPrimaryColor,
                         validator: RequiredValidator(errorText: 'Please enter your name'),
                         onSaved: (String? value) {
                           value!=nameController;
                         },
                         controller: nameController,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.person, color:ColorConverter.stringToHex(AppStrings.bg_color),),
                            label: Text(' Name',style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),)
                        ),
                      ),
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
                            suffixIcon: Icon(Icons.mail, color:ColorConverter.stringToHex(AppStrings.bg_color),),
                            label: Text('Gmail',style: TextStyle(
                              fontWeight: FontWeight.bold,

                            ),)
                        ),
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        //  validator: (value){
                        //   if(value!.isEmpty){
                        //     return 'Please enter a phone number';
                        // }else if(
                        // !RegExp(r"^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. ]*(\d{3}[-. ]*(\d{4})(?: *x(\d+))?\s*$").hasMatch(value)){
                        //     return "Please enter a valid phone number ";
                        //   }
                        //  },
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
                        onChanged: (onChanged){},
                        onSaved: (String? value) {
                          value!=phNoController;
                        },
                        controller: phNoController,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.call, color:ColorConverter.stringToHex(AppStrings.bg_color),),
                            label: Text(' PhoneNo',style: TextStyle(
                              fontWeight: FontWeight.bold,

                            ),)
                        ),
                      ),


                       TextFormField(
                         textInputAction: TextInputAction.done,
                         obscureText: _isObscure,
                         autovalidateMode: AutovalidateMode.onUserInteraction,

                         validator: (value) {
                           if (value == null || value.isEmpty)
                             return 'Password is required.';
                           String pattern = '' ;
                           if (!RegExp(pattern).hasMatch(value))
                             return '''
                                   ''';
                           return null;
                         },
                         onChanged: (onChanged){},
                         onSaved: (String? value) {
                           value!=passwordController;
                         },
                         controller: passwordController,
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
                            label: Text('Password',style: TextStyle(
                              fontWeight: FontWeight.bold,

                            ),)
                        ),
                      ),
                       TextFormField(
                         textInputAction: TextInputAction.done,
                         autovalidateMode: AutovalidateMode.onUserInteraction,
                         obscureText: _isObscure1,
                         onChanged: (onChanged){},
                        // cursorColor: kPrimaryColor,
                         validator: (value) {
                           if (value == null || value.isEmpty)
                             return 'Password is required.';
                           String pattern ='' ;
                           if (!RegExp(pattern).hasMatch(value))
                             return '''
                                      ''';
                           if(value!=passwordController.text)
                             return 'Password does not match';
                           return null;
                         },  onSaved: (String? value) {
                         value!=cnfrmpswrdController;
                       },
                         controller: cnfrmpswrdController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              color:ColorConverter.stringToHex(AppStrings.bg_color),
                              icon: Icon(
                                _isObscure1 ? Icons.visibility_off : Icons.visibility, color:ColorConverter.stringToHex(AppStrings.bg_color),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure1 = !_isObscure1;
                                });
                              },),
                            label: Text('Confirm Password',style: TextStyle(
                              fontWeight: FontWeight.bold,

                            ),)
                        ),
                      ),


                      const SizedBox(height: 70,),
                           GestureDetector(

                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        setState(() {
                          isloading=true;
                        });
                        Map<String,dynamic> atributes=Map();
                        atributes["username"]=nameController.text;
                        atributes["email"]=emailController.text;
                        atributes["password"]=passwordController.text;
                        atributes["phone_no"] =phNoController.text;
                        ApiClient client=ApiClient();
                        http.Response res= await client.signupUser(atributes);
                        Map map_response= json.decode(res.body);
                        print(res.body);
                        if(map_response["success"]==1) {




   //                       UserSharedPrefernces.setLogin(true);
   //  atributes["username"]!=null ? UserSharedPrefernces.setUserName(atributes["username"]) : (){
   //  CustomWidget.showSnackbar(context, "Something went wrong ! Please try again.") ;
   //  return;
   //  };
   //  print(UserSharedPrefernces.getUserName());
   //  atributes["email"]!=null ? UserSharedPrefernces.setUserEmail(atributes["email"].toString()) : (){
   //  CustomWidget.showSnackbar(context, "Something went wrong ! Please try again.") ;
   //  return;
   //  };
   //  print("Check:"+UserSharedPrefernces.getUserEmail());
   // atributes["password"]!=null ? UserSharedPrefernces.setUserPassword(atributes["password"].toString()) : (){
   //  CustomWidget.showSnackbar(context, "Something went wrong ! Please try again.") ;
   //  return;
   //  };
   //  print(UserSharedPrefernces.getUserPassword());
   //  atributes["phone_no"]!=null ? UserSharedPrefernces.setUserPhone( atributes["phone_no"].toString()) : (){
   //  CustomWidget.showSnackbar(context, "Something went wrong ! Please try again.") ;
   //  return;
    //};

                           setState(() {
                            isloading=false;
                          });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(map_response['message'])));
                         // Navigator.pushNamed(context, '/userSignin');
                        Navigator.pushNamed(context, '/userVerifyOtp',
                            arguments: {
                          "phno" :phNoController.text
                        }
                        );
                        }
                        else {
                          setState(() {
                            isloading = false;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(map_response['message'])));
                          });
                        }
                          }
                        },
                        child: Container(
                          height: 55,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color:ColorConverter.stringToHex(AppStrings.bg_color),
                          ),
                          child: const Center(child: Text(AppStrings.signup,style: TextStyle(
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
            )],
          ) ));
  }

}

