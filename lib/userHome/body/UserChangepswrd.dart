
import 'dart:convert';
import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/Model/api/ApiStrings.dart';
import 'package:carwash/model/sharedpre/userSharedPrefernces.dart';
import 'package:carwash/userlogin/userSignin.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart'as http;


class UserChpsswrd extends StatefulWidget {
  createState() => UserChpsswrdState();
}

class UserChpsswrdState extends State<UserChpsswrd>{
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPsswrd = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure  = true;
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  bool  isloading  = false;

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
                 // color:ColorConverter.stringToHex(AppStrings.bg_color),
                  child:  Padding(
                    padding: EdgeInsets.only(top: 60.0, left: 22),
                    child: Text(
                      'Change\n  Password',
                      style: GoogleFonts.alkalami(
                          fontSize: 30,
                          color: ColorConverter.stringToHex(AppStrings.bg_color),
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
                              controller: oldPassword,
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
                                  label: Text('current password',style: TextStyle(
                                   fontWeight: FontWeight.bold,
                                  ),)
                              ),
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              obscureText: _isObscure1,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: newPassword,
                              onChanged: (onChanged){},
                              onSaved: (String? value) {
                                value!=newPassword;
                              },
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
                                  label: Text('password',style: TextStyle(
                                    fontWeight: FontWeight.bold,

                                  ),)
                              ),
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              obscureText: _isObscure2,
                              controller: confirmPsswrd,
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
                                   updatePsswrd(UserSharedPrefernces.getUserId(),newPassword.text,oldPassword.text);
                                  }
                                },

                                child: Container(
                                  height: 55,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                   border: Border.all(width: 1)
                                   // color:ColorConverter.stringToHex(AppStrings.bg_color),
                                  ),
                                  child:  Center(child: Text('Submit',style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color:ColorConverter.stringToHex(AppStrings.orange_color),
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




  updatePsswrd(unique_id,password,old_password)async{
    String url = ApiStrings.api_host+ApiStrings.updatePswrd;
    print(url);
    print('id: '+unique_id);
    print(password);
    var response = await http.post(Uri.parse(url),
        body: {
       "unique_id" : UserSharedPrefernces.getUserId(),
       "old_password" : old_password,
        "password" : password,

        });

    if(response.statusCode==200){
      final data = jsonDecode(response.body);
      print("hi"+response.body);
      if(data['success']==1){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:Text(data['message']) ));
        Navigator.push(context, MaterialPageRoute(builder: (context)=>UserSignin()));
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:Text(data['message']) ));
      }
      return updatePsswrd;
    }
    else {
      throw Exception('Unable to connect');
    }
  }



}


