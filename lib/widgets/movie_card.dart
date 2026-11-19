import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MovieCard({super.key, required this.movie, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final watched = movie.status == MovieStatus.watched;
    return Card(
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(movie.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    tooltip: 'Excluir',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                  ),
                ],
              ),
              Text('${movie.year} • ${movie.genre}'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(watched ? Icons.check_circle : Icons.schedule,
                      size: 18, color: watched ? Colors.green : Colors.orange),
                  const SizedBox(width: 4),
                  Text(watched ? 'Assistido' : 'Quero assistir'),
                  const Spacer(),
                  for (var i = 1; i <= 5; i++)
                    Icon(i <= movie.rating ? Icons.star : Icons.star_border,
                        size: 18, color: Colors.amber),
                  const SizedBox(width: 8),
                ],
              ),
              if (movie.comment.isNotEmpty) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(movie.comment, maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
