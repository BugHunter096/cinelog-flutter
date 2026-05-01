import 'package:shared_preferences/shared_preferences.dart';

import '../models/film_entry.dart';

class FilmStorageService {
  FilmStorageService({SharedPreferences? preferences}) : _preferences = preferences;

  static const String _storageKey = 'cinelog_entries';

  SharedPreferences? _preferences;

  Future<SharedPreferences> get _prefs async {
    return _preferences ??= await SharedPreferences.getInstance();
  }

  Future<List<FilmEntry>> loadEntries() async {
    final prefs = await _prefs;
    final rawEntries = prefs.getStringList(_storageKey) ?? <String>[];

    return rawEntries
        .map(FilmEntry.fromJson)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<void> saveEntries(List<FilmEntry> entries) async {
    final prefs = await _prefs;
    final payload = entries.map((entry) => entry.toJson()).toList();
    await prefs.setStringList(_storageKey, payload);
  }
}
