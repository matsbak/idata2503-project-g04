import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/models/movie.dart';

/// Helper class to send http request to backend (Firebase).
class FirebaseService {
  static const String baseUrl =
      'idata2503-project-g04-default-rtdb.europe-west1.firebasedatabase.app';

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
}
