class Book {
  final String id;
  final String title;
  final String author;
  final String coverImage;
  final double rating;
  final String description;
  final String price;
  final int reviewCount;
  final String genre;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverImage,
    this.rating = 0.0,
    this.description = '',
    this.price = '\$0.00',
    this.reviewCount = 0,
    required this.genre,
  });
}

// Sample data for trending books
final List<Book> trendingBooks = [
  Book(
    id: '1',
    title: 'My Book Cover',
    author: 'The child of the world',
    coverImage: 'assets/book_covers/book1.png',
    rating: 4.5,
    description: 'A captivating story about discovering the world through the eyes of a child. This book takes you on an emotional journey filled with wonder, adventure, and life lessons.',
    price: '\$12.99',
    reviewCount: 234,
    genre: 'Fiction',
  ),
  Book(
    id: '2',
    title: 'A Million to One',
    author: 'The one of the world',
    coverImage: 'assets/book_covers/book2.png',
    rating: 4.8,
    description: 'Against all odds, one person\'s journey to success. An inspiring tale of perseverance, determination, and the power of believing in yourself.',
    price: '\$14.99',
    reviewCount: 567,
    genre: 'Biography',
  ),
  Book(
    id: '3',
    title: 'Spy Boy Rock',
    author: 'The Place of the world',
    coverImage: 'assets/book_covers/book3.png',
    rating: 4.3,
    description: 'An action-packed thriller following a young spy on his most dangerous mission yet. Full of twists, turns, and heart-pounding moments.',
    price: '\$11.99',
    reviewCount: 189,
    genre: 'Thriller',
  ),
  Book(
    id: '4',
    title: 'The Silent Echo',
    author: 'Emma Richardson',
    coverImage: 'assets/book_covers/book1.png',
    rating: 4.6,
    description: 'A mysterious tale of secrets and revelations that will keep you on the edge of your seat until the very last page.',
    price: '\$13.99',
    reviewCount: 412,
    genre: 'Mystery',
  ),
];

final List<Book> newArrivals = [
   Book(
    id: '5',
    title: 'Future Horizons',
    author: 'Dr. Alan Grant',
    coverImage: 'assets/book_covers/book1.png', // Placeholder
    rating: 4.2,
    description: 'Exploring the technological advancements that will shape our future.',
    price: '\$18.99',
    reviewCount: 89,
    genre: 'Sci-Fi',
  ),
  Book(
    id: '6',
    title: 'Daily Habits',
    author: 'Sarah Jenkins',
    coverImage: 'assets/book_covers/book2.png', // Placeholder
    rating: 4.7,
    description: 'Transform your life one day at a time with these simple yet effective habits.',
    price: '\$10.99',
    reviewCount: 320,
    genre: 'Self-Help',
  ),
];
