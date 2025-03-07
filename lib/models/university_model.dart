class University {
  final String name;
  final String? domain;
  final String? webPage;
  final String country;

  University({
    required this.name,
    this.domain,
    this.webPage,
    required this.country,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    String? sanitizeUrl(String? url) {
      if (url == null) return null;
      if (url.startsWith('http')) return url;
      return 'http://$url';
    }

    return University(
      name: json['name'] ?? 'Sin nombre',
      domain: json['domains']?.isNotEmpty == true ? json['domains'][0] : null,
      webPage:
          json['web_pages']?.isNotEmpty == true
              ? sanitizeUrl(json['web_pages'][0])
              : null,
      country: json['country'] ?? 'País desconocido',
    );
  }
}
