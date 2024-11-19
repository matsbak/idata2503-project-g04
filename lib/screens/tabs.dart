import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:project/models/movie.dart';
import 'package:project/screens/explore_screen.dart';
import 'package:project/screens/lists.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/screens/search_screen.dart';
import 'package:project/widgets/movie/movie_list.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  List<Movie> _registeredMovies = [];
  int _selectedPageIndex = 0;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  void _loadMovies() async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?language=en-US&page=1',
    );
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${dotenv.env['API_KEY']}',
          'accept': 'application/json',
        },
      );

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data';
        });
      }

      if (_error == null) {
        final Map<String, dynamic> movieData = json.decode(response.body);
        final List<Movie> loadedMovies = [];

        for (final movie in movieData['results']) {
          final loadedMovie = Movie(
            id: movie['id'],
            title: movie['title'],
            description: movie['overview'],
            posterPath: movie['poster_path'],
          );

          // Get posters for each movie
          loadedMovie.poster = Image.network(
              'https://image.tmdb.org/t/p/w600_and_h900_bestv2${loadedMovie.posterPath}');

          // Load genres for each movie
          _loadMovieGenres(loadedMovie);

          loadedMovies.add(loadedMovie);
        }

        // Check for error once more after loading genres
        if (_error == null) {
          setState(() {
            _registeredMovies = loadedMovies;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _error = 'Something went wrong';
      });
    }
  }

  void _loadMovieGenres(Movie movie) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/${movie.id}?language=en-US',
    );
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${dotenv.env['API_KEY']}',
          'accept': 'application/json',
        },
      );

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data';
        });
      }

      if (_error == null) {
        final Map<String, dynamic> movieDetailsData =
            json.decode(response.body);
        final List<String> loadedGenres = [];

        for (final genre in movieDetailsData['genres']) {
          loadedGenres.add(genre['name']);
        }

        movie.genres = loadedGenres;
      }
    } catch (e) {
      setState(() {
        _error = 'Something went wrong';
      });
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _navigateToProfile() {
    setState(() {
      _selectedPageIndex = 4; // A unique index for ProfilePage
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = MovieList(movies: _registeredMovies);

    if (_selectedPageIndex == 1) {
      activePage = ExploreScreen(movies: _registeredMovies);
    } else if (_selectedPageIndex == 2) {
      activePage = const SearchScreen();
    } else if (_selectedPageIndex == 3) {
      activePage = const ListsScreen();
    } else if (_selectedPageIndex == 4) {
      activePage = const ProfileScreen();
    }

    Widget content = activePage;

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      content = Center(
        child: Text(
          _error!,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.white,
              ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movie Rater'.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 5.0,
            ),
            child: IconButton(
              icon: const Icon(Icons.account_circle),
              style: IconButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              onPressed: _navigateToProfile, // Navigate to profile page
            ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      backgroundColor: const Color.fromARGB(255, 35, 30, 30),
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex < 4 ? _selectedPageIndex : 0,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined, color: Colors.white),
            label: 'Home',
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore_outlined, color: Colors.white),
            label: 'Explore',
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search_outlined, color: Colors.white),
            label: 'Search',
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_outlined, color: Colors.white),
            label: 'My List',
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        ],
        selectedItemColor: Colors.white,
      ),
    );
  }
}
