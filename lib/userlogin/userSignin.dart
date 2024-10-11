
import 'dart:convert';
import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/CustomWidget/CustomWidget.dart';
import 'package:carwash/model/http/ApiClient.dart';
import 'package:carwash/model/sharedpre/userSharedPrefernces.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;


class UserSignin extends StatefulWidget {
  createState() => UserSigninState();
}

 class UserSigninState extends State<UserSignin>{
   TextEditingController emailController = TextEditingController();
   TextEditingController passwordController = TextEditingController();
   bool isloading = false;
   final _formKey = GlobalKey<FormState>();
   bool _isObscure = true;

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserSharedPrefernces.init();

  }
   
    @override
  Widget build(BuildContext context) {
    // print("aaa"+UserSharedPrefernces.getUserId().toString());
      // emailController.text="mno@gmail.com";
      // passwordController.text="mno";
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
                  'Hello \n'+AppStrings.signin,
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
                         textInputAction: TextInputAction.done,
                         autovalidateMode: AutovalidateMode.onUserInteraction,
                         onChanged: (onChanged){},
                         //cursorColor: kPrimaryColor,
                         validator: (String? value){
                           if(value!.isEmpty){
                             return 'Please enter email / phone_no';
                           }
                           if(!RegExp(
                               r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                               .hasMatch(value)){
                             return '';
                           }
                           return null;
                         }, onSaved: (String? value) {
                         value!=emailController;
                       },
                        controller: emailController,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.mail_outline, color:ColorConverter.stringToHex(AppStrings.bg_color),),
                            label: Text('email / phone number.',style: TextStyle(
                              fontWeight: FontWeight.bold,

                            ),)
                        ),
                      ),
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.only(top: 10),
                         alignment: Alignment.topRight,
                         child: Text("Login with OTP ?",),
                          ),
                          onTap: (){
                            LoginOtp();
                          },
                        ),


                       TextFormField(
                         textInputAction: TextInputAction.done,
                         obscureText: _isObscure,
                         autovalidateMode: AutovalidateMode.onUserInteraction,
                         controller: passwordController,
                        //  validator: (value) {
                        //    if (value == null || value.isEmpty)
                        //      return 'Field is required.';
                        //    String pattern =
                        //        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                        //    if (!RegExp(pattern).hasMatch(value))
                        //      return '''
                        //        Password must be at least 8 characters,
                        //        include an uppercase letter, number and symbol.
                        //             ''';
                        //    return null;
                        //  },
                        // onChanged: (onChanged){},
                        //  //cursorColor: kPrimaryColor,
                        //  // validator: RequiredValidator(errorText:'Field cannot be empty' ),
                        //  onSaved: (String? value) {
                        //    value!=passwordController;
                        //  },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
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
                      const SizedBox(height: 20,),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, "/userRegphnNo");
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>RegphnNo()));
                        },
                        child:  const Align(
                        alignment: Alignment.centerRight,
                        child: Text('Forgot Password?',style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color:Colors.black,
                        ),),
                        ) ),
                      const SizedBox(height: 70,),
                       GestureDetector(
                           onTap: ()async{
                              setState(() {
                                isloading=true;
                              });
                             Map<String,dynamic> atributes=Map();
                             atributes["username"]=emailController.text;
                             atributes["password"]=passwordController.text;
                             ApiClient client=ApiClient();
                             http.Response res=  await client.signInUser(atributes);
                             Map map_response= json.decode(res.body);
                              print(map_response);
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
                                  setState(() {
                                    isloading=false;
                                  });
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(map_response['message'])));
                               Navigator.pop(context);
                               Navigator.pushNamed(context, '/userHomeNav');

                             }
                             else{
                             setState(() {
                               isloading=false;
                               print('Invalid Credentials');
                               //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter your email and password correctly')));
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(map_response['message'])));
                             });
                             }

                           },
                         child: Container(
                        height: 55,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color:ColorConverter.stringToHex(AppStrings.bg_color),
                        ),
                        child: const Center(child: Text(AppStrings.signin,style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white
                        ),),),
                      )),

                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                        Text('Dont have an account?'),
                        TextButton(onPressed: (){
                          Navigator.pushNamed(context, '/userSignup');
                        }, child: Text('Register!',style: TextStyle(color: Colors.red),))
                        ])),

                      ],
                  ),
                ),
              ),
            ),
            ) ],
        )));
  }

  LoginOtp()async {
    var response = await http.post(
        Uri.parse("https://shinezilla.in/app/public/api/loginwithotp"),
        body: {
          'username': emailController.text,
        });
print("xyz "+emailController.text);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null) {
        if (data['success'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(data['message'])));
          Navigator.pushNamed(context, "/SigninVerify_Otp",
              arguments: {
                'phone_no': data['phone_no']
              }
          );
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(data['message'])));
        }
        return LoginOtp;
      }
      else {
        throw Exception('Unable to connect');
      }
    }
  }


}
