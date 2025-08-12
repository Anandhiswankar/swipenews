import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_model.dart';

class StorageService {
  static const String _likedNewsKey = 'liked_news';
  static const String _dislikedNewsKey = 'disliked_news';
  static const String _neutralNewsKey = 'neutral_news';

  // Get news data from storage
  static Future<Map<String, dynamic>> _getNewsData() async {
    final prefs = await SharedPreferences.getInstance();
    final newsDataString = prefs.getString('news_data');

    if (newsDataString == null) return {};

    try {
      return jsonDecode(newsDataString);
    } catch (e) {
      print('Error parsing news data: $e');
      return {};
    }
  }

  // Save liked news
  static Future<void> saveLikedNews(NewsModel news) async {
    final prefs = await SharedPreferences.getInstance();
    final likedNews = await getLikedNewsIds();
    if (!likedNews.contains(news.id)) {
      likedNews.add(news.id);
      await prefs.setStringList(_likedNewsKey, likedNews);

      // Store the full news object
      final newsData = await _getNewsData();
      newsData[news.id] = news.toJson();
      await prefs.setString('news_data', jsonEncode(newsData));
    }
  }

  // Save disliked news
  static Future<void> saveDislikedNews(NewsModel news) async {
    final prefs = await SharedPreferences.getInstance();
    final dislikedNews = await getDislikedNewsIds();
    if (!dislikedNews.contains(news.id)) {
      dislikedNews.add(news.id);
      await prefs.setStringList(_dislikedNewsKey, dislikedNews);

      // Store the full news object
      final newsData = await _getNewsData();
      newsData[news.id] = news.toJson();
      await prefs.setString('news_data', jsonEncode(newsData));
    }
  }

  // Save neutral news
  static Future<void> saveNeutralNews(NewsModel news) async {
    final prefs = await SharedPreferences.getInstance();
    final neutralNews = await getNeutralNewsIds();
    if (!neutralNews.contains(news.id)) {
      neutralNews.add(news.id);
      await prefs.setStringList(_neutralNewsKey, neutralNews);

      // Store the full news object
      final newsData = await _getNewsData();
      newsData[news.id] = news.toJson();
      await prefs.setString('news_data', jsonEncode(newsData));
    }
  }

  // Remove news from all categories
  static Future<void> removeNewsFromAllCategories(String newsId) async {
    final prefs = await SharedPreferences.getInstance();

    // Remove from liked
    final likedNews = await getLikedNewsIds();
    likedNews.remove(newsId);
    await prefs.setStringList(_likedNewsKey, likedNews);

    // Remove from disliked
    final dislikedNews = await getDislikedNewsIds();
    dislikedNews.remove(newsId);
    await prefs.setStringList(_dislikedNewsKey, dislikedNews);

    // Remove from neutral
    final neutralNews = await getNeutralNewsIds();
    neutralNews.remove(newsId);
    await prefs.setStringList(_neutralNewsKey, neutralNews);
  }

  // Get user preference for a specific news
  static Future<String> getUserPreference(String newsId) async {
    final likedNews = await getLikedNewsIds();
    final dislikedNews = await getDislikedNewsIds();
    final neutralNews = await getNeutralNewsIds();

    if (likedNews.contains(newsId)) {
      return 'liked';
    } else if (dislikedNews.contains(newsId)) {
      return 'disliked';
    } else if (neutralNews.contains(newsId)) {
      return 'neutral';
    } else {
      return 'none';
    }
  }

  // Get liked news IDs
  static Future<List<String>> getLikedNewsIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_likedNewsKey) ?? [];
  }

  // Get disliked news IDs
  static Future<List<String>> getDislikedNewsIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_dislikedNewsKey) ?? [];
  }

  // Get neutral news IDs
  static Future<List<String>> getNeutralNewsIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_neutralNewsKey) ?? [];
  }

  // Get all stored news objects
  static Future<List<NewsModel>> getAllStoredNews() async {
    final prefs = await SharedPreferences.getInstance();
    final newsDataString = prefs.getString('news_data');

    if (newsDataString == null) return [];

    try {
      final Map<String, dynamic> newsData = jsonDecode(newsDataString);
      final List<NewsModel> newsList = [];

      for (final entry in newsData.entries) {
        try {
          final news = NewsModel.fromJson(entry.value);
          newsList.add(news);
        } catch (e) {
          print('Error parsing news: $e');
        }
      }

      return newsList;
    } catch (e) {
      print('Error parsing news data: $e');
      return [];
    }
  }

  // Check if news is liked
  static Future<bool> isNewsLiked(String newsId) async {
    final likedNews = await getLikedNewsIds();
    return likedNews.contains(newsId);
  }

  // Check if news is disliked
  static Future<bool> isNewsDisliked(String newsId) async {
    final dislikedNews = await getDislikedNewsIds();
    return dislikedNews.contains(newsId);
  }

  // Check if news is neutral
  static Future<bool> isNewsNeutral(String newsId) async {
    final neutralNews = await getNeutralNewsIds();
    return neutralNews.contains(newsId);
  }
}
