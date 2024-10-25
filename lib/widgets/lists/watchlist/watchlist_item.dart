import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';
import 'package:project/widgets/lists/watchlist/edit_watchlist_item.dart';

class WatchlistItem extends StatefulWidget {
  const WatchlistItem({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  State<WatchlistItem> createState() => _WatchlistItemState();
}

class _WatchlistItemState extends State<WatchlistItem> {
  void _openWatchlistOverlay(Movie movie) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => EditWatchlistItem(movie),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          _openWatchlistOverlay(widget.movie);
        },
        child: Row(
          children: [
            Image.asset(
              'assets/images/wall-e.jpg',
              width: 80.0,
              height: 80.0,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Row(
                  children: [
                    Text(
                      widget.movie.title,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.edit),
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
