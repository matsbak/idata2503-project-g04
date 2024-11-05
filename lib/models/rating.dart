/// Represetns a rating
class Rating {
  Rating({
    required this.score,
    required this.comment,
    required this.userId,
    required this.date,
  });

  double score;
  String comment;
  final String userId;
  final DateTime date;
}
