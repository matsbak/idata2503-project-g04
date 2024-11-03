import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';
import 'package:project/widgets/lists/watchlist/watchlist_item.dart';

class Watchlist extends StatelessWidget {
  const Watchlist({
    super.key,
    required this.movies,
  });

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 4.0,
        ),
        child: ListView.builder(
          itemCount: movies.length,
          itemBuilder: (ctx, index) => WatchlistItem(
            movie: movies[index],
          ),
        ),
      ),
    );
  }
}
