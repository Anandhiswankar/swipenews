import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/news_model.dart';
import '../services/storage_service.dart';
import '../config/app_config.dart';

class NewsCard extends StatefulWidget {
  final NewsModel news;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onDislike;
  final VoidCallback? onNeutral;

  const NewsCard({
    Key? key,
    required this.news,
    this.onTap,
    this.onLike,
    this.onDislike,
    this.onNeutral,
  }) : super(key: key);

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> with TickerProviderStateMixin {
  String _currentPreference = 'none';
  late AnimationController _likeController;
  late AnimationController _dislikeController;
  late AnimationController _neutralController;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      duration: AppConfig.cardAnimationDuration,
      vsync: this,
    );
    _dislikeController = AnimationController(
      duration: AppConfig.cardAnimationDuration,
      vsync: this,
    );
    _neutralController = AnimationController(
      duration: AppConfig.cardAnimationDuration,
      vsync: this,
    );
    _loadUserPreference();
  }

  @override
  void dispose() {
    _likeController.dispose();
    _dislikeController.dispose();
    _neutralController.dispose();
    super.dispose();
  }

  Future<void> _loadUserPreference() async {
    final preference = await StorageService.getUserPreference(widget.news.id);
    setState(() {
      _currentPreference = preference;
    });
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return '${difference.inMinutes}m ago';
        }
        return '${difference.inHours}h ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return DateFormat('MMM dd').format(date);
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.black),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: widget.news.image,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      color: Colors.grey.shade900,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: Colors.grey.shade900,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
              ),
            ),

            // Gradient Overlay for better text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.9),
                    ],
                    stops: const [0.0, 0.4, 0.7, 1.0],
                  ),
                ),
              ),
            ),

            // Content Section
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Source and Time
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade600,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.news.source.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _formatDate(widget.news.publishedAt),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Title
                    Text(
                      widget.news.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        color: Colors.white,
                      ),
                      maxLines: AppConfig.maxTitleLines,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Description
                    Text(
                      widget.news.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade200,
                        height: 1.4,
                      ),
                      maxLines: AppConfig.maxDescriptionLines,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.thumb_down,
                          label: 'Dislike',
                          isActive: _currentPreference == 'disliked',
                          onTap: () {
                            _handleDislike();
                            widget.onDislike?.call();
                          },
                          controller: _dislikeController,
                          color: Colors.red,
                        ),

                        _buildActionButton(
                          icon: Icons.remove_circle_outline,
                          label: 'Neutral',
                          isActive: _currentPreference == 'neutral',
                          onTap: () {
                            _handleNeutral();
                            widget.onNeutral?.call();
                          },
                          controller: _neutralController,
                          color: Colors.orange,
                        ),

                        _buildActionButton(
                          icon: Icons.thumb_up,
                          label: 'Like',
                          isActive: _currentPreference == 'liked',
                          onTap: () {
                            _handleLike();
                            widget.onLike?.call();
                          },
                          controller: _likeController,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Swipe Indicator
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Swipe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required AnimationController controller,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (controller.value * 0.2),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color:
                    isActive
                        ? color.withOpacity(0.8)
                        : Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(
                  AppConfig.buttonBorderRadius,
                ),
                border: Border.all(
                  color: isActive ? color : Colors.white.withOpacity(0.3),
                  width: isActive ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: isActive ? Colors.white : Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleLike() async {
    _likeController.forward().then((_) => _likeController.reverse());
    await StorageService.removeNewsFromAllCategories(widget.news.id);
    await StorageService.saveLikedNews(widget.news);
    setState(() {
      _currentPreference = 'liked';
    });
  }

  void _handleDislike() async {
    _dislikeController.forward().then((_) => _dislikeController.reverse());
    await StorageService.removeNewsFromAllCategories(widget.news.id);
    await StorageService.saveDislikedNews(widget.news);
    setState(() {
      _currentPreference = 'disliked';
    });
  }

  void _handleNeutral() async {
    _neutralController.forward().then((_) => _neutralController.reverse());
    await StorageService.removeNewsFromAllCategories(widget.news.id);
    await StorageService.saveNeutralNews(widget.news);
    setState(() {
      _currentPreference = 'neutral';
    });
  }
}
