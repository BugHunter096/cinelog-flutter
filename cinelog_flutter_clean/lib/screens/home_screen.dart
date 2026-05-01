import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/film_library_controller.dart';
import '../models/film_entry.dart';
import '../widgets/film_card.dart';
import '../widgets/library_stats.dart';
import 'editor_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FilmLibraryController>();
    final entries = controller.visibleEntries;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CineLog'),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        icon: const Icon(Icons.add),
        label: const Text('Añadir'),
      ),
      body: SafeArea(
        child: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tu biblioteca personal',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Guarda películas, series y documentales. Marca lo que has visto y valora tus favoritos.',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 16),
                          const LibraryStats(),
                          const SizedBox(height: 16),
                          TextField(
                            onChanged: controller.updateSearchTerm,
                            decoration: const InputDecoration(
                              hintText: 'Buscar por título, género o plataforma',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: [
                              ChoiceChip(
                                label: const Text('Todo'),
                                selected: controller.filter == LibraryFilter.all,
                                onSelected: (_) => controller.updateFilter(LibraryFilter.all),
                              ),
                              ChoiceChip(
                                label: const Text('Visto'),
                                selected: controller.filter == LibraryFilter.watched,
                                onSelected: (_) => controller.updateFilter(LibraryFilter.watched),
                              ),
                              ChoiceChip(
                                label: const Text('Pendiente'),
                                selected: controller.filter == LibraryFilter.pending,
                                onSelected: (_) => controller.updateFilter(LibraryFilter.pending),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (entries.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyState(
                        hasEntries: controller.totalCount > 0,
                        onCreate: () => _openEditor(context),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                      sliver: SliverList.separated(
                        itemCount: entries.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          return FilmCard(
                            entry: entry,
                            onTap: () => _openEditor(context, entry: entry),
                            onToggleWatched: () => context.read<FilmLibraryController>().toggleWatched(entry.id),
                            onDelete: () => _confirmDelete(context, entry),
                          );
                        },
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Future<void> _openEditor(BuildContext context, {FilmEntry? entry}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditorScreen(entry: entry),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, FilmEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar entrada'),
        content: Text('¿Quieres eliminar "${entry.title}" de tu biblioteca?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<FilmLibraryController>().deleteEntry(entry.id);
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.hasEntries,
    required this.onCreate,
  });

  final bool hasEntries;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasEntries ? Icons.filter_alt_off : Icons.movie_creation_outlined,
            size: 72,
            color: Colors.grey.shade500,
          ),
          const SizedBox(height: 16),
          Text(
            hasEntries ? 'No hay resultados con ese filtro' : 'Todavía no has añadido nada',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            hasEntries
                ? 'Prueba con otra búsqueda o cambia el filtro.'
                : 'Añade tu primera película, serie o documental.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700),
          ),
          if (!hasEntries) ...[
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text('Crear primera entrada'),
            ),
          ],
        ],
      ),
    );
  }
}
