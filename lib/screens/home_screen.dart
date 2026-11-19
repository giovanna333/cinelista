import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../routes.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../widgets/movie_card.dart';

enum _Filter { all, watchlist, watched }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = AuthService();
  final _db = DatabaseService();
  _Filter _filter = _Filter.all;

  String get _uid => _auth.currentUser!.uid;

  List<Movie> _applyFilter(List<Movie> all) {
    switch (_filter) {
      case _Filter.watchlist:
        return all.where((m) => m.status == MovieStatus.watchlist).toList();
      case _Filter.watched:
        return all.where((m) => m.status == MovieStatus.watched).toList();
      case _Filter.all:
        return all;
    }
  }

  Future<void> _confirmDelete(Movie movie) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir filme'),
        content: Text('Deseja excluir "${movie.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Excluir')),
        ],
      ),
    );
    if (ok == true) {
      try {
        await _db.deleteMovie(_uid, movie.id!);
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Erro ao excluir o filme.')));
        }
      }
    }
  }

  void _openForm([Movie? movie]) {
    Navigator.pushNamed(context, AppRoutes.movieForm, arguments: movie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Lista de Filmes'),
        actions: [
          IconButton(tooltip: 'Sair', icon: const Icon(Icons.logout), onPressed: _auth.logout),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Adicionar filme'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: SegmentedButton<_Filter>(
                  segments: const [
                    ButtonSegment(value: _Filter.all, label: Text('Todos')),
                    ButtonSegment(value: _Filter.watchlist, label: Text('Quero ver')),
                    ButtonSegment(value: _Filter.watched, label: Text('Assistidos')),
                  ],
                  selected: {_filter},
                  onSelectionChanged: (s) => setState(() => _filter = s.first),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<Movie>>(
                  stream: _db.watchMovies(_uid),
                  builder: (context, snap) {
                    if (snap.hasError) {
                      return const Center(child: Text('Erro ao carregar os filmes.'));
                    }
                    if (!snap.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final movies = _applyFilter(snap.data!);
                    if (movies.isEmpty) {
                      return const Center(child: Text('Nenhum filme por aqui. Toque em "Adicionar filme".'));
                    }
                    // Responsivo: 1 coluna no celular, 2+ colunas no desktop
                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 480,
                        mainAxisExtent: 190,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: movies.length,
                      itemBuilder: (_, i) => MovieCard(
                        movie: movies[i],
                        onEdit: () => _openForm(movies[i]),
                        onDelete: () => _confirmDelete(movies[i]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
