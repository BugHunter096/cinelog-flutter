import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/film_entry.dart';

class FilmCard extends StatelessWidget {
  const FilmCard({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onToggleWatched,
    required this.onDelete,
  });

  final FilmEntry entry;
  final VoidCallback onTap;
  final VoidCallback onToggleWatched;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final updatedDate = DateFormat('dd/MM/yyyy').format(entry.updatedAt);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _iconForType(entry.type),
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _subtitle,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<_FilmAction>(
                    onSelected: (action) {
                      switch (action) {
                        case _FilmAction.edit:
                          onTap();
                        case _FilmAction.delete:
                          onDelete();
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: _FilmAction.edit,
                        child: Text('Editar'),
                      ),
                      PopupMenuItem(
                        value: _FilmAction.delete,
                        child: Text('Eliminar'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Chip(label: entry.type.label),
                  if (entry.genre.isNotEmpty) _Chip(label: entry.genre),
                  if (entry.platform.isNotEmpty) _Chip(label: entry.platform),
                  _Chip(label: entry.isWatched ? 'Visto' : 'Pendiente'),
                ],
              ),
              if (entry.notes.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  entry.notes,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade800),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  _RatingStars(value: entry.rating),
                  const Spacer(),
                  Text(
                    'Actualizado $updatedDate',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  IconButton(
                    tooltip: entry.isWatched ? 'Marcar pendiente' : 'Marcar visto',
                    onPressed: onToggleWatched,
                    icon: Icon(
                      entry.isWatched ? Icons.visibility : Icons.visibility_off_outlined,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _subtitle {
    if (entry.year == null) return 'Sin año indicado';
    return '${entry.year}';
  }

  IconData _iconForType(FilmType type) {
    switch (type) {
      case FilmType.movie:
        return Icons.movie_outlined;
      case FilmType.series:
        return Icons.live_tv_outlined;
      case FilmType.documentary:
        return Icons.public_outlined;
    }
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}

class _RatingStars extends StatelessWidget {
  const _RatingStars({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    if (value == 0) {
      return Text(
        'Sin valorar',
        style: TextStyle(color: Colors.grey.shade600),
      );
    }

    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
          size: 18,
          color: Colors.amber.shade700,
        );
      }),
    );
  }
}

enum _FilmAction {
  edit,
  delete,
}
