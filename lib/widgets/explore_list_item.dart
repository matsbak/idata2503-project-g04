import 'package:flutter/material.dart';
import 'package:project/models/movie.dart';
import 'package:project/screens/movie_detail_screen.dart';

class ExploreListItem extends StatelessWidget {
  const ExploreListItem({
    super.key,
    required this.movie,
    // required this.onSelectedMovie,
  });

  final Movie movie;
  // final void Function() onSelectedMovie;

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
              child: Image.network(
                movie.posterUrl,
                fit: BoxFit.cover,
                height: 160,
                width: 120,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              movie.title,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
