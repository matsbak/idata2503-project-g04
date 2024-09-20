import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';
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
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'MOVIE RATER',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 60, 60, 60),
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 80, 80, 80),
          ),
          child: MovieList(movies: _registeredMovies),
        ),
      ),
    );
  }
}
