import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../models/book.dart';
import '../../widgets/book_card.dart';
import '../home/book_detail_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('books').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text('Error loading books'));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

        final allBooks = snapshot.data!.docs
            .map((doc) => Book.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();

        final booksByGenre = <String, List<Book>>{};
        for (var book in allBooks) {
          if (!booksByGenre.containsKey(book.genre)) {
            booksByGenre[book.genre] = [];
          }
          booksByGenre[book.genre]!.add(book);
        }

        final genres = booksByGenre.keys.toList();

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryMid.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
             child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textWhite, size: 18),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Catalog',
          style: GoogleFonts.poppins(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
               padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryMid.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search, color: AppColors.textWhite, size: 20)),
            onPressed: () {
               // Add search functionality or navigate to search
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: DefaultTabController(
            length: genres.length + 1, // +1 for "All"
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explore Books',
                            style: GoogleFonts.poppins(
                              color: AppColors.textWhite,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            'Find your next favorite read',
                            style: GoogleFonts.poppins(
                              color: AppColors.textLightGreen,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        isScrollable: true,
                        labelColor: AppColors.primaryDark,
                        unselectedLabelColor: AppColors.textLightGreen,
                        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        unselectedLabelStyle: GoogleFonts.poppins(),
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: AppColors.accentGreen,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 24),
                        tabs: [
                          const Tab(text: 'All'),
                          ...genres.map((genre) => Tab(text: genre)),
                        ],
                      ),
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  // "All" Tab
                  _buildBookGrid(context, allBooks),
                  // Genre Tabs
                  ...genres.map((genre) => _buildBookGrid(context, booksByGenre[genre]!)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  },
);
}

  Widget _buildBookGrid(BuildContext context, List<Book> books) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65, // Taller cards
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookCard(
          book: books[index],
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BookDetailScreen(book: books[index]),
              ),
            );
          },
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height + 16;
  @override
  double get maxExtent => _tabBar.preferredSize.height + 16;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.primaryDark, // Background for sticky header
      child: Center(child: _tabBar),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
