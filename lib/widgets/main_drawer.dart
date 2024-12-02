import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
    required this.onSelectMovies,
  });

  final void Function(String movies) onSelectMovies;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 120.0,
            child: DrawerHeader(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.movie_outlined,
                    size: 30.0,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    'Movies',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.adjust,
              color: Colors.white,
            ),
            title: Text(
              'All Movies',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
            onTap: () {
              onSelectMovies('all');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.trending_up,
              color: Colors.white,
            ),
            title: Text(
              'Popular Movies',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
            onTap: () {
              onSelectMovies('popular');
            },
          ),
        ],
      ),
    );
  }
}
