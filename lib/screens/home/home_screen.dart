import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/book.dart';
import '../../theme/app_colors.dart';
import '../../widgets/book_card.dart';
import 'package:provider/provider.dart';
import '../cart/cart_screen.dart';
import 'book_detail_screen.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';

class HomeScreen extends StatefulWidget {
  final bool isGuest;
  
  final VoidCallback? onMenuTap;
  final VoidCallback? onProfileTap;
  
  const HomeScreen({
    super.key, 
    this.isGuest = false,
    this.onMenuTap,
    this.onProfileTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTimeframeIndex = 1; // Default to 'Week'
  final List<String> _timeframes = ['DAY', 'WEEK', 'MONTH', 'YEAR'];

  void _navigateToDetail(BuildContext context, Book book) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookDetailScreen(book: book),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: widget.onMenuTap,
                    child: const Icon(Icons.sort, color: AppColors.textWhite, size: 28),
                  ),
                  Text(
                    'Greenbolt',
                    style: GoogleFonts.poppins(
                      color: AppColors.textWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                        child: Stack(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(Icons.shopping_cart_outlined, color: AppColors.textWhite, size: 28),
                            ),
                            Consumer<CartProvider>(
                              builder: (_, cart, __) => cart.itemCount > 0
                                  ? Positioned(
                                      right: 8,
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: AppColors.accentGreen,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '${cart.itemCount}',
                                          style: const TextStyle(
                                            color: AppColors.primaryDark,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onProfileTap,
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primaryLight,
                          child: Icon(Icons.person, color: AppColors.textWhite),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Greeting & Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      String displayName = 'Guest';
                      if (!widget.isGuest && auth.user != null) {
                        displayName = auth.user?.email?.split('@').first ?? 'User';
                      }
                      return Text(
                        'Hello, $displayName!',
                        style: GoogleFonts.poppins(
                          color: AppColors.textWhite,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Book, Authors, Geners',
                      prefixIcon: const Icon(Icons.search, color: AppColors.textLightGreen), // Changed to search icon as per image
                      suffixIcon: const Icon(Icons.mic, color: AppColors.textLightGreen), // Added mic as per common pattern or just search
                      // Overriding theme for this specific input to match design exactly
                      fillColor: AppColors.primaryLight.withOpacity(0.5),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: AppColors.accentGreen, width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Timeframe Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_timeframes.length, (index) {
                  final isSelected = _selectedTimeframeIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTimeframeIndex = index;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          _timeframes[index],
                          style: GoogleFonts.poppins(
                            color: isSelected ? AppColors.accentGreen : AppColors.textLightGreen.withOpacity(0.6),
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (isSelected)
                          Container(
                            width: 20,
                            height: 2,
                            color: AppColors.accentGreen,
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // "Weekly Trending Books" Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Weekly Trending Books',
                style: GoogleFonts.poppins(
                  color: AppColors.textWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Books Grid/List
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7, // Adjust based on Card design
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: trendingBooks.length,
                itemBuilder: (context, index) {
                  return BookCard(
                    book: trendingBooks[index],
                    onTap: () => _navigateToDetail(context, trendingBooks[index]),
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
