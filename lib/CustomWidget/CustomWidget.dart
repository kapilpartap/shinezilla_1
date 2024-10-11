

import 'package:carousel_slider/carousel_slider.dart';
import 'package:carwash/Model/Helper/CategoriesHelper.dart';
import 'package:carwash/Model/api/ApiStrings.dart';
import 'package:carwash/model/Helper/OffersHelper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomWidget
{

 static showSnackbar(BuildContext context,String message)
  {
     var snackBar = SnackBar(
      content: Text(message!),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  static FutureBuilder<List<OffersHelper>> getSlider(Future<List<OffersHelper>>? offers,BuildContext context)
  {
    return FutureBuilder<List<OffersHelper>>(
        future: offers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text(''));
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<OffersHelper> items = snapshot.data!;
            Size size = MediaQuery.of(context).size;
            return CarouselSlider.builder(
              itemBuilder: (context, index, realIndex) {
                return Card(
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.circular(8.0),
                      child: Image.network(
                        ApiStrings.image_url +'/' +items[index].folder.toString()+'/'+items[index].sliderImage.toString(),
                        fit: BoxFit.fill,
                      ),
                    ));
              },
              options: CarouselOptions(
                  autoPlayAnimationDuration:
                  const Duration(
                      milliseconds: 1000),
                  initialPage: 0,
                  autoPlay: true,
                  disableCenter: true,
                  enlargeCenterPage: true,
                  // Increase the size of the center item
                  //enableInfiniteScroll: true,
                  height: 180),
              itemCount: items.length,
            );
          }else{
            return Container(
              height: 150,
              child:Center(
                child: Text(''),
              ) ,
            );
          }
        }
    );
  }

 static FutureBuilder<List<Categories>> getCategories(Future<List<Categories>>? categories)
 {
   return FutureBuilder<List<Categories>>(
       future: categories,
       builder: (context, snapshot) {
         if (snapshot.connectionState == ConnectionState.waiting) {
           return Center(child: Container(child: Text(""),));
         } else if (snapshot.hasError) {
           return Center(child: CircularProgressIndicator());
         } else if (snapshot.hasData) {
           List<Categories> items = snapshot.data!;
           return GridView.builder(
            // padding: EdgeInsets.only(top: 10,bottom: 10,left: 15,right: 15),
               shrinkWrap: true,
              primary: false,
              // physics: NeverScrollableScrollPhysics(),
               itemCount: items.length,
               itemBuilder: (context, index,) {
                 return  GestureDetector(child:
                   Card(
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                     //color: Colors.grey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children:[
                       Image.network(
                            ApiStrings.image_url+'/'+items[index].folder.toString()+'/'+items[index].logo.toString(),
                               height: 80,    ),
                   Container(padding: EdgeInsets.only(left: 10,right: 10),
                       child: Center(child:Text(items[index].categoryName.toString(),softWrap: true,
                         style: GoogleFonts.acme(fontSize: 10,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)))                                                  // child: ClipRRect(
                    ])),onTap: (){

                   Navigator.pushNamed(context, '/userServices',
                   arguments: {
                     "id":items[index].id.toString(),
                     "category_name":items[index].categoryName.toString(),
                     "catfolder":items[index].folder.toString(),
                     "catimage":items[index].logo.toString(),

                   });
                   // Navigator.push(context, MaterialPageRoute(
                   //                       builder: (context)=>UserServices(
                   //                         id:items[index].id.toString(),category_name: items[index].categoryName.toString(),
                   //                         catfolder: items[index].folder.toString(),
                   //                         catimage: items[index].logo.toString())));
                 },);
               }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: 3,
             mainAxisSpacing: 1,
             crossAxisSpacing: 1,
            // childAspectRatio: 10/7
           ),
         );
        }
         else{
           return Container(
             child:Center(
               child: Text('Not Available'),
             ) ,
           );
         }
       });

 }
}

