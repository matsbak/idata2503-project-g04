import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';

class MovieItem extends StatelessWidget {
  const MovieItem({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 16.0,
        ),
        child: Column(
          children: [
            Text(
              movie.title.toUpperCase(),
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              movie.description,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Color.fromARGB(255, 230, 212, 50),
                ),
                Text(
                  movie.rating.toString(),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 230, 212, 50),
                  ),
                ),
                const Spacer(),
                Icon(
                  genreIcons[movie.genre],
                ),
                Text(
                  genreText[movie.genre]!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
