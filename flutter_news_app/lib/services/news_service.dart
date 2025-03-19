import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_news_app/models/article.dart';
import 'package:flutter_news_app/utils/constants.dart';

class NewsService {
  Future<List<Article>> getTopHeadlines() async {
    final url = Uri.parse(
        '${Constants.baseUrl}${Constants.topHeadlinesEndpoint}?country=${Constants.country}&apiKey=${Constants.apiKey}');

    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'ok') {
          final articles = data['articles'] as List;
          return articles.map((article) => Article.fromJson(article)).toList();
        } else {
          throw Exception('Failed to load news: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }
  
  Future<List<Article>> searchNews(String query) async {
    final url = Uri.parse(
        '${Constants.baseUrl}${Constants.topHeadlinesEndpoint}?q=$query&country=${Constants.country}&apiKey=${Constants.apiKey}');

    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'ok') {
          final articles = data['articles'] as List;
          return articles.map((article) => Article.fromJson(article)).toList();
        } else {
          throw Exception('Failed to load news: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }
}