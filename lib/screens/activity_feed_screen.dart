import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'menu_screen.dart';
import 'student_insights_screen.dart';

const _bgPrimary = Color(0xFFF9F9FB);
const _textDark = Color(0xFF181821);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);
const _accentLight = Color(0xFFF3F0FF);

class ActivityFeedScreen extends StatefulWidget {
  const ActivityFeedScreen({super.key});

  @override
  State<ActivityFeedScreen> createState() => _ActivityFeedScreenState();
}

class _ActivityFeedScreenState extends State<ActivityFeedScreen> {
  int _bottomNavIndex = 2; // Activity is index 2
  String _activeFilter = 'All modules';
  String _searchQuery = '';
  String _timeRange = 'Today';
  final TextEditingController _searchController = TextEditingController();

  // [Responsive Fix]: Central breakpoint check
  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      body: SafeArea(
        bottom: false,
        // [Responsive Fix]: Constrain width to prevent infinite stretching on ultra-wides
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(),
                // [Responsive Fix]: Adapt side padding
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(_isTablet ? 40 : 20, 0, _isTablet ? 40 : 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 12),
                          _buildKpiGrid(),
                          const SizedBox(height: 16),
                          _buildHighlightsHeader(),
                          const SizedBox(height: 12),
                          _buildHighlightsGrid(),
                          const SizedBox(height: 16),
                          _buildFilterChips(),
                          const SizedBox(height: 12),
                          _buildFeedList(),
                          const SizedBox(height: 16),
                          _buildLoadEarlierBtn(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const MenuScreen(activeScreen: 'Activity Feed'),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
        Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const Icon(Icons.menu, color: _textDark, size: 28),
          ),
        ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFEBEBEB)),
              ),
              child: Row(
                children: const [
                Icon(Icons.search, color: _textMuted, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text('Search posts, updates...', style: TextStyle(color: _textMuted, fontSize: 14), overflow: TextOverflow.ellipsis)),
              ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Stack(
            children: [
              const Icon(Icons.notifications_none, color: _textDark, size: 28),
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: _bgPrimary, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFE5DCF3),
            child: Icon(Icons.person, color: _accent, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Activity Feed',
                style: TextStyle(
                  color: _textDark,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _accentLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: _accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Live',
                    style: TextStyle(
                      color: _accent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Live activity stream across all school modules.',
          style: TextStyle(color: _textMuted, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildKpiGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // [Responsive Fix]: Switch to 4 columns on tablets
        crossAxisCount: _isTablet ? 4 : 2,
        mainAxisExtent: 140,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: MockData.activityFeedKpi.length,
      itemBuilder: (context, index) {
        final kpi = MockData.activityFeedKpi[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF3F3F6), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.015),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: kpi['iconBg'] as Color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(kpi['icon'] as IconData, size: 16, color: kpi['iconColor'] as Color),
                  ),
                  if ((kpi['trend'] as String).isNotEmpty)
                    Text(
                      kpi['trend'] as String,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark),
                    ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(kpi['value'] as String, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _textDark)),
                  const SizedBox(height: 2),
                  Text(
                    kpi['title'] as String,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if ((kpi['subtitle'] as String).isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      kpi['subtitle'] as String,
                      style: const TextStyle(fontSize: 10, color: _textMuted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHighlightsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: const [
            Icon(Icons.auto_awesome, color: _accent, size: 20),
            SizedBox(width: 8),
            Text(
              "Today's Highlights",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _accentLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'UPDATED 2 MIN AGO',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _accent, letterSpacing: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // [Responsive Fix]: 4 items horizontally on tablets
        crossAxisCount: _isTablet ? 4 : 2,
        mainAxisExtent: 110,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: MockData.activityHighlights.length,
      itemBuilder: (context, index) {
        final item = MockData.activityHighlights[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: item['cardBg'] as Color? ?? Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: item['iconBg'] as Color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item['icon'] as IconData, size: 20, color: item['iconColor'] as Color),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item['title'] as String,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                item['value'] as String,
                style: const TextStyle(fontSize: 13, color: _textMuted),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All modules', 'Students', 'Attendance', 'Academics'];
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        children: filters.map((filter) {
          final isSelected = filter == _activeFilter;
          return GestureDetector(
            onTap: () {
              setState(() {
                _activeFilter = filter;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? _accent : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: isSelected ? null : Border.all(color: const Color(0xFFEBEBEB)),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : _textMuted,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


  /// Returns a badge icon for each badge type, matching the reference image.
  IconData _badgeIcon(String badge) {
    final b = badge.toUpperCase();
    if (b.contains('SECURITY')) return Icons.security;
    if (b.contains('FINANCE')) return Icons.account_balance_wallet_outlined;
    if (b.contains('TRANSPORT')) return Icons.directions_bus_outlined;
    if (b.contains('LIBRARY')) return Icons.menu_book_outlined;
    if (b.contains('ACADEMIC')) return Icons.school_outlined;
    return Icons.circle;
  }

  Widget _buildFeedList() {
    return Column(
      children: MockData.activityEvents.map((group) {
        final allEvents = group['events'] as List<Map<String, dynamic>>;
        final filteredEvents = allEvents.where((event) {
          final matchesFilter = _activeFilter == 'All modules' ||
              (event['title'] as String).toLowerCase().contains(_activeFilter.toLowerCase()) ||
              (event['badge'] as String).toLowerCase().contains(_activeFilter.toLowerCase());
          final matchesSearch = _searchQuery.isEmpty ||
              (event['title'] as String).toLowerCase().contains(_searchQuery) ||
              (event['main'] as String).toLowerCase().contains(_searchQuery) ||
              (event['subtitle'] as String).toLowerCase().contains(_searchQuery);
          return matchesFilter && matchesSearch;
        }).toList();

        if (filteredEvents.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Group header: plain style matching the reference image ──
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    group['groupTime'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                  Text(
                    group['groupCount'] as String,
                    style: const TextStyle(fontSize: 12, color: _textMuted),
                  ),
                ],
              ),
            ),
            ...filteredEvents.map((event) {
              final initColor = event['initColor'] as Color;
              final badgeColor = event['badgeColor'] as Color;
              final badge = event['badge'] as String;
              final action = event['action'] as String;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Profile avatar: light pastel bg + dark text + white border ring ──
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,       // white outer ring
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: initColor.withValues(alpha: 0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: initColor.withValues(alpha: 0.12), // light pastel fill
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            event['init'] as String,
                            style: TextStyle(
                              color: initColor,            // dark colored text
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF3F3F6), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.015),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Header row: title • subtitle   time ──
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      style: const TextStyle(fontSize: 13, color: _textDark),
                                      children: [
                                        TextSpan(
                                          text: event['title'] as String,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        const TextSpan(
                                          text: ' • ',
                                          style: TextStyle(color: _textMuted),
                                        ),
                                        TextSpan(
                                          text: event['subtitle'] as String,
                                          style: const TextStyle(color: _textMuted),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  event['time'] as String,
                                  style: const TextStyle(fontSize: 11, color: _textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // ── Badge with icon, matching reference ──
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: badgeColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _badgeIcon(badge),
                                    size: 10,
                                    color: badgeColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    badge,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: badgeColor,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // ── Main event title ──
                            Text(
                              event['main'] as String,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: _textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // ── Detail rows stacked vertically (matches reference image) ──
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 12, color: _textMuted),
                                children: [
                                  TextSpan(text: event['detail1Label'] as String),
                                  const TextSpan(text: ' '),
                                  TextSpan(
                                    text: event['detail1Value'] as String,
                                    style: const TextStyle(color: _textDark, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 12, color: _textMuted),
                                children: [
                                  TextSpan(text: event['detail2Label'] as String),
                                  const TextSpan(text: ' '),
                                  TextSpan(
                                    text: event['detail2Value'] as String,
                                    style: const TextStyle(color: _textDark, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            // ── Action link (e.g. "View pass ˅") ──
                            if (action.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              const Divider(height: 1, color: Color(0xFFF3F3F6)),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    // Remove trailing " v" suffix used in mock data as chevron placeholder
                                    action.endsWith(' v')
                                        ? action.substring(0, action.length - 2)
                                        : action,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: _accent,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.keyboard_arrow_down, size: 16, color: _accent),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildLoadEarlierBtn() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFEBEBEB)),
        ),
        child: const Text(
          'Load earlier activity',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textMuted),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.05))),
      ),
      child: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const StudentInsightsScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: Duration.zero,
              ),
            );
          } else {
            setState(() {
              _bottomNavIndex = index;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _accent,
        unselectedItemColor: _textMuted,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'Academics'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), activeIcon: Icon(Icons.show_chart), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Staff'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Messages'),
        ],
      ),
    );
  }
}
