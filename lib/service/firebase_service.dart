import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:project/models/movie.dart';
import 'package:project/models/rating.dart';

class FirebaseService {
  static String baseUrl = dotenv.env['FIREBASE_BASE_URL'] ?? '';

  /// Fetch Firebase key for a movie by its ID within a specific user's collection
  static Future<String?> getFirebaseKeyByMovieId(
      int movieId, String uid) async {
    try {
      final url = Uri.https(baseUrl, 'users/$uid/watchlist.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> moviesData =
            json.decode(response.body) as Map<String, dynamic>;
        for (var entry in moviesData.entries) {
          if (entry.value['id'] == movieId) {
            return entry.key; // Return the Firebase key
          }
        }
      }
      return null; // Return null if not found.
    } catch (error) {
      throw Exception("Error fetching Firebase key: $error");
    }
  }

  static Future<String?> getFirebaseKeyByMovieIdInMyList(
      int movieId, String uid) async {
    try {
      final url = Uri.https(baseUrl, 'users/$uid/mylist.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> moviesData =
            json.decode(response.body) as Map<String, dynamic>;
        for (var entry in moviesData.entries) {
          if (entry.value['id'] == movieId) {
            return entry.key; // Return the Firebase key
          }
        }
      }
      return null; // Return null if not found.
    } catch (error) {
      throw Exception("Error fetching Firebase key: $error");
    }
  }

  /// Method to send http DELETE request to backend (Firebase) to remove a movie from a user's collection
  static Future<void> removeMovieFromWatchlist(int movieId, String uid) async {
    try {
      final firebaseKey = await getFirebaseKeyByMovieId(movieId, uid);
      if (firebaseKey == null) {
        throw Exception("Movie not found in Firebase");
      }

      final url = Uri.https(baseUrl, 'users/$uid/watchlist/$firebaseKey.json');
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        throw Exception(
          "Failed to delete movie from Firebase. Status code: ${response.statusCode}",
        );
      }
    } catch (error) {
      throw Exception("Error deleting movie: $error");
    }
  }

  //Removes a movie from mylist
  static Future<void> removeMovieFromMylist(int movieId, String uid) async {
    try {
      final firebaseKey = await getFirebaseKeyByMovieIdInMyList(movieId, uid);
      if (firebaseKey == null) {
        throw Exception("Movie not found in Firebase");
      }

      final url = Uri.https(baseUrl, 'users/$uid/mylist/$firebaseKey.json');
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        throw Exception(
          "Failed to delete movie from Firebase. Status code: ${response.statusCode}",
        );
      }
    } catch (error) {
      throw Exception("Error deleting movie: $error");
    }
  }

  /// Method to send http POST request to backend (Firebase) to add a movie to a user's collection
  static Future<String?> addMovieToWatchlist(Movie movie, String uid) async {
    try {
      final url = Uri.https(baseUrl, 'users/$uid/watchlist.json');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': movie.id,
          'title': movie.title,
          'description': movie.description,
          'posterPath': movie.posterPath,
        }),
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
    await removeMovieFromWatchlist(movie.id, uid);
    try {
      final url = Uri.https(baseUrl, 'users/$uid/mylist.json');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': movie.id,
          'title': movie.title,
          'description': movie.description,
          'posterPath': movie.posterPath,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return responseData['name'];
      } else {
        throw Exception('Failed to add movie to Firebase');
      }
    } catch (error) {
      throw Exception("Error adding movie to mylist: $error");
    }
  }

  /// Method to add a rating to a movie in backend
  static Future<void> addRatingToMovie(int movieId, Rating rating) async {
    try {
      final movieFirebaseKey =
          await getFirebaseKeyByMovieIdInMyList(movieId, rating.userId);
      if (movieFirebaseKey == null) {
        throw Exception("Movie not found in Firebase");
      }

      final url = Uri.https(
        baseUrl,
        'users/${rating.userId}/saved-movies/$movieFirebaseKey/ratings.json',
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
      final url = Uri.https(baseUrl, 'shared-movies/$movieId/ratings.json');
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
