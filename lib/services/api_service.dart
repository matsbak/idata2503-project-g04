import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import 'package:project/models/movie.dart';

/// The ApiService class represents a service class for mainly fetching movie data from the API.
class ApiService {
  static const _pages = 1;
  static const _baseUrl = 'https://api.themoviedb.org/3/movie';
  static const _posterBaseUrl =
      'https://image.tmdb.org/t/p/w600_and_h900_bestv2';

  /// Fetches all movies from the API. The amount of movies fetched depends on the pages constant,
  /// where each page contains 20 movies.
  static Future<List<Movie>> fetchMovies(Client client) async {
    List<Movie> movies = [];

    for (var i = 1; i <= _pages; i++) {
      final url = Uri.parse(
        '$_baseUrl/popular?language=en-US&page=$i',
      );
      final response = await client.get(
        url,
        headers: {
          'Authorization': 'Bearer ${dotenv.env['API_KEY']}',
          'accept': 'application/json',
        },
      );

      if (response.statusCode >= 400) {
        throw Exception();
      }

      final Map<String, dynamic> movieData = json.decode(response.body);
      final List<Movie> loadedMovies = [];

      for (final movie in movieData['results']) {
        final loadedMovie = Movie(
          id: movie['id'],
          title: movie['title'],
          description: movie['overview'],
          posterPath: movie['poster_path'],
        );

        loadedMovies.add(loadedMovie);
      }

      movies = [...movies, ...loadedMovies];
    }

    return movies;
  }

  /// Fetches all genres for the specified movie from the API. Each movie can have multiple genres.
  static Future<List<String>> fetchMovieGenres(
      Movie movie, Client client) async {
    List<String> genres = [];

    final url = Uri.parse(
      '$_baseUrl/${movie.id}?language=en-US',
    );
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer ${dotenv.env['API_KEY']}',
        'accept': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw Exception();
    }

    final Map<String, dynamic> movieDetailsData = json.decode(response.body);
    final List<String> loadedGenres = [];

    for (final genre in movieDetailsData['genres']) {
      loadedGenres.add(genre['name']);
    }

    genres = [...loadedGenres];

    return genres;
  }

  /// Fetches the poster for the specified movie. This method does not fetch data from the API like
  /// the other methods defined in this class. It uses a base URL defined outside of the API
  /// reference to fetch the movie poster.
  static Image fetchMoviePoster(Movie movie) {
    return Image.network('$_posterBaseUrl${movie.posterPath}');
  }
}
