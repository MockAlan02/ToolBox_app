class WordPressPost {
  final String title;
  final String excerpt;
  final String link;
  final DateTime date;
  final String? featuredImage;

  WordPressPost({
    required this.title,
    required this.excerpt,
    required this.link,
    required this.date,
    this.featuredImage,
  });

  factory WordPressPost.fromJson(Map<String, dynamic> json) {
    return WordPressPost(
      title: json['title']['rendered'] ?? 'Sin título',
      excerpt: _parseExcerpt(json['excerpt']['rendered']),
      link: json['link'] ?? '',
      date: DateTime.parse(json['date']),
      featuredImage: json['_embedded']?['wp:featuredmedia']?[0]?['source_url'],
    );
  }

  static String _parseExcerpt(String htmlExcerpt) {
    return htmlExcerpt
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }
}
