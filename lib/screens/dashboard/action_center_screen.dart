import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../data/mock_data/dashboard_mock.dart';
import '../../screens/auth/menu_screen.dart';
import '../students/students_list_screen.dart';

const _bgPrimary = Color(0xFFF6F6F8);
const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);

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
        // [Responsive Fix]: Constrain max width for ultra-wide tablets
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(),
                // [Responsive Fix]: Scale padding based on width
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(_isTablet ? 40 : 16, 24, _isTablet ? 40 : 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          SizedBox(height: 12.h),
                          _buildKpiGrid(),
                          SizedBox(height: 12.h),
                          _buildFilters(),
                          const SizedBox(height: 20),
                          _buildAlertsList(),
                          SizedBox(height: 12.h),
                          _buildRecommendedActions(),
                          const SizedBox(height: 24),
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
      drawer: const MenuScreen(activeScreen: 'Action Center'),
      
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Builder(
              builder: (context) => GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: const Icon(Icons.menu_rounded, color: Color(0xFF8F96A3), size: 28),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFF3F4F6)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: Color(0xFF8F96A3), size: 20),
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
                          hintStyle: TextStyle(color: Color(0xFF8F96A3), fontSize: 14),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(color: Color(0xFF181B20), fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Stack(
              children: [
                const Icon(Icons.notifications_none_rounded, color: Color(0xFF8F96A3), size: 28),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF72222),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF9FAFB), width: 2),
                color: Colors.grey[300],
              ),
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ],
        ),
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
            color: const Color(0xFFFDE9E9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF8D7D7)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFF72222),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'LIVE • ACTION REQUIRED',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFF72222),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Action Center',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: _textDark,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Items requiring your attention across the school.',
          style: TextStyle(fontSize: 15, color: _textMuted),
        ),
      ],
    );
  }

  Widget _buildKpiGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // [Responsive Fix]: Switch to 4 columns on tablets/landscape
        crossAxisCount: _isTablet ? 4 : 2,
        mainAxisExtent: 115.h,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: MockData.actionCenterKpi.length,
      itemBuilder: (context, index) {
        final kpi = MockData.actionCenterKpi[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF9FAFB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: kpi['iconBg'] as Color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(kpi['icon'] as IconData, size: 12, color: kpi['iconColor'] as Color),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      kpi['title'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8F96A3),
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kpi['value'] as String,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF181B20),
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    kpi['subtitle'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: kpi['subtitleColor'] as Color,
                    ),
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
    final firstLineFilters = ['All', 'Critical', 'Attendance', 'Finance'];
    final secondLineFilters = ['Admissions', 'Academics', 'Staff'];

    Widget buildFilterChip(String filter) {
      final isSelected = filter == _activeFilter;
      return GestureDetector(
        onTap: () {
          setState(() {
            _activeFilter = filter;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF7C5BFF) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isSelected ? const Color(0xFF7C5BFF) : const Color(0xFFF3F4F6)),
          ),
          child: Text(
            filter,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF8F96A3),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            children: firstLineFilters.map((f) {
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: buildFilterChip(f),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            children: secondLineFilters.map((f) {
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: buildFilterChip(f),
              );
            }).toList(),
          ),
        ),
      ],
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
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: section['sectionIconBg'] as Color,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFF3F4F6)),
                        ),
                        child: Icon(section['sectionIcon'] as IconData, size: 20, color: section['sectionIconColor'] as Color),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          section['sectionTitle'] as String,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          section['sectionBadge'] as String,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF8F96A3)),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Text('View all', style: TextStyle(fontSize: 13, color: Color(0xFF8F96A3))),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 10, color: Color(0xFF8F96A3)),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            ...filteredItems.map((item) {
              final isCritical = item['isCritical'] as bool;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: isCritical ? const Color(0x33FF5C5C) : const Color(0xFFF3F4F6)),
                  boxShadow: isCritical ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ] : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isCritical)
                          Container(
                            width: 4,
                            color: const Color(0xFFFF5C5C),
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
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: item['badge'] == 'CRITICAL' ? const Color(0xFFFF5252) : item['badgeColor'] as Color,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (item['badge'] == 'CRITICAL') ...[
                                                  const Icon(Icons.gpp_maybe_outlined, size: 12, color: Colors.white),
                                                  const SizedBox(width: 4),
                                                ],
                                                Text(
                                                  item['badge'] as String,
                                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              item['category'] as String,
                                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF8D95A5), letterSpacing: 1.0),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Icon(Icons.access_time_rounded, size: 12, color: Color(0xFF8D95A5)),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              item['time'] as String,
                                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF8D95A5)),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  item['title'] as String,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF181B20), height: 1.3),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['subtitle'] as String,
                                  style: const TextStyle(fontSize: 14, color: Color(0xFF8F96A3)),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        // [Responsive Fix]: Min height constraint to prevent text clipping if scaled up
                                        constraints: const BoxConstraints(minHeight: 48),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: const Color(0xFF181B20)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            item['btn1'] as String,
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF181B20)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Container(
                                        // [Responsive Fix]: Min height constraint
                                        constraints: const BoxConstraints(minHeight: 48),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          color: item['badge'] == 'CRITICAL' ? const Color(0xFFFF5C5C) : item['btn2Color'] as Color,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: Text(
                                            item['btn2'] as String,
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                            textAlign: TextAlign.center,
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0x1A7C5BFF), Color(0x0D7C5BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x337C5BFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0x337C5BFF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lightbulb_outline, size: 20, color: Color(0xFF7C5BFF)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Recommended Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0x337C5BFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('AI Suggestions', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF7C5BFF))),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...MockData.actionCenterRecommendations.map((rec) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x1A7C5BFF)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rec['title'] as String,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark, height: 1.3),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rec['subtitle'] as String,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF8F96A3), height: 1.5),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C5BFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        rec['btn'] as String,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
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
