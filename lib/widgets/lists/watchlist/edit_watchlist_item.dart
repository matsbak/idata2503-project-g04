import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';

class EditWatchlistItem extends StatelessWidget {
  const EditWatchlistItem(this.movie, {super.key});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(
                top: 40.0,
                bottom: 24.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.asset(
                'assets/images/wall-e.jpg',
                width: 250.0,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  const Icon(Icons.star),
                  const SizedBox(
                    width: 4.0,
                  ),
                  Text(
                    movie.rating.toString(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(movie.description),
            ],
          ),
          const Spacer(),
          FilledButton.tonal(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 242, 108, 98),
            ),
            child: const Row(
              children: [
                Icon(Icons.delete),
                SizedBox(
                  width: 2.0,
                ),
                Text('Remove'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
