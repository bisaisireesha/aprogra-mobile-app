import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../data/mock_data/inventory_mock.dart';
import '../auth/menu_screen.dart';

class InventoryInsightsScreen extends StatefulWidget {
  const InventoryInsightsScreen({super.key});

  @override
  State<InventoryInsightsScreen> createState() => _InventoryInsightsScreenState();
}

class _InventoryInsightsScreenState extends State<InventoryInsightsScreen> {
  int _bottomNavIndex = 2; // Dashboard, Assets, Activity, Settings
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  List<String> _activeFilters = [];
  String _selectedFilter = 'All';
  String _selectedCategory = 'All Categories';
  String _selectedDateRange = 'This Month';

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 800;

  static const Color _textDark = Color(0xFF181B20);
  static const Color _textMuted = Color(0xFF5E6A78);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: _buildAppBar(),
      ),
      drawer: const MenuScreen(activeScreen: 'Inventory Insights'),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isTablet)
            const SizedBox(
              width: 280,
              child: MenuScreen(activeScreen: 'Inventory Insights'),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildAssetKPIs(),
                  const SizedBox(height: 32),
                  _buildStatusBoard(),
                  const SizedBox(height: 32),
                  if (_isTablet) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: _buildCriticalAlerts()),
                        const SizedBox(width: 32),
                        Expanded(flex: 4, child: _buildPurchaseRequests()),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: _buildIncomingDeliveries()),
                        const SizedBox(width: 32),
                        Expanded(flex: 4, child: _buildInventoryHealth()),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: _buildDamagedMissing()),
                        const SizedBox(width: 32),
                        Expanded(flex: 4, child: _buildDepartmentUsage()),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildAssetMonitoring(),
                    const SizedBox(height: 32),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: _buildInventoryActivityFeed()),
                        const SizedBox(width: 32),
                        Expanded(flex: 4, child: _buildInventoryAlertsCenter()),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildTodayHighlights(),
                  ] else ...[
                    _buildCriticalAlerts(),
                    const SizedBox(height: 32),
                    _buildPurchaseRequests(),
                    const SizedBox(height: 32),
                    _buildIncomingDeliveries(),
                    const SizedBox(height: 32),
                    _buildInventoryHealth(),
                    const SizedBox(height: 32),
                    _buildDamagedMissing(),
                    const SizedBox(height: 32),
                    _buildDepartmentUsage(),
                    const SizedBox(height: 32),
                    _buildAssetMonitoring(),
                    const SizedBox(height: 32),
                    _buildInventoryActivityFeed(),
                    const SizedBox(height: 32),
                    _buildInventoryAlertsCenter(),
                    const SizedBox(height: 32),
                    _buildTodayHighlights(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      
    );
  }

    Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Stockroom Active - Live',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        _buildFilterButton(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      width: _isTablet ? 300 : null,
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search inventory...',
          hintStyle: const TextStyle(color: _textMuted, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: _textMuted, size: 20),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF6B4EE6)),
          ),
        ),
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
            Text('Filter', style: TextStyle(color: Color(0xFF8F96A3), fontSize: 14, fontWeight: FontWeight.w600)),
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                          child: const Icon(Icons.close, color: _textDark, size: 24),
                        ),
                        const Text('Filter Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                        GestureDetector(
                          onTap: () {
                            setModalState(() {
                              tempFilter = 'All';
                              tempCategory = 'All Categories';
                              tempDateRange = 'This Month';
                              tempActiveFilters.clear();
                            });
                          },
                          child: const Text('Reset', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6B4EE6))),
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
                        const Text('Active Filters', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                        GestureDetector(
                          onTap: () {
                            setModalState(() {
                              tempActiveFilters.clear();
                              tempFilter = 'All';
                              tempCategory = 'All Categories';
                              tempDateRange = 'This Month';
                            });
                          },
                          child: const Text('Clear All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6B4EE6))),
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
                          final textColor = _getActiveFilterColor(filter, isBg: false);
                          final bgColor = _getActiveFilterColor(filter, isBg: true);
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: bgColor.withOpacity(0.5)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(filter, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor)),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      tempActiveFilters.remove(filter);
                                      if (filter == tempCategory) tempCategory = 'All Categories';
                                      if (filter == tempDateRange) tempDateRange = 'This Month';
                                      if (filter == tempFilter) tempFilter = 'All';
                                    });
                                  },
                                  child: Icon(Icons.close, size: 14, color: textColor),
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
                    child: Text('Quick Filter Chips', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['All', 'Critical Priority', 'Pending Action', 'Low Stock', 'In Transit', 'Resolved'].map((chip) {
                        final isSelected = tempFilter == chip;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              tempFilter = chip;
                              if (chip != 'All' && !tempActiveFilters.contains(chip)) {
                                tempActiveFilters.add(chip);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFF3F0FF) : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: isSelected ? const Color(0xFFE5E0F8) : const Color(0xFFF0F0F0)),
                            ),
                            child: Text(chip, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? const Color(0xFF6B4EE6) : const Color(0xFF4B5563))),
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
                        _buildFilterListItem(Icons.category_outlined, 'Category', tempCategory, onTap: () {
                          _showSelectionDialog('Select Category', ['All Categories', 'IT Department', 'Sports Department', 'Science Department', 'Operations', 'General'], tempCategory, (val) {
                            setModalState(() {
                              if (tempCategory != 'All Categories') tempActiveFilters.remove(tempCategory);
                              tempCategory = val;
                              if (val != 'All Categories' && !tempActiveFilters.contains(val)) tempActiveFilters.add(val);
                            });
                          });
                        }),
                        _buildFilterListItem(Icons.calendar_today_outlined, 'Date Range', tempDateRange, onTap: () {
                          _showSelectionDialog('Select Date Range', ['Today', 'This Week', 'This Month', 'This Year (2024)', 'All Time'], tempDateRange, (val) {
                            setModalState(() {
                              if (tempDateRange != 'This Month' && tempDateRange != 'All Time') tempActiveFilters.remove(tempDateRange);
                              tempDateRange = val;
                              if (val != 'This Month' && val != 'All Time' && !tempActiveFilters.contains(val)) tempActiveFilters.add(val);
                            });
                          });
                        }),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
    if (filter.toLowerCase() == 'critical priority') return isBg ? const Color(0xFFFFEBEB) : const Color(0xFFEF4444);
    if (filter.toLowerCase() == 'low stock') return isBg ? const Color(0xFFFFF7ED) : const Color(0xFFF59E0B);
    return isBg ? const Color(0xFFF3F0FF) : const Color(0xFF6B4EE6);
  }

  Widget _buildFilterListItem(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
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
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: _textMuted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFD1D5DB), size: 20),
          ],
        ),
      ),
    );
  }

  void _showSelectionDialog(String title, List<String> options, String currentSelection, Function(String) onSelected) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF6B4EE6))),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeaderAction(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF4B5563)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF4B5563))),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredData(List<Map<String, dynamic>> data) {
    return data.where((item) {
      bool matchesSearch = _searchQuery.isEmpty ||
          (item['title']?.toString().toLowerCase().contains(_searchQuery) ?? false) ||
          (item['subtitle']?.toString().toLowerCase().contains(_searchQuery) ?? false) ||
          (item['location']?.toString().toLowerCase().contains(_searchQuery) ?? false) ||
          (item['vendor']?.toString().toLowerCase().contains(_searchQuery) ?? false) ||
          (item['department']?.toString().toLowerCase().contains(_searchQuery) ?? false) ||
          (item['issue']?.toString().toLowerCase().contains(_searchQuery) ?? false);

      bool matchesFilter = _activeFilters.isEmpty;
      if (_activeFilters.isNotEmpty) {
        String title = item['title']?.toString().toLowerCase() ?? '';
        String subtitle = item['subtitle']?.toString().toLowerCase() ?? '';
        String location = item['location']?.toString().toLowerCase() ?? '';
        String department = item['department']?.toString().toLowerCase() ?? '';
        String combined = '$title $subtitle $location $department'.toLowerCase();
        
        for (String filter in _activeFilters) {
          if (filter == 'Critical Priority' && (item['colorType'] == 'red' || combined.contains('critical') || combined.contains('out of stock'))) {
            matchesFilter = true;
          } else if (filter == 'IT Department' && (combined.contains('it ') || combined.contains('computer'))) {
            matchesFilter = true;
          } else if (filter == 'Sports Department' && combined.contains('sports')) {
            matchesFilter = true;
          } else if (filter == 'Science Department' && (combined.contains('science') || combined.contains('lab'))) {
            matchesFilter = true;
          } else if (filter == 'Operations' && combined.contains('operations')) {
            matchesFilter = true;
          } else if (filter == 'Pending Action' && (combined.contains('pending') || combined.contains('awaiting') || combined.contains('review'))) {
            matchesFilter = true;
          } else if (filter == 'Low Stock' && (combined.contains('low') || combined.contains('below'))) {
            matchesFilter = true;
          } else if (filter == 'In Transit' && (combined.contains('transit') || combined.contains('dispatched'))) {
            matchesFilter = true;
          } else if (filter == 'Resolved' && (combined.contains('resolved') || combined.contains('completed'))) {
            matchesFilter = true;
          }
        }
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  Widget _buildAssetKPIs() {
    double screenWidth = MediaQuery.of(context).size.width;
    int columns = _isTablet ? (screenWidth > 1200 ? 6 : 3) : 2;
    double spacing = 16.0;
    double availableWidth = screenWidth - (_isTablet ? 280 : 0) - 48;
    double cardWidth = (availableWidth - (spacing * (columns - 1))) / columns;
    if (cardWidth < 150) cardWidth = 150;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: InventoryMockData.assetKPIs.map((kpi) => SizedBox(
        width: cardWidth,
        child: _buildKPICard(kpi),
      )).toList(),
    );
  }

  Widget _buildKPICard(Map<String, dynamic> kpi) {
    Color iconColor;
    Color iconBgColor;

    switch (kpi['colorType']) {
      case 'yellow':
        iconColor = const Color(0xFFF59E0B);
        iconBgColor = const Color(0xFFFFF7ED);
        break;
      case 'orange':
        iconColor = const Color(0xFFF97316);
        iconBgColor = const Color(0xFFFFF7ED);
        break;
      case 'red':
        iconColor = const Color(0xFFEF4444);
        iconBgColor = const Color(0xFFFFEBEB);
        break;
      case 'blue':
        iconColor = const Color(0xFF3B82F6);
        iconBgColor = const Color(0xFFEFF6FF);
        break;
      case 'green':
        iconColor = const Color(0xFF10B981);
        iconBgColor = const Color(0xFFE8F5E9);
        break;
      case 'purple':
        iconColor = const Color(0xFF8B5CF6);
        iconBgColor = const Color(0xFFF5F3FF);
        break;
      default:
        iconColor = _textDark;
        iconBgColor = const Color(0xFFF3F3F6);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(8)),
                child: Icon(kpi['icon'] as IconData, size: 20, color: iconColor),
              ),
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(kpi['value'] as String, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 4),
          Text(kpi['title'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textDark)),
          const SizedBox(height: 2),
          Text(kpi['subtitle'] as String, style: const TextStyle(fontSize: 12, color: _textMuted)),
        ],
      ),
    );
  }

  Widget _buildStatusBoard() {
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
                  decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.inventory_2_outlined, color: Color(0xFF6B4EE6), size: 18),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Inventory Status Board', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                    Text('Category-level stock health', style: TextStyle(fontSize: 12, color: _textMuted)),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
              child: const Text('4 Healthy • 3 Attention', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        LayoutBuilder(
          builder: (context, constraints) {
            int columns = _isTablet ? (constraints.maxWidth > 800 ? 3 : 2) : 1;
            double spacing = 16.0;
            double cardWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;
            
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: InventoryMockData.statusBoard.map((status) {
                Color mainColor;
                Color bgColor;

                switch (status['colorType']) {
                  case 'yellow':
                    mainColor = const Color(0xFFF59E0B);
                    bgColor = const Color(0xFFFFF7ED);
                    break;
                  case 'red':
                    mainColor = const Color(0xFFEF4444);
                    bgColor = const Color(0xFFFFEBEB);
                    break;
                  case 'blue':
                    mainColor = const Color(0xFF3B82F6);
                    bgColor = const Color(0xFFEFF6FF);
                    break;
                  case 'green':
                  default:
                    mainColor = const Color(0xFF10B981);
                    bgColor = const Color(0xFFE8F5E9);
                }

                return Container(
                  width: cardWidth,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: mainColor.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
                            child: Icon(status['icon'] as IconData, size: 20, color: mainColor),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(status['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                                const SizedBox(height: 2),
                                Text(status['items'] as String, style: const TextStyle(fontSize: 12, color: _textMuted)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
                            child: Text(status['status'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: mainColor)),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(child: _buildDataBox('Low', status['low'] as String)),
                          const SizedBox(width: 8),
                          Expanded(child: _buildDataBox('Out', status['out'] as String)),
                          const SizedBox(width: 8),
                          Expanded(child: _buildDataBox('Pending', status['pending'] as String)),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Stock health', style: TextStyle(fontSize: 12, color: _textMuted)),
                          Text(status['health'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
                          child: Row(
                            children: [
                              Expanded(
                                flex: ((status['healthValue'] as double) * 100).toInt(),
                                child: Container(color: mainColor),
                              ),
                              if (status['healthValue'] < 1.0)
                                Expanded(
                                  flex: ((1.0 - (status['healthValue'] as double)) * 100).toInt(),
                                  child: Container(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDataBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: _textMuted)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
        ],
      ),
    );
  }

  Widget _buildCriticalAlerts() {
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
                  decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.error_outline, color: Color(0xFF6B4EE6), size: 18),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Critical Stock Alerts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                    Text('Items requiring immediate replenishment', style: TextStyle(fontSize: 12, color: _textMuted)),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFFFEBEB), borderRadius: BorderRadius.circular(12)),
              child: const Text('High Priority', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2), // Light red background tint
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFCA5A5).withOpacity(0.5)), // Light red border
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              int columns = constraints.maxWidth > 500 ? 2 : 1;
              double cardWidth = (constraints.maxWidth - (16 * (columns - 1))) / columns;
              
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: InventoryMockData.criticalAlerts.map((alert) {
                  Color badgeColor = alert['colorType'] == 'red' ? const Color(0xFFEF4444) : const Color(0xFFF59E0B);
                  Color badgeBgColor = alert['colorType'] == 'red' ? const Color(0xFFFFEBEB) : const Color(0xFFFFF7ED);
                  
                  return Container(
                    width: cardWidth,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.warning_amber_rounded, size: 20, color: badgeColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(alert['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                              const SizedBox(height: 2),
                              Text(alert['department'] as String, style: const TextStyle(fontSize: 12, color: _textMuted)),
                              const SizedBox(height: 6),
                              Text(alert['detail'] as String, style: const TextStyle(fontSize: 12, color: _textDark)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: badgeBgColor, borderRadius: BorderRadius.circular(4)),
                          child: Text(alert['status'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: badgeColor)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPurchaseRequests() {
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
                  decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF3B82F6), size: 18),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Purchase Request Center', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                    Text('Awaiting approval & procurement', style: TextStyle(fontSize: 12, color: _textMuted)),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(12)),
              child: const Text('7 Pending', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Column(
          children: InventoryMockData.purchaseRequests.map((request) {
            Color badgeColor;
            Color badgeBgColor;

            switch (request['colorType']) {
              case 'orange':
                badgeColor = const Color(0xFFF59E0B);
                badgeBgColor = const Color(0xFFFFF7ED);
                break;
              case 'blue':
                badgeColor = const Color(0xFF3B82F6);
                badgeBgColor = const Color(0xFFEFF6FF);
                break;
              case 'purple':
                badgeColor = const Color(0xFF8B5CF6);
                badgeBgColor = const Color(0xFFF5F3FF);
                break;
              case 'green':
                badgeColor = const Color(0xFF10B981);
                badgeBgColor = const Color(0xFFE8F5E9);
                break;
              default:
                badgeColor = _textDark;
                badgeBgColor = const Color(0xFFF3F3F6);
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF0F0F0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.receipt_long, size: 20, color: Color(0xFF8B5CF6)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(request['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                        const SizedBox(height: 2),
                        Text(request['items'] as String, style: const TextStyle(fontSize: 12, color: _textDark)),
                        const SizedBox(height: 4),
                        Text(request['requestedBy'] as String, style: const TextStyle(fontSize: 11, color: _textMuted)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: badgeBgColor, borderRadius: BorderRadius.circular(8)),
                    child: Text(request['status'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: badgeColor)),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIncomingDeliveries() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.local_shipping_outlined, color: Color(0xFF6B4EE6), size: 18),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Incoming Deliveries', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                Text('Received and in-transit shipments', style: TextStyle(fontSize: 12, color: _textMuted)),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h),
        LayoutBuilder(
          builder: (context, constraints) {
            int columns = constraints.maxWidth > 500 ? 2 : 1;
            double spacing = 16.0;
            double cardWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;
            
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: InventoryMockData.incomingDeliveries.map((delivery) {
                Color badgeColor;
                Color badgeBgColor;

                switch (delivery['colorType']) {
                  case 'red':
                    badgeColor = const Color(0xFFEF4444);
                    badgeBgColor = const Color(0xFFFFEBEB);
                    break;
                  case 'yellow':
                    badgeColor = const Color(0xFFF59E0B);
                    badgeBgColor = const Color(0xFFFFF7ED);
                    break;
                  case 'blue':
                    badgeColor = const Color(0xFF3B82F6);
                    badgeBgColor = const Color(0xFFEFF6FF);
                    break;
                  case 'purple':
                    badgeColor = const Color(0xFF8B5CF6);
                    badgeBgColor = const Color(0xFFF5F3FF);
                    break;
                  case 'green':
                  default:
                    badgeColor = const Color(0xFF10B981);
                    badgeBgColor = const Color(0xFFE8F5E9);
                }

                return Container(
                  width: cardWidth,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: badgeBgColor, borderRadius: BorderRadius.circular(8)),
                        child: Icon(delivery['icon'] as IconData, size: 20, color: badgeColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(delivery['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                            const SizedBox(height: 4),
                            Text('Vendor: ${delivery['vendor']}', style: const TextStyle(fontSize: 12, color: _textMuted)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 14, color: _textMuted),
                                const SizedBox(width: 4),
                                Expanded(child: Text(delivery['detail'] as String, style: const TextStyle(fontSize: 12, color: _textDark))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: badgeBgColor, borderRadius: BorderRadius.circular(12)),
                        child: Text(delivery['status'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: badgeColor)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInventoryHealth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.show_chart, color: Color(0xFF6B4EE6), size: 18),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Inventory Health Monitor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                Text('Status by category', style: TextStyle(fontSize: 12, color: _textMuted)),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0F0F0)),
          ),
          child: Column(
            children: List.generate(InventoryMockData.inventoryHealth.length, (index) {
              final health = InventoryMockData.inventoryHealth[index];
              Color dotColor;
              Color badgeBgColor;

              switch (health['colorType']) {
                case 'yellow':
                  dotColor = const Color(0xFFF59E0B);
                  badgeBgColor = const Color(0xFFFFF7ED);
                  break;
                case 'red':
                  dotColor = const Color(0xFFEF4444);
                  badgeBgColor = const Color(0xFFFFEBEB);
                  break;
                case 'blue':
                  dotColor = const Color(0xFF3B82F6);
                  badgeBgColor = const Color(0xFFEFF6FF);
                  break;
                case 'purple':
                  dotColor = const Color(0xFF8B5CF6);
                  badgeBgColor = const Color(0xFFF5F3FF);
                  break;
                case 'green':
                default:
                  dotColor = const Color(0xFF10B981);
                  badgeBgColor = const Color(0xFFE8F5E9);
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
                            const SizedBox(width: 12),
                            Text(health['category'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _textDark)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: badgeBgColor, borderRadius: BorderRadius.circular(12)),
                          child: Text(health['status'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: dotColor)),
                        ),
                      ],
                    ),
                  ),
                  if (index != InventoryMockData.inventoryHealth.length - 1)
                    Divider(color: Colors.grey.withOpacity(0.2), height: 1),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildDamagedMissing() {
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
                  decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.build, color: Color(0xFF6B4EE6), size: 18),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Damaged & Missing Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                    Text('Loss prevention and inspections', style: TextStyle(fontSize: 12, color: _textMuted)),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFFFEBEB), borderRadius: BorderRadius.circular(12)),
              child: const Text('15 Open', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        LayoutBuilder(
          builder: (context, constraints) {
            int columns = constraints.maxWidth > 500 ? 2 : 1;
            double spacing = 16.0;
            double cardWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;
            
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: InventoryMockData.damagedMissingItems.map((item) {
                Color themeColor;
                Color themeBgColor;

                switch (item['colorType']) {
                  case 'red':
                    themeColor = const Color(0xFFEF4444);
                    themeBgColor = const Color(0xFFFFEBEB);
                    break;
                  case 'yellow':
                    themeColor = const Color(0xFFF59E0B);
                    themeBgColor = const Color(0xFFFFF7ED);
                    break;
                  case 'orange':
                    themeColor = const Color(0xFFF97316);
                    themeBgColor = const Color(0xFFFFF7ED);
                    break;
                  case 'blue':
                  default:
                    themeColor = const Color(0xFF3B82F6);
                    themeBgColor = const Color(0xFFEFF6FF);
                }

                return Container(
                  width: cardWidth,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: themeBgColor, borderRadius: BorderRadius.circular(8)),
                        child: Icon(item['icon'] as IconData, size: 20, color: themeColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: Text(item['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark))),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: themeBgColor, borderRadius: BorderRadius.circular(12)),
                                  child: Text(item['status'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: themeColor)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(item['location'] as String, style: const TextStyle(fontSize: 12, color: _textMuted)),
                            const SizedBox(height: 8),
                            const Text('Open ticket >', style: TextStyle(fontSize: 12, color: Color(0xFF6B4EE6), fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDepartmentUsage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.corporate_fare_outlined, color: Color(0xFF6B4EE6), size: 18),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Department Inventory Usage', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                Text('Items allocated & active', style: TextStyle(fontSize: 12, color: _textMuted)),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0F0F0)),
          ),
          child: Column(
            children: List.generate(InventoryMockData.departmentUsage.length, (index) {
              final dept = InventoryMockData.departmentUsage[index];
              Color barColor;

              switch (dept['colorType']) {
                case 'red':
                  barColor = const Color(0xFFEF4444);
                  break;
                case 'blue':
                  barColor = const Color(0xFF3B82F6);
                  break;
                case 'lightBlue':
                  barColor = const Color(0xFF38BDF8);
                  break;
                case 'purple':
                  barColor = const Color(0xFF8B5CF6);
                  break;
                case 'orange':
                  barColor = const Color(0xFFF97316);
                  break;
                case 'green':
                default:
                  barColor = const Color(0xFF10B981);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index > 0)
                    Divider(color: Colors.grey.withOpacity(0.2), height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dept['department'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _textDark)),
                      Text(dept['items'] as String, style: const TextStyle(fontSize: 12, color: _textMuted)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
                      child: Row(
                        children: [
                          Expanded(
                            flex: ((dept['usage'] as double) * 100).toInt(),
                            child: Container(color: barColor),
                          ),
                          Expanded(
                            flex: ((1.0 - (dept['usage'] as double)) * 100).toInt(),
                            child: Container(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildAssetMonitoring() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.monitor, color: Color(0xFF6B4EE6), size: 18),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Asset Monitoring', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                Text('School assets and maintenance status', style: TextStyle(fontSize: 12, color: _textMuted)),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h),
        LayoutBuilder(
          builder: (context, constraints) {
            int columns = _isTablet ? (constraints.maxWidth > 800 ? 4 : 2) : 1;
            double spacing = 16.0;
            double cardWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;
            
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: InventoryMockData.assetMonitoring.map((asset) {
                Color statusColor;
                Color statusBgColor;

                switch (asset['statusColor']) {
                  case 'yellow':
                    statusColor = const Color(0xFFF59E0B);
                    statusBgColor = const Color(0xFFFFF7ED);
                    break;
                  case 'orange':
                    statusColor = const Color(0xFFF97316);
                    statusBgColor = const Color(0xFFFFF7ED);
                    break;
                  case 'purple':
                    statusColor = const Color(0xFF8B5CF6);
                    statusBgColor = const Color(0xFFF5F3FF);
                    break;
                  case 'lightBlue':
                  default:
                    statusColor = const Color(0xFF38BDF8);
                    statusBgColor = const Color(0xFFF0F9FF);
                }

                return Container(
                  width: cardWidth,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(8)),
                            child: Icon(asset['icon'] as IconData, size: 20, color: statusColor),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(asset['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                                const SizedBox(height: 2),
                                Text(asset['total'] as String, style: const TextStyle(fontSize: 12, color: _textMuted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_circle_outline, size: 14, color: Color(0xFF10B981)),
                              const SizedBox(width: 4),
                              Text(asset['operationalLabel'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(4)),
                            child: Text(asset['status'] as String, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
                          child: Row(
                            children: [
                              Expanded(
                                flex: ((asset['healthValue'] as double) * 100).toInt(),
                                child: Container(color: const Color(0xFF10B981)),
                              ),
                              Expanded(
                                flex: ((1.0 - (asset['healthValue'] as double)) * 100).toInt(),
                                child: Container(color: statusColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInventoryActivityFeed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.timeline, color: Color(0xFF6B4EE6), size: 18),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Inventory Activity Feed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                Text('Live operations timeline', style: TextStyle(fontSize: 12, color: _textMuted)),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: Column(
            children: _getFilteredData(InventoryMockData.activityFeed).map((activity) {
              Color themeColor;
              switch (activity['colorType']) {
                case 'blue':
                  themeColor = const Color(0xFF3B82F6);
                  break;
                case 'purple':
                  themeColor = const Color(0xFF8B5CF6);
                  break;
                case 'orange':
                  themeColor = const Color(0xFFF59E0B);
                  break;
                case 'red':
                  themeColor = const Color(0xFFEF4444);
                  break;
                case 'green':
                default:
                  themeColor = const Color(0xFF10B981);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(color: themeColor, shape: BoxShape.circle),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(activity['icon'] as IconData, size: 16, color: const Color(0xFF6B7280)),
                              const SizedBox(width: 8),
                              Text(activity['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(activity['subtitle'] as String, style: const TextStyle(fontSize: 12, color: _textMuted)),
                        ],
                      ),
                    ),
                    Text(activity['time'] as String, style: const TextStyle(fontSize: 12, color: _textMuted)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryAlertsCenter() {
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
                  decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.error_outline, color: Color(0xFF6B4EE6), size: 18),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Inventory Alerts Center', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                    Text('Operational issues to review', style: TextStyle(fontSize: 12, color: _textMuted)),
                  ],
                ),
              ],
            ),
            const Text('5 Active', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
          ],
        ),
        SizedBox(height: 12.h),
        Column(
          children: _getFilteredData(InventoryMockData.alertsCenter).map((alert) {
            Color themeColor;
            Color themeBgColor;

            switch (alert['colorType']) {
              case 'yellow':
                themeColor = const Color(0xFFF59E0B);
                themeBgColor = const Color(0xFFFFF7ED);
                break;
              case 'red':
                themeColor = const Color(0xFFEF4444);
                themeBgColor = const Color(0xFFFFEBEB);
                break;
              case 'lightBlue':
                themeColor = const Color(0xFF38BDF8);
                themeBgColor = const Color(0xFFF0F9FF);
                break;
              case 'orange':
                themeColor = const Color(0xFFF97316);
                themeBgColor = const Color(0xFFFFF7ED);
                break;
              case 'purple':
              default:
                themeColor = const Color(0xFF8B5CF6);
                themeBgColor = const Color(0xFFF5F3FF);
            }

            return InkWell(
              onTap: () => _showAlertViewPopup(alert),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF3F4F6)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: themeBgColor, borderRadius: BorderRadius.circular(8)),
                      child: Icon(alert['icon'] as IconData, size: 20, color: themeColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(alert['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                          const SizedBox(height: 2),
                          Text(alert['subtitle'] as String, style: const TextStyle(fontSize: 12, color: _textMuted)),
                        ],
                      ),
                    ),
                    const Text('View >', style: TextStyle(fontSize: 12, color: Color(0xFF6B4EE6))),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showAlertViewPopup(Map<String, dynamic> alert) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(alert['icon'] as IconData, color: const Color(0xFF6B4EE6)),
              const SizedBox(width: 8),
              Expanded(child: Text(alert['title'] as String, style: const TextStyle(fontSize: 18))),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Details: ${alert['subtitle']}', style: const TextStyle(fontSize: 14, color: _textMuted)),
              SizedBox(height: 12.h),
              const Text('Please review this operational issue and take appropriate action to resolve it.'),
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
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action initiated.')));
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B4EE6)),
              child: const Text('Acknowledge / Resolve', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTodayHighlights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.auto_awesome, color: Color(0xFF6B4EE6), size: 18),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Today\'s Highlights', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                Text('Snapshot of the day', style: TextStyle(fontSize: 12, color: _textMuted)),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h),
        LayoutBuilder(
          builder: (context, constraints) {
            int columns = _isTablet ? (constraints.maxWidth > 800 ? 6 : 3) : 2;
            double spacing = 16.0;
            double cardWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;
            
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: InventoryMockData.todayHighlights.map((kpi) {
                return SizedBox(
                  width: cardWidth,
                  child: _buildHighlightCard(kpi),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHighlightCard(Map<String, dynamic> kpi) {
    Color mainColor;
    Color bgColor;

    switch (kpi['colorType']) {
      case 'yellow':
        mainColor = const Color(0xFFF59E0B);
        bgColor = const Color(0xFFFFF7ED);
        break;
      case 'red':
        mainColor = const Color(0xFFEF4444);
        bgColor = const Color(0xFFFFEBEB);
        break;
      case 'blue':
        mainColor = const Color(0xFF3B82F6);
        bgColor = const Color(0xFFEFF6FF);
        break;
      case 'orange':
        mainColor = const Color(0xFFF97316);
        bgColor = const Color(0xFFFFF7ED);
        break;
      case 'purple':
        mainColor = const Color(0xFF8B5CF6);
        bgColor = const Color(0xFFF5F3FF);
        break;
      case 'green':
      default:
        mainColor = const Color(0xFF10B981);
        bgColor = const Color(0xFFE8F5E9);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: mainColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
            child: Icon(kpi['icon'] as IconData, color: mainColor, size: 20),
          ),
          SizedBox(height: 12.h),
          Text(kpi['value'] as String, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 4),
          Text(kpi['subtitle'] as String, style: const TextStyle(fontSize: 12, color: _textMuted)),
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
                          hintText: 'Search inventory...',
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

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.dashboard_outlined, 'Dashboard'),
              _buildNavItem(1, Icons.inventory_2_outlined, 'Assets'),
              _buildNavItem(2, Icons.show_chart, 'Activity'),
              _buildNavItem(3, Icons.settings_outlined, 'Settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _bottomNavIndex == index;
    final color = isSelected ? const Color(0xFF6B4EE6) : const Color(0xFF8F96A3);

    return GestureDetector(
      onTap: () {
        setState(() {
          _bottomNavIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3F0FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
