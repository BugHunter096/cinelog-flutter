import 'dart:convert';

/// Represents one movie or series saved by the user.
class FilmEntry {
  FilmEntry({
    required this.id,
    required this.title,
    required this.year,
    required this.genre,
    required this.platform,
    required this.type,
    required this.rating,
    required this.isWatched,
    required this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  final String id;
  final String title;
  final int? year;
  final String genre;
  final String platform;
  final FilmType type;
  final int rating;
  final bool isWatched;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  FilmEntry copyWith({
    String? title,
    int? year,
    bool clearYear = false,
    String? genre,
    String? platform,
    FilmType? type,
    int? rating,
    bool? isWatched,
    String? notes,
  }) {
    return FilmEntry(
      id: id,
      title: title ?? this.title,
      year: clearYear ? null : year ?? this.year,
      genre: genre ?? this.genre,
      platform: platform ?? this.platform,
      type: type ?? this.type,
      rating: rating ?? this.rating,
      isWatched: isWatched ?? this.isWatched,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'genre': genre,
      'platform': platform,
      'type': type.name,
      'rating': rating,
      'isWatched': isWatched,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory FilmEntry.fromMap(Map<String, dynamic> map) {
    return FilmEntry(
      id: map['id'] as String,
      title: map['title'] as String,
      year: map['year'] as int?,
      genre: map['genre'] as String? ?? '',
      platform: map['platform'] as String? ?? '',
      type: FilmType.values.firstWhere(
        (value) => value.name == map['type'],
        orElse: () => FilmType.movie,
      ),
      rating: map['rating'] as int? ?? 0,
      isWatched: map['isWatched'] as bool? ?? false,
      notes: map['notes'] as String? ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory FilmEntry.fromJson(String source) {
    return FilmEntry.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }
}

enum FilmType {
  movie,
  series,
  documentary,
}

extension FilmTypeLabel on FilmType {
  String get label {
    switch (this) {
      case FilmType.movie:
        return 'Película';
      case FilmType.series:
        return 'Serie';
      case FilmType.documentary:
        return 'Documental';
    }
  }
}
