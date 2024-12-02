import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';
import 'package:project/models/rating.dart';
import 'package:project/services/firebase_service.dart';
import 'package:project/widgets/lists/my_list/my_list_modal.dart';

class MyListItem extends StatefulWidget {
  const MyListItem({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  State<MyListItem> createState() {
    return _MyListItemState();
  }
}

class _MyListItemState extends State<MyListItem> {
  double _userRating = 0.0;

  void _openMyListOverlay(Movie movie) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => MyListModal(movie),
    );
  }

  void _fetchUserRating(String email) async {
    List<Rating> ratings =
        await FirebaseService.fetchRatingForMovie(widget.movie.id);

    for (final rating in ratings) {
      if (rating.userId == email) {
        _userRating = rating.score;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current Firebase user
    final user = FirebaseAuth.instance.currentUser;
    // Retrieve the user's email
    final String email = user?.email ?? 'user@example.com';

    _fetchUserRating(email);

    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 4.0,
      ),
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
            SizedBox(
              width: 80.0,
              height: 80.0,
              child: FittedBox(
                fit: BoxFit.cover,
                child: widget.movie.poster,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.movie.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.star_border),
                        const SizedBox(width: 2.0),
                        Text(
                          _userRating.toString(),
                          style: const TextStyle(
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
