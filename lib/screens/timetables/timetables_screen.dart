import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../data/mock_data/timetables_mock.dart';
import '../auth/menu_screen.dart';
import 'create_timetable_wizard.dart';
import '../../widgets/app_bottom_nav.dart';

const _bgPrimary = Color(0xFFF6F6F8);
const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);

class TimetablesScreen extends StatefulWidget {
  const TimetablesScreen({super.key});

  @override
  State<TimetablesScreen> createState() => _TimetablesScreenState();
}

class _TimetablesScreenState extends State<TimetablesScreen> {
  int _bottomNavIndex = 1; // 1 for Academics
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex =
      0; // 0 for All, 1 for Pre-Primary, 2 for Primary, 3 for Secondary

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredTimetables {
    List<Map<String, dynamic>> list;
    if (_selectedFilterIndex == 0) {
      list = TimetablesMockData.allTimetables;
    } else if (_selectedFilterIndex == 1)
      list = TimetablesMockData.prePrimaryTimetables;
    else if (_selectedFilterIndex == 2)
      list = TimetablesMockData.primaryTimetables;
    else
      list = TimetablesMockData.secondaryTimetables;

    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return list;

    return list.where((t) {
      return t['title'].toString().toLowerCase().contains(query) ||
          t['class'].toString().toLowerCase().contains(query) ||
          t['teacher'].toString().toLowerCase().contains(query);
    }).toList();
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
                      padding: EdgeInsets.fromLTRB(
                        _isTablet ? 40 : 16,
                        24,
                        _isTablet ? 40 : 16,
                        16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 32),
                          _buildFilterButtons(),
                          const SizedBox(height: 24),
                          _buildTimetablesTable(),
                          const SizedBox(height: 32),
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
      drawer: const MenuScreen(activeScreen: 'Timetables'),
      bottomNavigationBar: const AppBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEBEBEB))),
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
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFEBEBEB)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Color(0xFF8F96A3),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search timetable, class, or teacher...',
                          hintStyle: GoogleFonts.figtree(
                            color: const Color(0xFF8F96A3),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                        ),
                        style: GoogleFonts.figtree(
                          color: _textDark,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF8F96A3),
              size: 24,
            ),
            const SizedBox(width: 16),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFF4F1FF),
              child: Text(
                'A',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8463E9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEBEBEB), width: 1)),
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
        unselectedItemColor: const Color(0xFF8F96A3),
        selectedLabelStyle: GoogleFonts.figtree(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.figtree(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Academics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Comm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Timetables',
                style: GoogleFonts.figtree(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Class schedules with periods, breaks, and assigned teachers.',
                style: GoogleFonts.figtree(fontSize: 16, color: _textMuted),
              ),
            ],
          ),
        ),
        _buildCreateButton(),
      ],
    );
  }

  Widget _buildCreateButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        await showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.5),
          builder: (context) => const CreateTimetableWizard(),
        );
        if (mounted) setState(() {});
      },
      icon: const Icon(Icons.add, size: 18, color: Colors.white),
      label: Text(
        'Create Timetable',
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      children: [
        Expanded(child: _buildFilterButton('All', 0)),
        const SizedBox(width: 8),
        Expanded(child: _buildFilterButton('Pre-Primary', 1)),
        const SizedBox(width: 8),
        Expanded(child: _buildFilterButton('Primary', 2)),
        const SizedBox(width: 8),
        Expanded(child: _buildFilterButton('Secondary', 3)),
      ],
    );
  }

  Widget _buildFilterButton(String label, int index) {
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
          border: Border.all(
            color: isSelected ? _accent : const Color(0xFFEBEBEB),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _accent.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.figtree(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : _textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildActionMenu(Map<String, dynamic> timetable) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 20, color: _textMuted),
      padding: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (value) async {
        if (value == 'delete') {
          setState(() {
            TimetablesMockData.allTimetables.remove(timetable);
          });
        } else if (value == 'view' || value == 'edit') {
          await showDialog(
            context: context,
            barrierColor: Colors.black.withOpacity(0.5),
            builder: (context) => CreateTimetableWizard(
              isViewOnly: value == 'view',
              initialData: timetable,
            ),
          );
          if (mounted) setState(() {});
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              const Icon(LucideIcons.eye, size: 18, color: _textDark),
              const SizedBox(width: 8),
              Text(
                'View',
                style: GoogleFonts.figtree(color: _textDark, fontSize: 14),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              const Icon(Icons.edit_outlined, size: 18, color: _textDark),
              const SizedBox(width: 8),
              Text(
                'Edit',
                style: GoogleFonts.figtree(color: _textDark, fontSize: 14),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline, size: 18, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                'Delete',
                style: GoogleFonts.figtree(color: Colors.red, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimetablesTable() {
    if (!_isTablet) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _filteredTimetables.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final timetable = _filteredTimetables[index];
          return _buildMobileCard(timetable);
        },
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'TIMETABLE',
                    style: GoogleFonts.figtree(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _textMuted,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'CLASS',
                    style: GoogleFonts.figtree(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _textMuted,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'CLASS TEACHER',
                    style: GoogleFonts.figtree(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _textMuted,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'SCHEDULE',
                    style: GoogleFonts.figtree(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _textMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEBEBEB)),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredTimetables.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1, color: Color(0xFFEBEBEB)),
            itemBuilder: (context, index) {
              final timetable = _filteredTimetables[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F1FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              LucideIcons.calendar,
                              size: 20,
                              color: _accent,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  timetable['title'] as String,
                                  style: GoogleFonts.figtree(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: _textDark,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      timetable['level'] as String,
                                      style: GoogleFonts.figtree(
                                        fontSize: 12,
                                        color: _textMuted,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      LucideIcons.clock,
                                      size: 12,
                                      color: _textMuted,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      timetable['time'] as String,
                                      style: GoogleFonts.figtree(
                                        fontSize: 12,
                                        color: _textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        timetable['class'] as String,
                        style: GoogleFonts.figtree(
                          fontSize: 14,
                          color: _textDark,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.user,
                            size: 14,
                            color: _textMuted,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              timetable['teacher'] as String,
                              style: GoogleFonts.figtree(
                                fontSize: 14,
                                color: _textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.bookOpen,
                            size: 14,
                            color: _textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${timetable['periods']}',
                            style: GoogleFonts.figtree(
                              fontSize: 12,
                              color: _textMuted,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            LucideIcons.coffee,
                            size: 14,
                            color: _textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${timetable['breaks']}',
                            style: GoogleFonts.figtree(
                              fontSize: 12,
                              color: _textMuted,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            timetable['duration'] as String,
                            style: GoogleFonts.figtree(
                              fontSize: 12,
                              color: _textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildActionMenu(timetable),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMobileCard(Map<String, dynamic> timetable) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEBEBEB)),
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
                  color: const Color(0xFFF4F1FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.calendar,
                  size: 20,
                  color: _accent,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timetable['title'] as String,
                      style: GoogleFonts.figtree(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timetable['level'] as String,
                      style: GoogleFonts.figtree(
                        fontSize: 12,
                        color: _textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionMenu(timetable),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(LucideIcons.clock, size: 14, color: _textMuted),
              const SizedBox(width: 8),
              Text(
                timetable['time'] as String,
                style: GoogleFonts.figtree(fontSize: 12, color: _textDark),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(LucideIcons.user, size: 14, color: _textMuted),
              const SizedBox(width: 8),
              Text(
                timetable['teacher'] as String,
                style: GoogleFonts.figtree(fontSize: 12, color: _textDark),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(LucideIcons.bookOpen, size: 14, color: _textMuted),
              const SizedBox(width: 4),
              Text(
                '${timetable['periods']} periods',
                style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
              ),
              const SizedBox(width: 12),
              const Icon(LucideIcons.coffee, size: 14, color: _textMuted),
              const SizedBox(width: 4),
              Text(
                '${timetable['breaks']} breaks',
                style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
              ),
              const SizedBox(width: 12),
              Text(
                timetable['duration'] as String,
                style: GoogleFonts.figtree(
                  fontSize: 12,
                  color: _accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
