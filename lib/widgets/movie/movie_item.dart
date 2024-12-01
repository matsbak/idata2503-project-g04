import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project/models/movie.dart';
import 'package:project/providers/ratings_notifier.dart';
import 'package:project/screens/movie_detail_screen.dart';
import 'package:project/widgets/starbuilder.dart';

/// Represents a Movie Card viewed on start page
class MovieItem extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final averageRating = ref.watch(ratingsProvider.notifier).averageRating;
    return InkWell(
      onTap: () => _onSelectedMovie(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                width: 100,
                height: 120,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: movie.poster,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                        StarBuilder(rating: averageRating),
                        Text(
                          averageRating.toStringAsFixed(1),
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
