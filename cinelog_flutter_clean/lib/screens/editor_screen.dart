import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/film_library_controller.dart';
import '../models/film_entry.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key, this.entry});

  final FilmEntry? entry;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _yearController;
  late final TextEditingController _genreController;
  late final TextEditingController _platformController;
  late final TextEditingController _notesController;

  late FilmType _type;
  late int _rating;
  late bool _isWatched;

  bool get _isEditing => widget.entry != null;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _titleController = TextEditingController(text: entry?.title ?? '');
    _yearController = TextEditingController(text: entry?.year?.toString() ?? '');
    _genreController = TextEditingController(text: entry?.genre ?? '');
    _platformController = TextEditingController(text: entry?.platform ?? '');
    _notesController = TextEditingController(text: entry?.notes ?? '');
    _type = entry?.type ?? FilmType.movie;
    _rating = entry?.rating ?? 0;
    _isWatched = entry?.isWatched ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    _genreController.dispose();
    _platformController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar entrada' : 'Nueva entrada'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 2) {
                    return 'Introduce un título válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _yearController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Año',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  final trimmed = value?.trim() ?? '';
                  if (trimmed.isEmpty) return null;
                  final year = int.tryParse(trimmed);
                  if (year == null || year < 1888 || year > DateTime.now().year + 5) {
                    return 'Introduce un año válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<FilmType>(
                value: _type,
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                  prefixIcon: Icon(Icons.category),
                ),
                items: FilmType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _type = value);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _genreController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Género',
                  prefixIcon: Icon(Icons.local_offer_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _platformController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Plataforma',
                  prefixIcon: Icon(Icons.tv),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: SwitchListTile(
                  title: const Text('Contenido visto'),
                  subtitle: Text(_isWatched ? 'Ya lo has visto' : 'Pendiente'),
                  value: _isWatched,
                  onChanged: (value) => setState(() => _isWatched = value),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Valoración',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                children: List.generate(5, (index) {
                  final value = index + 1;
                  return IconButton(
                    onPressed: () => setState(() => _rating = value),
                    icon: Icon(
                      value <= _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber.shade700,
                    ),
                  );
                }),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => setState(() => _rating = 0),
                  child: const Text('Quitar valoración'),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Notas',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.notes),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: Text(_isEditing ? 'Guardar cambios' : 'Guardar entrada'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final yearText = _yearController.text.trim();
    final year = yearText.isEmpty ? null : int.parse(yearText);

    final entry = widget.entry;
    final controller = context.read<FilmLibraryController>();

    if (entry == null) {
      await controller.addEntry(
        FilmEntry(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          year: year,
          genre: _genreController.text.trim(),
          platform: _platformController.text.trim(),
          type: _type,
          rating: _rating,
          isWatched: _isWatched,
          notes: _notesController.text.trim(),
        ),
      );
    } else {
      await controller.updateEntry(
        entry.copyWith(
          title: _titleController.text.trim(),
          year: year,
          clearYear: year == null,
          genre: _genreController.text.trim(),
          platform: _platformController.text.trim(),
          type: _type,
          rating: _rating,
          isWatched: _isWatched,
          notes: _notesController.text.trim(),
        ),
      );
    }

    if (mounted) Navigator.of(context).pop();
  }
}
