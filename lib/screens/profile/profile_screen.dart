import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import 'edit/edit_profile_screen.dart';
import '../orders/order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Header
              const CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.person, size: 50, color: AppColors.textWhite),
              ),
              const SizedBox(height: 16),
              Text(
                'John Den.',
                style: GoogleFonts.poppins(
                  color: AppColors.textWhite,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'john.doe@example.com',
                style: GoogleFonts.poppins(
                  color: AppColors.textLightGreen,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30),
              
              // Stats
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat('Books', '12'),
                    _buildStat('Reviews', '5'),
                    _buildStat('Hours', '48'),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Menu Items
              _buildMenuItem(Icons.person_outline, 'Edit Profile', onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              }),
              _buildMenuItem(Icons.shopping_bag_outlined, 'My Orders', onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                );
              }),
              _buildMenuItem(Icons.notifications_outlined, 'Notifications'),
              _buildMenuItem(Icons.security_outlined, 'Privacy & Security'),
              _buildMenuItem(Icons.help_outline, 'Help & Support'),
              _buildMenuItem(Icons.logout, 'Logout', isDestructive: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            color: AppColors.textWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.textLightGreen,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool isDestructive = false, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red.withOpacity(0.1) : AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : AppColors.accentGreen,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: isDestructive ? Colors.red : AppColors.textWhite,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textLightGreen, size: 16),
        onTap: onTap ?? () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        tileColor: AppColors.cardBackground.withOpacity(0.3),
      ),
    );
  }
}
