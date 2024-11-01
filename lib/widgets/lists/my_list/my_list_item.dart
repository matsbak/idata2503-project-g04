import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';
import 'package:project/widgets/lists/my_list/edit_my_list_item.dart';

class MyListItem extends StatefulWidget {
  const MyListItem({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  State<MyListItem> createState() => _MyListItemState();
}

class _MyListItemState extends State<MyListItem> {
  void _openMyListOverlay(Movie movie) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => EditMyListItem(movie),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: InkWell(
        onTap: () {
          _openMyListOverlay(widget.movie);
        },
        child: Row(
          children: [
            Image.asset(
              'assets/images/wall-e.jpg',
              width: 80.0,
              height: 80.0,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Row(
                  children: [
                    Text(
                      widget.movie.title,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.edit),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
