
import 'dart:io';
import 'package:carwash/animation/appSplash.dart';
import 'package:carwash/booking/userBooking.dart';
import 'package:carwash/booking/userSelectDate.dart';
import 'package:carwash/booking/userbooking_status.dart';
import 'package:carwash/forgotpassword/phCpsswrd.dart';
import 'package:carwash/forgotpassword/signVerifyOtp.dart';
import 'package:carwash/forgotpassword/verify_phnoOtp.dart';
import 'package:carwash/forgotpassword/send_phnoOtp.dart';
import 'package:carwash/forgotpassword/sendOtp.dart';
import 'package:carwash/forgotpassword/verfiyOtp.dart';
import 'package:carwash/model/locationapi/MapAddress.dart';
import 'package:carwash/network/dependency_injection.dart';
import 'package:carwash/services/UserServiceDetail.dart';
import 'package:carwash/services/userServices.dart';
import 'package:carwash/userHome/body/UserChangepswrd.dart';
import 'package:carwash/userHome/body/userProfile.dart';
import 'package:carwash/userHome/body/userProfiledetail.dart';
import 'package:carwash/userHome/main.dart';
import 'package:carwash/userVechile/UserSelectVechile.dart';
import 'package:carwash/userlogin/userSignin.dart';
import 'package:carwash/userlogin/userSignup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:path/path.dart';
import 'booking/userbooking_view.dart';


Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(
      GetMaterialApp(
      title: 'Shine Zilla',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/' : (context) => AppSplash(),

      //  '/userWelcome'       :(context) => WelcomeScreen(),
        '/userHomeNav'       :(context) => UserHomeNav(),
        '/userSignin'        :(context) => UserSignin(),
        '/userSignup'        :(context) => UserSignup(),
        '/userSendOtp'       :(context) => SendOtp(),
        '/userVerifyOtp'     :(context) => VerifyOtp(),
        '/userRegphnNo'      :(context) => RegphnNo(),
        '/phVerifyOtp'       :(context) => PhNoOtp(),
        '/phnPassword'       :(context) => Phnpsswrd(),
        '/SigninVerify_Otp'   :(context) => SigninVerifyOtp(),
        '/locationAccess'    :(context) => LocationAccess(),
        '/UserSelectVechile' :(context) => UserSelectVechile(),
        '/userServices'      :(context) => UserServices(),
        '/userServiceDetail' :(context) => UserServiceDetail(),
        '/UserSelectDate'    :(context) => UserSelectDate(),
        '/UserBooking'       :(context) => UserBooking(),
        '/userProfile'       :(context) => UserProfile(),
        '/UserProfileDetail' :(context) => UserProfileDetail(),
        '/UserChpsswrd'      :(context) => UserChpsswrd(),
        '/UserBookingStatus' :(context) => UserBookingStatus(),
        '/UserBookingView'   :(context) => UserBookingView(),

      },
    )
  );
  DependencyInjection.init();
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}



// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//     @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//          home: AppSplash(),
//     );
//   }
// }


//$(SRCROOT)/ifos/Runner/Runner-Bridging-Header.h

// flutter clean
// rm -Rf ios/Pods
// rm -Rf ios/.symlinks
// rm -Rf ios/Flutter/Flutter.framework
// rm -Rf ios/Flutter/Flutter.podspec
//arch -x86_64 pod install --repo-update;