import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project/models/movie.dart';
import 'package:project/providers/lists_provider.dart';
import 'package:project/widgets/lists/watchlist/watchlist_item.dart';

class Watchlist extends ConsumerWidget {
  const Watchlist({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //ref.invalidate(watchlistProvider);
    final movies = ref.watch(watchlistProvider);
    //return Expanded(
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 4.0,
      ),
      child: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (ctx, index) => WatchlistItem(
          movie: movies[index],
        ),
      ),
    );
    // );
  }
}
