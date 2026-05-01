import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/film_library_controller.dart';

class LibraryStats extends StatelessWidget {
  const LibraryStats({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FilmLibraryController>();

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Total',
            value: controller.totalCount.toString(),
            icon: Icons.collections_bookmark_outlined,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            title: 'Vistas',
            value: controller.watchedCount.toString(),
            icon: Icons.check_circle_outline,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            title: 'Media',
            value: controller.averageRating == 0
                ? '-'
                : controller.averageRating.toStringAsFixed(1),
            icon: Icons.star_border,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            Text(
              title,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
