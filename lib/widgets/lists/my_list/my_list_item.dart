import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';

class MyListItem extends StatelessWidget {
  const MyListItem({
    super.key,
    required this.movie,
  });

  final Movie movie;

  // TODO Add padding on card without affecting image
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/wall-e.jpg',
            width: 80.0,
            height: 80.0,
            fit: BoxFit.cover,
          ),
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
              Icon(Icons.star_border),
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
    );
  }
}
