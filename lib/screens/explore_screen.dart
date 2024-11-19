import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';
import 'package:project/widgets/explore_list_item.dart';

/// A screen representing the explore section of the app. The explore screen
/// is to show the user with the different movies based on category.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({
    super.key,
    required this.movies,
  });

  final List<Movie> movies;

  @override
  State<ExploreScreen> createState() {
    return _ExploreScreenState();
  }
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    // final actionMovies =
    //     dummyMovies.where((movie) => movie.genre == Genre.action).toList();
    // final fantacyMovies =
    //     dummyMovies.where((movie) => movie.genre == Genre.fantasy).toList();
    // final sciFiMovies = dummyMovies
    //     .where((movie) => movie.genre == Genre.scienceFiction)
    //     .toList();
    // final comedyMovies =
    //     dummyMovies.where((movie) => movie.genre == Genre.comedy).toList();
    // final horrorMovies =
    //     dummyMovies.where((movie) => movie.genre == Genre.horror).toList();
    // final dramaMovies =
    //     dummyMovies.where((movie) => movie.genre == Genre.drama).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          // _buildGenreSection(genre),
        ],
      ),
    );
  }

  /// A widget that builds a genre section with every movie in that given genre.
  // Widget buildGenreSection(Genre genre, List<Movie> movies) {
  Widget _buildGenreSection(String genre) {
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
              itemCount: widget.movies.length,
              itemBuilder: (ctx, index) {
                return ExploreListItem(movie: widget.movies[index]);
              }),
        ),
      ],
    );
  }
}
