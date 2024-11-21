import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:project/models/movie.dart';
import 'package:project/models/rating.dart';

/// Helper class to send http request to backend (Firebase).
class FirebaseService {
  static String baseUrl = dotenv.env['FIREBASE_BASE_URL'] ?? '';

  /// Fetch Firebase key for a movie by its ID, used when interacting with
  /// objects in Firebase
  static Future<String?> getFirebaseKeyByMovieId(int movieId) async {
    try {
      final url = Uri.https(baseUrl, 'saved-movies.json');
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

  /// Method to send http DELETE request to backend (Firebase). To
  /// remove/delete a movie from backend database.
  static Future<void> removeMovieById(int movieId) async {
    try {
      final firebaseKey = await getFirebaseKeyByMovieId(movieId);
      if (firebaseKey == null) {
        throw Exception("Movie not found in Firebase");
      }

      final url = Uri.https(baseUrl, 'saved-movies/$firebaseKey.json');
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

  /// Method to send http POST request to backend (Firebase). To add movie to
  /// backend database.
  static Future<String?> addMovieToFirebase(Movie movie) async {
    try {
      final url = Uri.https(baseUrl, 'saved-movies.json');
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
        throw throw Exception('Failed to add movie to Firebase');
      }
    } catch (error) {
      throw Exception("Error adding movie: $error");
    }
  }

  /// Method to add rating to a movie in backend
  static Future<void> addRatingToMovie(int movieId, Rating rating) async {
    try {
      final movieFirebaseKey = await getFirebaseKeyByMovieId(movieId);
      if (movieFirebaseKey == null) {
        throw Exception("Movie not found in Firebase");
      }

      final url = Uri.https(
        baseUrl,
        'saved-movies/$movieFirebaseKey/ratings.json',
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

  static Future<List<Rating>> fetchRatingForMovie(
      String movieFirebaseKey) async {
    try {
      final url = Uri.https(
        baseUrl,
        'saved-movies/$movieFirebaseKey/ratings.json',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic>? ratingsData =
            json.decode(response.body) as Map<String, dynamic>?;

        if (ratingsData != null) {
          return ratingsData.values.map((ratingsData) {
            return Rating(
              score: ratingsData['score'],
              review: ratingsData['review'],
              userId: ratingsData['userId'],
              date: DateTime.parse(ratingsData['date']),
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
