import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';
import 'package:project/widgets/lists/watchlist/watchlist_modal.dart';

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
      builder: (ctx) => WatchlistModal(movie),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 4.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: InkWell(
        onTap: () {
          _openWatchlistOverlay(widget.movie);
        },
        child: Row(
          children: [
            SizedBox(
              width: 80.0,
              height: 80.0,
              child: FittedBox(
                fit: BoxFit.cover,
                child: widget.movie.poster,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.movie.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
