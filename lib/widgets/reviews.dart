import 'package:flutter/material.dart';
import 'package:project/models/rating.dart';

/// Represents the lists of reviews shown at the movie details screen
class Reviews extends StatelessWidget {
  const Reviews({super.key, required this.ratings});

  final List<Rating> ratings;

  @override
  Widget build(BuildContext context) {
    if (ratings.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          "No Reviews yet.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ratings.length,
      itemBuilder: (context, index) {
        final rating = ratings[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rating: ${rating.score} / 5.0",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rating.comment,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "by ${rating.userId} on ${rating.date.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
