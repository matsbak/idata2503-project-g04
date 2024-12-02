import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:project/models/movie.dart';
import 'package:project/models/rating.dart';
import 'package:project/services/api_service.dart';

class FirebaseService {
  static String baseUrl = dotenv.env['FIREBASE_BASE_URL'] ?? '';

  /// Fetches all movies from Firebase.
  static Future<List<Movie>> getMovies() async {
    List<Movie> movies = [];

    try {
      final url = Uri.https(baseUrl, 'movies.json');
      final response = await http.get(url);

      if (response.body != 'null') {
        final Map<String, dynamic> moviesData = json.decode(response.body);
        final List<Movie> loadedMovies = [];

        for (final entry in moviesData.entries) {
          final loadedMovie = Movie(
            id: entry.value['id'],
            title: entry.value['title'],
            description: entry.value['description'],
            posterPath: entry.value['posterPath'],
            genres: [...entry.value['genres']],
          );

          loadedMovie.poster = ApiService.fetchMoviePoster(loadedMovie);

          // Adds each rating to the loaded movie if they exist
          if (entry.value['ratings'] != null) {
            final ratingsData = entry.value['ratings'] as Map<String, dynamic>;
            final List<Rating> ratings = [];

            for (final ratingEntry in ratingsData.entries) {
              final rating = Rating(
                score: ratingEntry.value['score'],
                review: ratingEntry.value['review'],
                userId: ratingEntry.value['userId'],
                date: DateTime.parse(ratingEntry.value['date']),
              );

              ratings.add(rating);
            }

            loadedMovie.ratings = [...ratings];
          }

          loadedMovies.add(loadedMovie);
        }

        movies = [...loadedMovies];
      }
    } catch (error) {
      throw Exception('Error fetching movies: $error');
    }

    return movies;
  }

  /// Fetch Firebase key for a movie by its ID within a specific user's list
  static Future<String?> getMovieFirebaseKeyByUserId(
      int movieId, String uid, String list) async {
    try {
      final url = Uri.https(baseUrl, 'users/$uid/$list.json');
      final response = await http.get(url);

      if (response.statusCode == 200 && response.body != 'null') {
        final Map<String, dynamic> moviesData =
            json.decode(response.body) as Map<String, dynamic>;

        for (var entry in moviesData.entries) {
          if (entry.value == movieId) {
            return entry.key; // Return the Firebase key
          }
        }
      }
      return null; // Return null if not found.
    } catch (error) {
      throw Exception('Error fetching Firebase key: $error');
    }
  }

  /// Fetch Firebase key for a movie by its id.
  static Future<String?> getFirebaseKeyByMovie(int movieId) async {
    try {
      final url = Uri.https(baseUrl, 'movies.json');
      final response = await http.get(url);

      if (response.statusCode == 200 && response.body != 'null') {
        final Map<String, dynamic> movieData =
            json.decode(response.body) as Map<String, dynamic>;

        for (var entry in movieData.entries) {
          if (entry.value['id'] == movieId) {
            return entry.key;
          }
        }
      }
      return null;
    } catch (error) {
      throw Exception("Error fetching Firebase Key: $error");
    }
  }

  /// Adds a movie Firebase if it does not already exist
  static Future<void> addMovieToFirebase(Movie movie) async {
    bool isStored = false;
    // Checks if movie already exists in Firebase
    try {
      final url = Uri.https(baseUrl, 'movies.json');
      final response = await http.get(url);
      if (response.body != 'null') {
        final Map<String, dynamic> moviesData = json.decode(response.body);
        for (final entry in moviesData.entries) {
          if (entry.value['id'] == movie.id) {
            isStored = true;
          }
        }
      }
    } catch (error) {
      throw Exception("Error fetching movies: $error");
    }
    // Adds movie to Firebase if it does not already exist
    if (!isStored) {
      try {
        final url = Uri.https(baseUrl, 'movies.json');
        await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'id': movie.id,
            'title': movie.title,
            'description': movie.description,
            'genres': movie.genres,
            'posterPath': movie.posterPath,
          }),
        );
      } catch (error) {
        throw Exception("Error adding to movies: $error");
      }
    }
  }

  /// Removes a movie from Firebase if no user has it in either of its lists.
  static Future<void> removeMovieFromFirebase(int movieId) async {
    bool isStored = false;
    // Checks if any user has the movie stored in either of its lists
    try {
      var url = Uri.https(baseUrl, 'users.json');
      var response = await http.get(url);

      if (response.body != 'null') {
        final Map<String, dynamic> usersData = json.decode(response.body);

        for (final list in usersData.values) {
          for (final listItem in list.values) {
            for (final mId in listItem.values) {
              if (mId == movieId) {
                isStored = true;
              }
            }
          }
        }
      }
    } catch (error) {
      throw Exception("Error fetching users data: $error");
    }
    // Removes movie from Firebase if no user has it in either of its lists
    if (!isStored) {
      try {
        final String? firebaseKey = await getFirebaseKeyByMovie(movieId);
        final url = Uri.https(baseUrl, 'movies/$firebaseKey.json');
        await http.delete(url);
      } catch (error) {
        throw Exception("Error deleting from movies: $error");
      }
    }
  }

  /// Method to send http DELETE request to backend (Firebase) to remove a movie from a user's collection
  static Future<void> removeMovieFromWatchlist(int movieId, String uid) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final String email = user?.email ?? 'unknown@example.com';
      final firebaseKey =
          await _fetchFirebaseKeyForUserMovie(movieId, uid, 'watchlist');
      if (firebaseKey == null) {
        throw Exception("Movie not found in Firebase");
      }

      // Remove the movie from the user's "watchlist"
      await _removeMovieFromUserList(uid, 'watchlist', firebaseKey);

      final List<Rating> ratings = await fetchRatingForMovie(movieId);
      if (ratings.isEmpty) {
        await removeMovieFromFirebase(movieId);
      } else {
        final movieFirebaseKey = await getFirebaseKeyByMovie(movieId);
        if (movieFirebaseKey != null) {
          await _removeUserRating(movieFirebaseKey, email);
          await _checkAndDeleteMovieIfNoRatingsLeft(movieId);
        } else {
          throw Exception("movie not found in Firebase");
        }
      }
    } catch (error) {
      throw Exception("Error deleting movie: $error");
    }
  }

  //Removes a movie from the user's "Mylist" and handles ratings appropriately
  static Future<void> removeMovieFromMylist(int movieId, String uid) async {
    try {
      // Fetch the logged-in user's email
      final user = FirebaseAuth.instance.currentUser;
      final String email = user?.email ?? 'unknown@example.com';

      // Fetch the Firebase key for the movie in the user's "mylist"
      final firebaseKey =
          await _fetchFirebaseKeyForUserMovie(movieId, uid, 'mylist');
      if (firebaseKey == null) {
        throw Exception("Movie not found in user's mylist.");
      }

      // Remove the movie from the user's "mylist"
      await _removeMovieFromUserList(uid, 'mylist', firebaseKey);

      // Check if the movie has ratings
      final List<Rating> ratings = await fetchRatingForMovie(movieId);
      if (ratings.isEmpty) {
        await removeMovieFromFirebase(movieId);
      } else {
        final movieFirebaseKey = await getFirebaseKeyByMovie(movieId);
        if (movieFirebaseKey != null) {
          await _removeUserRating(movieFirebaseKey, email);
          await _checkAndDeleteMovieIfNoRatingsLeft(movieId);
        } else {
          throw Exception("Movie not found in Firebase.");
        }
      }
    } catch (error) {
      throw Exception("Error deleting movie from mylist: $error");
    }
  }

  /// Fetch the Firebase key for a user's movie in a spesific list
  static Future<String?> _fetchFirebaseKeyForUserMovie(
      int movieId, String uid, String listType) async {
    return await getMovieFirebaseKeyByUserId(movieId, uid, listType);
  }

  /// Remove a movie from a user's list
  static Future<void> _removeMovieFromUserList(
      String uid, String listType, String firebaseKey) async {
    final url = Uri.https(baseUrl, 'users/$uid/$listType/$firebaseKey.json');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception(
          "Failed to delete movie from $listType. Status code. ${response.statusCode}");
    }
  }

  /// Remove a user's specific rating for a movie
  static Future<void> _removeUserRating(
      String movieFirebaseKey, String email) async {
    final userRatingEntry = await _getUserRatingEntry(movieFirebaseKey, email);

    if (userRatingEntry != null) {
      final ratingUrl = Uri.https(
        baseUrl,
        'movies/$movieFirebaseKey/ratings/${userRatingEntry.key}.json',
      );
      final deleteResponse = await http.delete(ratingUrl);

      if (deleteResponse.statusCode != 200) {
        throw Exception(
            "Failed to delete the user's rating. Status code: ${deleteResponse.statusCode}");
      }
    }
  }

  /// Check if any ratings are left for a movie and delete the movie if none exist.
  static Future<void> _checkAndDeleteMovieIfNoRatingsLeft(int movieId) async {
    final List<Rating> updatedRatings = await fetchRatingForMovie(movieId);
    if (updatedRatings.isEmpty) {
      await removeMovieFromFirebase(movieId);
    }
  }

  /// Helper method to get the Firebase entry key for a user's rating.
  static Future<MapEntry<String, dynamic>?> _getUserRatingEntry(
      String movieFirebaseKey, String userEmail) async {
    try {
      final url = Uri.https(baseUrl, 'movies/$movieFirebaseKey/ratings.json');
      final response = await http.get(url);

      if (response.statusCode == 200 && response.body != 'null') {
        final Map<String, dynamic>? ratingsData =
            json.decode(response.body) as Map<String, dynamic>?;

        if (ratingsData != null) {
          try {
            final userRatingEntry = ratingsData.entries.firstWhere(
              (entry) => entry.value['userId'] == userEmail,
            );
            return userRatingEntry;
          } catch (error) {
            return null;
          }
        }
      }
      return null;
    } catch (error) {
      throw Exception("Error fetching user rating entry: $error");
    }
  }

  /// Method to send http POST request to backend (Firebase) to add a movie to a user's collection
  static Future<String?> addMovieToWatchlist(Movie movie, String uid) async {
    addMovieToFirebase(movie);
    try {
      final url = Uri.https(baseUrl, 'users/$uid/watchlist.json');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(movie.id),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return responseData['name'];
      } else {
        throw Exception('Failed to add movie to Firebase');
      }
    } catch (error) {
      throw Exception("Error adding movie: $error");
    }
  }

  //Mehtod to handle the changing of list types
  static Future<String?> addMovieToMylist(Movie movie, String uid) async {
    try {
      final url = Uri.https(baseUrl, 'users/$uid/mylist.json');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(movie.id),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        removeMovieFromWatchlist(movie.id, uid);
        final responseData = json.decode(response.body);
        return responseData['name'];
      } else {
        throw Exception('Failed to add movie to Firebase');
      }
    } catch (error) {
      throw Exception("Error adding movie to mylist: $error");
    }
  }

  static Future<void> updateRatingForMovie(int movieId, Rating rating) async {
    try {
      final movieFirebaseKey = await getFirebaseKeyByMovie(movieId);
      if (movieFirebaseKey == null) {
        throw Exception("Movie not found in Firebase");
      }

      // Fetch all ratings to locate the wanted one
      final ratingsUrl =
          Uri.https(baseUrl, 'movies/$movieFirebaseKey/ratings.json');
      final response = await http.get(ratingsUrl);

      if (response.statusCode != 200) {
        throw Exception("Failed to fetch ratings for movie");
      }

      // Decode ratings to find the target rating key
      final data = json.decode(response.body) as Map<String, dynamic>;
      String? ratingKey;

      data.forEach((key, value) {
        if (value['userId'] == rating.userId) {
          ratingKey = key;
        }
      });

      if (ratingKey == null) {
        throw Exception("Rating not found for user ${rating.userId}");
      }

      // Update the rating at the specific key
      final updateUrl = Uri.https(
        baseUrl,
        'movies/$movieFirebaseKey/ratings/$ratingKey.json',
      );
      final updateResponse = await http.patch(
        updateUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'score': rating.score,
          'review': rating.review,
          'date': rating.date.toIso8601String(),
        }),
      );

      if (updateResponse.statusCode != 200) {
        throw Exception("Failed to update rating");
      }
    } catch (error) {
      throw Exception("Error updating rating: $error");
    }
  }

  static Future<List<Movie>> fetchWatchlistMovies(String uid) async {
    final List<Movie> movies = [];
    try {
      final url = Uri.https(baseUrl, 'movies.json');
      final response = await http.get(url);
      if (response != 'null') {
        final Map<String, dynamic> movieData = json.decode(response.body);
        //Until here it works
        try {
          final url = Uri.https(baseUrl, 'users/$uid/watchlist.json');
          final response = await http.get(url);

          if (response.statusCode != 200) {
            throw Exception('Failed to fetch the watchlist');
          }

          if (response.body != 'null') {
            final Map<String, dynamic> watchListData =
                json.decode(response.body);
            //Fetched watchlist data correct length
            for (final entry in watchListData.entries) {
              final movieId = entry.value;
              for (final movieEntry in movieData.entries) {
                if (movieEntry.value['id'] == movieId) {
                  final movie = Movie(
                      id: movieEntry.value['id'],
                      title: movieEntry.value['title'],
                      description: movieEntry.value['description'],
                      posterPath: movieEntry.value['posterPath']);
                  movie.poster = Image.network(
                      'https://image.tmdb.org/t/p/w600_and_h900_bestv2${movie.posterPath}');
                  movies.add(movie);
                }
              }
            }
          }
        } catch (error) {
          throw Exception('Error fetching watchlist: $error');
        }
      }
    } catch (e) {
      throw Exception('Error fetching: $e');
    }
    return movies;
  }

  /// Duplicated method this can be fixed , but for now it is like this
  static Future<List<Movie>> fetchMylistMovies(String uid) async {
    final List<Movie> movies = [];
    try {
      final url = Uri.https(baseUrl, 'movies.json');
      final response = await http.get(url);
      if (response != 'null') {
        final Map<String, dynamic> movieData = json.decode(response.body);
        //Until here it works
        try {
          final url = Uri.https(baseUrl, 'users/$uid/mylist.json');
          final response = await http.get(url);

          if (response.statusCode != 200) {
            throw Exception('Failed to fetch the mylist');
          }

          if (response.body != 'null') {
            final Map<String, dynamic> watchListData =
                json.decode(response.body);
            //Fetched watchlist data correct length
            for (final entry in watchListData.entries) {
              final movieId = entry.value;
              for (final movieEntry in movieData.entries) {
                if (movieEntry.value['id'] == movieId) {
                  final movie = Movie(
                      id: movieEntry.value['id'],
                      title: movieEntry.value['title'],
                      description: movieEntry.value['description'],
                      posterPath: movieEntry.value['posterPath']);
                  movie.poster = Image.network(
                      'https://image.tmdb.org/t/p/w600_and_h900_bestv2${movie.posterPath}');
                  movies.add(movie);
                }
              }
            }
          }
        } catch (error) {
          throw Exception('Error fetching mylist: $error');
        }
      }
    } catch (e) {
      throw Exception('Error fetching: $e');
    }
    return movies;
  }

  /// Method to add a rating to a movie in backend
  static Future<void> addRatingToMovie(int movieId, Rating rating) async {
    try {
      final movieFirebaseKey = await getFirebaseKeyByMovie(movieId);
      if (movieFirebaseKey == null) {
        throw Exception("Movie not found in Firebase");
      }

      final url = Uri.https(
        baseUrl,
        'movies/$movieFirebaseKey/ratings.json',
      );

      // Send POST request to save rating
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'score': rating.score,
          'review': rating.review,
          'userId': rating.userId,
          'date': rating.date.toIso8601String(),
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Failed to add rating");
      }
    } catch (error) {
      throw Exception("Error adding rating: $error");
    }
  }

  /// Method to fetch ratings for a movie
  static Future<List<Rating>> fetchRatingForMovie(int movieId) async {
    try {
      final firebaseKey = await getFirebaseKeyByMovie(movieId);
      if (firebaseKey == null) return [];

      final url = Uri.https(baseUrl, 'movies/$firebaseKey/ratings.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic>? ratingsData =
            json.decode(response.body) as Map<String, dynamic>?;

        if (ratingsData != null) {
          return ratingsData.values.map((ratingData) {
            return Rating(
              score: ratingData['score'],
              review: ratingData['review'],
              userId: ratingData['userId'],
              date: DateTime.parse(ratingData['date']),
            );
          }).toList();
        }
      }
      return [];
    } catch (error) {
      throw Exception("Error fetching ratings: $error");
    }
  }
}
