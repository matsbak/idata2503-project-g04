import 'package:flutter/material.dart';
import 'package:project/models/movie.dart';

class ExploreListItem extends StatelessWidget {
  const ExploreListItem({
    super.key,
    required this.posterUrl,
    required this.movie,
    // required this.onSelectedMovie,
  });

  final Movie movie;
  final String posterUrl;
  // final void Function() onSelectedMovie;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: onSelectedMovie,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(posterUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
