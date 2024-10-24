import 'package:flutter/material.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trending / featured',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: movies.length,
              itemBuilder: (ctx, index) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: MovieItem(
                  movie: movies[index],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
