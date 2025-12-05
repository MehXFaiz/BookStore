import 'book.dart';

enum OrderStatus {
  processing,
  packed,
  shipped,
  outForDelivery,
  delivered,
  cancelled
}

class OrderItem {
  final Book book;
  final int quantity;
  final double priceAtPurchase;

  OrderItem({
    required this.book,
    required this.quantity,
    required this.priceAtPurchase,
  });
}

class Order {
  final String id;
  final DateTime date;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final String trackingNumber;

  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.totalAmount,
    required this.status,
    this.trackingNumber = '',
  });

  String get statusText {
    switch (status) {
      case OrderStatus.processing: return 'Processing';
      case OrderStatus.packed: return 'Packed';
      case OrderStatus.shipped: return 'Shipped';
      case OrderStatus.outForDelivery: return 'Out for Delivery';
      case OrderStatus.delivered: return 'Delivered';
      case OrderStatus.cancelled: return 'Cancelled';
    }
  }
}

// Mock Data
final List<Order> mockOrders = [
  Order(
    id: '#ORD-2023-001',
    date: DateTime.now().subtract(const Duration(days: 2)),
    items: [
      OrderItem(
         book: Book(
            id: '1',
            title: 'My Book Cover',
            author: 'The child of the world',
            coverImage: 'assets/book_covers/book1.png',
            rating: 4.5,
            description: '...',
            price: '\$12.99',
            genre: 'Fiction'
          ),
          quantity: 1,
          priceAtPurchase: 12.99
      ),
    ],
    totalAmount: 12.99,
    status: OrderStatus.outForDelivery,
    trackingNumber: 'TRK123456789',
  ),
  Order(
    id: '#ORD-2023-002',
    date: DateTime.now().subtract(const Duration(days: 10)),
    items: [
       OrderItem(
         book: Book(
            id: '2',
            title: 'A Million to One',
            author: 'The one of the world',
            coverImage: 'assets/book_covers/book2.png',
            rating: 4.8,
            description: '...',
            price: '\$14.99',
            genre: 'Biography'
          ),
          quantity: 2,
          priceAtPurchase: 14.99
      ),
    ],
    totalAmount: 29.98,
    status: OrderStatus.delivered,
    trackingNumber: 'TRK987654321',
  ),
];
