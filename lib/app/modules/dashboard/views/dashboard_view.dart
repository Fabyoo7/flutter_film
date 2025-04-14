import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_applicationx/app/modules/dashboard/views/film_view.dart';
import 'package:flutter_applicationx/app/modules/genre/views/genre_view.dart';
import 'package:flutter_applicationx/app/modules/kategori/views/kategori_view.dart';
import 'package:flutter_applicationx/app/modules/dashboard/views/profile_view.dart';
import 'package:flutter_applicationx/app/modules/dashboard/views/index_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  late List<BottomNavigationBarItem> _navItems;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [];

  @override
  void initState() {
    super.initState();

    final role = GetStorage().read('role') ?? 'user';

    if (role == 'admin') {
      _pages = const [
        IndexView(),
        KategoriView(),
        GenreView(),
        FilmView(),
        ProfileView(),
      ];
      _navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Kategori'),
        BottomNavigationBarItem(
            icon: Icon(Icons.theater_comedy), label: 'Genre'),
        BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Film'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
    } else {
      _pages = const [
        IndexView(),
        FilmView(),
        ProfileView(),
      ];
      _navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Film'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
    }

    _navigatorKeys.addAll(
        List.generate(_pages.length, (_) => GlobalKey<NavigatorState>()));
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  Widget _buildOffstageNavigator(int index, Widget child) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (_) => child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      body: Stack(
        children: [
          for (var i = 0; i < _pages.length; i++)
            _buildOffstageNavigator(i, _pages[i]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF2A2A2A),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: _navItems,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 10,
      ),
    );
  }
}
