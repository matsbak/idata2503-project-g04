import 'package:flutter/material.dart';
import 'package:project/models/movie.dart';
import 'package:project/data/dummy_data.dart';
import 'package:project/screens/movie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResults = [];
  final List<Movie> _dummyMovies = dummyMovies;

  void _performSearch(String query) {
    setState(() {
      _searchResults = _dummyMovies
          .where((movie) => movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectMovie(Movie movie) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (ctx) => MovieDetailScreen(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: _performSearch,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (ctx, index) {
                final movie = _searchResults[index];
                return Card(
                  child: ListTile(
                    title: Text(movie.title),
                    subtitle: Text(movie.description),
                    onTap: () => _selectMovie(movie),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}