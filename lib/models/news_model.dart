class NewsModel {
  final String id;
  final String title;
  final String description;
  final String content;
  final String url;
  final String image;
  final String publishedAt;
  final Source source;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.image,
    required this.publishedAt,
    required this.source,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      url: json['url'] ?? '',
      image: json['image'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      source: Source.fromJson(json['source'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'url': url,
      'image': image,
      'publishedAt': publishedAt,
      'source': source.toJson(),
    };
  }
}

class Source {
  final String id;
  final String name;
  final String url;

  Source({required this.id, required this.name, required this.url});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'url': url};
  }
}

class NewsResponse {
  final int totalArticles;
  final List<NewsModel> articles;

  NewsResponse({required this.totalArticles, required this.articles});

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return NewsResponse(
      totalArticles: json['totalArticles'] ?? 0,
      articles:
          (json['articles'] as List?)
              ?.map((article) => NewsModel.fromJson(article))
              .toList() ??
          [],
    );
  }
}
