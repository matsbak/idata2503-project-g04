import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project/models/movie.dart';
import 'package:project/providers/lists_provider.dart';

class EditWatchlistItem extends ConsumerStatefulWidget {
  const EditWatchlistItem(this.movie, {super.key});

  final Movie movie;

  @override
  ConsumerState<EditWatchlistItem> createState() {
    return _EditWatchlistItemState();
  }
}

class _EditWatchlistItemState extends ConsumerState<EditWatchlistItem> {
  bool isAddedToMyList = false;

  void _removeFromWatchlist(BuildContext context, String title) {
    ref.read(watchlistProvider.notifier).removeFromWatchlist(widget.movie);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$title removed from watchlist'),
    ));
  }

  void _addToMyList() {
    ref.read(myListProvider.notifier).addToMyList(widget.movie);
    ref.read(watchlistProvider.notifier).removeFromWatchlist(widget.movie);
    setState(() {
      isAddedToMyList = true;
    });
  }

  void _removeFromMyList() {
    ref.read(myListProvider.notifier).removeFromMyList(widget.movie);
    ref.read(watchlistProvider.notifier).addToWatchlist(widget.movie);
    setState(() {
      isAddedToMyList = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                widget.movie.posterUrl,
                width: 250.0,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.movie.title,
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
                    widget.movie.averageRating.toString(),
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
                widget.movie.description,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text('Done watching?',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
          const SizedBox(
            height: 8.0,
          ),
          FilledButton(
            onPressed: isAddedToMyList
                ? () {
                    _removeFromMyList();
                  }
                : () {
                    _addToMyList();
                  },
            child: SizedBox(
              width: 125.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isAddedToMyList
                      ? const Icon(Icons.check)
                      : const Icon(Icons.add),
                  const SizedBox(
                    width: 2.0,
                  ),
                  const Text('Add to my list'),
                ],
              ),
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: FilledButton.tonal(
              onPressed: () {
                _removeFromWatchlist(context, widget.movie.title);
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
