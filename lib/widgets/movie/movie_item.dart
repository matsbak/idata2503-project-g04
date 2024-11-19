import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';
import 'package:project/screens/movie_detail_screen.dart';
import 'package:project/widgets/starbuilder.dart';

class MovieItem extends StatelessWidget {
  const MovieItem({
    super.key,
    required this.movie,
  });

  final Movie movie;

  //Duplicated code the same as in explore_list_item.dart
  void _onSelectedMovie(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => MovieDetailScreen(movie: movie)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onSelectedMovie(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Card corner radius
        ),
        clipBehavior: Clip
            .antiAlias, // Clips the child widgets to the card's border radius
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Row(
          children: [
            Expanded(
              flex: 3, // Set flex for the image, adjust as needed
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  height: 100,
                  child: movie.poster,
                ),
              ),
            ),
            Expanded(
              flex: 5, // Adjust flex for content
              child: Padding(
                padding: const EdgeInsets.all(
                    16.0), // Padding around the text content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        StarBuilder(rating: movie.averageRating),
                        Text(
                          movie.averageRating.toString(),
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
      ),
    );
  }
}
