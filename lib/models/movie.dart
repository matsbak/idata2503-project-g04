import 'package:flutter/material.dart';
import 'package:project/models/rating.dart';

enum Genre { action, fantasy, scienceFiction, comedy, horror, drama }

const genreText = {
  Genre.action: 'Action',
  Genre.fantasy: 'Fantasy',
  Genre.scienceFiction: 'Science fiction',
  Genre.comedy: 'Comedy',
  Genre.horror: 'Horror',
  Genre.drama: "Drama",
};

const genreIcons = {
  Genre.action: Icons.flash_on,
  Genre.fantasy: Icons.fort,
  Genre.scienceFiction: Icons.rocket,
  Genre.comedy: Icons.theater_comedy,
  Genre.horror: Icons.sentiment_very_dissatisfied_outlined,
};

class Movie {
  Movie({
    required this.title,
    required this.description,
    this.ratings = const [],
    required this.genre,
    required this.posterUrl,
  });

  final String title;
  final String description;
  List<Rating> ratings;
  final Genre genre;
  final String posterUrl;

  /// Calculate the average rating
  double get averageRating {
    if (ratings.isEmpty) return 0;
    double avg =
        ratings.map((r) => r.score).reduce((a, b) => a + b) / ratings.length;
    return double.parse(avg.toStringAsFixed(2));
  }
}
