import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../data/mock_data/students_mock.dart';
import '../auth/menu_screen.dart';
import 'create_student_wizard.dart';
import 'student_details_popup.dart';

const _bgPrimary = Color(0xFFF6F6F8);
const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  int _bottomNavIndex = 2; // 2 for Students
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;
  final int _itemsPerPage = 15;

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _currentPage = 1; // Reset to first page on search
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredStudents {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return StudentsMockData.studentsList;

    return StudentsMockData.studentsList.where((student) {
      final name = student['name']?.toString().toLowerCase() ?? '';
      final parent = student['parent']?.toString().toLowerCase() ?? '';
      final studentClass = student['class']?.toString().toLowerCase() ?? '';
      return name.contains(query) || parent.contains(query) || studentClass.contains(query);
    }).toList();
  }

  Future<void> _showCreateStudentPopup({Map<String, dynamic>? initialStudent}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => CreateStudentWizard(initialStudent: initialStudent, isEditing: initialStudent != null),
    );

    if (result != null) {
      setState(() {
        if (initialStudent != null) {
          final index = StudentsMockData.studentsList.indexOf(initialStudent);
          if (index != -1) {
            StudentsMockData.studentsList[index] = result;
          }
        } else {
          StudentsMockData.studentsList.insert(0, result);
          _searchController.clear();
          _currentPage = 1;
        }
      });
    }
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
                          _buildStatsCards(),
                          const SizedBox(height: 24),
                          _buildSearchBarRow(),
                          const SizedBox(height: 24),
                          _buildStudentsTable(),
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
      drawer: const MenuScreen(activeScreen: 'Students'),
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
                          hintText: 'Search students by name...',
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

  Widget _buildCreateButton() {
    return ElevatedButton.icon(
      onPressed: _showCreateStudentPopup,
      icon: const Icon(Icons.add, size: 18, color: Colors.white),
      label: Text(
        'Add Student',
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
              Text('Students', style: GoogleFonts.figtree(fontSize: 32, fontWeight: FontWeight.bold, color: _textDark)),
              const SizedBox(height: 8),
              Text('All students enrolled across pre-primary, primary, and secondary.', style: GoogleFonts.figtree(fontSize: 16, color: _textMuted)),
            ],
          ),
        ),
        _buildCreateButton(),
      ],
    );
  }

  Widget _buildStatsCards() {
    if (!_isTablet) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatCard('174', 'Total Students', LucideIcons.users, _accent, isSelected: true)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('38', 'Pre-Primary Students', LucideIcons.baby, Colors.redAccent)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatCard('72', 'Primary Students', LucideIcons.fileText, Colors.orange)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('64', 'Secondary Students', LucideIcons.graduationCap, Colors.green)),
            ],
          ),
        ],
      );
    }
    
    return Row(
      children: [
        Expanded(child: _buildStatCard('174', 'Total Students', LucideIcons.users, _accent, isSelected: true)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('38', 'Pre-Primary Students', LucideIcons.baby, Colors.redAccent)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('72', 'Primary Students', LucideIcons.fileText, Colors.orange)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('64', 'Secondary Students', LucideIcons.graduationCap, Colors.green)),
      ],
    );
  }

  Widget _buildStatCard(String count, String label, IconData icon, Color color, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? color.withValues(alpha: 0.5) : const Color(0xFFEBEBEB), width: isSelected ? 1.5 : 1),
        boxShadow: isSelected ? [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 16),
          Text(count, style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
        ],
      ),
    );
  }

  Widget _buildSearchBarRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFEBEBEB)),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Color(0xFF8F96A3), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search students, parents, or class',
                      hintStyle: GoogleFonts.figtree(color: const Color(0xFF8F96A3), fontSize: 13),
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
        Expanded(
          flex: 1,
          child: Text(
            'Showing ${_filteredStudents.length} students',
            style: GoogleFonts.figtree(fontSize: 13, color: _textMuted),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentsTable() {
    final allStudents = _filteredStudents;
    final totalPages = (allStudents.length / _itemsPerPage).ceil();
    if (_currentPage > totalPages && totalPages > 0) _currentPage = totalPages;
    
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage < allStudents.length) 
        ? startIndex + _itemsPerPage 
        : allStudents.length;
        
    final paginatedStudents = allStudents.isNotEmpty ? allStudents.sublist(startIndex, endIndex) : <Map<String, dynamic>>[];

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
                Expanded(flex: 5, child: Text('STUDENT', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textMuted, letterSpacing: 0.5))),
                Expanded(flex: 2, child: Text('CLASS', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textMuted, letterSpacing: 0.5))),
                Expanded(flex: 3, child: Text('PARENT', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textMuted, letterSpacing: 0.5))),
                const SizedBox(width: 24), // For the action button
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEBEBEB)),
          // Table Body
          if (paginatedStudents.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text('No students found', style: GoogleFonts.figtree(color: _textMuted)),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paginatedStudents.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEBEBEB)),
              itemBuilder: (context, index) {
                final student = paginatedStudents[index];
                return _buildStudentRow(student);
              },
            ),
          // Table Footer
          if (allStudents.isNotEmpty) ...[
            const Divider(height: 1, color: Color(0xFFEBEBEB)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  Text(
                    'Showing ${startIndex + 1}-$endIndex of ${allStudents.length}',
                    style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildPageButton(Icons.chevron_left, _currentPage > 1 ? () {
                        setState(() { _currentPage--; });
                      } : null),
                      const SizedBox(width: 16),
                      Text(
                        'Page $_currentPage / ${totalPages == 0 ? 1 : totalPages}',
                        style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textDark),
                      ),
                      const SizedBox(width: 16),
                      _buildPageButton(Icons.chevron_right, _currentPage < totalPages ? () {
                        setState(() { _currentPage++; });
                      } : null),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPageButton(IconData icon, VoidCallback? onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: onPressed != null ? Colors.white : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFEBEBEB)),
        ),
        child: Icon(icon, size: 16, color: onPressed != null ? _textDark : const Color(0xFFD1D5DB)),
      ),
    );
  }

  Widget _buildStudentRow(Map<String, dynamic> student) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // STUDENT COLUMN
          Expanded(
            flex: 5,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFFF4F1FF),
                  child: Text(
                    student['initials'],
                    style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _accent),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student['name'],
                        style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        student['roll'],
                        style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // CLASS COLUMN
          Expanded(
            flex: 2,
            child: Text(
              student['class'],
              style: GoogleFonts.figtree(fontSize: 14, color: _textDark),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // PARENT COLUMN
          Expanded(
            flex: 3,
            child: Text(
              student['parent'],
              style: GoogleFonts.figtree(fontSize: 14, color: _textDark),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // ACTION BUTTON
          SizedBox(
            width: 24,
            child: PopupMenuButton<String>(
              icon: const Icon(LucideIcons.moreVertical, size: 18, color: _textMuted),
              padding: EdgeInsets.zero,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              onSelected: (value) {
                if (value == 'view') {
                  showDialog(
                    context: context,
                    builder: (context) => StudentDetailsPopup(
                      student: student,
                      onEdit: () => _showCreateStudentPopup(initialStudent: student),
                    ),
                  );
                } else if (value == 'edit') {
                  _showCreateStudentPopup(initialStudent: student);
                } else if (value == 'delete') {
                  setState(() {
                    StudentsMockData.studentsList.remove(student);
                  });
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      const Icon(Icons.visibility_outlined, size: 18, color: _textDark),
                      const SizedBox(width: 12),
                      Text('View Details', style: GoogleFonts.figtree(fontSize: 14, color: _textDark)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit_outlined, size: 18, color: _textDark),
                      const SizedBox(width: 12),
                      Text('Edit', style: GoogleFonts.figtree(fontSize: 14, color: _textDark)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                      const SizedBox(width: 12),
                      Text('Delete', style: GoogleFonts.figtree(fontSize: 14, color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
