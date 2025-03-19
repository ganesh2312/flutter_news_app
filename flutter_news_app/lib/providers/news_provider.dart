import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/article.dart';
import 'package:flutter_news_app/services/news_service.dart';

class NewsProvider extends ChangeNotifier {
  final NewsService _service = NewsService();
  List<Article> _articles = [];
  String _error = '';
  bool _isLoading = false;
  bool _isDark = false;

  List<Article> get articles => _articles;
  String get error => _error;
  bool get isLoading => _isLoading;
  bool get isDark => _isDark;

  Future<void> fetchTopHeadlines() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _articles = await _service.getTopHeadlines();
      _error = '';
    } catch (e) {
      _error = e.toString();
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchNews(String query) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _articles = await _service.searchNews(query);
      _error = '';
    } catch (e) {
      _error = e.toString();
    }
    
    _isLoading = false;
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDark = !_isDark;
    notifyListeners();
  }
}