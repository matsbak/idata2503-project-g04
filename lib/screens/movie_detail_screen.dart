import 'package:flutter/material.dart';
import 'package:project/models/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  final Movie movie;

  String get genreText {
    return movie.genre.name[0].toUpperCase() + movie.genre.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    movie.posterUrl,
                    height: 300,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                movie.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Rating: ${movie.rating}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 10),
                  _buildStarRating(movie.rating),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Genre: $genreText',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Text(
                movie.description,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildStarRating(double rating) {
  int fullStars = rating.floor();
  bool hasHalfStar = (rating - fullStars) >= 0.5;
  List<Widget> stars = [];

  for (int i = 0; i < fullStars; i++) {
    stars.add(const Icon(
      Icons.star,
      color: Colors.amber,
      size: 24,
    ));
  }

  if (hasHalfStar) {
    stars.add(const Icon(
      Icons.star_half,
      color: Colors.amber,
      size: 24,
    ));
  }

  while (stars.length < 5) {
    stars.add(const Icon(
      Icons.star_border,
      color: Colors.amber,
      size: 24,
    ));
  }

  return Row(children: stars);
}
