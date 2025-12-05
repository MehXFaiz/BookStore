import 'package:flutter/foundation.dart';
import '../models/book.dart';

class WishlistProvider extends ChangeNotifier {
  final Set<String> _wishlistIds = {};

  // In a real app, you would fetch these from a database/API
  Set<String> get wishlistIds => _wishlistIds;
  
  // Helper to get actual Book objects. In a real app this would query the DB.
  List<Book> get wishlistBooks {
    final allBooks = [...trendingBooks, ...newArrivals];
    return allBooks.where((book) => _wishlistIds.contains(book.id)).toList();
  }

  bool isInWishlist(String bookId) {
    return _wishlistIds.contains(bookId);
  }

  void toggleWishlist(String bookId) {
    if (_wishlistIds.contains(bookId)) {
      _wishlistIds.remove(bookId);
    } else {
      _wishlistIds.add(bookId);
    }
    notifyListeners();
  }
}
