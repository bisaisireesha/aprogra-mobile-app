import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aprogra/screens/dashboard/dashboard_screen.dart';
import 'package:aprogra/screens/classes/classes_screen.dart';
import 'package:aprogra/screens/messages/messages_screen.dart';
import 'package:aprogra/screens/non_teaching/staff_management_screen.dart';
import 'package:aprogra/screens/auth/menu_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  final Color _accent = const Color(0xFF8463E9);
  final Color _textMuted = const Color(0xFF595973);

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const DashboardScreen(),
      const ClassesScreen(),
      const MessagesScreen(),
      const StaffManagementScreen(),
      // For the "More" tab, we just show a placeholder, but we will intercept the tap 
      // to open the drawer of the currently active screen.
      SizedBox(),
    ];
  }

  void _onTabTapped(int index) {
    if (index == 4) {
      // Tap on "More"
      // Open the drawer by finding a Scaffold in the current Navigator's tree.
      // Note: Because we use nested Navigators, context needs to be looked up.
      // For simplicity, since all our screens have an AppBar with a Menu icon that opens a Drawer,
      // and a Scaffold that manages it, we can trigger the Scaffold.of(context).openDrawer() by
      // traversing the element tree of the current active navigator.
      
      final currentNavCtx = _navigatorKeys[_currentIndex].currentContext;
      if (currentNavCtx != null) {
        // A hacky but effective way to find the scaffold in the active tab
        void findScaffoldAndOpenDrawer(Element element) {
          if (element.widget is Scaffold) {
            final scaffoldState = (element as StatefulElement).state as ScaffoldState;
            if (scaffoldState.hasDrawer) {
              scaffoldState.openDrawer();
            }
          } else {
            element.visitChildren(findScaffoldAndOpenDrawer);
          }
        }
        (currentNavCtx as Element).visitChildren(findScaffoldAndOpenDrawer);
      }
      return; // Do not switch tabs for "More"
    }

    if (_currentIndex == index) {
      // Pop to first route if tapping the same tab
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // WillPopScope prevents exiting the app if there's back history in the current tab
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab = !await _navigatorKeys[_currentIndex].currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          // If not on the first tab, go back to the first tab instead of exiting
          if (_currentIndex != 0) {
            setState(() {
              _currentIndex = 0;
            });
            return false;
          }
          return true; // Exit app
        }
        return false; // Popped nested route
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: List.generate(_pages.length, (index) {
            return Navigator(
              key: _navigatorKeys[index],
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => _pages[index],
                  settings: settings,
                );
              },
            );
          }),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20.r,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, 'Home'),
              _buildNavItem(1, Icons.school_outlined, 'Academics'),
              _buildNavItem(2, Icons.chat_bubble_outline, 'Messages', badge: '9'),
              _buildNavItem(3, Icons.cases_outlined, 'Operations'),
              _buildNavItem(4, Icons.more_horiz, 'More'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {String? badge}) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                color: isSelected ? _accent : _textMuted,
                size: 24,
              ),
              if (badge != null)
                Positioned(
                  right: -6,
                  top: -4,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? _accent : _textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
