/// Represetns a rating
class Rating {
  Rating({
    required this.score,
    required this.review,
    required this.userId,
    required this.date,
  });

  final double score;
  final String review;
  final String userId;
  final DateTime date;
}
