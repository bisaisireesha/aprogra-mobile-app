import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock_data/subjects_mock.dart';
import '../auth/menu_screen.dart';
import 'create_subject_wizard.dart';

const _bgPrimary = Color(0xFFF6F6F8);
const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  int _bottomNavIndex = 1; // 1 for Academics
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 1;

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

  Future<void> _showCreateSubjectPopup() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => const CreateSubjectWizard(),
    );

    if (result != null) {
      setState(() {
        if (result['category'] == 'Pre-Primary') {
          SubjectsMockData.prePrimarySubjects.add(result);
        } else if (result['category'] == 'Primary') {
          SubjectsMockData.primarySubjects.add(result);
        } else if (result['category'] == 'Secondary') {
          SubjectsMockData.secondarySubjects.add(result);
        }
      });
    }
  }

  Future<void> _showEditSubjectPopup(Map<String, dynamic> subject) async {
    // Inject the subject's category if it doesn't have it so the wizard knows.
    final subjectWithCategory = Map<String, dynamic>.from(subject);
    if (!subjectWithCategory.containsKey('category')) {
      if (SubjectsMockData.prePrimarySubjects.contains(subject)) {
        subjectWithCategory['category'] = 'Pre-Primary';
      } else if (SubjectsMockData.secondarySubjects.contains(subject)) subjectWithCategory['category'] = 'Secondary';
      else subjectWithCategory['category'] = 'Primary';
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => CreateSubjectWizard(initialSubject: subjectWithCategory),
    );

    if (result != null) {
      setState(() {
        SubjectsMockData.prePrimarySubjects.remove(subject);
        SubjectsMockData.primarySubjects.remove(subject);
        SubjectsMockData.secondarySubjects.remove(subject);

        if (result['category'] == 'Pre-Primary') {
          SubjectsMockData.prePrimarySubjects.add(result);
        } else if (result['category'] == 'Primary') {
          SubjectsMockData.primarySubjects.add(result);
        } else if (result['category'] == 'Secondary') {
          SubjectsMockData.secondarySubjects.add(result);
        }
      });
    }
  }

  Widget _buildSubjectActionMenu(Map<String, dynamic> subject) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 20, color: _textMuted),
      padding: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (value) {
        if (value == 'edit') {
          _showEditSubjectPopup(subject);
        } else if (value == 'delete') {
          setState(() {
            SubjectsMockData.prePrimarySubjects.remove(subject);
            SubjectsMockData.primarySubjects.remove(subject);
            SubjectsMockData.secondarySubjects.remove(subject);
          });
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              const Icon(Icons.edit_outlined, size: 18, color: _textDark),
              const SizedBox(width: 8),
              Text('Edit', style: GoogleFonts.figtree(color: _textDark, fontSize: 14)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline, size: 18, color: Colors.red),
              const SizedBox(width: 8),
              Text('Delete', style: GoogleFonts.figtree(color: Colors.red, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
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
                          const SizedBox(height: 32),
                          _buildFilterButtons(),
                          const SizedBox(height: 24),
                          _buildSubjectsTable(),
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
      drawer: const MenuScreen(activeScreen: 'Subjects'),
      bottomNavigationBar: _buildBottomNav(),
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
                child: const Icon(Icons.menu_rounded, color: Color(0xFF8F96A3), size: 28),
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
                    const Icon(Icons.search, color: Color(0xFF8F96A3), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search subjects or teachers...',
                          hintStyle: GoogleFonts.figtree(color: const Color(0xFF8F96A3), fontSize: 14),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        style: GoogleFonts.figtree(color: _textDark, fontSize: 14),
                      ),
                    ),
                  ],
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
        selectedLabelStyle: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'Academics'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Students'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Comm'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
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
              Text('Subjects', style: GoogleFonts.figtree(fontSize: 32, fontWeight: FontWeight.bold, color: _textDark)),
              const SizedBox(height: 8),
              Text('Subjects offered across every level, with assigned teachers and syllabus.', style: GoogleFonts.figtree(fontSize: 16, color: _textMuted)),
            ],
          ),
        ),
        _buildCreateButton(),
      ],
    );
  }

  Widget _buildCreateButton() {
    return ElevatedButton.icon(
      onPressed: _showCreateSubjectPopup,
      icon: const Icon(Icons.add, size: 18, color: Colors.white),
      label: Text(
        'Create Subject',
        style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _accent,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredSubjects {
    List<Map<String, dynamic>> list;
    if (_selectedFilterIndex == 0) {
      list = SubjectsMockData.prePrimarySubjects;
    } else if (_selectedFilterIndex == 1) list = SubjectsMockData.primarySubjects;
    else list = SubjectsMockData.secondarySubjects;

    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return list;

    return list.where((subject) {
      return subject['subject'].toString().toLowerCase().contains(query) ||
             subject['teacher'].toString().toLowerCase().contains(query);
    }).toList();
  }

  Widget _buildFilterButtons() {
    return Row(
      children: [
        Expanded(child: _buildFilterButton('Pre-Primary', 0)),
        const SizedBox(width: 8),
        Expanded(child: _buildFilterButton('Primary', 1)),
        const SizedBox(width: 8),
        Expanded(child: _buildFilterButton('Secondary', 2)),
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
          border: Border.all(color: isSelected ? _accent : const Color(0xFFEBEBEB)),
          boxShadow: isSelected ? [BoxShadow(color: _accent.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))] : null,
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

  Widget _buildSubjectsTable() {
    if (!_isTablet) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _filteredSubjects.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final subject = _filteredSubjects[index];
          return _buildSubjectCard(subject);
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Table Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text('SUBJECT', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textMuted, letterSpacing: 0.5))),
                Expanded(flex: 3, child: Text('TEACHER', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textMuted, letterSpacing: 0.5))),
                Expanded(flex: 3, child: Text('SYLLABUS', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textMuted, letterSpacing: 0.5))),
                const SizedBox(width: 24), // For the action button
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEBEBEB)),
          // Table Body
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredSubjects.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEBEBEB)),
            itemBuilder: (context, index) {
              final subject = _filteredSubjects[index];
              return _buildSubjectRow(subject);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    int progress = subject['progress'];
    int total = subject['total'];
    Color color = subject['color'];
    double ratio = total > 0 ? progress / total : 0;

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
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.menu_book_outlined, size: 20, color: _accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject['subject'],
                      style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subject['teacher'],
                      style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
                    ),
                  ],
                ),
              ),
              _buildSubjectActionMenu(subject),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: ratio,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '$progress/$total',
                style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectRow(Map<String, dynamic> subject) {
    int progress = subject['progress'];
    int total = subject['total'];
    Color color = subject['color'];
    double ratio = total > 0 ? progress / total : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // SUBJECT COLUMN
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F1FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.menu_book_outlined, size: 16, color: _accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    subject['subject'],
                    style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // TEACHER COLUMN
          Expanded(
            flex: 3,
            child: Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: _textMuted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    subject['teacher'],
                    style: GoogleFonts.figtree(fontSize: 14, color: _textDark),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // SYLLABUS COLUMN
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: ratio,
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.format_list_bulleted, size: 14, color: _textMuted),
                const SizedBox(width: 4),
                Text(
                  '$progress/$total',
                  style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
                ),
              ],
            ),
          ),
          // ACTION BUTTON
          SizedBox(
            width: 24,
            child: _buildSubjectActionMenu(subject),
          ),
        ],
      ),
    );
  }
}
