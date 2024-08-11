
abstract class BookDataModel {
  String get authors;
  String get title;
  String get publishedDate;
  bool? get wasRead;
}

class BookData implements BookDataModel {
  @override
  final String authors;
  @override
  final String title;
  @override
  final String publishedDate;
  @override
  final bool? wasRead;

  BookData({
    required this.authors,
    required this.title,
    required this.publishedDate,
    this.wasRead,
  });

  @override
  String toString() {
    return 'Title: $title, Authors: $authors, Published Date: $publishedDate, Was Read: $wasRead';
  }

  BookData copyWith({
    String? title,
    String? authors,
    String? publishedDate,
    bool? wasRead,
  }) {
    return BookData(
      title: title ?? this.title,
      authors: authors ?? this.authors,
      publishedDate: publishedDate ?? this.publishedDate,
      wasRead: wasRead ?? this.wasRead,
    );
  }

  static bool? _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    } else if (value is String) {
      return value.toLowerCase() == 'true';
    } else if (value is int) {
      return value != 0;
    } else if (value == null) {
      return null;
    }
    return false;
  }

  factory BookData.fromJson(Map<String, dynamic> json) {
    String authors = '';

    if (json['authors'] is List) {
      authors = (json['authors'] as List<dynamic>).join(', ');
    } else if (json['authors'] is String) {
      authors = json['authors'] as String;
    } else {
      authors = 'Sem autores';
    }

    return BookData(
      authors: authors,
      title: json['title'] ?? 'Sem título',
      publishedDate: json['publishedDate'] ?? 'Sem data de publicação',
      wasRead: _parseBool(json['wasRead']),
    );
  }
}