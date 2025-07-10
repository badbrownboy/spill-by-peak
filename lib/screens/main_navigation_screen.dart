import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'chat_page.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 1; // Start with Profile tab (middle)

  final List<Widget> _pages = [
    const SearchPage(),
    const ProfilePage(),
    const ChatPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a1a), Colors.black],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF6366f1),
          unselectedItemColor: Colors.white.withOpacity(0.5),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: _currentIndex == 0
                    ? BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF6366f1).withOpacity(0.2),
                            Colors.transparent,
                          ],
                        ),
                        shape: BoxShape.circle,
                      )
                    : null,
                child: Icon(
                  _currentIndex == 0 ? Icons.search : Icons.search_outlined,
                  size: 26,
                ),
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: _currentIndex == 1
                    ? BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF6366f1).withOpacity(0.2),
                            Colors.transparent,
                          ],
                        ),
                        shape: BoxShape.circle,
                      )
                    : null,
                child: Icon(
                  _currentIndex == 1 ? Icons.person : Icons.person_outline,
                  size: 26,
                ),
              ),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: _currentIndex == 2
                    ? BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF6366f1).withOpacity(0.2),
                            Colors.transparent,
                          ],
                        ),
                        shape: BoxShape.circle,
                      )
                    : null,
                child: Icon(
                  _currentIndex == 2 ? Icons.chat_bubble : Icons.chat_bubble_outline,
                  size: 26,
                ),
              ),
              label: 'Chat',
            ),
          ],
        ),
      ),
    );
  }
}
