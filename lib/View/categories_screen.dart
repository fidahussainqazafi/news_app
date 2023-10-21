
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:news_app/model/category_news_model.dart';

import '../view_model/news_view_model.dart';

class Categories_Screen extends StatefulWidget {
  const Categories_Screen({Key? key}) : super(key: key);

  @override
  State<Categories_Screen> createState() => _Categories_ScreenState();
}

class _Categories_ScreenState extends State<Categories_Screen> {

  NewsViewModel newsViewModel =  NewsViewModel();
  final format = DateFormat('MMM dd, YYY');
  String categoryName = 'genral';
  List<String> categoriesList = [
    'Genral',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
        child: Column(
          children: [
            SizedBox(height: 50.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      categoryName = categoriesList[index];
                      setState(() {

                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: categoryName == categoriesList[index]? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 9.0),
                          child: Center(child: Text(categoriesList[index].toString(),style: TextStyle(
                            color: Colors.white,fontSize: 13,fontWeight: FontWeight.w700
                          ),)),
                        ),
                      ),
                    ),
                  );

            }),
            ),
            Expanded(
              child: FutureBuilder<CategoriesNewsHeadline>(
                future: newsViewModel.fetchCategoriesApi(categoryName),
                builder: (BuildContext context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){

                    return Center(
                      child: SpinKitCircle(
                        color: Colors.blue,
                        size: 50,
                      ),
                    );
                  } else{
                    return ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context,index)

                        {
                          DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 9),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: CachedNetworkImage(
                                      imageUrl:snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      height: height * .48,
                                      width: width * .3,
                                      placeholder : (context, url) => Container(child: Center(
                                        child: SpinKitCircle(
                                          color: Colors.blue,
                                          size: 50,
                                        ),
                                      )),
                                      errorWidget: (context,url,error)=> Icon(Icons.error_outline,color: Colors.red,)
                                  ),
                                ),
                                Expanded(child: Container(
                                  height: height * .48,
                                  padding: EdgeInsets.only(left: 9),
                                  child: Column(
                                    children: [
                                      Text( snapshot.data!.articles![index].source!.name.toString(),
                                        style: TextStyle(

                                        color: Colors.black54,fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                        Text( format.format(dateTime),
                                          style: TextStyle(

                                            color: Colors.black54,fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                          ),),

                                      ],)

                                    ],
                                  ),
                                ))
                              ],
                            ),
                          );
                        });
                  }

                },
              ),
            ),

          ],
        ),
      ),
    );

  }
}
