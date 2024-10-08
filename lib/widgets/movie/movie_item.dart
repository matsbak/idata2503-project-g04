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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Card corner radius
      ),
      clipBehavior:
          Clip.antiAlias, // Clips the child widgets to the card's border radius
      child: Row(
        children: [
          Expanded(
            flex: 3, // Set flex for the image, adjust as needed
            child: Image.asset(
              'assets/images/cars2.jpg',
              fit: BoxFit.cover, // Fills the container with the image
              height: 150, // Adjust height of the image
            ),
          ),
          Expanded(
            flex: 5, // Adjust flex for content
            child: Padding(
              padding:
                  const EdgeInsets.all(16.0), // Padding around the text content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
