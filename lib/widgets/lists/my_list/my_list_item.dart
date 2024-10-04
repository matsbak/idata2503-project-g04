import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';

class MyListItem extends StatelessWidget {
  const MyListItem({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 16.0,
        ),
        child: Row(
          children: [
            Text(
              movie.title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Row(
              children: [
                Icon(Icons.star),
                SizedBox(width: 2.0),
                Text(
                  '4.5',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.edit),
          ],
        ),
      ),
    );
  }
}
