import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../screens/catalog/catalog_screen.dart';
import '../screens/wishlist/wishlist_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.primaryLight,
                      child: Icon(Icons.person, size: 30, color: AppColors.textWhite),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'John Den.',
                      style: GoogleFonts.poppins(
                        color: AppColors.textWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'john.doe@example.com',
                      style: GoogleFonts.poppins(
                        color: AppColors.textLightGreen,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.primaryLight),
              const SizedBox(height: 20),
              _buildDrawerItem(Icons.home_outlined, 'Home', () => Navigator.pop(context)),
              _buildDrawerItem(Icons.category_outlined, 'Categories', () {
                Navigator.pop(context); // Close drawer
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CatalogScreen()),
                );
              }),
              _buildDrawerItem(Icons.bookmark_outline, 'My Library', () {}), // Could link to Library tab
              _buildDrawerItem(Icons.favorite_border, 'Wishlist', () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const WishlistScreen()),
                );
              }),
              _buildDrawerItem(Icons.settings_outlined, 'Settings', () {}),
              const Spacer(),
              const Divider(color: AppColors.primaryLight),
              _buildDrawerItem(Icons.logout, 'Logout', () {}, isDestructive: true),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppColors.textLightGreen,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: isDestructive ? Colors.red : AppColors.textWhite,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}
