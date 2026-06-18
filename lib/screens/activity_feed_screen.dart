import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'menu_screen.dart';

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildKpiGrid(),
                    const SizedBox(height: 32),
                    _buildHighlightsHeader(),
                    const SizedBox(height: 16),
                    _buildHighlightsGrid(),
                    const SizedBox(height: 24),
                    _buildFilterChips(),
                    const SizedBox(height: 24),
                    _buildSearchAndSort(),
                    const SizedBox(height: 16),
                    _buildFeedList(),
                    const SizedBox(height: 24),
                    _buildLoadEarlierBtn(),
                    const SizedBox(height: 80), // Space for FAB
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: _accent,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.auto_awesome, color: Colors.white),
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.15,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: MockData.activityFeedKpi.length,
      itemBuilder: (context, index) {
        final kpi = MockData.activityFeedKpi[index];
        return Container(
          padding: const EdgeInsets.all(16),
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: MockData.activityHighlights.length,
      itemBuilder: (context, index) {
        final item = MockData.activityHighlights[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  const SizedBox(width: 8), // slightly reduced spacing
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
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
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

  Widget _buildSearchAndSort() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEBEBEB)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: _textMuted, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val.toLowerCase();
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search activity...',
                          hintStyle: TextStyle(color: _textMuted, fontSize: 14),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(color: _textDark, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEBEBEB)),
              ),
              child: PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'Custom Date...') {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() {
                        _timeRange = 'Custom';
                      });
                    }
                  } else {
                    setState(() {
                      _timeRange = value;
                    });
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'Today', child: Text('Today')),
                  PopupMenuItem(value: 'This Week', child: Text('This Week')),
                  PopupMenuItem(value: 'This Month', child: Text('This Month')),
                  PopupMenuItem(value: 'This Year', child: Text('This Year')),
                  PopupMenuItem(value: 'Custom Date...', child: Text('Custom Date...')),
                ],
                child: Row(
                  children: [
                    Text(_timeRange, style: const TextStyle(color: _textDark, fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down, color: _textMuted, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEBEBEB)),
              ),
              child: const Icon(Icons.filter_list, color: _textDark),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(color: _textMuted, fontSize: 13),
                children: [
                  TextSpan(text: 'Showing '),
                  TextSpan(text: '16 events', style: TextStyle(color: _textDark, fontWeight: FontWeight.bold)),
                  TextSpan(text: ' • Today'),
                ],
              ),
            ),
            Row(
              children: const [
                Icon(Icons.file_download_outlined, color: _textMuted, size: 16),
                SizedBox(width: 4),
                Text('Export', style: TextStyle(color: _textMuted, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ],
    );
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFEBEBEB)),
                    ),
                    child: Text(
                      group['groupTime'] as String,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark),
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
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (event['initColor'] as Color).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          event['init'] as String,
                          style: TextStyle(
                            color: event['initColor'] as Color,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
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
                                        TextSpan(text: event['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        const TextSpan(text: ' • ', style: TextStyle(color: _textMuted)),
                                        TextSpan(text: event['subtitle'] as String, style: const TextStyle(color: _textMuted)),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  event['time'] as String,
                                  style: const TextStyle(fontSize: 11, color: _textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: (event['badgeColor'] as Color).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                event['badge'] as String,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: event['badgeColor'] as Color,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              event['main'] as String,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(fontSize: 12, color: _textMuted),
                                      children: [
                                        TextSpan(text: event['detail1Label'] as String),
                                        const TextSpan(text: ' '),
                                        TextSpan(text: event['detail1Value'] as String, style: const TextStyle(color: _textDark, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(fontSize: 12, color: _textMuted),
                                      children: [
                                        TextSpan(text: event['detail2Label'] as String),
                                        const TextSpan(text: ' '),
                                        TextSpan(text: event['detail2Value'] as String, style: const TextStyle(color: _textDark, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if ((event['action'] as String).isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    (event['action'] as String).replaceAll(' v', ''),
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _accent),
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
          setState(() {
            _bottomNavIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _accent,
        unselectedItemColor: _textMuted,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'Academics'),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.show_chart),
              ],
            ),
            activeIcon: const Icon(Icons.show_chart),
            label: 'Activity',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Staff'),
          const BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Messages'),
        ],
      ),
    );
  }
}
