
import 'dart:convert';
import 'dart:io';
import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/Model/api/ApiStrings.dart';
import 'package:carwash/model/Helper/profieData.dart';
import 'package:carwash/model/sharedpre/userSharedPrefernces.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;



class UserProfileDetail extends StatefulWidget {
  const UserProfileDetail({super.key});

  @override
  State<UserProfileDetail> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfileDetail> {
  File? _imagefile;
 Future<List<ProfileData>>? profile;
  final _formKey = GlobalKey<FormState>();
  bool data = false;
  bool updateSatus=false;
//  bool emailEditable=true;
 // get_profile_data
 //  unique_id
 TextEditingController  name_controller = TextEditingController();
  TextEditingController lastname_controller =TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController address_controller = TextEditingController();
  TextEditingController phNO_controller = TextEditingController();
  TextEditingController pincode_controller = TextEditingController();
  TextEditingController postOffice_controller = TextEditingController();
  TextEditingController city_controller = TextEditingController();
  TextEditingController state_controller = TextEditingController();
  TextEditingController district_controller = TextEditingController();
  TextEditingController landmark_controller = TextEditingController();
  TextEditingController customer_controller = TextEditingController();


 @override
  void initState() {
   profile = getprofileData();
    super.initState();
  }
bool enableDisableUpdateProfile()
{

  return false;
}
  @override
  Widget build(BuildContext context) {

   UserSharedPrefernces.init();
  print("Karan ji: "+ UserSharedPrefernces.getUserId());
     return
     Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
           title: Text('Profile Detail ',style: GoogleFonts.alkalami(fontWeight: FontWeight.bold,fontSize: 17,
               color: ColorConverter.stringToHex(AppStrings.bg_color))),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
         actions: [
            Switch(
              value: updateSatus,
               thumbColor: const MaterialStatePropertyAll<Color>(Colors.black),
                 onChanged: (bool value) {
                    setState(() {
                     updateSatus = value;
          });
        },
      )
],
      ),


      body: Form(
    key: _formKey,
    child:
      SingleChildScrollView(
        child: Column(
          children: [
           //  Container(
           //    child: ListView(shrinkWrap: true,primary: false,
           //        children: [
           //    ListTile(
           //      title: Text(UserSharedPrefernces.getUserName()),
           //      subtitle: Text(UserSharedPrefernces.getUserPhone().toString()),
           //      leading:  Container(
           //        child:   SizedBox(
           //                 height: 115,
           //                 width: 115,
           //                child:  Stack(
           //                  clipBehavior: Clip.none,
           //                  fit: StackFit.expand,
           //                  children: [
           //                    CircleAvatar(
           //                      radius: 80,
           //                      child: ClipOval(
           //                        child: _imagefile != null
           //                            ? Image.file(File(_imagefile!.path))
           //                            : Image.asset('assets/images/bg.png'),
           //                      ),
           //                    ),
           //
           //                    Positioned(
           //                        bottom: 0,
           //                        right: -25,
           //                        child: RawMaterialButton(
           //                          onPressed: () {
           //                            showModalBottomSheet(context: context, builder: ((builder)=>bottomsheet()));
           //                          },
           //                          elevation: 2.0,
           //                          fillColor: Color(0xFFF5F6F9),
           //                          child: Icon(Icons.camera_alt_outlined, color: Colors.blue,),
           //                          padding: EdgeInsets.all(15.0),
           //                          shape: CircleBorder(),
           //                        )),
           //                  ],
           //                ),
           //              ))),
           //
           // ]) ),
            Container(
                child:   FutureBuilder<List<ProfileData>>(
         future: profile,
         builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
             return Center(child: CircularProgressIndicator());
           } else if (snapshot.hasError) {
             return Center(child: Text('${snapshot.error}'));
           } else if (snapshot.hasData) {
             List<ProfileData> items = snapshot.data!;
             return ListView.builder(
                 shrinkWrap: true,
                 primary: false,
                 itemCount: items.length,
                 itemBuilder: (context, index,) {
                   name_controller.text=items[index].username.toString()!="null" ?items[index].username.toString() :"";
                   lastname_controller.text = items[index].lastName.toString()!= "null" ?items[index].lastName.toString() :"";
                   email_controller.text = items[index].email.toString()!="null" ?items[index].email.toString() :"";
                   address_controller.text = items[index].address.toString()!= "null" ?items[index].address.toString() :"";
                   phNO_controller.text = items[index].phoneNo.toString()!= "null" ?items[index].phoneNo.toString() :"";;
                   pincode_controller.text = items[index].pincode.toString()!= "null" ?items[index].pincode.toString() :"";;
                   postOffice_controller.text = items[index].postOffice.toString()!= "null" ?items[index].postOffice.toString() :"";;
                   city_controller.text = items[index].city.toString() != "null" ?items[index].city.toString() :"";;
                   state_controller.text = items[index].state.toString()!= "null" ?items[index].state.toString() :"";;
                   district_controller.text = items[index].district.toString()!= "null" ?items[index].district.toString() :"";;
                   landmark_controller.text = items[index].landmark.toString()!= "null" ?items[index].landmark.toString() :"";;

                   return SingleChildScrollView(
                     child: Column(children: [
                           Container(
                               margin:  EdgeInsets.only(top:20,left: 20, right: 20),
                                child: TextFormField(
                                  enabled: updateSatus,
                                 textInputAction: TextInputAction.next,
                                 autofocus: true,
                                 controller: name_controller,
                                 validator: RequiredValidator(errorText: 'Name is required'),
                                 onSaved: (String? value){
                                   value!= name_controller;
                                 },
                                 decoration: InputDecoration(
                                   prefixIcon: Icon(Icons.person,color: ColorConverter.stringToHex(AppStrings.bg_color),),
                                     label: Text('First Name'),labelStyle: TextStyle(color: ColorConverter.stringToHex(AppStrings.orange_color)),
                                     contentPadding: EdgeInsets.all(5)
                                       ),
                                     )),

                           Container(
                             margin: EdgeInsets.only(top:5,left: 20, right: 20),
                               child: TextFormField(
                                 textInputAction: TextInputAction.next,
                                  controller: lastname_controller,
                                 decoration: InputDecoration(
                                   prefixIcon: Icon(Icons.person,color: ColorConverter.stringToHex(AppStrings.bg_color)),
                                     label: Text('Last name',),labelStyle: TextStyle(color: ColorConverter.stringToHex(AppStrings.orange_color)),
                                 contentPadding: EdgeInsets.all(5)
                                 )
                             ),),


                           Container(
                             margin: EdgeInsets.only(top:5,left: 20, right: 20),
                            child: TextFormField(
                              enabled: updateSatus,
                              textInputAction: TextInputAction.next,
                               autofocus: true,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                 onChanged: (onChanged){},
                                // cursorColor: kPrimaryColor,
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
                                   },   onSaved: (String? value) {
                                   value!=email_controller;
                                 },
                                 controller: email_controller,
                                 //  cursorColor: Color(0xffF5591F),
                                 decoration: InputDecoration(
                                     focusedBorder: UnderlineInputBorder(
                                         borderSide: BorderSide(color: ColorConverter.stringToHex(AppStrings.orange_color))),
                                     prefixIcon: Icon(Icons.mail,color: ColorConverter.stringToHex(AppStrings.bg_color)),
                                    label: Text('Email'),labelStyle: TextStyle(color: ColorConverter.stringToHex(AppStrings.orange_color)),
                                 contentPadding: EdgeInsets.all(5)
                                 )),
                           ),
                           Container(
                            margin: EdgeInsets.only(top:5,left: 20, right: 20),
                              child: TextFormField(
                                 textInputAction: TextInputAction.next,
                                 minLines: 1,
                                 maxLines: 3,
                                 controller: address_controller,
                                 //  cursorColor: Color(0xffF5591F),
                                  decoration: InputDecoration(
                                     focusedBorder: UnderlineInputBorder(
                                         borderSide: BorderSide(color: ColorConverter.stringToHex(AppStrings.orange_color))),
                                     prefixIcon: Icon(Icons.home,color: ColorConverter.stringToHex(AppStrings.bg_color)),
                                 label: Text('Address'),labelStyle: TextStyle(color: ColorConverter.stringToHex(AppStrings.orange_color)),
                                  contentPadding: EdgeInsets.all(5)
                                  ),),
                           ),
                           Container(
                             margin: EdgeInsets.only(top:5,left: 20, right: 20),
                               child: TextFormField(
                                 enabled: updateSatus,
                                 textInputAction: TextInputAction.next,
                                 keyboardType: TextInputType.number,
                                 autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'phone_no is required.';
                                    String pattern =
                                        r'(^(?:[+0]9)?[0-9]{10}$)';
                                    if (!RegExp(pattern).hasMatch(value))
                                      return '''
                                        please enter valid phone_no
                                             ''';
                                    return null;
                                  },
                                 onChanged: (onChanged){},
                                  //cursorColor: kPrimaryColor,
                                  // validator: RequiredValidator(errorText:'Field cannot be empty' ),
                                  onSaved: (String? value) {
                                    value!=phNO_controller;
                                  },
                                 controller: phNO_controller,
                                 decoration: InputDecoration(
                                     focusedBorder: UnderlineInputBorder(
                                         borderSide: BorderSide(color: ColorConverter.stringToHex(AppStrings.orange_color))),
                                     prefixIcon: Icon(Icons.call,color: ColorConverter.stringToHex(AppStrings.bg_color)),
                               label: Text('Phone No.'),labelStyle: TextStyle(color: ColorConverter.stringToHex(AppStrings.orange_color)),
                             contentPadding: EdgeInsets.all(5)
                                 )),
                           ),
                           Container(
                             margin: EdgeInsets.only(top:5,left: 20, right: 20),
                              child: TextFormField(
                               textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                 // maxLength: 6,
                                 // validator: (value) {
                                 //   if (value == null || value.isEmpty)
                                 //     return 'pincode is required.';
                                 //   String pattern =
                                 //       r'(^(?:[+0]9)?[0-9]{10}$)';
                                 //   if (!RegExp(pattern).hasMatch(value))
                                 //     return 'please enter valid pincode';
                                 //   return null;
                                 // },
                                 // onChanged: (onChanged){},
                                 // //cursorColor: kPrimaryColor,
                                 // // validator: RequiredValidator(errorText:'Field cannot be empty' ),
                                 // onSaved: (String? value) {
                                 //   value!= pincode_controller;
                                 // },
                                 //regex = "^[1-9]{1}[0-9]{2}\\s{0, 1}[0-9]{3}$"
                                 controller: pincode_controller,
                                 decoration: InputDecoration(
                                     focusedBorder: UnderlineInputBorder(
                                         borderSide: BorderSide(color: ColorConverter.stringToHex(AppStrings.orange_color))),
                                     prefixIcon: Icon(Icons.pin,color: ColorConverter.stringToHex(AppStrings.bg_color)),
                               label: Text('pincode'),labelStyle: TextStyle(color: ColorConverter.stringToHex(AppStrings.orange_color)),
                               contentPadding: EdgeInsets.all(5)
                                 )),
                           ),
                           Container(
                             margin: EdgeInsets.only(top:5,left: 20, right: 20),
                               child: TextFormField(
                                 textInputAction: TextInputAction.next,
                                 controller: postOffice_controller,
                                 //  cursorColor: Color(0xffF5591F),
                                 decoration: InputDecoration(
                                     focusedBorder: UnderlineInputBorder(
                                         borderSide: BorderSide(color: ColorConverter.stringToHex(AppStrings.orange_color))),
                                     prefixIcon: Icon(Icons.post_add,color: ColorConverter.stringToHex(AppStrings.bg_color)),
                               label: Text('Post Office'),labelStyle: TextStyle(color: ColorConverter.stringToHex(AppStrings.orange_color)),
                                contentPadding: EdgeInsets.all(5)
                                 )),
                           ),
                           Container(
                             margin: EdgeInsets.only(top:5,left: 20, right: 20),
                               child: TextFormField(
                                 textInputAction: TextInputAction.next,
                                 controller: city_controller,
                                 //  cursorColor: Color(0xffF5591F),
                                 decoration: InputDecoration(
                                     focusedBorder: UnderlineInputBorder(
                                         borderSide: BorderSide(color: ColorConverter.stringToHex(AppStrings.orange_color))),
                                     prefixIcon: Icon(Icons.location_city,color: ColorConverter.stringToHex(AppStrings.bg_color)),
                               label: Text('City'),labelStyle: TextStyle(color: ColorConverter.stringToHex(AppStrings.orange_color)),
                                  contentPadding: EdgeInsets.all(5)
                                 )),
                           ),
                           Container(
                             margin: EdgeInsets.only(top:5,left: 20, right: 20),
                              child: TextFormField(
                                 textInputAction: TextInputAction.next,
                                 controller: state_controller,
                                 //  cursorColor: Color(0xffF5591F),
                                 decoration: InputDecoration(
                                     focusedBorder: UnderlineInputBorder(
                                         borderSide: BorderSide(color: ColorConverter.stringToHex(AppStrings.orange_color))),
                                     prefixIcon: Icon(Icons.location_city,color: ColorConverter.stringToHex(AppStrings.bg_color)),
                                label: Text('State'),labelStyle: TextStyle(color: ColorConverter.stringToHex(AppStrings.orange_color)),
                                 contentPadding: EdgeInsets.all(5)
                                 )),
                           ),
                           Container(
                             margin: EdgeInsets.only(top:5,left: 20, right: 20),
                             child: TextFormField(
                                 textInputAction: TextInputAction.next,
                                 controller: district_controller,
                                 //  cursorColor: Color(0xffF5591F),
                                 decoration: InputDecoration(
                                     // focusedBorder: UnderlineInputBorder(
                                     //     borderSide: BorderSide(color: ColorConverter.stringToHex(AppStrings.orange_color))),
                                     prefixIcon: Icon(Icons.display_settings,color: ColorConverter.stringToHex(AppStrings.bg_color)),
                               label: Text('District'),labelStyle: TextStyle(color: ColorConverter.stringToHex(AppStrings.orange_color)),
                                   contentPadding: EdgeInsets.all(5)
                                 )),
                           ),
                           Container(
                             margin: EdgeInsets.only(top:5,left: 20, right: 20),
                             child: TextFormField(
                                 textInputAction: TextInputAction.next,
                                 controller: landmark_controller,
                                 //  cursorColor: Color(0xffF5591F),
                                 decoration: InputDecoration(
                                     // focusedBorder: UnderlineInputBorder(
                                     //     borderSide: BorderSide(color: ColorConverter.stringToHex(AppStrings.orange_color))),
                                     prefixIcon: Icon(Icons.account_balance,color: ColorConverter.stringToHex(AppStrings.bg_color)),
                                label: Text('Landmark'),labelStyle: TextStyle(color: ColorConverter.stringToHex(AppStrings.orange_color)),
                                    contentPadding: EdgeInsets.all(5)
                                 )),
                           ),
                       Container(
                         margin: EdgeInsets.only(top:5,left: 20, right: 20),
                         child: TextFormField(
                             textInputAction: TextInputAction.next,
                             controller: customer_controller,
                             //  cursorColor: Color(0xffF5591F),
                             decoration: InputDecoration(
                                 focusedBorder: UnderlineInputBorder(
                                     borderSide: BorderSide(color: ColorConverter.stringToHex(AppStrings.orange_color))),
                                 prefixIcon: Icon(Icons.call,color: ColorConverter.stringToHex(AppStrings.bg_color)),
                                 label: Text('Customer care'),labelStyle: TextStyle(color: ColorConverter.stringToHex(AppStrings.orange_color)),
                                 contentPadding: EdgeInsets.all(5)
                             )),
                       ),
                         ]),
                     );
                 });
           }
           else {
             return Center(child: Text('${snapshot.error}'));
           }
         })),
            Container(
             // color: Colors.amber,
               margin: EdgeInsets.only(left: 50,right: 50,bottom: 80),
               // height: 60,
                width: double.infinity,
                child: ElevatedButton(

                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1,color: Colors.black26)
                        )
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                      updateProfile(UserSharedPrefernces.getUserId(), name_controller.text, lastname_controller.text,
                          email_controller.text,address_controller.text,phNO_controller.text,
                          pincode_controller.text,postOffice_controller.text,city_controller.text, state_controller.text,
                         district_controller.text,landmark_controller.text
                      );
                    }},
                    child: Text(' Update ', style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold,
                        color: ColorConverter.stringToHex(AppStrings.orange_color)
                    ),))
            )
          ],
        ),)  ) );
  }

  //phone_no validate
  String? validateMobile(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    }
    else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

//fetch profile data api
  Future<List<ProfileData>> getprofileData() async {
    List<ProfileData> getprofile = [];
    http.Response response = await http.post(
        Uri.parse(ApiStrings.api_host+ApiStrings.profileData),
      body: {
          "unique_id" : UserSharedPrefernces.getUserId(),
      }
    );
       print('Anush :'+ApiStrings.base_url+ApiStrings.profileData);
       print(response.body);
    List<dynamic> jsonData = json.decode(response.body);
    getprofile = jsonData.map((data) => ProfileData.fromJson(data)).toList();
    return getprofile;
  }


// Update button API
   updateProfile(unique_id,name_controller,lastname_controller,email_controller,address_controller,phNO_controller,
       pincode_controller,postOffice_controller,city_controller,state_controller,
       district_controller,landmark_controller) async {

    http.Response response = await http.post(
        Uri.parse(ApiStrings.api_host+ApiStrings.updateProfile),
      body: {
            'unique_id': unique_id,
            'username': name_controller,
            'last_name': lastname_controller,
            'email': email_controller,
            'address': address_controller,
            'phone_no':phNO_controller,
            'pincode': pincode_controller,
            'post_office': postOffice_controller,
            'city': city_controller,
            'state': state_controller,
            'district': district_controller,
            'landmark': landmark_controller,
      }
    );
     print('kartik sir :'+ApiStrings.base_url+ApiStrings.updateProfile);
    if(response.statusCode==200)
    {
     var data = jsonDecode(response.body);
     print(response.body);
     print(response.statusCode);
      if(data["success"]==1) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:Text(data['message']) ));
        Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfileDetail()));
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:Text(data['message']) ));
      }
    }
    else
    {
      print("Network Problem...");
    }


  }


  // Widget bottomsheet(){
  //   return Container(
  //     height: 100,
  //     width: MediaQuery.of(context).size.width,
  //     margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
  //     child: Column(
  //       children: [
  //         Text('Choose Profile Photo',style: TextStyle(fontSize: 20),),
  //         SizedBox(height: 20,),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             ElevatedButton.icon(onPressed: (){
  //               takePhoto(ImageSource.camera);
  //             },
  //                 icon: Icon(Icons.camera),
  //                 label: Text('Camera')
  //             ),
  //             ElevatedButton.icon(onPressed: (){
  //               takePhoto(ImageSource.gallery);
  //             },
  //                 icon: Icon(Icons.image),
  //                 label: Text('Gallery')
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  // void takePhoto (ImageSource source) async {
  //   XFile? file= await ImagePicker().pickImage(source: source);
  //   CroppedFile? croppedFile = await ImageCropper().cropImage(
  //     sourcePath: file!.path,
  //     aspectRatioPresets: [
  //       CropAspectRatioPreset.square,
  //       CropAspectRatioPreset.ratio3x2,
  //       CropAspectRatioPreset.original,
  //       CropAspectRatioPreset.ratio4x3,
  //       CropAspectRatioPreset.ratio16x9
  //     ],
  //     uiSettings: [
  //       AndroidUiSettings(
  //           toolbarTitle: 'Cropper',
  //           toolbarColor: Colors.deepOrange,
  //           toolbarWidgetColor: Colors.white,
  //           initAspectRatio: CropAspectRatioPreset.original,
  //           lockAspectRatio: false),
  //       IOSUiSettings(
  //         title: 'Cropper',
  //       ),
  //       WebUiSettings(
  //         context: context,
  //       ),
  //     ],
  //   );
  //   setState(() {
  //     _imagefile =new File(croppedFile!.path.toString());
  //   });
  // }

  void onBackPress(){

    Navigator.pop(context);
  }



}



