import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../models/book.dart';
import '../../widgets/book_card.dart';
import '../home/book_detail_screen.dart';

enum SortOption { priceLowToHigh, priceHighToLow, popularity, newest }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _searchResults = [];
  bool _isSearching = false;
  SortOption? _selectedSortOption;

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      // Search logic: Title, Author, Genre
      var results = [...trendingBooks, ...newArrivals].where((book) {
        final titleLower = book.title.toLowerCase();
        final authorLower = book.author.toLowerCase();
        final genreLower = book.genre.toLowerCase();
        final queryLower = query.toLowerCase();
        return titleLower.contains(queryLower) || 
               authorLower.contains(queryLower) ||
               genreLower.contains(queryLower);
      }).toSet().toList(); // Remove duplicates

      // Sorting logic
      if (_selectedSortOption != null) {
        _sortBooks(results, _selectedSortOption!);
      }
      
      _searchResults = results;
    });
  }

  void _sortBooks(List<Book> books, SortOption option) {
    switch (option) {
      case SortOption.priceLowToHigh:
        books.sort((a, b) => _parsePrice(a.price).compareTo(_parsePrice(b.price)));
        break;
      case SortOption.priceHighToLow:
        books.sort((a, b) => _parsePrice(b.price).compareTo(_parsePrice(a.price)));
        break;
      case SortOption.popularity:
        // Sort by review count descending
        books.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case SortOption.newest:
        // Using ID assuming higher ID is newer for this mock data
        books.sort((a, b) => b.id.compareTo(a.id)); 
        break;
    }
  }

  double _parsePrice(String priceString) {
    // Remove '$' and parse
    return double.tryParse(priceString.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primaryMid,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sort By',
                    style: GoogleFonts.poppins(
                      color: AppColors.textWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSortOption(setModalState, 'Price: Low to High', SortOption.priceLowToHigh),
                  _buildSortOption(setModalState, 'Price: High to Low', SortOption.priceHighToLow),
                  _buildSortOption(setModalState, 'Popularity', SortOption.popularity),
                  _buildSortOption(setModalState, 'Newest Arrivals', SortOption.newest),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Re-apply search with new sort
                        _performSearch(_searchController.text);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGreen,
                        foregroundColor: AppColors.primaryDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text('Apply Filters'),
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

  Widget _buildSortOption(StateSetter setModalState, String title, SortOption option) {
    final isSelected = _selectedSortOption == option;
    return ListTile(
      onTap: () {
        setModalState(() {
          _selectedSortOption = option;
        });
      },
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isSelected ? AppColors.accentGreen : AppColors.textLightGreen,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: isSelected ? AppColors.textWhite : AppColors.textLightGreen,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _performSearch,
                      style: const TextStyle(color: AppColors.textWhite),
                      cursorColor: AppColors.accentGreen,
                      decoration: InputDecoration(
                        hintText: 'Search Books, Authors, Genres...',
                        hintStyle: TextStyle(color: AppColors.textLightGreen.withOpacity(0.5)),
                        prefixIcon: const Icon(Icons.search, color: AppColors.textLightGreen),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: AppColors.textLightGreen),
                                onPressed: () {
                                  _searchController.clear();
                                  _performSearch('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: AppColors.primaryLight.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: AppColors.accentGreen),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filter Button
                  GestureDetector(
                    onTap: _showFilterModal,
                    child: Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: _selectedSortOption != null ? AppColors.accentGreen : AppColors.primaryLight.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                        border: _selectedSortOption != null ? null : Border.all(color: AppColors.primaryLight),
                      ),
                      child: Icon(
                        Icons.tune,
                        color: _selectedSortOption != null ? AppColors.primaryDark : AppColors.textWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _searchResults.isEmpty && _searchController.text.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 80,
                            color: AppColors.textLightGreen.withOpacity(0.2),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No books found',
                            style: GoogleFonts.poppins(
                              color: AppColors.textLightGreen,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _searchResults.isEmpty && _searchController.text.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search,
                                size: 80,
                                color: AppColors.textLightGreen.withOpacity(0.2),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Search for your favorite books',
                                style: GoogleFonts.poppins(
                                  color: AppColors.textLightGreen,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            return BookCard(
                              book: _searchResults[index],
                              onTap: () {
                                 Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => BookDetailScreen(book: _searchResults[index]),
                                  ),
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
