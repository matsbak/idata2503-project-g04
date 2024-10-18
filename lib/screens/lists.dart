import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';
import 'package:project/widgets/lists/lists_button.dart';
import 'package:project/widgets/lists/my_list/my_list.dart';
import 'package:project/widgets/lists/watchlist/watchlist.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ListsScreenState();
  }
}

class _ListsScreenState extends State<ListsScreen> {
  final List<Movie> _registeredMovies = [
    Movie(
      title: 'Wall-E',
      description:
          'A robot who is responsible for cleaning a waste-covered Earth meets another robot and falls in love with her. Together, they set out on a journey that will alter the fate of mankind.',
      rating: 5.0,
      genre: Genre.scienceFiction,
      posterUrl: '',
    ),
  ];

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
          if (_currentList == 'watchlist') Watchlist(movies: _registeredMovies),
          if (_currentList == 'mylist') MyList(movies: _registeredMovies),
        ],
      ),
    );
  }
}
