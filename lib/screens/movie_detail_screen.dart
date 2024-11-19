import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:project/models/movie.dart';
import 'package:project/providers/lists_provider.dart';
import 'package:project/service/FirebaseService.dart';
import 'package:project/widgets/reviews.dart';
import 'package:project/widgets/starbuilder.dart';

/// A screen representing the movie details screen. This screen shows a movie
/// with every detail the movie has.
class MovieDetailScreen extends ConsumerStatefulWidget {
  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  @override
  ConsumerState<MovieDetailScreen> createState() {
    return _MovieDetailScreenState();
  }

  final Movie movie;
}

class _MovieDetailScreenState extends ConsumerState<MovieDetailScreen> {
  bool _isLoading = true;
  String? _error;

  void _loadGenres() async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/${widget.movie.id}?language=en-US',
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

        setState(() {
          widget.movie.genres = loadedGenres;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Something went wrong';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadGenres();
  }

  /// Adds a movie to the watch list
  void _addToWatchList(BuildContext context, WidgetRef ref) async {
    try {
      final firebaseKey =
          await FirebaseService.addMovieToFirebase(widget.movie);
      if (firebaseKey != null) {
        ref.read(watchlistProvider.notifier).addToWatchlist(widget.movie);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Movie added to watchlist')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add movie to watchlist: $error")),
      );
    }
  }

  /// Removes a movie from the watch list
  void _removeFromWatchList(BuildContext context, WidgetRef ref) async {
    try {
      await FirebaseService.removeMovieById(widget.movie.id);

      ref.read(watchlistProvider.notifier).removeFromWatchlist(widget.movie);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Movie removed from watchlist')));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to remove moive to watchlist: $error"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final watchlist = ref.watch(watchlistProvider);
    final myList = ref.watch(myListProvider);
    final isInLists =
        watchlist.contains(widget.movie) || myList.contains(widget.movie);

    List<Widget> genresContent = [const CircularProgressIndicator()];

    if (!_isLoading) {
      genresContent = [];
      for (final genre in widget.movie.genres) {
        genresContent = [
          ...genresContent,
          Text(
            genre,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ];
      }
    }

    if (_error != null) {
      genresContent = [
        Text(
          _error!,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.movie.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 200,
                    child: widget.movie.poster,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.movie.title,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Rating: ${widget.movie.averageRating}',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${widget.movie.ratings.length})',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      StarBuilder(rating: widget.movie.averageRating),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (isInLists) {
                        _removeFromWatchList(context, ref);
                      } else {
                        _addToWatchList(context, ref);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer),
                    child: Text(
                      isInLists ? 'Remove from Watchlist' : 'Add to Watchlist',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Genres:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              ...genresContent,
              const SizedBox(height: 20),
              Text(
                widget.movie.description,
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              const SizedBox(height: 12),
              Reviews(ratings: widget.movie.ratings),
            ],
          ),
        ),
      ),
    );
  }
}
