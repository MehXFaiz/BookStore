import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'home/home_screen.dart';
import 'search/search_screen.dart';
import 'library/library_screen.dart';
import 'profile/profile_screen.dart';
import 'wishlist/wishlist_screen.dart';
import '../widgets/custom_drawer.dart';

class MainScreen extends StatefulWidget {
  final bool isGuest;
  
  const MainScreen({super.key, this.isGuest = false});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // We'll initialize screens in build to ensure they have access to latest context and callbacks if needed,
  // but better to keep them in state if they don't change.
  // However, for simplicity to pass callbacks that call setState:
    
  @override
  void initState() {
    super.initState();
  }

  void _onProfileTap() {
    setState(() {
      _currentIndex = 4; // Profile tab index
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        isGuest: widget.isGuest,
        onMenuTap: () {
          // Open drawer - we need a Builder or GlobalKey if we are not in the context of the Scaffold with the drawer.
          // Since MainScreen builds the Scaffold, we need transparency.
          // Actually, Scaffold.of(context) looks up the widget tree.
          // HomeScreen is child of Scaffold, so Scaffold.of(context) inside HomeScreen will find MainScreen's Scaffold.
          // BUT, to be safe and explicit, let's just trigger it from within HomeScreen which is what we did: Scaffold.of(context).openDrawer().
          // Oh, wait, I updated HomeScreen to take a callback for onMenuTap. 
          // If I pass a callback, I need to open the drawer here.
          // But I can't open the drawer of the Scaffold I am currently building!
          // Standard pattern: HomeScreen uses Scaffold.of(context).openDrawer() internally if it's a child.
          // If I passed a callback, I should use a GlobalKey<ScaffoldState>.
          _scaffoldKey.currentState?.openDrawer();
        },
        onProfileTap: _onProfileTap, // Navigate to Profile tab
      ),
      const SearchScreen(),
      const WishlistScreen(showBackButton: false),
      const LibraryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: screens[_currentIndex],
      extendBody: true, // Allow body to extend behind the bottom bar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.primaryMid,
              AppColors.primaryLight,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Colors.transparent, // Important for gradient to show through
            selectedItemColor: AppColors.accentGreen,
            unselectedItemColor: AppColors.textLightGreen.withOpacity(0.5),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                activeIcon: Icon(Icons.favorite),
                label: 'Wishlist',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_outline),
                activeIcon: Icon(Icons.bookmark),
                label: 'Library',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
