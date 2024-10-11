//
//
// import 'package:carwash/CustomWidget/ColorConverter.dart';
// import 'package:carwash/Model/api/ApiStrings.dart';
// import 'package:carwash/userlogin/userSignin.dart';
// import 'package:carwash/userlogin/userSignup.dart';
// import 'package:carwash/values/AppStrings.dart';
// import 'package:flutter/material.dart';
//
// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color:ColorConverter.stringToHex(AppStrings.bg_color),
//         child:
//       Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//                SizedBox(
//                 height: 100,
//               ),
//                Text('Welcome',style: TextStyle(
//                   fontSize: 30, color: Colors.white ),),
//                SizedBox(height: 30,),
//               GestureDetector(
//                 onTap: (){
//                   Navigator.pushNamed(context, '/userSignin');
//                   // Navigator.push(context,
//                   //     MaterialPageRoute(builder: (context) =>  UserSignin()));
//                 },
//                 child: Container(
//                   height: 53,
//                   width: 320,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     border: Border.all(color: Colors.white),
//                   ),
//                   child: const Center(child: Text(AppStrings.signin,style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white
//                   ),),),
//                 ),
//               ),
//                SizedBox(height: 30,),
//               GestureDetector(
//                 onTap: (){
//                   Navigator.pushNamed(context, '/userSignup');
//                   // Navigator.push(context,
//                   //     MaterialPageRoute(builder: (context) =>  UserSignup()));
//                 },
//                 child: Container(
//                   height: 53,
//                    decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(30),
//                     border: Border.all(color: Colors.white),
//                   ),
//                   child:  Center(child: Text(AppStrings.signup,style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black
//                   ),),),
//                 ),
//               ),
//             ]
//        ),
//       )
//     );
//   }
// }
//
// //
// // import 'package:flutter/material.dart';
// //
// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});
// //
// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }
// //
// // class _HomeScreenState extends State<HomeScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return  Scaffold(
// //       appBar: AppBar(
// //         title: Text('Home'),
// //       ),
// //       body: Container(),
// //     );
// //
// //   }
// // }
