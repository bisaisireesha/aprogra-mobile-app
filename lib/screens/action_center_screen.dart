import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'menu_screen.dart';

const _bgPrimary = Color(0xFFF9F9FB);
const _textDark = Color(0xFF181821);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);
const _accentLight = Color(0xFFF3F0FF);

class ActionCenterScreen extends StatefulWidget {
  const ActionCenterScreen({super.key});

  @override
  State<ActionCenterScreen> createState() => _ActionCenterScreenState();
}

class _ActionCenterScreenState extends State<ActionCenterScreen> {
  int _bottomNavIndex = 0; // Keeping it default or home for this screen
  String _activeFilter = 'All';
  String _searchQuery = '';
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
                    const SizedBox(height: 24),
                    _buildFilters(),
                    const SizedBox(height: 32),
                    _buildAlertsList(),
                    const SizedBox(height: 24),
                    _buildRecommendedActions(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: const MenuScreen(activeScreen: 'Action Center'),
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
                      hintText: 'Search anything...',
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1F1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'LIVE • ACTION REQUIRED',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Action Center',
          style: TextStyle(
            color: _textDark,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Items requiring your attention across the school.',
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
        childAspectRatio: 1.25,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: MockData.actionCenterKpi.length,
      itemBuilder: (context, index) {
        final kpi = MockData.actionCenterKpi[index];
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: kpi['iconBg'] as Color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(kpi['icon'] as IconData, size: 16, color: kpi['iconColor'] as Color),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      kpi['title'] as String,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _textMuted, height: 1.2),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(kpi['value'] as String, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _textDark)),
                  const SizedBox(height: 2),
                  Text(
                    kpi['subtitle'] as String,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: kpi['subtitleColor'] as Color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilters() {
    final filters = ['All', 'Critical', 'Attendance', 'Finance', 'Admissions', 'Academics', 'Staff'];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: filters.map((filter) {
        final isSelected = filter == _activeFilter;
        return GestureDetector(
          onTap: () {
            setState(() {
              _activeFilter = filter;
            });
          },
          child: Container(
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
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAlertsList() {
    return Column(
      children: MockData.actionCenterAlerts.map((section) {
        final allItems = section['items'] as List<Map<String, dynamic>>;
        final filteredItems = allItems.where((item) {
          final matchesFilter = _activeFilter == 'All' ||
              (_activeFilter == 'Critical' && item['isCritical'] == true) ||
              (item['category'] as String).toLowerCase().contains(_activeFilter.toLowerCase());
          final matchesSearch = _searchQuery.isEmpty ||
              (item['title'] as String).toLowerCase().contains(_searchQuery) ||
              (item['subtitle'] as String).toLowerCase().contains(_searchQuery);
          return matchesFilter && matchesSearch;
        }).toList();

        if (filteredItems.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: section['sectionIconBg'] as Color,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(section['sectionIcon'] as IconData, size: 16, color: section['sectionIconColor'] as Color),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      section['sectionTitle'] as String,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        section['sectionBadge'] as String,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _textMuted),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Text('View all', style: TextStyle(fontSize: 12, color: _textMuted)),
                    Icon(Icons.chevron_right, size: 16, color: _textMuted),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            ...filteredItems.map((item) {
              final isCritical = item['isCritical'] as bool;
              return Container(
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF3F3F6), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isCritical)
                          Container(
                            width: 4,
                            color: Colors.redAccent,
                          ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: item['badgeColor'] as Color,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              item['badge'] as String,
                                              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              item['category'] as String,
                                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, size: 12, color: _textMuted),
                                        const SizedBox(width: 4),
                                        Text(item['time'] as String, style: const TextStyle(fontSize: 12, color: _textMuted)),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  item['title'] as String,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark, height: 1.3),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item['subtitle'] as String,
                                  style: const TextStyle(fontSize: 13, color: _textMuted),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(24),
                                          border: Border.all(color: _textDark),
                                        ),
                                        child: Center(
                                          child: Text(
                                            item['btn1'] as String,
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        decoration: BoxDecoration(
                                          color: item['btn2Color'] as Color,
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        child: Center(
                                          child: Text(
                                            item['btn2'] as String,
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildRecommendedActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _accentLight,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lightbulb_outline, size: 16, color: _accent),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Recommended Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('AI Suggestions', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _accent, letterSpacing: 0.5)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...MockData.actionCenterRecommendations.map((rec) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rec['title'] as String,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark, height: 1.3),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rec['subtitle'] as String,
                    style: const TextStyle(fontSize: 12, color: _textMuted, height: 1.3),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        rec['btn'] as String,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
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
