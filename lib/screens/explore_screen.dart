import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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
  List<String> _genres = [];
  bool _isLoading = true;
  String? _error;

  void _loadGenres(int id) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/$id?language=en-US',
    );
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${dotenv.env['API_KEY']}',
          'accept': 'application/json',
        },
      );

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data';
        });
      }

      if (_error == null) {
        final Map<String, dynamic> movieDetailsData = json.decode(response.body);
        final List<String> loadedGenres = [];

        for (final genre in movieDetailsData['genres']) {
          if (!_genres.contains(genre['name'])) {
            loadedGenres.add(genre['name']);
          }
        }

        setState(() {
          _genres = [..._genres, ...loadedGenres];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Something went wrong';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    for (final movie in widget.movies) {
      _loadGenres(movie.id);
    }
  }
  
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
          for (final genre in _genres)
            _buildGenreSection(genre),
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
