import 'package:flutter/material.dart';
import 'package:project/models/movie.dart';

class ExploreListItem extends StatelessWidget {
  const ExploreListItem({
    super.key,
    required this.movie,
    // required this.onSelectedMovie,
  });

  final Movie movie;
  // final void Function() onSelectedMovie;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: onSelectedMovie,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        width: 120,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                movie.posterUrl,
                fit: BoxFit.cover,
                height: 160,
                width: 120,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              movie.title,
              style: TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
