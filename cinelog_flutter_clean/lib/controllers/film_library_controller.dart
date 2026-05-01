import 'package:flutter/foundation.dart';

import '../models/film_entry.dart';
import '../services/film_storage_service.dart';

class FilmLibraryController extends ChangeNotifier {
  FilmLibraryController({FilmStorageService? storageService})
      : _storageService = storageService ?? FilmStorageService();

  final FilmStorageService _storageService;

  final List<FilmEntry> _entries = <FilmEntry>[];
  String _searchTerm = '';
  LibraryFilter _filter = LibraryFilter.all;
  bool _isLoading = false;

  List<FilmEntry> get entries => List.unmodifiable(_entries);
  String get searchTerm => _searchTerm;
  LibraryFilter get filter => _filter;
  bool get isLoading => _isLoading;

  int get totalCount => _entries.length;
  int get watchedCount => _entries.where((entry) => entry.isWatched).length;
  int get pendingCount => totalCount - watchedCount;

  double get averageRating {
    final ratedEntries = _entries.where((entry) => entry.rating > 0).toList();
    if (ratedEntries.isEmpty) return 0;

    final total = ratedEntries.fold<int>(0, (sum, entry) => sum + entry.rating);
    return total / ratedEntries.length;
  }

  List<FilmEntry> get visibleEntries {
    final normalizedTerm = _normalize(_searchTerm);

    return _entries.where((entry) {
      final matchesFilter = switch (_filter) {
        LibraryFilter.all => true,
        LibraryFilter.watched => entry.isWatched,
        LibraryFilter.pending => !entry.isWatched,
      };

      if (!matchesFilter) return false;

      if (normalizedTerm.isEmpty) return true;

      final searchableText = _normalize(
        '${entry.title} ${entry.genre} ${entry.platform} ${entry.type.label}',
      );

      return searchableText.contains(normalizedTerm);
    }).toList();
  }

  Future<void> load() async {
    _setLoading(true);
    try {
      final loadedEntries = await _storageService.loadEntries();
      _entries
        ..clear()
        ..addAll(loadedEntries);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addEntry(FilmEntry entry) async {
    _entries.insert(0, entry);
    await _persistAndNotify();
  }

  Future<void> updateEntry(FilmEntry updatedEntry) async {
    final index = _entries.indexWhere((entry) => entry.id == updatedEntry.id);
    if (index == -1) return;

    _entries[index] = updatedEntry;
    _entries.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    await _persistAndNotify();
  }

  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((entry) => entry.id == id);
    await _persistAndNotify();
  }

  Future<void> toggleWatched(String id) async {
    final index = _entries.indexWhere((entry) => entry.id == id);
    if (index == -1) return;

    final current = _entries[index];
    _entries[index] = current.copyWith(isWatched: !current.isWatched);
    await _persistAndNotify();
  }

  void updateSearchTerm(String value) {
    _searchTerm = value;
    notifyListeners();
  }

  void updateFilter(LibraryFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  Future<void> _persistAndNotify() async {
    await _storageService.saveEntries(_entries);
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _normalize(String value) {
    return value.trim().toLowerCase();
  }
}

enum LibraryFilter {
  all,
  watched,
  pending,
}
