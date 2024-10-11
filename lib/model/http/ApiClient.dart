
import 'dart:convert';

import 'package:carwash/Model/Helper/CategoriesHelper.dart';
import 'package:carwash/Model/api/ApiStrings.dart';
import 'package:carwash/model/Helper/OffersHelper.dart';
import 'package:http/http.dart' as http;




class ApiClient {

  Future<http.Response> signupUser(Map<String, dynamic>? userData) async {
      http.Response response = await http.post(
          Uri.parse(ApiStrings.api_host+ApiStrings.reg_url),
        body: userData,);
      print(ApiStrings.api_host+ApiStrings.reg_url);
      print("Anu"+userData.toString());
     return response;
  }

  Future<http.Response> signInUser(Map<String, dynamic>? userData) async {
    http.Response response = await http.post(
      Uri.parse(ApiStrings.api_host+ApiStrings.login_url),
      body: userData,);
    print(ApiStrings.api_host+ApiStrings.login_url);
    print("pagal"+userData.toString());
    return response;
  }


  Future<List<OffersHelper>> getOffers() async {
    List<OffersHelper> offers = [];
    http.Response response = await http.get(
         Uri.parse(ApiStrings.api_host+ApiStrings.slider));
      List<dynamic> jsonData = json.decode(response.body);
            offers =   jsonData.map((data) => OffersHelper.fromJson(data)).toList();
      return offers;
  }

  Future<List<Categories>> getCategories() async {
    List<Categories> catData = [];
    http.Response response = await http.get(
      Uri.parse(ApiStrings.api_host+ApiStrings.category),);
     List<dynamic> jsonData = json.decode(response.body);
    catData =   jsonData.map((data) => Categories.fromJson(data)).toList();
       // print(categories[0].categoryName);
   // print(jsonData);
    return catData;

  }






}