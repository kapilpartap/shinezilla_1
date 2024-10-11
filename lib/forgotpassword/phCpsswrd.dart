



import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:flutter/material.dart';



class Phnpsswrd extends StatefulWidget {
  createState() => CpsswrdState();
}

class CpsswrdState extends State<Phnpsswrd>{

  String? user_id;
  TextEditingController new_Password = TextEditingController();
  TextEditingController confirm_Psswrd = TextEditingController();

  void didChangeDependencies() {
    final routeargs = ModalRoute.of(context)?.settings.arguments as Map;
    user_id = routeargs["user_id"].toString()!=null ? routeargs["user_id"].toString(): "N/A";

    super.didChangeDependencies();
  }

  @override
  void initState() {
    PhnCpsswrd(new_Password.text);
    super.initState();
  }


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
                      'Update\n Password',
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
                                value!=new_Password;
                              },

                              controller: new_Password,
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
                                  label: Text('new password',style: TextStyle(
                                    fontWeight: FontWeight.bold,

                                  ),)
                              ),
                            ),
                            TextFormField(
                              controller: confirm_Psswrd,
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
                                if(value!=new_Password.text)
                                  return 'Password does not match';
                                return null;
                              },  onSaved: (String? value) {
                              value!=confirm_Psswrd;
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
                                    PhnCpsswrd(new_Password.text);
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


  PhnCpsswrd(password)async {
    var response = await http.post(
        Uri.parse("https://shinezilla.in/app/public/api/resetPassword"),
        body: {
          'user_id': user_id,
          'password': password,

        });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      if (data['success'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['message'])));
        Navigator.pushNamed(context, "/userSignin");
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['message'])));
      }
      return PhnCpsswrd;
    }
    else {
      throw Exception('Unable to connect');
    }
  }


}


