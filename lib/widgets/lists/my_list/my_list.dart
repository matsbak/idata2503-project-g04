import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';
import 'package:project/widgets/lists/my_list/my_list_item.dart';

class MyList extends StatelessWidget {
  const MyList({
    super.key,
    required this.movies,
  });

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 24.0,
        ),
        child: ListView.builder(
          itemCount: movies.length,
          itemBuilder: (ctx, index) => MyListItem(
            movie: movies[index],
          ),
        ),
      ),
    );
  }
}
