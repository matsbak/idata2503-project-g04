import 'package:flutter/material.dart';
import 'package:project/data/dummy_data.dart';
import 'package:project/models/movie.dart';
import 'package:project/widgets/explore_list_item.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({
    super.key,
    required this.movies,
  });

  final List<Movie> movies;

  // Group movies by genre
  Map<Genre, List<Movie>> _groupMoviesByGenre() {
    Map<Genre, List<Movie>> groupedMovies = {};
    for (var movie in movies) {
      if (groupedMovies[movie.genre] == null) {
        groupedMovies[movie.genre] = [];
      }
      groupedMovies[movie.genre]!.add(movie);
    }
    return groupedMovies;
  }

  @override
  Widget build(BuildContext context) {
    final actionMovies =
        dummyMovies.where((movie) => movie.genre == Genre.action).toList();
    final sciFiMovies = dummyMovies
        .where((movie) => movie.genre == Genre.scienceFiction)
        .toList();
    final comedyMovies =
        dummyMovies.where((movie) => movie.genre == Genre.comedy).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          buildGenreSection('Action', actionMovies),
          buildGenreSection('Sci.Fi', sciFiMovies),
          buildGenreSection('Comedy', comedyMovies),
        ],
      ),
    );
  }

  Widget buildGenreSection(String genreTitle, List<Movie> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            genreTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (ctx, index) {
                return ExploreListItem(movie: movies[index]);
              }),
        )
      ],
    );
  }
}
