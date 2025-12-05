class Review {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar; // Optional: URL or asset path
  final double rating;
  final String comment;
  final DateTime date;
  int likes;
  bool isLiked; // Local state for the current user

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar = '',
    required this.rating,
    required this.comment,
    required this.date,
    this.likes = 0,
    this.isLiked = false,
  });
}

// Sample Reviews
List<Review> getSampleReviews() {
  return [
    Review(
      id: '1',
      userId: 'user1',
      userName: 'Alice M.',
      rating: 5.0,
      comment: 'Absolutely loved this book! The characters were so deep and the plot twist at the end caught me off guard.',
      date: DateTime.now().subtract(const Duration(days: 2)),
      likes: 12,
    ),
    Review(
      id: '2',
      userId: 'user2',
      userName: 'Bob D.',
      rating: 4.0,
      comment: 'Great read, slightly slow in the middle but picks up beautifully.',
      date: DateTime.now().subtract(const Duration(days: 5)),
      likes: 5,
    ),
     Review(
      id: '3',
      userId: 'user3',
      userName: 'Charlie',
      rating: 3.0,
      comment: 'It was okay. Not my favorite genre but well written.',
      date: DateTime.now().subtract(const Duration(days: 10)),
      likes: 0,
    ),
  ];
}
