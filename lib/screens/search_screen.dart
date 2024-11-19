import 'dart:async';

import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';
import 'package:project/screens/movie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.movies,
  });

  final List<Movie> movies;

  @override
  State<SearchScreen> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Movie> _searchResults = [];
  List<String> _recentSearches = [];
  Timer? _debounce;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchResults = widget.movies;

    // Add a listener to handle focus changes
    _focusNode.addListener(() {
      setState(() {
        _isSearching = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = widget.movies
            .where((movie) =>
                movie.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  void _selectMovie(Movie movie) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MovieDetailScreen(movie: movie),
      ),
    );

    final movieTitle = movie.title;
    if (!_recentSearches.contains(movieTitle)) {
      setState(() {
        _recentSearches.insert(0, movieTitle);
        if (_recentSearches.length > 5) _recentSearches.removeLast();
      });
    }
    _focusNode.unfocus(); // Remove focus to show the movie list again
  }

  void _clearSearch() {
    _searchController.clear();
    _performSearch('');
    _focusNode.unfocus(); // Remove focus to show the movie list again
  }

  void _unfocusSearchBar() {
    setState(() {
      _isSearching = false;
    });
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocusSearchBar,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Search',
                labelStyle: const TextStyle(color: Colors.white),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
              onSubmitted: _performSearch, // Handle "Enter" key press
            ),
          ),
          if (_isSearching &&
              _searchController.text.isEmpty &&
              _recentSearches.isNotEmpty)
            Expanded(
              child: ListView.separated(
                itemCount: _recentSearches.length,
                separatorBuilder: (ctx, index) =>
                    const Divider(color: Colors.grey),
                itemBuilder: (ctx, index) {
                  final search = _recentSearches[index];
                  return GestureDetector(
                    onTap: () {
                      _searchController.text = search;
                      _performSearch(search);
                      _focusNode
                          .unfocus(); // Dismiss keyboard after selecting a recent search
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Text(
                        search,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            )
          else if (!_isSearching && _searchController.text.isEmpty)
            // Show the full movie list when not interacting with the search bar and no input is given
            Expanded(
              child: ListView.separated(
                itemCount: widget.movies.length,
                separatorBuilder: (ctx, index) =>
                    const Divider(color: Colors.grey),
                itemBuilder: (ctx, index) {
                  final movie = widget.movies[index];
                  return ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: movie.poster,
                      ),
                    ),
                    title: Text(movie.title,
                        style: const TextStyle(color: Colors.white)),
                    onTap: () => _selectMovie(movie),
                  );
                },
              ),
            )
          else if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
            // Show an error message when no results are found
            const Expanded(
              child: Center(
                child: Text(
                  '😢 Sorry... we found no results...',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            )
          else if (_searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (ctx, index) {
                  final movie = _searchResults[index];
                  return ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: movie.poster,
                      ),
                    ),
                    title: Text(movie.title,
                        style: const TextStyle(color: Colors.white)),
                    onTap: () => _selectMovie(movie),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
