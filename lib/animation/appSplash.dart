

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/model/sharedpre/userSharedPrefernces.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:flutter/material.dart';


class AppSplash extends StatefulWidget {
  const AppSplash({super.key});
  @override
  State<AppSplash> createState() => AppSplashState();
}

class AppSplashState extends State<AppSplash> {
  @override
  void initState() {
    UserSharedPrefernces.init();

    Future.delayed(Duration(seconds: 6),(){
      Navigator.pop(context);
       if(UserSharedPrefernces.getLogin() ?? false)
         {
           Navigator.pushNamed(context, '/userHomeNav');
         //  Navigator.push(context, MaterialPageRoute(builder: (context)=>UserHomeNav()));
         return;
         }
           Navigator.pushNamed(context, '/userSignin');
     // Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomeScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor:ColorConverter.stringToHex(AppStrings.bg_color),
      body: Stack(
    children: [

      Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
         child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(100),
            child: SizedBox(
                child:Image.asset("assets/images/app_logo.png"),

          )),

          // Container(
          //
          //     child:  AnimatedTextKit(
          //       animatedTexts: [
          //         TyperAnimatedText(
          //             'we are one tap away..',
          //             textStyle: const TextStyle(
          //                 fontSize: 13,color: Colors.white)),
          //       ],
          //       totalRepeatCount: 1,
          //       onTap: () { },
          //     )
          // )

    ])
    )
    ),
      Container(
        alignment: Alignment.bottomCenter,
        child: Text("Version 1.0.0(1)",style: TextStyle(color: Colors.white,fontSize: 10),),
      )
    ],
    )
    );
  }
}

// - Reachability
// - ReachabilitySwift

// - Reachability (3.7.6)
// - ReachabilitySwift (5.2.3)