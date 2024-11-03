import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project/providers/lists_provider.dart';
import 'package:project/widgets/lists/lists_button.dart';
import 'package:project/widgets/lists/my_list/my_list.dart';
import 'package:project/widgets/lists/watchlist/watchlist.dart';

class ListsScreen extends ConsumerStatefulWidget {
  const ListsScreen({super.key});

  @override
  ConsumerState<ListsScreen> createState() {
    return _ListsScreenState();
  }
}

class _ListsScreenState extends ConsumerState<ListsScreen> {
  String _currentList = 'watchlist';

  bool _isWatchlistActive = true;
  bool _isMyListActive = false;

  void switchToWatchlist() {
    setState(() {
      _currentList = 'watchlist';
      _isWatchlistActive = true;
      _isMyListActive = false;
    });
  }

  void switchToMyList() {
    setState(() {
      _currentList = 'mylist';
      _isWatchlistActive = false;
      _isMyListActive = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              ListsButton(
                text: 'Watchlist',
                isActive: _isWatchlistActive,
                onClick: switchToWatchlist,
              ),
              const Spacer(),
              ListsButton(
                text: 'My List',
                isActive: _isMyListActive,
                onClick: switchToMyList,
              ),
            ],
          ),
          if (_currentList == 'watchlist') Watchlist(movies: ref.watch(watchlistProvider)),
          if (_currentList == 'mylist') MyList(movies: ref.watch(myListProvider)),
        ],
      ),
    );
  }
}
