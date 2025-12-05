import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../models/book.dart';
import '../../widgets/book_card.dart';
import '../home/book_detail_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    // Group books by genre for the catalog
    final allBooks = [...trendingBooks, ...newArrivals];
    final booksByGenre = <String, List<Book>>{};
    
    for (var book in allBooks) {
      if (!booksByGenre.containsKey(book.genre)) {
        booksByGenre[book.genre] = [];
      }
      booksByGenre[book.genre]!.add(book);
    }
    
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Custom AppBar for Catalog
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                   Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textWhite, size: 20),
                      ),
                    ),
                  ),
                  Text(
                    'Book Catalog',
                    style: GoogleFonts.poppins(
                      color: AppColors.textWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                children: [
                  
                  // Best Sellers Section (using trendingBooks as proxy)
                   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildSectionHeader('Best Sellers'),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 280,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      itemCount: trendingBooks.length,
                      itemBuilder: (context, index) {
                         return BookCard(
                            book: trendingBooks[index],
                            onTap: () => _navigateToDetail(context, trendingBooks[index]),
                          );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // New Arrivals Section
                   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildSectionHeader('New Arrivals'),
                  ),
                  const SizedBox(height: 16),
                   SizedBox(
                    height: 280,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      itemCount: newArrivals.length,
                      itemBuilder: (context, index) {
                         return BookCard(
                            book: newArrivals[index],
                            onTap: () => _navigateToDetail(context, newArrivals[index]),
                          );
                      },
                    ),
                  ),
                  
                   const SizedBox(height: 30),
                   
                   // Browse by Category Section
                   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildSectionHeader('Browse by Genre'),
                  ),
                  
                  // Generates a list of genres with books
                  ...booksByGenre.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                             entry.key,
                             style: GoogleFonts.poppins(
                               color: AppColors.accentGreen,
                               fontSize: 16,
                               fontWeight: FontWeight.w600,
                             ),
                           ),
                        ),
                        const SizedBox(height: 12),
                         SizedBox(
                          height: 280,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            scrollDirection: Axis.horizontal,
                            itemCount: entry.value.length,
                            itemBuilder: (context, index) {
                               return BookCard(
                                  book: entry.value[index],
                                  onTap: () => _navigateToDetail(context, entry.value[index]),
                                );
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  
                   const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _navigateToDetail(BuildContext context, Book book) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookDetailScreen(book: book),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: AppColors.textWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(Icons.arrow_forward, color: AppColors.textLightGreen),
      ],
    );
  }
}
