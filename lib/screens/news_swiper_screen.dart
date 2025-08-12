import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';
import '../widgets/news_card.dart';
import '../config/app_config.dart';
import 'web_view_screen.dart';

class NewsSwiperScreen extends StatefulWidget {
  const NewsSwiperScreen({Key? key}) : super(key: key);

  @override
  State<NewsSwiperScreen> createState() => _NewsSwiperScreenState();
}

class _NewsSwiperScreenState extends State<NewsSwiperScreen>
    with TickerProviderStateMixin {
  List<NewsModel> _newsArticles = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  late AnimationController _fadeController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: AppConfig.splashAnimationDuration,
      vsync: this,
    );
    _pageController = PageController();
    _loadNews();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadNews() async {
    try {
      final news = await NewsService.getAllNews();
      setState(() {
        _newsArticles = news;
        _isLoading = false;
      });
      _fadeController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppConfig.loadingErrorMessage}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onCardTap(NewsModel news) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(url: news.url, title: news.title),
      ),
    );
  }

  void _onLike(NewsModel news) {
    // Handle like action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppConfig.likeSuccessMessage}: ${news.title}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onDislike(NewsModel news) {
    // Handle dislike action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppConfig.dislikeSuccessMessage}: ${news.title}'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onNeutral(NewsModel news) {
    // Handle neutral action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppConfig.neutralSuccessMessage}: ${news.title}'),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _goToNext() {
    if (_currentIndex < _newsArticles.length - 1) {
      _pageController.nextPage(
        duration: AppConfig.pageTransitionDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: AppConfig.pageTransitionDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.blue.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.newspaper,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConfig.appName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Swipe up for next, down for previous',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Horizontal Swipe Indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.blue.shade400.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.swap_horiz,
                          color: Colors.blue.shade400,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Swipe Left/Right',
                          style: TextStyle(
                            color: Colors.blue.shade400,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Swiper Section
            Expanded(
              child:
                  _isLoading
                      ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Loading news...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                      : _newsArticles.isEmpty
                      ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.white,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No news available',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                      : FadeTransition(
                        opacity: _fadeController,
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: _onPageChanged,
                          scrollDirection:
                              Axis.vertical, // Vertical scrolling like Reels/Shorts
                          itemCount: _newsArticles.length,
                          itemBuilder: (context, index) {
                            final news = _newsArticles[index];
                            return NewsCard(
                              news: news,
                              onTap: () => _onCardTap(news),
                              onLike: () => _onLike(news),
                              onDislike: () => _onDislike(news),
                              onNeutral: () => _onNeutral(news),
                            );
                          },
                        ),
                      ),
            ),

            // Navigation Controls
            if (!_isLoading && _newsArticles.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavigationButton(
                      icon: Icons.keyboard_arrow_up,
                      label: 'Previous',
                      onTap: _goToPrevious,
                      color: Colors.orange,
                      isEnabled: _currentIndex > 0,
                    ),
                    _buildNavigationButton(
                      icon: Icons.refresh,
                      label: 'Refresh',
                      onTap: _loadNews,
                      color: Colors.blue,
                      isEnabled: true,
                    ),
                    _buildNavigationButton(
                      icon: Icons.keyboard_arrow_down,
                      label: 'Next',
                      onTap: _goToNext,
                      color: Colors.green,
                      isEnabled: _currentIndex < _newsArticles.length - 1,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    required bool isEnabled,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(isEnabled ? 0.1 : 0.05),
            borderRadius: BorderRadius.circular(AppConfig.buttonBorderRadius),
            border: Border.all(
              color: color.withOpacity(isEnabled ? 0.3 : 0.1),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color.withOpacity(isEnabled ? 1.0 : 0.5),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color.withOpacity(isEnabled ? 1.0 : 0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
