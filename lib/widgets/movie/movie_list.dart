import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';
import 'package:project/widgets/movie/movie_item.dart';

class MovieList extends StatelessWidget {
  const MovieList({
    super.key,
    required this.movies,
  });

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (ctx, index) => MovieItem(
          movie: movies[index],
        ),
      ),
    );
  }
}
