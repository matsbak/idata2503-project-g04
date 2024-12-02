import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';
import 'package:project/screens/movie_detail_screen.dart';

/// A widget that shows movies as images and movie title.
class ExploreListItem extends StatelessWidget {
  const ExploreListItem({
    super.key,
    required this.movie,
  });

  final Movie movie;

  /// Pushes a new screen ontop of the existing screen
  void _onSelectedMovie(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => MovieDetailScreen(movie: movie)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onSelectedMovie(context, movie),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        width: 120,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 120,
                height: 160,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: movie.poster,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              movie.title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
