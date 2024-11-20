import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';
import 'package:project/widgets/explore_list_item.dart';

/// A screen representing the explore section of the app. The explore screen
/// is to show the user with the different movies based on category.
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({
    super.key,
    required this.movies,
  });

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    List<String> genres = [];

    // Initializes all genres to be shown on the screen
    for (final movie in movies) {
      for (String genre in movie.genres) {
        if (!genres.contains(genre)) {
          genres.add(genre);
        }
      }
    }

    List<Movie> getGenreMovies(String genre) {
      List<Movie> genreMovies = [];

      for (final movie in movies) {
        if (movie.genres.contains(genre)) {
          genreMovies.add(movie);
        }
      }

      return genreMovies;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          for (final genre in genres)
            _buildGenreSection(genre, getGenreMovies(genre)),
        ],
      ),
    );
  }

  /// A widget that builds a genre section with every movie in that given genre.
  Widget _buildGenreSection(String genre, List<Movie> genreMovies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            genre,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: genreMovies.length,
              itemBuilder: (ctx, index) {
                return ExploreListItem(movie: genreMovies[index]);
              }),
        ),
      ],
    );
  }
}
