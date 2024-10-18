import 'package:flutter/material.dart';

enum Genre { action, fantasy, scienceFiction, comedy, horror }

const genreText = {
  Genre.action: 'Action',
  Genre.fantasy: 'Fantasy',
  Genre.scienceFiction: 'Science fiction',
  Genre.comedy: 'Comedy',
  Genre.horror: 'Horror',
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
    required this.rating,
    required this.genre,
    required this.posterUrl,
  });

  final String title;
  final String description;
  final double rating;
  final Genre genre;
  final String posterUrl;
}
