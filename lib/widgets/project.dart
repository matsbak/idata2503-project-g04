import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';
import 'package:project/screens/explore_screen.dart';
import 'package:project/widgets/movie/movie_list.dart';

class Project extends StatefulWidget {
  const Project({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProjectState();
  }
}

class _ProjectState extends State<Project> {
  final List<Movie> _registeredMovies = [
    Movie(
      title: 'Wall-E',
      description:
          'A robot who is responsible for cleaning a waste-covered Earth meets another robot and falls in love with her. Together, they set out on a journey that will alter the fate of mankind.',
      rating: 5.0,
      genre: Genre.scienceFiction,
      posterUrl:
          'https://m.media-amazon.com/images/M/MV5BMTUzNTc3MTU3M15BMl5BanBnXkFtZTcwMzIxNTc3NA@@._V1_FMjpg_UX1000_.jpg',
    ),
    Movie(
      title: 'Wall-E',
      description:
          'A robot who is responsible for cleaning a waste-covered Earth meets another robot and falls in love with her. Together, they set out on a journey that will alter the fate of mankind.',
      rating: 5.0,
      genre: Genre.action,
      posterUrl: '',
    ),
    Movie(
      title: 'Wall-E',
      description:
          'A robot who is responsible for cleaning a waste-covered Earth meets another robot and falls in love with her. Together, they set out on a journey that will alter the fate of mankind.',
      rating: 5.0,
      genre: Genre.comedy,
      posterUrl: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'MOVIE RATER',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          //child: MovieList(movies: _registeredMovies),
          child: ExploreScreen(movies: _registeredMovies),
        ),
      ),
    );
  }
}
