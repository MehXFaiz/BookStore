import 'package:flutter/foundation.dart';
import '../models/book.dart';

class CartItem {
  final Book book;
  int quantity;

  CartItem({required this.book, this.quantity = 1});
  
  double get totalPrice {
    // Parse price string '$12.99' -> 12.99
    double price = double.tryParse(book.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    return price * quantity;
  }
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void addToCart(Book book) {
    // Check if book already exists
    final existingIndex = _items.indexWhere((item) => item.book.id == book.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(CartItem(book: book));
    }
    notifyListeners();
  }
  
  void removeFromCart(String bookId) {
    _items.removeWhere((item) => item.book.id == bookId);
    notifyListeners();
  }

  void updateQuantity(String bookId, int quantity) {
    final index = _items.indexWhere((item) => item.book.id == bookId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
