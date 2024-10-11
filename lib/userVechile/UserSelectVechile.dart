
import 'dart:convert';
import 'package:carwash/CustomWidget/ColorConverter.dart';
import 'package:carwash/Model/api/ApiStrings.dart';
import 'package:carwash/model/Helper/addVechile.dart';
import 'package:carwash/model/Helper/brand_model.dart';
import 'package:carwash/model/Helper/brand_name.dart';
import 'package:carwash/model/Helper/categoriesServices.dart';
import 'package:carwash/model/sharedpre/userSharedPrefernces.dart';
import 'package:carwash/values/AppStrings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;


class UserSelectVechile extends StatefulWidget {
    @override
  State<UserSelectVechile> createState() => _UserSelectVechileState();
}

class _UserSelectVechileState extends State<UserSelectVechile> {

  Future<List<BrandName>>? brand;
  Future<List<BrandModel>>? model;
  Future<List<AddVechile>>? vechile;

  TextEditingController search_controller = TextEditingController();

  @override
  void initState() {
    brand = getBrandName();
  }
   String?  setBrandIcon;
  @override
  Widget build(BuildContext context) {
    UserSharedPrefernces.init();
    return Scaffold(
       backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('Select Vechile', style: GoogleFonts.alkalami(
              color: ColorConverter.stringToHex(AppStrings.bg_color),fontWeight: FontWeight.bold,fontSize: 17),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),

        ),

        body: SingleChildScrollView(
            child: Column(
                children: [
                  Container(
                   // color: Colors.black,
                    padding: EdgeInsets.only(top: 5,left: 25,right: 25),
                    child:  TextFormField(
                      textInputAction: TextInputAction.search,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (onChanged){},
                      controller: search_controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10.0)),
                          suffixIcon: IconButton(onPressed: (){
                            setState(() {
                              model = SearchBrandModel(search_controller.text);
                            });
                          }, icon: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                             border: Border(
                              left: BorderSide(
                              color: Colors.black,
                                  )) ),
                            child: Icon(Icons.search,size: 27,color: Colors.black,),
                          )),
                           label: Text('Search Brand , Model',style: TextStyle(
                            fontWeight: FontWeight.bold),),
                      ),
                      onFieldSubmitted: (onFieldSubmitted){
                        setState(() {
                          model = SearchBrandModel(search_controller.text);
                        });
                      },
                    ),

                     ),

                  Container(
                    padding: EdgeInsets.only(top: 20,left: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                       child: Text("Choose your Vehicle",style: GoogleFonts.alkalami(fontWeight: FontWeight.bold),),
                    ) ),
                  Container(
                   // padding: EdgeInsets.only(top: 10),
                    child: GridView.count(
                      padding: EdgeInsets.all(10),
                      shrinkWrap: true,
                      primary: false,
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.6,
                      children: [
                    GestureDetector(
                        child: Container(
                            decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                           // border: Border.all(width: 1,color: Colors.grey)
                            ),
                         child:                     //  elevation: 5,
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          Image.asset('assets/images/Rbg.png',
                            height: 80,),
                          // ),
                          Container(padding: EdgeInsets.only(left: 10,right: 10),
                             child: Center(child:Text('I have a CAR', softWrap: true,style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 12),textAlign: TextAlign.center,)))                                                  // child: ClipRRect(
                        ])),
                    onTap: (){},
                    ),
                        GestureDetector(
                          child:Container(
                           decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                             borderRadius: BorderRadius.circular(10),
                              //border: Border.all(width: 1,color: Colors.grey)
                           ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children:[
                                    Image.asset('assets/images/bike.png',height: 80,),
                                    // ),
                                    Container(
                                        child: Text('I have a BIKE', softWrap: true,style: TextStyle(fontWeight: FontWeight.bold,
                                            fontSize: 12),textAlign: TextAlign.center,))                                                  // child: ClipRRect(
                                  ])),
                          onTap: (){
                            String brand='Bike';
                            String model = 'Bike';
                            String user_id=UserSharedPrefernces.getUserId();
                            String type = '0';
                            fetchAddVechile(brand.toString(),user_id, model.toString(),type);
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(children: [
                        Padding(padding: EdgeInsets.only(left: 10),
                            child: Text('Trending Vehicles',
                                style: GoogleFonts.alkalami(fontWeight: FontWeight.bold,
                                    color: ColorConverter.stringToHex(AppStrings.bg_color)))),
                        Icon(Icons.trending_up),
                      ])),

              FutureBuilder(
                future: brand,
                builder: (context, snapshot) {
                 if (snapshot.connectionState == ConnectionState.waiting) {
                   return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                    } else if (snapshot.hasData) {
                     List<BrandName> items = snapshot.data!;
                      return Container(
                       // color: Colors.grey,
                        height: 120.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.all(8),
                       shrinkWrap: true,
                        //primary: false,
                        itemCount: items.length,
                        itemBuilder: (context, index,) {
                          return  GestureDetector(
                              child: SizedBox(
                                width: 80.0,
                              child: Card(
                                elevation: 5,
                                color: Colors.white,
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                               child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children:[
                                    Container(
                                      //  color: Colors.grey,
                                        child: Image.network(
                               ApiStrings.image_url+'/' + items[index].folder.toString() + '/' +
                                               items[index].brandLogo.toString(),height: 40,width: double.infinity,)),
                             Container(
                               padding: EdgeInsets.only(top: 5),
                                child: Text(items[index].brandName.toString(),style: GoogleFonts.acme(color: Colors.black,
                               fontWeight: FontWeight.bold,fontSize: 12),textAlign: TextAlign.center,),
                                       )
                                     ],))),
                            onTap: (){
                              setState(() {

                                //  title =   ApiStrings.image_url+'/' + items[index].folder.toString() + '/' +
                                //     items[index].brandLogo.toString();

                                model = fetchBrandModel((items[index].id.toString()));
                                   });
                             // print(model);
                          },);
                        },
                      //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //   crossAxisCount: 4,
                      //   mainAxisSpacing: 5,
                      //   crossAxisSpacing: 1,
                      //    childAspectRatio: 5/7
                      // ),
                        ));
                } else {
                  return CircularProgressIndicator();
                   }
                }),

                  Container(
                      padding: EdgeInsets.only(left: 10,top: 15 ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Car List', style: GoogleFonts.alkalami(
                            fontWeight: FontWeight.bold, color: ColorConverter.stringToHex(AppStrings.bg_color)),),
                      )),
                  Divider(
                    color: ColorConverter.stringToHex(AppStrings.bg_color),
                    indent: 20,endIndent: 20,
                  ),

          FutureBuilder(
          future: model,
          builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
           return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
           return Center(child: Text('${snapshot.error}'));
           } else if (snapshot.hasData) {
           List<BrandModel> items = snapshot.data!;
            return ListView.builder(
           shrinkWrap: true,
           primary: false,
           //  physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
           itemBuilder: (context, index,) {
            return ListTile(
             title: Text(items[index].model.toString(),
                  style: GoogleFonts.acme(color: ColorConverter.stringToHex(AppStrings.bg_color)),),
             leading: CircleAvatar(
               radius: 20,
                 child: Image.network(ApiStrings.image_url+'/' + items[index].folder.toString() + '/' +
                 items[index].brand_logo.toString(),fit: BoxFit.fill,),backgroundColor: Colors.white,),

               onTap: () {
                String user_id = UserSharedPrefernces.getUserId();
                String type = '1';
            fetchAddVechile(items[index].brandId.toString(),user_id, items[index].modelId.toString(),type);
                   },
               onLongPress: () {},
                 );
               });
              } else {
              return  Container(
                padding: EdgeInsets.all(20),
                  child: Text('Please select the trending vechile ',style: GoogleFonts.abel()));
               }
             }),

           ]))
    );
  }


  Future<List<BrandModel>> SearchBrandModel(brand_model) async {
    List<BrandModel> brandmodel = [];

    http.Response response = await http.post(
        Uri.parse(ApiStrings.api_host+ApiStrings.brand_model_search),
        body: {
          "brand_model":brand_model
        }
    );
    // print('Rajput :'+ApiStrings.base_url+ApiStrings.brandmodel);
    List<dynamic> jsonData = json.decode(response.body);
    print('Dhanola :'+response.body);
    brandmodel = jsonData.map((data) => BrandModel.fromJson(data)).toList();
    // print(jsonData);
    return brandmodel;
  }


  Future<List<BrandName>> getBrandName() async {
    List<BrandName> BrandData = [];
    http.Response response = await http.post(
      Uri.parse(ApiStrings.api_host+ApiStrings.branddetail));
     List<dynamic> jsonData = json.decode(response.body);
    BrandData = jsonData.map((data) => BrandName.fromJson(data)).toList();
       return BrandData;
  }

  Future<List<BrandModel>> fetchBrandModel(brand_id) async {
    List<BrandModel> brandmodel = [];
    http.Response response = await http.post(
        Uri.parse(ApiStrings.api_host+ApiStrings.brandmodel),
    body: {
          "brand_id":brand_id
    }
    );
   // print('Rajput :'+ApiStrings.base_url+ApiStrings.brandmodel);
    List<dynamic> jsonData = json.decode(response.body);
    print('Dhanola :'+response.body);
    brandmodel=jsonData.map((data) => BrandModel.fromJson(data)).toList();
   // print(jsonData);
     return brandmodel;
  }


   fetchAddVechile(brand_id,user_id,model_id,type) async {
     print(brand_id + " " + user_id + " " + model_id + " " + type);
     http.Response response = await http.post(
         Uri.parse(ApiStrings.api_host + ApiStrings.addVechile),
         body: {
           "brand_id": brand_id,
           "user_id": user_id,
           "model_id": model_id,
           "type": type
         }
     );
     if (response.statusCode == 200) {
       var data = jsonDecode(response.body);

       if(data["success"]==1) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["message"]) ));

         if(data["type"]=='0') {
           Navigator.pushNamed(context, '/userServices', arguments: {
             "id": 2,
             "category_name": 'Bike services',

           });
         }
         else
           {
             Navigator.pushNamed(context, '/userServices', arguments: {
               "id": 0,
               "category_name": 'All services'
             });
           }
       }
       else
         {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["message"]) ));
         }

     }
     else{
       print('something went wrong !');
     }
   }


   //bikeServices


}

