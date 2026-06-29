import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../data/mock_data/homework_mock.dart';
import '../auth/menu_screen.dart';
import 'create_homework_bottom_sheet.dart';
import 'view_homework_dialog.dart';

// Category lookup by class name (mirrors the map in create_homework_bottom_sheet.dart)
const _homeworkCategoryMap = {
  'Nursery A': 'Pre-Primary', 'Nursery B': 'Pre-Primary', 'Nursery C': 'Pre-Primary',
  'LKG A': 'Pre-Primary', 'LKG B': 'Pre-Primary', 'LKG C': 'Pre-Primary',
  'UKG A': 'Pre-Primary', 'UKG B': 'Pre-Primary', 'UKG C': 'Pre-Primary',
  'Class 1A': 'Primary', 'Class 1B': 'Primary', 'Class 1C': 'Primary',
  'Class 2A': 'Primary', 'Class 2B': 'Primary', 'Class 2C': 'Primary',
  'Class 3A': 'Primary', 'Class 3B': 'Primary',
  'Class 4A': 'Primary', 'Class 4B': 'Primary', 'Class 4C': 'Primary',
  'Class 5A': 'Primary', 'Class 5B': 'Primary',
  'Class 6A': 'Secondary', 'Class 6B': 'Secondary',
  'Class 7A': 'Secondary', 'Class 7B': 'Secondary',
  'Class 8A': 'Secondary', 'Class 8B': 'Secondary',
  'Class 9A': 'Secondary', 'Class 9B': 'Secondary',
  'Class 10A': 'Secondary', 'Class 10B': 'Secondary',
  'Class 11A': 'Secondary', 'Class 12A': 'Secondary',
};

const _bgPrimary = Color(0xFFF6F6F8);
const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);
const _iconBg = Color(0xFFFFF4E5); // Light yellow/orange for homework icon
const _iconColor = Color(0xFFFF9F2D); // Orange for homework icon

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  int _bottomNavIndex = 1; // 1 for Academics
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 2; // 2 for Primary
  
  List<Map<String, dynamic>> _items = [];

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  @override
  void initState() {
    super.initState();
    _items = List<Map<String, dynamic>>.from(HomeworkMockData.homeworkItems);
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _currentCategory =>
      _selectedFilterIndex == 1 ? 'Pre-Primary' : _selectedFilterIndex == 2 ? 'Primary' : 'Secondary';

  List<Map<String, dynamic>> get _filteredItems {
    final query = _searchController.text.toLowerCase();
    return _items.where((item) {
      // Derive category from class name if not set
      final category = item['category'] as String? ??
          (_homeworkCategoryMap[item['class']] ?? 'Primary');
      final matchesCategory = category == _currentCategory;
      final matchesQuery = query.isEmpty ||
          (item['title'] as String).toLowerCase().contains(query) ||
          (item['class'] as String).toLowerCase().contains(query) ||
          (item['teacher'] as String).toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  int _countForCategory(String category) =>
      _items.where((item) {
        final cat = item['category'] as String? ??
            (_homeworkCategoryMap[item['class']] ?? 'Primary');
        return cat == category;
      }).length;

  void _handleCreateHomework() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
        child: CreateHomeworkBottomSheet(
          onSave: (newItem) {
            setState(() {
              _items.insert(0, newItem); // Add to top
            });
          },
        ),
      ),
    );
  }

  void _handleEditHomework(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
        child: CreateHomeworkBottomSheet(
          initialData: item,
          onSave: (updatedItem) {
            setState(() {
              final index = _items.indexOf(item);
              if (index != -1) {
                _items[index] = updatedItem;
              }
            });
          },
        ),
      ),
    );
  }

  void _handleViewHomework(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => ViewHomeworkDialog(item: item),
    );
  }

  void _handleDeleteHomework(Map<String, dynamic> item) {
    setState(() {
      _items.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(_isTablet ? 40 : 16, 24, _isTablet ? 40 : 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 24),
                          _buildFilterButtons(),
                          const SizedBox(height: 24),
                          _buildSearchBarRow(),
                          const SizedBox(height: 24),
                          _isTablet ? _buildDesktopList() : _buildMobileList(),
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
      drawer: const MenuScreen(activeScreen: 'Homework'),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F8),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Color(0xFF8F96A3), fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF8F96A3), size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.notifications_none_rounded, color: Color(0xFF8F96A3), size: 24),
          const SizedBox(width: 16),
          CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFF4F1FF),
              child: Text('A', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF8463E9))),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.notebookPen, color: _accent, size: 28),
                            const SizedBox(width: 12),
                            Text(
                              'Homework',
                              style: GoogleFonts.figtree(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: _textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Assign daily homework to classes and track who has completed it.',
                          style: GoogleFonts.figtree(
                            fontSize: 16,
                            color: _textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildCreateButton(),
                ],
              )
            else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.notebookPen, color: _accent, size: 24),
                            const SizedBox(width: 12),
                            Text(
                              'Homework',
                              style: GoogleFonts.figtree(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: _textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Assign daily homework to classes and track who has completed it.',
                          style: GoogleFonts.figtree(
                            fontSize: 14,
                            color: _textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: _buildCreateButton(),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildCreateButton() {
    return ElevatedButton.icon(
      onPressed: _handleCreateHomework,
      icon: const Icon(Icons.add, size: 18, color: Colors.white),
      label: Text(
        'Create Homework',
        style: GoogleFonts.figtree(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _accent,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      children: [
        Expanded(child: _buildFilterButton('Pre-Primary', 1, _countForCategory('Pre-Primary'))),
        const SizedBox(width: 8),
        Expanded(child: _buildFilterButton('Primary', 2, _countForCategory('Primary'))),
        const SizedBox(width: 8),
        Expanded(child: _buildFilterButton('Secondary', 3, _countForCategory('Secondary'))),
      ],
    );
  }

  Widget _buildFilterButton(String label, int index, int count) {
    bool isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _accent : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? _accent : const Color(0xFFEBEBEB)),
          boxShadow: isSelected ? [BoxShadow(color: _accent.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))] : null,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.figtree(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : _textMuted,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.25) : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.figtree(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : _textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }




  Widget _buildSearchBarRow() {
    return Row(
      children: [
        Expanded(
          flex: _isTablet ? 1 : 2,
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search homework, teacher, or class',
                hintStyle: TextStyle(color: Color(0xFF8F96A3), fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Color(0xFF8F96A3), size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),
        if (!_isTablet) ...[
          const SizedBox(width: 12),
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Icon(Icons.filter_list, color: _textDark),
          ),
        ],
        if (_isTablet) ...[
          const SizedBox(width: 24),
          Text(
            '${_filteredItems.length} items',
            style: GoogleFonts.figtree(
              fontSize: 14,
              color: _textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
        ],
      ],
    );
  }

  Widget _buildDesktopList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          // Header Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              children: [
                Expanded(flex: 4, child: Text('TITLE', style: _tableHeaderStyle())),
                Expanded(flex: 2, child: Text('CLASS', style: _tableHeaderStyle())),
                Expanded(flex: 3, child: Text('ASSIGNED TEACHER', style: _tableHeaderStyle())),
                Expanded(flex: 2, child: Text('DUE', style: _tableHeaderStyle())),
                const SizedBox(width: 32),
              ],
            ),
          ),
          if (_filteredItems.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No homework found.',
                style: GoogleFonts.figtree(fontSize: 16, color: _textMuted),
              ),
            ),
          // Data Rows
          ..._filteredItems.map((item) {
            final isLast = item == _filteredItems.last;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _iconBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(item['icon'], color: _iconColor, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['title'], style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
                              const SizedBox(height: 4),
                              Text('${item['submitted']}/${item['total']} submitted', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(flex: 2, child: Text(item['class'], style: GoogleFonts.figtree(fontSize: 14, color: _textDark))),
                  Expanded(flex: 3, child: Text(item['teacher'], style: GoogleFonts.figtree(fontSize: 14, color: _textDark))),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        const Icon(LucideIcons.calendarDays, size: 16, color: _textMuted),
                        const SizedBox(width: 8),
                        Text(item['due'], style: GoogleFonts.figtree(fontSize: 14, color: _textDark)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    child: _buildPopupMenu(item),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  TextStyle _tableHeaderStyle() {
    return GoogleFonts.figtree(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF8F96A3),
      letterSpacing: 0.5,
    );
  }

  Widget _buildMobileList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 4),
          child: Text(
            '${_filteredItems.length} Homework',
            style: GoogleFonts.figtree(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
        ),
        if (_filteredItems.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'No homework found.',
              style: GoogleFonts.figtree(fontSize: 16, color: _textMuted),
            ),
          ),
        ..._filteredItems.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
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
                        color: _iconBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(item['icon'], color: _iconColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title'], style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
                          const SizedBox(height: 4),
                          Text('${item['class']} • ${item['teacher']}', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
                        ],
                      ),
                    ),
                    _buildPopupMenu(item),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item['submitted']}/${item['total']} submitted', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted, fontWeight: FontWeight.w600)),
                    Row(
                      children: [
                        const Icon(LucideIcons.calendarDays, size: 14, color: _textMuted),
                        const SizedBox(width: 6),
                        Text(item['due'], style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textDark)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: item['submitted'] / item['total'],
                  backgroundColor: const Color(0xFFF3F4F6),
                  color: const Color(0xFF6B4EEA), // A slightly deeper purple for progress
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPopupMenu(Map<String, dynamic> item) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Color(0xFF595973), size: 20),
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      onSelected: (value) {
        if (value == 'view') {
          _handleViewHomework(item);
        } else if (value == 'edit') {
          _handleEditHomework(item);
        } else if (value == 'delete') {
          _handleDeleteHomework(item);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'view',
          child: Row(
            children: [
              const Icon(LucideIcons.eye, size: 18, color: Color(0xFF595973)),
              const SizedBox(width: 12),
              Text('View', style: GoogleFonts.figtree(color: const Color(0xFF181B20))),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              const Icon(LucideIcons.edit2, size: 18, color: Color(0xFF595973)),
              const SizedBox(width: 12),
              Text('Edit', style: GoogleFonts.figtree(color: const Color(0xFF181B20))),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              const Icon(LucideIcons.trash2, size: 18, color: Colors.redAccent),
              const SizedBox(width: 12),
              Text('Delete', style: GoogleFonts.figtree(color: Colors.redAccent)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        border: const Border(top: BorderSide(color: Color(0xFFEBEBEB), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
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
