import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';

class EditMyListItem extends StatelessWidget {
  const EditMyListItem(this.movie, {super.key});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Text('My List overlay'), // Placeholder
        ],
      ),
    );
  }
}
