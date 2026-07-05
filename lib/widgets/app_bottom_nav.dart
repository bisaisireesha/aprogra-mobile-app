import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes/app_routes.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, this.activeRoute});

  final String? activeRoute;

  static const _destinations = <_BottomNavDestination>[
    _BottomNavDestination(
      label: 'Home',
      routeName: AppRoutes.dashboard,
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    _BottomNavDestination(
      label: 'Academics',
      routeName: AppRoutes.classes,
      icon: Icons.school_outlined,
      activeIcon: Icons.school,
    ),
    _BottomNavDestination(
      label: 'Fees',
      routeName: AppRoutes.fees,
      icon: Icons.account_balance_wallet_outlined,
      activeIcon: Icons.account_balance_wallet,
    ),
    _BottomNavDestination(
      label: 'Staff',
      routeName: AppRoutes.staff,
      icon: Icons.people_outline,
      activeIcon: Icons.people,
    ),
    _BottomNavDestination(
      label: 'Messages',
      routeName: AppRoutes.messages,
      icon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
    ),
  ];

  static void navigate(BuildContext context, int index) {
    if (index < 0 || index >= _destinations.length) return;

    final routeName = _destinations[index].routeName;
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == routeName) return;

    AppRoutes.replace(context, routeName);
  }

  static int indexForRoute(String? routeName) {
    final path = Uri.tryParse(routeName ?? '')?.path ?? '';

    if (path == AppRoutes.messages) return 4;
    if (path == AppRoutes.staff || path.startsWith('${AppRoutes.staff}/')) {
      return 3;
    }
    if (path == AppRoutes.fees || path.startsWith('${AppRoutes.fees}/')) {
      return 2;
    }
    if (path == AppRoutes.academics ||
        path.startsWith('${AppRoutes.academics}/')) {
      return 1;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = activeRoute ?? ModalRoute.of(context)?.settings.name;
    final currentIndex = indexForRoute(currentRoute);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => navigate(context, index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF6366F1),
        unselectedItemColor: const Color(0xFF9CA3AF),
        selectedLabelStyle: GoogleFonts.figtree(
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.figtree(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        showUnselectedLabels: true,
        elevation: 0,
        items: _destinations
            .map(
              (destination) => BottomNavigationBarItem(
                icon: Icon(destination.icon),
                activeIcon: Icon(destination.activeIcon),
                label: destination.label,
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _BottomNavDestination {
  final String label;
  final String routeName;
  final IconData icon;
  final IconData activeIcon;

  const _BottomNavDestination({
    required this.label,
    required this.routeName,
    required this.icon,
    required this.activeIcon,
  });
}
