import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:project/models/movie.dart';
import 'package:project/screens/explore_screen.dart';
import 'package:project/screens/lists_screen.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/screens/search_screen.dart';
import 'package:project/services/api_service.dart';
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
    final client = http.Client();

    try {
      // Fetch all movies
      final List<Movie> fetchedMovies = await ApiService.fetchMovies(client);
      // Fetch all movie genres and the movie poster for each fetched movie
      for (final movie in fetchedMovies) {
        movie.genres = await ApiService.fetchMovieGenres(movie, client);
        movie.poster = ApiService.fetchMoviePoster(movie);
      }
      // Apply fetched movie to registered movies
      setState(() {
        _registeredMovies = [...fetchedMovies];
        _isLoading = false;
      });
    } catch (e) {
      // Check if error is caused by failed data fetch or not
      if (e.toString() == 'Exception') {
        setState(() {
          _error = 'Failed to fetch data';
        });
      } else {
        setState(() {
          _error = 'Something went wrong';
        });
      }
    } finally {
      client.close();
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
      activePage = SearchScreen(movies: _registeredMovies);
    } else if (_selectedPageIndex == 3) {
      activePage = const ListsScreen();
    } else if (_selectedPageIndex == 4) {
      activePage = const ProfileScreen();
    }

    Widget content = activePage;

    if (_isLoading) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Fetching movies for you',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'Please wait...',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            const CircularProgressIndicator(),
          ],
        ),
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
