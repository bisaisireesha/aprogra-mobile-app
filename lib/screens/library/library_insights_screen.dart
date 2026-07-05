import 'package:flutter/material.dart';
import '../../data/mock_data/library_mock.dart';
import '../auth/menu_screen.dart';
import '../students/student_insights_screen.dart';
import '../../widgets/app_bottom_nav.dart';

const _bgPrimary = Color(0xFFF9F9FB);
const _textDark = Color(0xFF181821);
const _textMuted = Color(0xFF595973);

class LibraryInsightsScreen extends StatefulWidget {
  const LibraryInsightsScreen({super.key});

  @override
  State<LibraryInsightsScreen> createState() => _LibraryInsightsScreenState();
}

class _LibraryInsightsScreenState extends State<LibraryInsightsScreen> {
  int _bottomNavIndex = 2; // Activity tab
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String _selectedCategory = 'All Categories';
  String _selectedDateRange = 'This Year (2024)';
  List<String> _activeFilters = ['Books', 'Available', 'Fiction', '2024'];
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> get _filteredAvailability {
    var list = LibraryMockData.availabilityBoard;
    if (_selectedFilter != 'All') {
      list = list
          .where(
            (item) =>
                (item['status'] as String).toLowerCase() ==
                _selectedFilter.toLowerCase(),
          )
          .toList();
    }
    if (_selectedCategory != 'All Categories') {
      list = list
          .where(
            (item) => (item['author'] as String).toLowerCase().contains(
              _selectedCategory.toLowerCase(),
            ),
          )
          .toList();
    }
    if (_searchQuery.isNotEmpty) {
      list = list
          .where(
            (item) =>
                (item['title'] as String).toLowerCase().contains(
                  _searchQuery,
                ) ||
                (item['author'] as String).toLowerCase().contains(_searchQuery),
          )
          .toList();
    }
    return list;
  }

  List<Map<String, dynamic>> get _filteredFollowUp {
    var list = LibraryMockData.followUpCenter;
    if (_selectedFilter == 'Overdue') {
      list = list
          .where(
            (item) =>
                (item['type'] as String).toLowerCase().contains('overdue'),
          )
          .toList();
    } else if (_selectedFilter == 'Available') {
      list = [];
    }
    if (_searchQuery.isNotEmpty) {
      list = list
          .where(
            (item) =>
                (item['studentName'] as String).toLowerCase().contains(
                  _searchQuery,
                ) ||
                (item['type'] as String).toLowerCase().contains(_searchQuery),
          )
          .toList();
    }
    return list;
  }

  List<Map<String, dynamic>> get _filteredNewArrivals {
    var list = LibraryMockData.newArrivals;
    if (_selectedCategory != 'All Categories') {
      list = list
          .where(
            (item) => (item['category'] as String).toLowerCase().contains(
              _selectedCategory.toLowerCase(),
            ),
          )
          .toList();
    }
    if (_searchQuery.isNotEmpty) {
      list = list
          .where(
            (item) =>
                (item['title'] as String).toLowerCase().contains(
                  _searchQuery,
                ) ||
                (item['author'] as String).toLowerCase().contains(
                  _searchQuery,
                ) ||
                (item['category'] as String).toLowerCase().contains(
                  _searchQuery,
                ),
          )
          .toList();
    }
    return list;
  }

  List<Map<String, dynamic>> get _filteredAlerts {
    if (_searchQuery.isEmpty) return LibraryMockData.libraryAlerts;
    return LibraryMockData.libraryAlerts
        .where(
          (item) =>
              (item['title'] as String).toLowerCase().contains(_searchQuery) ||
              (item['subtitle'] as String).toLowerCase().contains(_searchQuery),
        )
        .toList();
  }

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 800;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      drawer: const MenuScreen(activeScreen: 'Library Insights'),
      bottomNavigationBar: const AppBottomNav(),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: _isTablet ? 40 : 20,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 32),
                        _buildKPIGrid(),
                        const SizedBox(height: 32),
                        _buildMainContent(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Library Open - Live',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Updated just now',
              style: TextStyle(color: _textMuted, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Library Insights',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Monitor library operations, book circulation, availability, and student engagement.',
                    style: TextStyle(color: _textMuted, fontSize: 14),
                  ),
                ],
              ),
            ),
            if (_isTablet) ...[
              const SizedBox(width: 16),
              Expanded(child: _buildSecondarySearchBar()),
              const SizedBox(width: 16),
              _buildFilterButton(),
            ],
          ],
        ),
        if (!_isTablet) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildSecondarySearchBar()),
              const SizedBox(width: 16),
              _buildFilterButton(),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSecondarySearchBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFF8F96A3), size: 20),
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
                hintText: 'Search library insights...',
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
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: _showFilterMenu,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: const [
            Icon(Icons.filter_list, color: Color(0xFF8F96A3), size: 20),
            SizedBox(width: 8),
            Text(
              'Filter',
              style: TextStyle(
                color: Color(0xFF8F96A3),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButton(
    IconData icon,
    String label, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: _textDark),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPIGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _isTablet ? 6 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: _isTablet ? 1.0 : 1.2,
      ),
      itemCount: LibraryMockData.kpis.length,
      itemBuilder: (context, index) {
        final kpi = LibraryMockData.kpis[index];
        return _buildKPICard(kpi);
      },
    );
  }

  Widget _buildKPICard(Map<String, dynamic> data) {
    Color iconBgColor;
    Color iconColor;

    switch (data['colorType']) {
      case 'purple':
        iconBgColor = const Color(0xFFF0EDFA);
        iconColor = const Color(0xFF8463E9);
        break;
      case 'blue':
        iconBgColor = const Color(0xFFE5F0FF);
        iconColor = const Color(0xFF3B82F6);
        break;
      case 'orange':
        iconBgColor = const Color(0xFFFFF4E5);
        iconColor = const Color(0xFFF59E0B);
        break;
      case 'red':
        iconBgColor = const Color(0xFFFFEBEB);
        iconColor = const Color(0xFFEF4444);
        break;
      default:
        iconBgColor = const Color(0xFFF3F3F6);
        iconColor = _textDark;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  data['icon'] as IconData,
                  size: 20,
                  color: iconColor,
                ),
              ),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['value'] as String,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data['title'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data['subtitle'] as String,
                style: const TextStyle(fontSize: 11, color: _textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isTablet) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  children: [
                    _buildActivityBoard(),
                    const SizedBox(height: 32),
                    _buildAvailabilityBoard(),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(flex: 3, child: _buildFollowUpCenter()),
            ],
          ),
          const SizedBox(height: 32),
          _buildStudentReadingActivity(),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: _buildInventoryStatus()),
              const SizedBox(width: 32),
              Expanded(flex: 3, child: _buildLibrarianOperations()),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: _buildNewArrivals()),
              const SizedBox(width: 32),
              Expanded(flex: 3, child: _buildReadingPrograms()),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: _buildLibraryActivityFeed()),
              const SizedBox(width: 32),
              Expanded(flex: 3, child: _buildLibraryAlerts()),
            ],
          ),
          const SizedBox(height: 32),
          _buildTodaysHighlights(),
        ],
      );
    } else {
      return Column(
        children: [
          _buildActivityBoard(),
          const SizedBox(height: 32),
          _buildAvailabilityBoard(),
          const SizedBox(height: 32),
          _buildFollowUpCenter(),
          const SizedBox(height: 32),
          _buildStudentReadingActivity(),
          const SizedBox(height: 32),
          _buildInventoryStatus(),
          const SizedBox(height: 32),
          _buildLibrarianOperations(),
          const SizedBox(height: 32),
          _buildNewArrivals(),
          const SizedBox(height: 32),
          _buildReadingPrograms(),
          const SizedBox(height: 32),
          _buildLibraryActivityFeed(),
          const SizedBox(height: 32),
          _buildLibraryAlerts(),
          const SizedBox(height: 32),
          _buildTodaysHighlights(),
        ],
      );
    }
  }

  Widget _buildActivityBoard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.show_chart,
                  color: Color(0xFF8463E9),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Library Activity Board',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                    Text(
                      'Today\'s circulation at a glance',
                      style: TextStyle(fontSize: 12, color: _textMuted),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Operating Normally',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _isTablet ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.8,
          ),
          itemCount: LibraryMockData.activityBoard.length,
          itemBuilder: (context, index) {
            final activity = LibraryMockData.activityBoard[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getActivityBorderColor(
                    activity['colorType'] as String,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _getActivityIconBgColor(
                            activity['colorType'] as String,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          activity['icon'] as IconData,
                          size: 14,
                          color: _getActivityIconColor(
                            activity['colorType'] as String,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          activity['title'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: _textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity['value'] as String,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        activity['subtitle'] as String,
                        style: const TextStyle(fontSize: 11, color: _textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getActivityBorderColor(String type) {
    switch (type) {
      case 'blue':
        return const Color(0xFF3B82F6).withValues(alpha: 0.3);
      case 'green':
        return const Color(0xFF4CAF50).withValues(alpha: 0.3);
      case 'red':
        return const Color(0xFFEF4444).withValues(alpha: 0.3);
      case 'purple':
        return const Color(0xFF8463E9).withValues(alpha: 0.3);
      case 'orange':
        return const Color(0xFFF59E0B).withValues(alpha: 0.3);
      default:
        return Colors.grey.withValues(alpha: 0.2);
    }
  }

  Color _getActivityIconBgColor(String type) {
    if (type == 'blue') return const Color(0xFFE5F0FF);
    if (type == 'green') return const Color(0xFFE8F5E9);
    if (type == 'purple') return const Color(0xFFF0EDFA);
    return const Color(0xFFF3F3F6);
  }

  Color _getActivityIconColor(String type) {
    if (type == 'blue') return const Color(0xFF3B82F6);
    if (type == 'green') return const Color(0xFF4CAF50);
    if (type == 'purple') return const Color(0xFF8463E9);
    return _textDark;
  }

  Widget _buildAvailabilityBoard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EDFA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.library_books,
                color: Color(0xFF8463E9),
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Book Availability Board',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                Text(
                  'Popular and high-demand titles',
                  style: TextStyle(fontSize: 12, color: _textMuted),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _isTablet ? 2 : 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.2,
          ),
          itemCount: _filteredAvailability.length,
          itemBuilder: (context, index) {
            final book = _filteredAvailability[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF0F0F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8463E9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.menu_book,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book['title'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              book['author'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                color: _textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusBgColor(
                            book['statusColor'] as String,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          book['status'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _getStatusTextColor(
                              book['statusColor'] as String,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F9FB),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Available',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _textMuted,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                book['available'] as String,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F9FB),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Reserved',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _textMuted,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                book['reserved'] as String,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getStatusBgColor(String color) {
    if (color == 'red') return const Color(0xFFFFEBEB);
    if (color == 'green') return const Color(0xFFE8F5E9);
    if (color == 'orange') return const Color(0xFFFFF4E5);
    return const Color(0xFFF3F3F6);
  }

  Color _getStatusTextColor(String color) {
    if (color == 'red') return const Color(0xFFEF4444);
    if (color == 'green') return const Color(0xFF4CAF50);
    if (color == 'orange') return const Color(0xFFF59E0B);
    return _textDark;
  }

  Widget _buildFollowUpCenter() {
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
                    color: const Color(0xFFF0EDFA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFF8463E9),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Overdue & Follow-Up Center',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                    Text(
                      'Requires action today',
                      style: TextStyle(fontSize: 12, color: _textMuted),
                    ),
                  ],
                ),
              ],
            ),
            if (!_isTablet)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '21 Items',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.withValues(alpha: 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isTablet) ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '21 Items',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              ..._filteredFollowUp.map((item) {
                return _buildFollowUpCard(item);
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFollowUpCard(Map<String, dynamic> item) {
    Color iconColor;
    Color iconBgColor;

    if (item['typeColor'] == 'red') {
      iconColor = const Color(0xFFEF4444);
      iconBgColor = const Color(0xFFFFEBEB);
    } else {
      iconColor = const Color(0xFFF59E0B);
      iconBgColor = const Color(0xFFFFF4E5);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      size: 14,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item['type'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _showFollowUpPopup(item),
                child: Text(
                  item['action'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8463E9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item['studentName'] as String,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item['studentDetails'] as String,
            style: const TextStyle(fontSize: 12, color: _textMuted),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12, color: _textDark),
              children: [
                const TextSpan(
                  text: 'Book: ',
                  style: TextStyle(color: _textMuted),
                ),
                TextSpan(
                  text: item['bookTitle'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFollowUpPopup(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Follow Up Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Action: ${item['type']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Details: ${item['studentName']} - ${item['bookTitle']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: _textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Follow up initiated')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8463E9),
            ),
            child: const Text(
              'Initiate',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentReadingActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EDFA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.people_outline,
                color: Color(0xFF8463E9),
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Student Reading Activity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                Text(
                  'Engagement and follow-ups',
                  style: TextStyle(fontSize: 12, color: _textMuted),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_isTablet)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildTopBorrowersList()),
              const SizedBox(width: 16),
              Expanded(child: _buildPendingReturnsList()),
              const SizedBox(width: 16),
              Expanded(child: _buildReadingAwardsList()),
            ],
          )
        else
          Column(
            children: [
              _buildTopBorrowersList(),
              const SizedBox(height: 16),
              _buildPendingReturnsList(),
              const SizedBox(height: 16),
              _buildReadingAwardsList(),
            ],
          ),
      ],
    );
  }

  Widget _buildTopBorrowersList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.emoji_events_outlined,
                    color: Color(0xFFF59E0B),
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Top Borrowers This Month',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Leaderboard',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF59E0B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...LibraryMockData.topBorrowers.map(
            (item) => _buildBorrowerItem(item),
          ),
        ],
      ),
    );
  }

  Widget _buildBorrowerItem(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EDFA),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                item['rank'] as String,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8463E9),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item['grade']} - ${item['books']}',
                  style: const TextStyle(fontSize: 11, color: _textMuted),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4E5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star_border,
                  color: Color(0xFFF59E0B),
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  item['badge'] as String,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF59E0B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingReturnsList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.access_time, color: Color(0xFFF59E0B), size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Students with Pending Returns',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '14 Students',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF59E0B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...LibraryMockData.pendingReturns.map(
            (item) => _buildPendingReturnItem(item),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingReturnItem(Map<String, dynamic> item) {
    Color badgeColor = item['badgeColor'] == 'red'
        ? const Color(0xFFEF4444)
        : const Color(0xFFF59E0B);
    Color badgeBgColor = item['badgeColor'] == 'red'
        ? const Color(0xFFFFEBEB)
        : const Color(0xFFFFF4E5);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['name'] as String,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item['grade'] as String,
                style: const TextStyle(fontSize: 11, color: _textMuted),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              item['badge'] as String,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: badgeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingAwardsList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.auto_awesome_outlined,
                    color: Color(0xFF8463E9),
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Reading Awards',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EDFA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'This Term',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8463E9),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...LibraryMockData.readingAwards.map(
            (item) => _buildReadingAwardItem(item),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingAwardItem(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['name'] as String,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item['grade'] as String,
                style: const TextStyle(fontSize: 11, color: _textMuted),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EDFA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              item['badge'] as String,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8463E9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryStatus() {
    final status = LibraryMockData.inventoryStatus;
    final total =
        status['available'] +
        status['issued'] +
        status['reserved'] +
        status['repair'] +
        status['missing'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EDFA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: Color(0xFF8463E9),
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Library Inventory Status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                Text(
                  'Stock health across catalog',
                  style: TextStyle(fontSize: 12, color: _textMuted),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0F0F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildInventoryStatCard(
                      'Available',
                      status['available'].toString(),
                      const Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInventoryStatCard(
                      'Issued',
                      status['issued'].toString(),
                      const Color(0xFF3B82F6),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInventoryStatCard(
                      'Reserved',
                      status['reserved'].toString(),
                      const Color(0xFF8463E9),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInventoryStatCard(
                      'Repair',
                      status['repair'].toString(),
                      const Color(0xFFF59E0B),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInventoryStatCard(
                      'Missing',
                      status['missing'].toString(),
                      const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Row(
                  children: [
                    Expanded(
                      flex: status['available'] as int,
                      child: Container(
                        height: 8,
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                    Expanded(
                      flex: status['issued'] as int,
                      child: Container(
                        height: 8,
                        color: const Color(0xFF3B82F6),
                      ),
                    ),
                    Expanded(
                      flex: status['reserved'] as int,
                      child: Container(
                        height: 8,
                        color: const Color(0xFF8463E9),
                      ),
                    ),
                    Expanded(
                      flex: (status['repair'] as int) > 0
                          ? (total * 0.05).toInt()
                          : 0,
                      child: Container(
                        height: 8,
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                    Expanded(
                      flex: (status['missing'] as int) > 0
                          ? (total * 0.05).toInt()
                          : 0,
                      child: Container(
                        height: 8,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildLegendItem('Available', const Color(0xFF4CAF50)),
                  _buildLegendItem('Issued', const Color(0xFF3B82F6)),
                  _buildLegendItem('Reserved', const Color(0xFF8463E9)),
                  _buildLegendItem('Repair', const Color(0xFFF59E0B)),
                  _buildLegendItem('Missing', const Color(0xFFEF4444)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: _textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.rectangle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: _textMuted)),
      ],
    );
  }

  Widget _buildLibrarianOperations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EDFA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.playlist_add_check_outlined,
                color: Color(0xFF8463E9),
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Librarian Operations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                Text(
                  'Workflow queue',
                  style: TextStyle(fontSize: 12, color: _textMuted),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0F0F0)),
          ),
          child: Column(
            children: LibraryMockData.librarianOperations.map((op) {
              Color iconColor;
              Color iconBgColor;

              switch (op['colorType']) {
                case 'green':
                  iconColor = const Color(0xFF4CAF50);
                  iconBgColor = const Color(0xFFE8F5E9);
                  break;
                case 'orange':
                  iconColor = const Color(0xFFF59E0B);
                  iconBgColor = const Color(0xFFFFF4E5);
                  break;
                case 'blue':
                  iconColor = const Color(0xFF3B82F6);
                  iconBgColor = const Color(0xFFE5F0FF);
                  break;
                case 'purple':
                  iconColor = const Color(0xFF8463E9);
                  iconBgColor = const Color(0xFFF0EDFA);
                  break;
                default:
                  iconColor = _textDark;
                  iconBgColor = const Color(0xFFF3F3F6);
              }

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        op['icon'] as IconData,
                        size: 16,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        op['title'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _textDark,
                        ),
                      ),
                    ),
                    Text(
                      op['count'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNewArrivals() {
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
                    color: const Color(0xFFF0EDFA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.collections_bookmark_outlined,
                    color: Color(0xFF8463E9),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'New Arrivals',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                    Text(
                      'Recently added to the catalog',
                      style: TextStyle(fontSize: 12, color: _textMuted),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EDFA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '18 this week',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8463E9),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _isTablet ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: _filteredNewArrivals.length,
          itemBuilder: (context, index) {
            final item = _filteredNewArrivals[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF0F0F0)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: _getNewArrivalGradient(
                          item['colorType'] as String,
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Stack(
                        children: [
                          const Positioned(
                            top: 0,
                            right: 0,
                            child: Icon(
                              Icons.menu_book,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item['category'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: _textDark,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['author'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              color: _textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 12,
                                color: _textMuted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item['date'] as String,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: _textMuted,
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
            );
          },
        ),
      ],
    );
  }

  LinearGradient _getNewArrivalGradient(String type) {
    switch (type) {
      case 'blue':
        return const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        );
      case 'purple':
        return const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFFC084FC)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        );
      case 'orange':
        return const LinearGradient(
          colors: [Color(0xFFF97316), Color(0xFFFBBF24)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        );
      case 'green':
        return const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF34D399)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        );
      case 'pink':
        return const LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        );
      case 'red':
        return const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFF87171)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        );
      default:
        return const LinearGradient(colors: [Colors.grey, Colors.grey]);
    }
  }

  Widget _buildReadingPrograms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EDFA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.campaign_outlined,
                color: Color(0xFF8463E9),
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Reading Programs & Events',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                Text(
                  'Upcoming engagement',
                  style: TextStyle(fontSize: 12, color: _textMuted),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0F0F0)),
          ),
          child: Column(
            children: LibraryMockData.readingPrograms.map((program) {
              Color badgeColor;
              Color badgeBgColor;

              switch (program['colorType']) {
                case 'green':
                  badgeColor = const Color(0xFF4CAF50);
                  badgeBgColor = const Color(0xFFE8F5E9);
                  break;
                case 'orange':
                  badgeColor = const Color(0xFFF59E0B);
                  badgeBgColor = const Color(0xFFFFF4E5);
                  break;
                case 'blue':
                  badgeColor = const Color(0xFF3B82F6);
                  badgeBgColor = const Color(0xFFE5F0FF);
                  break;
                case 'purple':
                  badgeColor = const Color(0xFF8463E9);
                  badgeBgColor = const Color(0xFFF0EDFA);
                  break;
                case 'red':
                  badgeColor = const Color(0xFFEF4444);
                  badgeBgColor = const Color(0xFFFFEBEB);
                  break;
                default:
                  badgeColor = _textDark;
                  badgeBgColor = const Color(0xFFF3F3F6);
              }

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.event_note_outlined,
                        size: 16,
                        color: badgeColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            program['title'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            program['description'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              color: _textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        program['badgeText'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLibraryActivityFeed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EDFA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.show_chart,
                color: Color(0xFF8463E9),
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Library Activity Feed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                Text(
                  'Live operational timeline',
                  style: TextStyle(fontSize: 12, color: _textMuted),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0F0F0)),
          ),
          child: Column(
            children: List.generate(LibraryMockData.activityFeed.length, (
              index,
            ) {
              final item = LibraryMockData.activityFeed[index];
              Color dotColor;
              switch (item['colorType']) {
                case 'blue':
                  dotColor = const Color(0xFF3B82F6);
                  break;
                case 'green':
                  dotColor = const Color(0xFF4CAF50);
                  break;
                case 'purple':
                  dotColor = const Color(0xFF8463E9);
                  break;
                case 'orange':
                  dotColor = const Color(0xFFF59E0B);
                  break;
                case 'red':
                  dotColor = const Color(0xFFEF4444);
                  break;
                default:
                  dotColor = Colors.grey;
              }

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 24,
                      child: Column(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: dotColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          if (index < LibraryMockData.activityFeed.length - 1)
                            Expanded(
                              child: Container(
                                width: 1,
                                color: Colors.grey.withValues(alpha: 0.2),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  item['icon'] as IconData,
                                  size: 14,
                                  color: _textMuted,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item['title'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: _textDark,
                                    ),
                                  ),
                                ),
                                Text(
                                  item['time'] as String,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: _textMuted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['subtitle'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                color: _textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildLibraryAlerts() {
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
                    color: const Color(0xFFF0EDFA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Color(0xFF8463E9),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Library Alerts',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                    Text(
                      'Operational issues to review',
                      style: TextStyle(fontSize: 12, color: _textMuted),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '5 Active',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEF4444),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0F0F0)),
          ),
          child: Column(
            children: _filteredAlerts.map((alert) {
              Color badgeColor;
              Color badgeBgColor;

              switch (alert['colorType']) {
                case 'red':
                  badgeColor = const Color(0xFFEF4444);
                  badgeBgColor = const Color(0xFFFFEBEB);
                  break;
                case 'orange':
                  badgeColor = const Color(0xFFF59E0B);
                  badgeBgColor = const Color(0xFFFFF4E5);
                  break;
                case 'blue':
                  badgeColor = const Color(0xFF3B82F6);
                  badgeBgColor = const Color(0xFFE5F0FF);
                  break;
                case 'purple':
                  badgeColor = const Color(0xFF8463E9);
                  badgeBgColor = const Color(0xFFF0EDFA);
                  break;
                default:
                  badgeColor = _textDark;
                  badgeBgColor = const Color(0xFFF3F3F6);
              }

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        alert['icon'] as IconData,
                        size: 16,
                        color: badgeColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alert['title'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            alert['subtitle'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              color: _textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _showAlertPopup(alert),
                      child: const Text(
                        'View >',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8463E9),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showAlertPopup(Map<String, dynamic> alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(alert['icon'] as IconData, color: _textDark),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                alert['title'] as String,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        content: Text(alert['subtitle'] as String),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Action taken for ${alert['title']}')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8463E9),
            ),
            child: const Text(
              'Take Action',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysHighlights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EDFA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Color(0xFF8463E9),
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Today\'s Highlights',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                Text(
                  'Snapshot of the day',
                  style: TextStyle(fontSize: 12, color: _textMuted),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0F0F0)),
          ),
          child: Column(
            children: LibraryMockData.todaysHighlights
                .map((item) => _buildHighlightCard(item))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightCard(Map<String, dynamic> item) {
    Color iconColor;
    Color iconBgColor;

    switch (item['colorType']) {
      case 'blue':
        iconColor = const Color(0xFF3B82F6);
        iconBgColor = const Color(0xFFE5F0FF);
        break;
      case 'green':
        iconColor = const Color(0xFF4CAF50);
        iconBgColor = const Color(0xFFE8F5E9);
        break;
      case 'red':
        iconColor = const Color(0xFFEF4444);
        iconBgColor = const Color(0xFFFFEBEB);
        break;
      case 'purple':
        iconColor = const Color(0xFF8463E9);
        iconBgColor = const Color(0xFFF0EDFA);
        break;
      case 'orange':
        iconColor = const Color(0xFFF59E0B);
        iconBgColor = const Color(0xFFFFF4E5);
        break;
      default:
        iconColor = _textDark;
        iconBgColor = const Color(0xFFF3F3F6);
    }

    int value = int.tryParse(item['value'].toString()) ?? 0;
    double progress = value / 100.0;
    if (progress > 1.0) progress = 1.0;
    if (progress < 0.05 && value > 0) progress = 0.05;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item['icon'] as IconData, size: 20, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['label'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _textDark,
                      ),
                    ),
                    Text(
                      item['value'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.1),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: (progress * 100).toInt(),
                          child: Container(color: iconColor),
                        ),
                        Expanded(
                          flex: 100 - (progress * 100).toInt(),
                          child: const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
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
                child: const Icon(
                  Icons.menu_rounded,
                  color: Color(0xFF8F96A3),
                  size: 28,
                ),
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
                    const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF8F96A3),
                      size: 20,
                    ),
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
                          hintStyle: TextStyle(
                            color: Color(0xFF8F96A3),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(
                          color: Color(0xFF181B20),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Stack(
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF8F96A3),
                  size: 28,
                ),
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

  void _showFilterMenu() {
    String tempFilter = _selectedFilter;
    String tempCategory = _selectedCategory;
    String tempDateRange = _selectedDateRange;
    List<String> tempActiveFilters = List.from(_activeFilters);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.close,
                            color: _textDark,
                            size: 24,
                          ),
                        ),
                        const Text(
                          'Filter',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setModalState(() {
                              tempFilter = 'All';
                              tempCategory = 'All Categories';
                              tempDateRange = 'This Year (2024)';
                              tempActiveFilters.clear();
                            });
                          },
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6B4EE6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Active Filters
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Active Filters',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setModalState(() {
                              tempActiveFilters.clear();
                            });
                          },
                          child: const Text(
                            'Clear All',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B4EE6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (tempActiveFilters.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: tempActiveFilters.map((filter) {
                          final textColor = _getActiveFilterColor(
                            filter,
                            isBg: false,
                          );
                          final bgColor = _getActiveFilterColor(
                            filter,
                            isBg: true,
                          );
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: bgColor.withOpacity(0.5),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  filter,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      tempActiveFilters.remove(filter);
                                      if (filter == tempCategory)
                                        tempCategory = 'All Categories';
                                      if (filter == tempDateRange)
                                        tempDateRange = 'This Year (2024)';
                                      if (filter == tempFilter)
                                        tempFilter = 'All';
                                    });
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 14,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Quick Filter Chips
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Quick Filter Chips',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          [
                            'All',
                            'Available',
                            'Issued',
                            'Reserved',
                            'Overdue',
                            'Lost / Damaged',
                          ].map((chip) {
                            final isSelected = tempFilter == chip;
                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  tempFilter = chip;
                                  if (chip != 'All' &&
                                      !tempActiveFilters.contains(chip)) {
                                    tempActiveFilters.add(chip);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFF3F0FF)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFE5E0F8)
                                        : const Color(0xFFF0F0F0),
                                  ),
                                ),
                                child: Text(
                                  chip,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? const Color(0xFF6B4EE6)
                                        : const Color(0xFF4B5563),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // List items
                  Expanded(
                    child: ListView(
                      children: [
                        _buildFilterListItem(
                          Icons.category_outlined,
                          'Category',
                          tempCategory,
                          onTap: () {
                            _showSelectionDialog(
                              'Select Category',
                              [
                                'All Categories',
                                'Fiction',
                                'Reference',
                                'Literature',
                                'Science',
                                'History',
                              ],
                              tempCategory,
                              (val) {
                                setModalState(() {
                                  if (tempCategory != 'All Categories')
                                    tempActiveFilters.remove(tempCategory);
                                  tempCategory = val;
                                  if (val != 'All Categories' &&
                                      !tempActiveFilters.contains(val))
                                    tempActiveFilters.add(val);
                                });
                              },
                            );
                          },
                        ),
                        _buildFilterListItem(
                          Icons.calendar_today_outlined,
                          'Date Range',
                          tempDateRange,
                          onTap: () {
                            _showSelectionDialog(
                              'Select Date Range',
                              [
                                'Today',
                                'This Week',
                                'This Month',
                                'This Year (2024)',
                                'All Time',
                              ],
                              tempDateRange,
                              (val) {
                                setModalState(() {
                                  if (tempDateRange != 'This Year (2024)' &&
                                      tempDateRange != 'All Time')
                                    tempActiveFilters.remove(tempDateRange);
                                  tempDateRange = val;
                                  if (val != 'This Year (2024)' &&
                                      val != 'All Time' &&
                                      !tempActiveFilters.contains(val))
                                    tempActiveFilters.add(val);
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Apply Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedFilter = tempFilter;
                            _selectedCategory = tempCategory;
                            _selectedDateRange = tempDateRange;
                            _activeFilters = List.from(tempActiveFilters);
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B4EE6),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _getActiveFilterColor(String filter, {bool isBg = false}) {
    if (filter.toLowerCase() == 'books')
      return isBg ? const Color(0xFFEBF5FF) : const Color(0xFF3B82F6);
    if (filter.toLowerCase() == 'available')
      return isBg ? const Color(0xFFE8F5E9) : const Color(0xFF10B981);
    if (filter.toLowerCase() == '2024')
      return isBg ? const Color(0xFFFFF7ED) : const Color(0xFFF59E0B);
    return isBg
        ? const Color(0xFFF3F0FF)
        : const Color(0xFF6B4EE6); // default purple
  }

  Widget _buildFilterListItem(
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.transparent,
          border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF4B5563), size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: _textMuted),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFD1D5DB), size: 20),
          ],
        ),
      ),
    );
  }

  void _showSelectionDialog(
    String title,
    List<String> options,
    String currentSelection,
    Function(String) onSelected,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((opt) {
                return RadioListTile<String>(
                  title: Text(opt, style: const TextStyle(fontSize: 14)),
                  value: opt,
                  groupValue: currentSelection,
                  activeColor: const Color(0xFF6B4EE6),
                  onChanged: (val) {
                    if (val != null) {
                      onSelected(val);
                      Navigator.pop(context);
                    }
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const StudentInsightsScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
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
        selectedItemColor: const Color(0xFF8463E9),
        unselectedItemColor: _textMuted,
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Academics',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [const Icon(Icons.show_chart)],
            ),
            activeIcon: const Icon(Icons.show_chart),
            label: 'Activity',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Staff',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
        ],
      ),
    );
  }
}
