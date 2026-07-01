import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../data/mock_data/assignments_mock.dart';
import '../auth/menu_screen.dart';
import 'create_assignment_bottom_sheet.dart';

// Category map mirrored here for local use
const _assignmentCategoryMap = {
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
const _iconBg = Color(0xFFEEE8FF);
const _iconColor = Color(0xFF8463E9);

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  int _bottomNavIndex = 1;
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 2; // Default: Primary

  List<Map<String, dynamic>> _items = [];

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  @override
  void initState() {
    super.initState();
    _loadItems();
    _items = List<Map<String, dynamic>>.from(AssignmentsMockData.assignmentItems);
    _searchController.addListener(() => setState(() {}));
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
      final category = item['category'] as String? ??
          (_assignmentCategoryMap[item['class']] ?? 'Primary');
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
            (_assignmentCategoryMap[item['class']] ?? 'Primary');
        return cat == category;
      }).length;

  void _handleCreate() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
        child: CreateAssignmentBottomSheet(
          onSave: (newItem) => setState(() => _items.insert(0, newItem)),
        ),
      ),
    );
  }

  void _handleEdit(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
        child: CreateAssignmentBottomSheet(
          initialData: item,
          onSave: (updatedItem) {
            setState(() {
              final index = _items.indexOf(item);
              if (index != -1) _items[index] = updatedItem;
            });
          },
        ),
      ),
    );
  }

  void _handleView(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => _AssignmentViewDialog(item: item),
    );
  }

  void _handleDelete(Map<String, dynamic> item) {
    setState(() => _items.remove(item));
  }

  
  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__items_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _items = decoded.map((item) {
          final map = Map<String, dynamic>.from(item);
          for (final key in map.keys.toList()) {
            if (key.toLowerCase().contains('color') && map[key] is int) {
              map[key] = Color(map[key] as int);
            }
          }
          return map;
        }).toList();
      });
    }
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _items.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__items_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      drawer: const MenuScreen(activeScreen: 'Assignments'),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(_isTablet ? 40 : 16, 24, _isTablet ? 40 : 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 24),
                          _buildFilterButtons(),
                          const SizedBox(height: 24),
                          _buildSearchRow(),
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
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Builder(builder: (context) => GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: const Icon(Icons.menu_rounded, color: Color(0xFF8F96A3), size: 28),
          )),
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
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 600;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(LucideIcons.clipboardList, color: _accent, size: isMobile ? 24 : 28),
                      const SizedBox(width: 12),
                      Text('Assignments', style: GoogleFonts.figtree(fontSize: isMobile ? 28 : 32, fontWeight: FontWeight.bold, color: _textDark)),
                    ]),
                    const SizedBox(height: 8),
                    Text(
                      'Plan longer assignments and holiday projects with flexible date ranges.',
                      style: GoogleFonts.figtree(fontSize: isMobile ? 14 : 16, color: _textMuted),
                    ),
                  ],
                ),
              ),
              if (!isMobile) _buildCreateButton(),
            ],
          ),
          if (isMobile) ...[
            const SizedBox(height: 16),
            Align(alignment: Alignment.centerRight, child: _buildCreateButton()),
          ],
        ],
      );
    });
  }

  Widget _buildCreateButton() {
    return ElevatedButton.icon(
      onPressed: _handleCreate,
      icon: const Icon(Icons.add, size: 18, color: Colors.white),
      label: Text('Create Assignment', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: _accent,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      children: [
        Expanded(child: _buildFilterBtn('Pre-Primary', 1)),
        const SizedBox(width: 8),
        Expanded(child: _buildFilterBtn('Primary', 2)),
        const SizedBox(width: 8),
        Expanded(child: _buildFilterBtn('Secondary', 3)),
      ],
    );
  }

  Widget _buildFilterBtn(String label, int index) {
    bool isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _accent : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? _accent : const Color(0xFFEBEBEB)),
          boxShadow: isSelected ? [BoxShadow(color: _accent.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))] : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.figtree(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : _textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search assignments, teacher, or class',
                hintStyle: TextStyle(color: Color(0xFF8F96A3), fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Color(0xFF8F96A3), size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),
        if (_isTablet) ...[
          const SizedBox(width: 24),
          Text('${_filteredItems.length} items', style: GoogleFonts.figtree(fontSize: 14, color: _textMuted, fontWeight: FontWeight.w500)),
          const Spacer(),
        ],
        if (!_isTablet) ...[
          const SizedBox(width: 12),
          Container(
            height: 44, width: 44,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: const Icon(Icons.filter_list, color: _textDark),
          ),
        ],
      ],
    );
  }

  Widget _buildDesktopList() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
            child: Row(children: [
              Expanded(flex: 4, child: Text('TITLE', style: _headerStyle())),
              Expanded(flex: 2, child: Text('CLASS', style: _headerStyle())),
              Expanded(flex: 3, child: Text('ASSIGNED TEACHER', style: _headerStyle())),
              Expanded(flex: 3, child: Text('WINDOW', style: _headerStyle())),
              const SizedBox(width: 32),
            ]),
          ),
          if (_filteredItems.isEmpty)
            Padding(padding: const EdgeInsets.all(32), child: Text('No assignments found.', style: GoogleFonts.figtree(fontSize: 16, color: _textMuted))),
          ..._filteredItems.map((item) {
            final isLast = item == _filteredItems.last;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 4, child: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: _iconBg, borderRadius: BorderRadius.circular(8)),
                      child: Icon(item['icon'], color: _iconColor, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(item['title'], style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
                      const SizedBox(height: 4),
                      Text('${item['submitted']}/${item['total']} submitted', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
                    ])),
                  ])),
                  Expanded(flex: 2, child: Text(item['class'], style: GoogleFonts.figtree(fontSize: 14, color: _textDark))),
                  Expanded(flex: 3, child: Text(item['teacher'], style: GoogleFonts.figtree(fontSize: 14, color: _textDark))),
                  Expanded(flex: 3, child: Row(children: [
                    const Icon(LucideIcons.calendarDays, size: 16, color: _textMuted),
                    const SizedBox(width: 8),
                    Text('${item['windowStart']} – ${item['windowEnd']}', style: GoogleFonts.figtree(fontSize: 14, color: _textDark)),
                  ])),
                  SizedBox(width: 32, child: _buildPopupMenu(item)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  TextStyle _headerStyle() => GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF8F96A3), letterSpacing: 0.5);

  Widget _buildMobileList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 4),
          child: Text('${_filteredItems.length} Assignments', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
        ),
        if (_filteredItems.isEmpty)
          Padding(padding: const EdgeInsets.all(16), child: Text('No assignments found.', style: GoogleFonts.figtree(fontSize: 16, color: _textMuted))),
        ..._filteredItems.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: _iconBg, borderRadius: BorderRadius.circular(8)),
                  child: Icon(item['icon'], color: _iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item['title'], style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
                  const SizedBox(height: 4),
                  Text('${item['class']} • ${item['teacher']}', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
                ])),
                _buildPopupMenu(item),
              ]),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('${item['submitted']}/${item['total']} submitted', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted, fontWeight: FontWeight.w600)),
                Row(children: [
                  const Icon(LucideIcons.calendarDays, size: 14, color: _textMuted),
                  const SizedBox(width: 6),
                  Text('${item['windowStart']} – ${item['windowEnd']}', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textDark)),
                ]),
              ]),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (item['submitted'] as int) / (item['total'] as int),
                backgroundColor: const Color(0xFFF3F4F6),
                color: _accent,
                minHeight: 4,
                borderRadius: BorderRadius.circular(4),
              ),
            ]),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE5E7EB))),
      onSelected: (value) {
        if (value == 'view') {
          _handleView(item);
        } else if (value == 'edit') _handleEdit(item);
        else if (value == 'delete') _handleDelete(item);
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(value: 'view', child: Row(children: [
          const Icon(LucideIcons.eye, size: 18, color: Color(0xFF595973)),
          const SizedBox(width: 12),
          Text('View', style: GoogleFonts.figtree(color: _textDark)),
        ])),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(value: 'edit', child: Row(children: [
          const Icon(LucideIcons.edit2, size: 18, color: Color(0xFF595973)),
          const SizedBox(width: 12),
          Text('Edit', style: GoogleFonts.figtree(color: _textDark)),
        ])),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(value: 'delete', child: Row(children: [
          const Icon(LucideIcons.trash2, size: 18, color: Colors.redAccent),
          const SizedBox(width: 12),
          Text('Delete', style: GoogleFonts.figtree(color: Colors.redAccent)),
        ])),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        border: const Border(top: BorderSide(color: Color(0xFFEBEBEB))),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) => setState(() => _bottomNavIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _accent,
        unselectedItemColor: _textMuted,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'Academics'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Staff'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Messages'),
        ],
      ),
    );
  }
}

// ─── View Dialog ─────────────────────────────────────────────────────────────
class _AssignmentViewDialog extends StatelessWidget {
  final Map<String, dynamic> item;
  const _AssignmentViewDialog({required this.item});

  @override
  Widget build(BuildContext context) {
    final int submittedCount = item['submitted'] ?? 0;
    final int totalCount = item['total'] ?? 0;
    final int notSubmittedCount = totalCount - submittedCount;

    final submitted = List.generate(submittedCount, (i) => ({
      'name': ['Kabir Kapoor', 'Arjun Patel', 'Nisha Verma', 'Reyansh Gupta', 'Aarav Singh', 'Vivaan Kumar', 'Aditya Sharma', 'Vihaan Das'][i % 8],
      'id': '#${(i * 12 + 13)}',
    }));
    final notSubmitted = List.generate(notSubmittedCount, (i) => ({
      'name': ['Diya Khan', 'Vihaan Verma', 'Saanvi Gupta', 'Rohan Nair', 'Aadhya Bhat', 'Sai Khan', 'Pari Kapoor', 'Tara Patel'][i % 8],
      'id': '#${(i * 6 + 1)}',
    }));

    return Dialog(
      backgroundColor: const Color(0xFFF6F6F8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
              padding: const EdgeInsets.all(24),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.close, color: Color(0xFF8F96A3), size: 24)),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('ASSIGNMENT', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF8463E9), letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(item['title'] ?? '', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF181B20))),
                ])),
              ]),
            ),
            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Stat cards
                  LayoutBuilder(builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    final cards = [
                      _statCard('CLASS', item['class'] ?? 'N/A', LucideIcons.graduationCap),
                      _statCard('ASSIGNED TO', item['teacher'] ?? 'N/A', LucideIcons.user),
                      _statCard('WINDOW', '${item['windowStart']} – ${item['windowEnd']}', LucideIcons.calendarDays),
                      _statCard('SUBMITTED', '${item['submitted']}/${item['total']}', LucideIcons.check),
                    ];
                    if (isMobile) {
                      return Column(children: [
                        Row(children: [Expanded(child: cards[0]), const SizedBox(width: 12), Expanded(child: cards[1])]),
                        const SizedBox(height: 12),
                        Row(children: [Expanded(child: cards[2]), const SizedBox(width: 12), Expanded(child: cards[3])]),
                      ]);
                    }
                    return Row(children: cards.expand((c) => [Expanded(child: c), const SizedBox(width: 16)]).toList()..removeLast());
                  }),
                  const SizedBox(height: 32),
                  _sectionTitle('Submitted ($submittedCount)'),
                  const SizedBox(height: 16),
                  _studentGrid(submitted, true),
                  const SizedBox(height: 32),
                  _sectionTitle('Not Submitted ($notSubmittedCount)'),
                  const SizedBox(height: 16),
                  _studentGrid(notSubmitted, false),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 14, color: const Color(0xFF8F96A3)),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF8F96A3))),
        ]),
        const SizedBox(height: 8),
        Text(value, style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF181B20)), maxLines: 1, overflow: TextOverflow.ellipsis),
      ]),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(text, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF181B20)));
  }

  Widget _studentGrid(List<Map<String, dynamic>> students, bool isSubmitted) {
    if (students.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text('No students in this category.', style: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFF8F96A3))),
      );
    }
    return LayoutBuilder(builder: (context, constraints) {
      final cols = constraints.maxWidth < 500 ? 1 : 2;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols, childAspectRatio: cols == 1 ? 5 : 4.5, crossAxisSpacing: 16, mainAxisSpacing: 16,
        ),
        itemCount: students.length,
        itemBuilder: (context, i) {
          final s = students[i];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isSubmitted ? const Color(0xFFF0FDF4) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isSubmitted ? const Color(0xFFBBF7D0) : const Color(0xFFE5E7EB)),
            ),
            child: Row(children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFF4F1FF),
                child: Icon(LucideIcons.user, size: 16, color: Color(0xFF8463E9)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(s['name'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFF181B20)))),
              Text(s['id'], style: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFF8F96A3))),
            ]),
          );
        },
      );
    });
  }
}
