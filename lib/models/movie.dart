import 'package:flutter/material.dart';

import 'package:project/models/rating.dart';

class Movie {
  Movie({
    required this.id,
    required this.title,
    required this.description,
    this.ratings = const [],
    this.genres = const [],
    required this.posterPath,
  });

  final int id;
  final String title;
  final String description;
  List<Rating> ratings;
  List<String> genres;
  final String posterPath;
  Image? poster;

  /// Calculate the average rating
  double get averageRating {
    if (ratings.isEmpty) return 0;
    double avg =
        ratings.map((r) => r.score).reduce((a, b) => a + b) / ratings.length;
    return double.parse(avg.toStringAsFixed(2));
  }
}
