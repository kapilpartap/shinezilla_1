

import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/booking/userbooking_status.dart';
import 'package:carwash/services/AllServices.dart';
import 'package:carwash/userHome/body/home.dart';
import 'package:carwash/userHome/body/userProfile.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:flutter/material.dart';


class UserHomeNav extends StatefulWidget {
  const UserHomeNav({super.key});
  @override
  State<UserHomeNav> createState() => UserHomeNavState();
}

class UserHomeNavState extends State<UserHomeNav> {

  int currentPageIndex = 0;
  final screens = [
    UserHome(),
    AllServices(),
    UserBookingStatus(),
    UserProfile(),

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        height: 60,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: ColorConverter.stringToHex(AppStrings.orange_color),
        selectedIndex: currentPageIndex,
        destinations:  <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.insert_chart_outlined_rounded),
             label: 'Services',
          ),
          NavigationDestination(
            icon:  Icon(Icons.next_plan_outlined),
            label: 'booking',
          ),
          NavigationDestination(
            icon:  Icon(Icons.person),
            label: 'Account',
          ),

        ],
      ),
      body: screens[currentPageIndex],


    );
  }
}


// NavigationDestination(
// icon: Badge(child: Icon(Icons.person)),
// label: 'Account',
// ),







// import 'package:carwash/booking/userbooking_status.dart';
// import 'package:carwash/userHome/body/home.dart';
// import 'package:carwash/userHome/body/userProfiledetail.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
//
//
//
// class UserHomeNav extends StatefulWidget{
//   createState()=>  HomeState();
// }
//
// class HomeState extends State<UserHomeNav>{
//   int currentIndex = 0;
//   final screens = [
//     UserHome(),
//     UserBookingStatus(),
//     UserProfile(),
//
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final items = [
//       Icon(Icons.home,size: 30),
//       Icon(Icons.library_books,size: 30,),
//      // Icon(Icons.next_plan_outlined ,size: 30,),
//       Icon(Icons.person,size: 30,),
//     ];
//     return SafeArea(
//     top: false,
//         child: Scaffold(
//       extendBody: true,
//
//       body: screens[currentIndex],
//        bottomNavigationBar: CurvedNavigationBar(
//          backgroundColor: Colors.transparent,
//         height: 40,
//         //color: ColorConverter.stringToHex(AppStrings.bg_color),
//          index: currentIndex,
//           items: items,
//            onTap: (index) => setState(() => currentIndex=index),
//       )
//       ));
//   }
// }
//
//
//
//
