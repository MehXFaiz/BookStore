import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../models/book.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryDark,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accentGreen,
          labelColor: AppColors.accentGreen,
          unselectedLabelColor: AppColors.textLightGreen,
          tabs: const [
            Tab(icon: Icon(Icons.book), text: 'Books'),
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.shopping_cart), text: 'Orders'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: TabBarView(
          controller: _tabController,
          children: const [
            ManageBooksSection(),
            ManageUsersSection(),
            ManageOrdersSection(),
          ],
        ),
      ),
    );
  }
}

class ManageUsersSection extends StatelessWidget {
  const ManageUsersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text('Error loading users'));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

        final users = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userData = users[index].data() as Map<String, dynamic>;
            final userId = users[index].id;
            final role = userData['role'] ?? 'user';

            return Card(
              color: AppColors.cardBackground,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.person, color: AppColors.textWhite),
                ),
                title: Text(userData['name'] ?? 'No Name', style: GoogleFonts.poppins(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
                subtitle: Text(userData['email'] ?? 'No Email', style: GoogleFonts.poppins(color: AppColors.textLightGreen, fontSize: 13)),
                trailing: DropdownButton<String>(
                  value: role,
                  dropdownColor: AppColors.primaryDark,
                  style: const TextStyle(color: AppColors.accentGreen),
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'user', child: Text('User')),
                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  ],
                  onChanged: (newRole) async {
                    if (newRole != null) {
                      await FirebaseFirestore.instance.collection('users').doc(userId).update({'role': newRole});
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ManageOrdersSection extends StatelessWidget {
  const ManageOrdersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text('Error loading orders'));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

        final orders = snapshot.data!.docs;

        if (orders.isEmpty) {
          return Center(
            child: Text(
              'No orders found.',
              style: GoogleFonts.poppins(color: AppColors.textLightGreen),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final orderData = orders[index].data() as Map<String, dynamic>;
            final orderId = orders[index].id;
            final status = orderData['status'] ?? 'processing';
            final total = orderData['totalAmount'] ?? 0.0;

            return Card(
              color: AppColors.cardBackground,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                iconColor: AppColors.accentGreen,
                collapsedIconColor: AppColors.textLightGreen,
                title: Text('Order #$orderId', style: GoogleFonts.poppins(color: AppColors.textWhite, fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: Text('Total: \$${total.toStringAsFixed(2)}', style: GoogleFonts.poppins(color: AppColors.accentGreen, fontSize: 13)),
                children: [
                   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status:', style: GoogleFonts.poppins(color: AppColors.textWhite)),
                        DropdownButton<String>(
                          value: status,
                          dropdownColor: AppColors.primaryDark,
                          style: const TextStyle(color: AppColors.accentGreen),
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: 'processing', child: Text('Processing')),
                            DropdownMenuItem(value: 'shipped', child: Text('Shipped')),
                            DropdownMenuItem(value: 'delivered', child: Text('Delivered')),
                            DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                          ],
                          onChanged: (newStatus) async {
                            if (newStatus != null) {
                              await FirebaseFirestore.instance.collection('orders').doc(orderId).update({'status': newStatus});
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class ManageBooksSection extends StatelessWidget {
  const ManageBooksSection({super.key});

  void _showAddEditBookDialog(BuildContext context, {Book? book}) {
    final titleController = TextEditingController(text: book?.title);
    final authorController = TextEditingController(text: book?.author);
    final genreController = TextEditingController(text: book?.genre);
    final priceController = TextEditingController(text: book?.price);
    final descriptionController = TextEditingController(text: book?.description);
    final coverImageController = TextEditingController(text: book?.coverImage);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryDark,
        title: Text(
          book == null ? 'Add New Book' : 'Edit Book',
          style: GoogleFonts.poppins(color: AppColors.textWhite),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(titleController, 'Title'),
              _buildTextField(authorController, 'Author'),
              _buildTextField(genreController, 'Genre'),
              _buildTextField(priceController, 'Price (e.g. \$12.99)'),
              _buildTextField(coverImageController, 'Cover Image URL/Path'),
              _buildTextField(descriptionController, 'Description', maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textLightGreen)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentGreen),
            onPressed: () async {
              final newBookData = {
                'title': titleController.text,
                'author': authorController.text,
                'genre': genreController.text,
                'price': priceController.text,
                'coverImage': coverImageController.text.isEmpty ? 'assets/book_covers/book1.png' : coverImageController.text,
                'description': descriptionController.text,
                'rating': book?.rating ?? 4.0,
                'reviewCount': book?.reviewCount ?? 0,
              };

              if (book == null) {
                await FirebaseFirestore.instance.collection('books').add(newBookData);
              } else {
                await FirebaseFirestore.instance.collection('books').doc(book.id).update(newBookData);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(book == null ? 'Add' : 'Update', style: const TextStyle(color: AppColors.primaryDark)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: AppColors.textWhite),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textLightGreen),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryLight)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGreen)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accentGreen,
        onPressed: () => _showAddEditBookDialog(context),
        child: const Icon(Icons.add, color: AppColors.primaryDark),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('books').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading books'));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final books = snapshot.data!.docs.map((doc) => Book.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();

          if (books.isEmpty) {
            return Center(
              child: Text(
                'No books found. Click + to add one.',
                style: GoogleFonts.poppins(color: AppColors.textLightGreen),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                color: AppColors.cardBackground,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      book.coverImage,
                      width: 40,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 40,
                        height: 60,
                        color: AppColors.primaryLight,
                        child: const Icon(Icons.book, color: AppColors.textLightGreen, size: 20),
                      ),
                    ),
                  ),
                  title: Text(book.title, style: GoogleFonts.poppins(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
                  subtitle: Text(book.author, style: GoogleFonts.poppins(color: AppColors.textLightGreen, fontSize: 13)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.accentGreen, size: 20),
                        onPressed: () => _showAddEditBookDialog(context, book: book),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: AppColors.primaryDark,
                              title: const Text('Delete Book', style: TextStyle(color: AppColors.textWhite)),
                              content: Text('Are you sure you want to delete "${book.title}"?', style: const TextStyle(color: AppColors.textLightGreen)),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.redAccent))),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            await FirebaseFirestore.instance.collection('books').doc(book.id).delete();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
