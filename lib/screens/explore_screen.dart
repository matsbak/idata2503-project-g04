import 'package:flutter/material.dart';
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
    final groupedMovies = _groupMoviesByGenre();

    return Scaffold(
      appBar: AppBar(title: const Text('Explore Movies')),
      body: ListView(
        children: groupedMovies.entries.map((entry) {
          final genre = entry.key;
          final genreMovies = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Text(
                  genre.toString().split('.').last.toUpperCase(), // Genre name
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 200.0, // Adjust height to fit your design
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: genreMovies.length,
                  itemBuilder: (context, index) {
                    return ExploreListItem(
                      movie: movies[index],
                      posterUrl: genreMovies[index].posterUrl,
                    );
                  },
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
