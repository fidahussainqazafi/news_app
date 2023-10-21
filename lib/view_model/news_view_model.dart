
import 'package:news_app/model/category_news_model.dart';
import 'package:news_app/model/news_chanel_headlines_model.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsViewModel{
  final _rep = NewsRepository();

  Future<NewsHeadlines> fetchNewsChannelHeadlinesApi(String channelName)async{
    final response = await _rep.fetchNewsChannelHeadlinesApi(channelName);
    return response;

  }

  Future<CategoriesNewsHeadline> fetchCategoriesApi(String category)async{
    final response = await _rep.fetchCategoriesApi(category);
    return response;
  }
}

