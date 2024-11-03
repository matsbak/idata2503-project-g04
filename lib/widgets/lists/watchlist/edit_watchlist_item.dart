import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project/models/movie.dart';
import 'package:project/providers/lists_provider.dart';

class EditWatchlistItem extends ConsumerWidget {
  const EditWatchlistItem(this.movie, {super.key});

  final Movie movie;

  void _removeFromWatchlist(BuildContext context, WidgetRef ref) {
    ref.read(watchlistProvider.notifier).removeFromWatchlist(movie);

    Navigator.pop(context);

    final String movieTitle = movie.title;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$movieTitle removed from watchlist'),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(
        top: 20.0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              size: 28.0,
              color: Colors.white,
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(
                top: 10.0,
                bottom: 24.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                movie.posterUrl,
                width: 250.0,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  const Icon(Icons.star),
                  const SizedBox(
                    width: 4.0,
                  ),
                  Text(
                    movie.rating.toString(),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                movie.description,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ],
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: FilledButton.tonal(
              onPressed: () {
                _removeFromWatchlist(context, ref);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  Text(
                    'Remove',
                    style: TextStyle(
                      color: Colors.white,
                    ),
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
