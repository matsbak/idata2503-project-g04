import 'package:flutter/material.dart';

/// Widget to create the rating stars a movie has. Based on the rating,
/// the widget represents the rating in the form of stars or halv-stars
class StarBuilder extends StatelessWidget {
  final double rating;

  const StarBuilder({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    List<Widget> stars = [];

    // Add full stars
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(
        Icons.star,
        color: Colors.amber,
        size: 24,
      ));
    }

    // Add half star if applicable
    if (hasHalfStar) {
      stars.add(const Icon(
        Icons.star_half,
        color: Colors.amber,
        size: 24,
      ));
    }

    // Add remaining empty stars
    while (stars.length < 5) {
      stars.add(const Icon(
        Icons.star_border,
        color: Colors.amber,
        size: 24,
      ));
    }

    return Row(children: stars);
  }
}
