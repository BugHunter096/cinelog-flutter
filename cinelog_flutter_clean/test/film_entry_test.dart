import 'package:cinelog_flutter/models/film_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FilmEntry serializes and deserializes correctly', () {
    final entry = FilmEntry(
      id: '1',
      title: 'Interstellar',
      year: 2014,
      genre: 'Sci-Fi',
      platform: 'Blu-ray',
      type: FilmType.movie,
      rating: 5,
      isWatched: true,
      notes: 'Great soundtrack.',
    );

    final decoded = FilmEntry.fromJson(entry.toJson());

    expect(decoded.id, entry.id);
    expect(decoded.title, entry.title);
    expect(decoded.year, entry.year);
    expect(decoded.genre, entry.genre);
    expect(decoded.platform, entry.platform);
    expect(decoded.type, entry.type);
    expect(decoded.rating, entry.rating);
    expect(decoded.isWatched, entry.isWatched);
    expect(decoded.notes, entry.notes);
  });
}
