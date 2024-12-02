import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';
import 'package:project/widgets/movie/movie_item.dart';

class MovieList extends StatelessWidget {
  const MovieList({
    super.key,
    required this.header,
    required this.movies,
  });

  final String header;
  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2.0),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: movies.length,
              itemBuilder: (ctx, index) => Padding(
                padding: const EdgeInsets.only(
                  top: 4.0,
                ),
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
