

import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPrefernces{

  static SharedPreferences? preferences;
   static init()async{
    preferences= await SharedPreferences.getInstance();
   }

   static Future setLogin(bool Status)async {
     await preferences!.setBool('Login', Status);
   }
   static bool? getLogin(){
     return preferences!.getBool('Login');
   }
  static Future setLoginToken(String token){
    return preferences!.setString("login_token",token);
  }
  static  getLoginToken(){
    return preferences!.getString("login_token");
  }
  static Future setUserId(String userid){
    return preferences!.setString("userid",userid);
  }
  static  getUserId(){
    return preferences!.getString("userid");
  }
   static Future setUserName(username)async{
     await preferences!.setString("username", username);
   }
   static  getUserName(){
     return preferences!.getString("username");
   }

   static Future setUserEmail(email)async{
     await preferences!.setString("email", email);
   }
   static getUserEmail(){
     return preferences!.getString("email");
   }

   static Future setUserPassword(password)async{
     await preferences!.setString("password", password);
   }
   static getUserPassword(){
     return preferences!.getString("password");
   }
  static Future  setUserPhone(phone) async
  {
    await preferences!.setString("phone", phone);
  }

  static String? getUserPhone()
  {
    return preferences!.getString("phone");
  }

  static Future  setuserlocation(current_loc) async
  {
    await preferences!.setString("current_loc", current_loc);
  }

  static String? getuserlocation()
  {
    return preferences!.getString("current_loc");
  }

  static Future logout() async
  {
     await preferences!.clear();

  }


}