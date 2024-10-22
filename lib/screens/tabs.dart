import 'package:flutter/material.dart';
import 'package:project/models/movie.dart';
import 'package:project/screens/explore_screen.dart';
import 'package:project/screens/lists.dart';
import 'package:project/widgets/movie/movie_list.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Movie> _registeredMovies = [
    Movie(
      title: 'Wall-E',
      description:
          'A robot who is responsible for cleaning a waste-covered Earth meets another robot and falls in love with her. Together, they set out on a journey that will alter the fate of mankind.',
      rating: 4.5,
      genre: Genre.scienceFiction,
      posterUrl:
          'https://m.media-amazon.com/images/M/MV5BMTUzNTc3MTU3M15BMl5BanBnXkFtZTcwMzIxNTc3NA@@._V1_FMjpg_UX1000_.jpg',
    ),
    Movie(
      title: 'Cars',
      description:
          'On the way to the biggest race of his life, a hotshot rookie race car gets stranded in a rundown town and learns that winning isn\'t everything in life.',
      rating: 5.0,
      genre: Genre.action,
      posterUrl:
          'https://m.media-amazon.com/images/M/MV5BMTUzNTc3MTU3M15BMl5BanBnXkFtZTcwMzIxNTc3NA@@._V1_FMjpg_UX1000_.jpg',
    ),
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO Change `MovieList` widget into screen widget
    Widget activePage = MovieList(movies: _registeredMovies);

    if (_selectedPageIndex == 1) {
      activePage = ExploreScreen(movies: _registeredMovies);
    } else if (_selectedPageIndex == 2) {
      // TODO Add search screen widget
      // activePage = const SearchScreen();
    } else if (_selectedPageIndex == 3) {
      activePage = const ListsScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movie rater'.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      backgroundColor: Colors.white,
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home_outlined,
              color: Colors.black,
            ),
            label: 'Home',
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.explore_outlined,
              color: Colors.black,
            ),
            label: 'Explore',
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.search_outlined,
              color: Colors.black,
            ),
            label: 'Search',
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.list_outlined,
              color: Colors.black,
            ),
            label: 'My List',
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        ],
        selectedItemColor: Colors.black,
      ),
    );
  }
}
