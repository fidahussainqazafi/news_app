import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:news_app/View/categories_screen.dart';
import 'package:news_app/const/images.dart';
import 'package:news_app/model/news_chanel_headlines_model.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../model/category_news_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}
 enum FilterList {bbcNews, aryNews,cnn,algazera,router,independent}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel =  NewsViewModel();
  FilterList? selectedMenu;

  final format = DateFormat('MMM dd, YYY');
  String name = 'bbc-news';
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Categories_Screen()));
          },
          icon: Image.asset(im_Category),
        ),
        title: Text('News'),
        actions: [
          PopupMenuButton<FilterList>(
              initialValue: selectedMenu,
              onSelected: (FilterList item){
                if(FilterList.bbcNews.name == item.name){
                  name = 'bbc-news';
                }

                if(FilterList.aryNews.name == item.name){
                  name = 'ary-news';
                }
                if(FilterList.aryNews.name == item.name){
                  name = 'al-jazera-english';
                }

               setState(() {
                 selectedMenu = item;
               });
              },
              itemBuilder: (BuildContext context)=><PopupMenuEntry<FilterList>>[
            PopupMenuItem<FilterList>(
              value: FilterList.bbcNews,
              child: Text('BBC News'),

            ),

                PopupMenuItem<FilterList>(
                  value: FilterList.aryNews,
                  child: Text('ARY News'),

                ),
                PopupMenuItem<FilterList>(
                  value: FilterList.algazera,
                  child: Text('Aljazera News'),

                ),
          ])
        ],
      ),
      body: ListView(

        children: [
          SizedBox(height: 9.h),
          Container(


            height: 600.h,
           // color: Colors.green,
            child: FutureBuilder<NewsHeadlines>(
              future: newsViewModel.fetchNewsChannelHeadlinesApi(''),
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
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index)
                      
                  {
                    DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                    return SizedBox(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width:400,
                            height: 500,

                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: CachedNetworkImage(
                                  imageUrl:snapshot.data!.articles![index].urlToImage.toString(),
                                  fit: BoxFit.cover,
                                  placeholder : (context, url) => Container(child: spinkit2,),
                                  errorWidget: (context,url,error)=> Icon(Icons.error_outline,color: Colors.red,)
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom:20,
                            child: Card(
                              elevation:5,
                              color:Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  height:150,
                                  width:250,


                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Text(snapshot.data!.articles![index].title.toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,

                                            style:TextStyle(
                                          fontSize: 17,fontWeight: FontWeight.w700
                                        )
                                        ),
                                      ),
                                      Spacer(),
                                      Container(

                                        child: Row(
                                        mainAxisAlignment:MainAxisAlignment.spaceBetween,

                                          children: [
                                            Text(snapshot.data!.articles![index].source!.name.toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,

                                                style:TextStyle(
                                                    fontSize: 13,fontWeight: FontWeight.w600
                                                )
                                            ),
                                            Text(format.format(dateTime),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,

                                                style:TextStyle(
                                                    fontSize: 12,fontWeight: FontWeight.w500
                                                )
                                            ),

                                          ],
                                        ),
                                      )

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );

                  });
                }

              },
            ),
          ),
          FutureBuilder<CategoriesNewsHeadline>(
            future: newsViewModel.fetchCategoriesApi('Genral'),
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
                  shrinkWrap: true,
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

        ],

      ),
    );
  }

}
const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
