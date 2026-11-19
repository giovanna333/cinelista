import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../utils/validators.dart';

/// Usada para CRIAR (movie == null) e EDITAR (movie != null).
class MovieFormScreen extends StatefulWidget {
  final Movie? movie;
  const MovieFormScreen({super.key, this.movie});

  @override
  State<MovieFormScreen> createState() => _MovieFormScreenState();
}

class _MovieFormScreenState extends State<MovieFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();
  late final TextEditingController _title;
  late final TextEditingController _year;
  late final TextEditingController _comment;
  late String _genre;
  late MovieStatus _status;
  late int _rating;
  bool _saving = false;

  bool get _isEditing => widget.movie != null;

  @override
  void initState() {
    super.initState();
    final m = widget.movie;
    _title = TextEditingController(text: m?.title ?? '');
    _year = TextEditingController(text: m?.year.toString() ?? '');
    _comment = TextEditingController(text: m?.comment ?? '');
    _genre = m?.genre ?? Movie.genres.first;
    _status = m?.status ?? MovieStatus.watchlist;
    _rating = m?.rating ?? 0;
  }

  @override
  void dispose() {
    _title.dispose();
    _year.dispose();
    _comment.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final uid = AuthService().currentUser!.uid;
      final movie = Movie(
        id: widget.movie?.id,
        title: _title.text.trim(),
        genre: _genre,
        year: int.parse(_year.text.trim()),
        rating: _rating,
        status: _status,
        comment: _comment.text.trim(),
        createdAt: widget.movie?.createdAt,
      );
      if (_isEditing) {
        await _db.updateMovie(uid, movie);
      } else {
        await _db.addMovie(uid, movie);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Erro ao salvar. Tente novamente.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Editar filme' : 'Novo filme')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _title,
                    decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
                    validator: (v) => Validators.required(v, 'Título'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _genre,
                    decoration: const InputDecoration(labelText: 'Gênero', border: OutlineInputBorder()),
                    items: Movie.genres.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                    onChanged: (v) => setState(() => _genre = v ?? _genre),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _year,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Ano', border: OutlineInputBorder()),
                    validator: Validators.year,
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<MovieStatus>(
                    segments: const [
                      ButtonSegment(value: MovieStatus.watchlist, label: Text('Quero assistir')),
                      ButtonSegment(value: MovieStatus.watched, label: Text('Assistido')),
                    ],
                    selected: {_status},
                    onSelectionChanged: (s) => setState(() => _status = s.first),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Nota: '),
                      for (var i = 1; i <= 5; i++)
                        IconButton(
                          tooltip: '$i estrela(s)',
                          icon: Icon(i <= _rating ? Icons.star : Icons.star_border, color: Colors.amber),
                          // tocar na estrela já marcada zera a nota
                          onPressed: () => setState(() => _rating = (_rating == i) ? 0 : i),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _comment,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        labelText: 'Comentário (opcional)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(_isEditing ? 'Salvar alterações' : 'Adicionar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
