import 'package:flutter/material.dart';
import 'package:project/data/dummy_data.dart';
import 'package:project/models/movie.dart';
import 'package:project/screens/explore_screen.dart';
import 'package:project/screens/lists.dart';
import 'package:project/screens/profilepage.dart';
import 'package:project/widgets/movie/movie_list.dart';
import 'package:project/screens/search_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Movie> _registeredMovies = dummyMovies;
  int _selectedPageIndex = 0;

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
    Widget activePage =
        MovieList(movies: _registeredMovies); // Default assignment

    if (_selectedPageIndex == 1) {
      activePage = ExploreScreen(movies: _registeredMovies);
    } else if (_selectedPageIndex == 2) {
      activePage = const SearchScreen();
    } else if (_selectedPageIndex == 3) {
      activePage = const ListsScreen();
    } else if (_selectedPageIndex == 4) {
      activePage = ProfilePage(); // Profile page when selected
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Spacer(),
            Text(
              'Movie Rater'.toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.account_circle),
              style: IconButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              onPressed: _navigateToProfile, // Navigate to profile page
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      backgroundColor: const Color.fromARGB(255, 35, 30, 30),
      body: activePage,
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
