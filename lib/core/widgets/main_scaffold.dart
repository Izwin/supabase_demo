import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_demo/features/coffee/presentation/screens/home_screen.dart';
import 'package:supabase_demo/features/stats/presentation/screens/stats_screen.dart';
import 'package:supabase_demo/features/profile/presentation/screens/profile_screen.dart';

class MainScaffold extends StatefulWidget {

  final StatefulNavigationShell statefulNavigationShell;
  const MainScaffold({
    super.key,
    required this.statefulNavigationShell
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.statefulNavigationShell.currentIndex;
  }

  void _onItemTapped(int index) {
    if (_currentIndex == index) return;
    
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        context.go(HomeScreen.routePath);
        break;
      case 1:
        context.go(StatsScreen.routePath);
        break;
      case 2:
        context.go(ProfileScreen.routePath);
        break;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.statefulNavigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.coffee),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
} 