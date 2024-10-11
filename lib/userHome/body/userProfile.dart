
import 'dart:convert';
import 'dart:io';
import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/Model/api/ApiStrings.dart';
import 'package:carwash/model/Helper/get_vechile.dart';
import 'package:carwash/model/sharedpre/userSharedPrefernces.dart';
import 'package:carwash/userHome/body/user_customer.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  File? _imagefile;
  String? customerCall;
  Future<List<VechileAdded>>? vechileads;
  String? userid;
  TextEditingController name_controller = TextEditingController();
  TextEditingController lastname_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController address_controller = TextEditingController();
  TextEditingController phNO_controller = TextEditingController();
  TextEditingController city_controller = TextEditingController();
  TextEditingController state_controller = TextEditingController();


  @override
  void initState() {
    UserSharedPrefernces.init();
    userid=UserSharedPrefernces.getUserId();
    //fetchProfile(userid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(userid);
    return WillPopScope(
        onWillPop: () async {
          onBackPress();
          return false;
        },
        child: Scaffold(
            // appBar: AppBar(
            //   backgroundColor: Colors.white,
            //   title: Text('Profile',
            //     style: TextStyle(color:ColorConverter.stringToHex(AppStrings.bg_color),
            //       fontWeight: FontWeight.bold,fontSize: 17,),),
            //   // leading: IconButton(
            //   //   icon: Icon(Icons.arrow_back, color: Colors.black),
            //   //   onPressed: () => Navigator.of(context).pop(),
            //   // ),
            //
            // ),
            body: SingleChildScrollView(
                child: Column(

                    children: [

                      // Container(
                      //     padding: EdgeInsets.only(top: 30),
                      //     child: Align(
                      //         alignment: Alignment.topCenter,
                      //         child: SizedBox(
                      //           height: 115,
                      //           width: 115,
                      //           child: Stack(
                      //             clipBehavior: Clip.none,
                      //             fit: StackFit.expand,
                      //             children: [
                      //               CircleAvatar(
                      //                 backgroundColor: Colors.white,
                      //                 radius: 80,
                      //                 child: ClipOval(
                      //                   child: _imagefile != null
                      //                       ? Image.file(File(_imagefile!.path),
                      //                     fit: BoxFit.cover,)
                      //                       : Image.asset(
                      //                       'assets/images/car1.png'),
                      //                 ),
                      //               ),
                      //
                      //               Positioned(
                      //                   bottom: 0,
                      //                   right: -25,
                      //                   child: RawMaterialButton(
                      //                     onPressed: () {
                      //                       showModalBottomSheet(
                      //                           context: context,
                      //                           builder: ((builder) =>
                      //                               bottomsheet()));
                      //                     },
                      //                     elevation: 2.0,
                      //                     fillColor: Color(0xFFF5F6F9),
                      //                     child: Icon(Icons.camera_alt_outlined,
                      //                       color: ColorConverter.stringToHex(AppStrings.orange_color),),
                      //                     padding: EdgeInsets.all(15.0),
                      //                     shape: CircleBorder(),
                      //                   )),
                      //             ],
                      //           ),
                      //         ))),
                    Container(
                      margin: EdgeInsets.only(top: 40,left: 30),
                      child: Align(alignment: Alignment.topLeft,
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                        Text('Settings',style: GoogleFonts.alkalami(fontWeight: FontWeight.bold,fontSize: 20,)),
                         Padding(padding: EdgeInsets.only(right: 20),
                          child:Icon(Icons.settings,color: Colors.blue,))
                   ]) )),

                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: SizedBox(height: 150,
                          child:  Card(
                          margin: EdgeInsets.all(15),
                         color: Colors.grey.withOpacity(0.1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),),
                          child: Center(child:
                          ListTile(
                            leading: CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('assets/images/img_1.png',),

                            ),
                            title: Text(UserSharedPrefernces.getUserName(),style: GoogleFonts.alkalami(fontSize: 20),),
                            subtitle: Text(UserSharedPrefernces.getUserEmail(),style: GoogleFonts.acme(),),
                          )   ),
                        ),
                        )),

                                Container(
                                  margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                                 decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                   borderRadius: BorderRadius.circular(20)),
                                    child: ListTile(
                                  title: Text('Profile Setting',
                                    style: GoogleFonts.alkalami(
                                        color: ColorConverter.stringToHex(
                                            AppStrings.bg_color),
                                        fontWeight: FontWeight.bold),),
                                  leading: Icon(Icons.settings,
                                      color:Colors.red ),
                                  trailing: Icon(Icons.arrow_forward_ios,
                                      color: ColorConverter.stringToHex(
                                          AppStrings.bg_color), size: 20),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/UserProfileDetail');
                                      },
                                   )),
                            Container(
                                margin: EdgeInsets.only(top: 15,left: 13,right: 13),
                             decoration: BoxDecoration(
                             color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20)),
                             child: ListTile(
                                  title: Text('Change Password',
                                      style: GoogleFonts.alkalami(
                                          color: ColorConverter.stringToHex(
                                              AppStrings.bg_color),
                                          fontWeight: FontWeight.bold)),
                                  leading: Icon(Icons.password,
                                      color: Colors.red ),
                                  trailing: Icon(Icons.arrow_forward_ios,
                                      color: ColorConverter.stringToHex(
                                          AppStrings.bg_color), size: 20),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/UserChpsswrd');
                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>UserChpsswrd()));
                                  },
                             )),
            Container(
                margin: EdgeInsets.only(top: 15,left: 13,right: 13),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20)),
                child:  ListTile(
                  title: Text('Add vehicle', style: GoogleFonts.alkalami(
                   color: ColorConverter.stringToHex(
                     AppStrings.bg_color),
                     fontWeight: FontWeight.bold)),
                 leading: Icon(Icons.time_to_leave,
                   color: Colors.red),
                  trailing: Icon(Icons.arrow_forward_ios,
                  color: ColorConverter.stringToHex(AppStrings.bg_color), size: 20),
                   onTap: () {
                     showModal(context,userid);
                        },
                )),
                      Container(
                          margin: EdgeInsets.only(top: 15,left: 13,right: 13),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20)),
                          child:  ListTile(
                            title: Text('Help No', style: GoogleFonts.alkalami(
                                color: ColorConverter.stringToHex(AppStrings.bg_color),fontWeight: FontWeight.bold)),
                           subtitle:  Text("+918195960039"),
                            leading: Icon(Icons.call,
                                color: Colors.red),
                            trailing: CircleAvatar(
                              backgroundColor: ColorConverter.stringToHex(AppStrings.orange_color),
                                child: IconButton(
                                  onPressed: ()async{
                                  final Uri url = Uri(
                                    scheme: "tel",
                                    path: "+918195960039",
                                  );
                                  if(await canLaunchUrl(url))
                                  {
                                  await launchUrl(url);
                                    }
                                    else{
                                      print("");
                                  }
                            },
                                  icon: Icon(Icons.call,color: Colors.white,),))
                          )),



            Container(
                margin: EdgeInsets.only(top: 15,left: 13,right: 13),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20)),
                child:  ListTile(
                  title: Text ('Logout', style: GoogleFonts.alkalami(color: ColorConverter.stringToHex(AppStrings.bg_color),
                      fontWeight: FontWeight.bold)),
                      leading: Icon(Icons.logout,
                      color: Colors.red),
                      trailing: Icon(Icons.arrow_forward_ios,
                      color: ColorConverter.stringToHex( AppStrings.bg_color), size: 20,),
                        onTap: () {
                                 _showDialog();
                        //  UserSharedPrefernces.logout();
                        //  //Navigator.pop(context,true);
                        //  Navigator.pop(context);
                        // Navigator.pushNamed(context, '/userSignin');
                           },
                          ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Text("Version 1.0.0(1)",style: TextStyle(color: Colors.black,fontSize: 10),),
                      )
                 ]))));
  }



  // logout dialogbox
  _showDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Do you want to logout ?',
              style: GoogleFonts.alkalami(
                  color: ColorConverter.stringToHex(AppStrings.bg_color),
                  fontWeight: FontWeight.bold)),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () {
                UserSharedPrefernces.logout();
                 Navigator.pop(context,true);
                Navigator.pop(context);

                Navigator.pushNamed(context, '/userSignin');
              },
              child: Text('Yes',
                  style: GoogleFonts.alkalami(
                      color: ColorConverter.stringToHex(AppStrings.bg_color),
                      fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No',
                  style: GoogleFonts.alkalami(
                      color: ColorConverter.stringToHex(AppStrings.bg_color),
                      fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
  //
  // Widget bottomsheet() {
  //   return Container(
  //     height: 100,
  //     width: MediaQuery
  //         .of(context)
  //         .size
  //         .width,
  //     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  //     child: Column(
  //       children: [
  //         Text('Choose Profile Photo', style: TextStyle(
  //             color: ColorConverter.stringToHex(AppStrings.bg_color),
  //             fontWeight: FontWeight.bold),),
  //       //  SizedBox(height: 20,),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Container(
  //              margin: EdgeInsets.only(top: 20),
  //               height: 40,
  //              width: 120,
  //              decoration: BoxDecoration(
  //              color: Colors.grey.withOpacity(0.1),
  //               borderRadius: BorderRadius.circular(10)),
  //               child: InkWell(child: Row(children: [
  //                   Icon(Icons.camera),
  //                   Text('Camera'),
  //                  ]),onTap: (){
  //                   takePhoto(ImageSource.camera);
  //                    Navigator.pop(context);
  //               },)
  //               //  ElevatedButton.icon(onPressed: () {
  //               //   takePhoto(ImageSource.camera);
  //               //    Navigator.pop(context);
  //               //   },
  //               //   style: ElevatedButton.styleFrom(
  //               //       backgroundColor: Colors.white),
  //               //   icon: Icon(Icons.camera, color: Colors.black87,),
  //               //   label: Text(
  //               //     'Camera', style: TextStyle(color: Colors.black87),)
  //               // )
  //              ),
  //             Container(
  //               margin: EdgeInsets.only(top: 20),
  //               height: 40,
  //               width: 120,
  //               decoration: BoxDecoration(
  //                   color: Colors.grey.withOpacity(0.1),
  //                   borderRadius: BorderRadius.circular(10)),
  //               child: InkWell(child: Row(children: [
  //                 Icon(Icons.image),
  //                 Text('Gallery'),
  //               ]),onTap: (){
  //                 takePhoto(ImageSource.gallery);
  //                 Navigator.pop(context);
  //               },)),
  //             // ElevatedButton.icon(onPressed: () {
  //             //   takePhoto(ImageSource.gallery);
  //             //   Navigator.pop(context);
  //             // },
  //             //     style: ElevatedButton.styleFrom(
  //             //         backgroundColor: Colors.white),
  //             //     icon: Icon(Icons.image, color: Colors.black87),
  //             //     label: Text(
  //             //         'Gallery', style: TextStyle(color: Colors.black87))
  //             // ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  fetchProfile(userid) async
  {
    //print(ApiStrings.api_host+ApiStrings.getProfilePic+"?unique_id="+userid.toString());
    var response = await http.post(Uri.parse(ApiStrings.api_host+ApiStrings.getProfilePic+"?unique_id="+userid.toString()));
     print("yoyoyooyooy"+response.body);

  }

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
  //     _imagefile =  File(croppedFile!.path.toString());
  //   });
  //   uploadImage(_imagefile);
  //
  // }


uploadProfile()async{
    var response = await http.post(Uri.parse(ApiStrings.api_host+ApiStrings.updateProfilePic));
  }

  Future<void> uploadImage(uploadimage) async {
    //show your own loading or progressing code here

    //String uploadurl = "http://192.168.0.112/test/image_upload.php";
    String uploadurl=ApiStrings.api_host+ApiStrings.updateProfilePic;


    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP

    try{
      List<int> imageBytes = uploadimage.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      //convert file image to Base64 encoding
      var response = await http.post(
          Uri.parse(uploadurl),
          body: {
            'image': baseimage,
          }
      );
      if(response.statusCode == 200){
        var jsondata = json.decode(response.body); //decode json data
        if(jsondata["error"]){ //check error sent from server
          print(jsondata["msg"]);
          //if error return from server, show message from server
        }else{
          print("Upload successful");
        }
      }else{
        print("Error during connection to server");
        //there is error during connecting to server,
        //status code might be 404 = url not found
      }
    }catch(e){
      print("Error during converting to Base64");
      //there is error during converting file image to base64 encoding.
    }
  }




//add vechile
  Future<List<VechileAdded>> getmyVechile() async {
    List<VechileAdded> vechileAd = [];
    var response = await http.post(
        Uri.parse(ApiStrings.api_host+ApiStrings.getVechile),
        body: {
          "user_id" : userid,
        }
    );
     List<dynamic> jsonData = json.decode(response.body);
      vechileAd=jsonData.map((data) => VechileAdded.fromJson(data)).toList();
       return vechileAd;
  }

  ActiveVechile(id,type) async {
    var response = await http.post(
        Uri.parse(ApiStrings.api_host + ApiStrings.updateVechile),
        body: {
          "user_id": userid,
          "type": type,
          "vehicle_id": id,
        }
    );
    print(id+ ': jshjsajasdjad');
    print('hnji sirji XYZ  :' + ApiStrings.api_host + ApiStrings.updateVechile);
    print(response.body);

  }



  showModal(context,userid)
  {
    vechileads = getmyVechile();
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
              height: 400,
              child: Column(
                  children: [
                    Container(child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(padding: EdgeInsets.only(
                              left: 15),
                              child: Text('select vehicle',
                                  style:  GoogleFonts.acme(
                                      fontWeight: FontWeight.bold,fontSize: 18))),
                          Padding(padding: EdgeInsets.only(right: 10),
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                             Navigator.pushNamed(context, '/UserSelectVechile');
                     // Navigator.push(context,  MaterialPageRoute( builder: (context) => UserSelectVechile()));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: BorderSide(
                                        width: 1,
                                        color: Colors.black26)
                                ),
                                icon: Icon(Icons.add,
                                    color: ColorConverter
                                        .stringToHex(
                                        AppStrings
                                            .bg_color),
                                    size: 20),
                                label: Text(
                                  'Add New Vehicle',
                                  style: TextStyle(
                                      color: ColorConverter
                                          .stringToHex(
                                          AppStrings
                                              .bg_color),
                                      fontWeight: FontWeight
                                          .bold,
                                      fontSize: 12),
                                )),
                          )
                        ])),
                    Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text('Saved Vehicles',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,fontWeight: FontWeight.bold),),
                            ))),
                    Container(
                      height: 280,
                      child:
                      FutureBuilder<List<VechileAdded>>(
                        future: vechileads,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            List<VechileAdded> items = snapshot.data!;
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              itemBuilder: (context, index,) {
                                return ListTile(
                                  title: InkWell(
                                    child: Column(children: [
                                      Container(child:
                                      Text(items[index].model.toString()+ ' , '+items[index].brandName.toString(),
                                          style: GoogleFonts.acme()),
                                      ), Divider(),
                                    ] ),
                                    onTap: (){
                                      String type = "1";
                                      ActiveVechile(items[index].id.toString(),type);
                                    },
                                  ),
                                  leading: Icon(Icons.time_to_leave,color: ColorConverter.stringToHex(AppStrings.bg_color)),
                                  trailing: IconButton(
                                    onPressed: (){
                                      // _showAddListDialog();
                                      String type = "0";
                                      ActiveVechile(items[index].id.toString(),type);
                                     Navigator.pop(context);
                                     Navigator.pop(context);
                                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vechile deleted successfully')));
                                     Navigator.pushNamed(context, '/userProfile');
                                      //showModal(context);
                                    },
                                    icon: Icon(Icons.delete,color: Colors.red,size: 20,),
                                  ),
                                  onTap: (){ },
                                );
                              }, );

                          } else {
                            return Center(child: Text('${snapshot.error}'));
                          }
                        } ,
                      ),
                    ),
                  ]));
        });
  }




  void onBackPress(){
    Navigator.pop(context);
  }
}



