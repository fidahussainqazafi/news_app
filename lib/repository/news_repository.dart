import 'dart:convert';

import 'package:http/http.dart'as http;
import 'package:news_app/model/category_news_model.dart';
import 'package:news_app/model/news_chanel_headlines_model.dart';

class NewsRepository{

  Future<NewsHeadlines> fetchNewsChannelHeadlinesApi(String channelName)async{
    String url = 'https://newsapi.org/v2/top-headlines?sources=${channelName}bbc-news&apiKey=0e6d621f4ca6469c928df61314aa8b92';

    final  response =await http.get(Uri.parse(url));

    if(response.statusCode ==200){
      final body = jsonDecode(response.body);
      return NewsHeadlines.fromJson(body);

    }throw Exception('Error');
  }

  Future<CategoriesNewsHeadline> fetchCategoriesApi(String category)async{
    String url = 'https://newsapi.org/v2/everything?q=${category}&apiKey=0e6d621f4ca6469c928df61314aa8b92';

    final  response =await http.get(Uri.parse(url));

    if(response.statusCode ==200){
      final body = jsonDecode(response.body);
      return CategoriesNewsHeadline.fromJson(body);

    }throw Exception('Error');
  }
}