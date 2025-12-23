import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/catalog/catalog_screen.dart';
import '../screens/wishlist/wishlist_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final role = authProvider.role;

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
                      user?.email?.split('@').first ?? 'Guest User',
                      style: GoogleFonts.poppins(
                        color: AppColors.textWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (role != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: role == 'admin' ? Colors.red.withOpacity(0.2) : AppColors.accentGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: role == 'admin' ? Colors.red : AppColors.accentGreen,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          role.toUpperCase(),
                          style: GoogleFonts.poppins(
                            color: role == 'admin' ? Colors.red : AppColors.accentGreen,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'Not logged in',
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
              if (authProvider.isAdmin) ...[
                const Divider(color: AppColors.primaryLight),
                _buildDrawerItem(Icons.admin_panel_settings_outlined, 'Admin Panel', () {
                  // Admin specific logic
                }),
              ],
              const Spacer(),
              const Divider(color: AppColors.primaryLight),
              _buildDrawerItem(Icons.logout, 'Logout', () async {
                await authProvider.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              }, isDestructive: true),
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
