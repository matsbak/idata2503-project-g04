class Rating {
  Rating({
    required this.score,
    required this.userId,
    required this.date,
  });

  double score;
  final String userId;
  final DateTime date;
}
