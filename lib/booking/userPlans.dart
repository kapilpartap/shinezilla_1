//
// import 'package:carwash/CustomWidget/ColorConverter.dart';
// import 'package:carwash/values/AppStrings.dart';
// import 'package:flutter/material.dart';
//
// class UserPlan extends StatefulWidget {
//   const UserPlan({super.key});
//
//   @override
//   State<UserPlan> createState() => _PlanState();
// }
//
// class _PlanState extends State<UserPlan> {
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       backgroundColor: ColorConverter.stringToHex(AppStrings.bg_color),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text('Plans!',style: TextStyle(color: ColorConverter.stringToHex(AppStrings.bg_color)),),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         actions: [
//           Padding(padding: EdgeInsets.only(right: 15),
//           child:Icon(Icons.next_plan_outlined,color: Colors.black,size: 30,)
//           )],
//       ),
//       body: Container(
//
//       ),
//     );
//   }
// }
