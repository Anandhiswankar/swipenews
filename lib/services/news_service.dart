import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/news_model.dart';

class NewsService {
  static List<NewsModel> _newsArticles = [];
  static bool _isLoaded = false;

  // Load news from local JSON file
  static Future<List<NewsModel>> loadNews() async {
    if (_isLoaded) {
      return _newsArticles;
    }

    try {
      final String response = await rootBundle.loadString(
        'asset/json/news.json',
      );
      final data = await json.decode(response);
      final newsResponse = NewsResponse.fromJson(data);
      _newsArticles = newsResponse.articles;
      _isLoaded = true;
      return _newsArticles;
    } catch (e) {
      print('Error loading news: $e');
      return [];
    }
  }

  // Get all news articles
  static Future<List<NewsModel>> getAllNews() async {
    if (!_isLoaded) {
      await loadNews();
    }
    return _newsArticles;
  }

  // Get news by ID
  static Future<NewsModel?> getNewsById(String id) async {
    if (!_isLoaded) {
      await loadNews();
    }
    try {
      return _newsArticles.firstWhere((news) => news.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get news by source
  static Future<List<NewsModel>> getNewsBySource(String sourceName) async {
    if (!_isLoaded) {
      await loadNews();
    }
    return _newsArticles
        .where((news) => news.source.name == sourceName)
        .toList();
  }

  // Search news by title or description
  static Future<List<NewsModel>> searchNews(String query) async {
    if (!_isLoaded) {
      await loadNews();
    }
    final lowercaseQuery = query.toLowerCase();
    return _newsArticles.where((news) {
      return news.title.toLowerCase().contains(lowercaseQuery) ||
          news.description.toLowerCase().contains(lowercaseQuery) ||
          news.source.name.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get total count of news articles
  static Future<int> getTotalNewsCount() async {
    if (!_isLoaded) {
      await loadNews();
    }
    return _newsArticles.length;
  }

  // Refresh news data
  static Future<void> refreshNews() async {
    _isLoaded = false;
    _newsArticles.clear();
    await loadNews();
  }
}
