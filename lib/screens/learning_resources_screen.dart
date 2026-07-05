import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../data/mock_data/learning_resources_mock.dart';
import 'auth/menu_screen.dart';
import 'create_folder_dialog.dart';
import 'folder_details_screen.dart';
import '../widgets/app_bottom_nav.dart';

const _bgPrimary = Color(0xFFF6F6F8);
const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);

class LearningResourcesScreen extends StatefulWidget {
  const LearningResourcesScreen({super.key});

  @override
  State<LearningResourcesScreen> createState() =>
      _LearningResourcesScreenState();
}

class _LearningResourcesScreenState extends State<LearningResourcesScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 2; // 1: Pre-Primary, 2: Primary, 3: Secondary
  int _bottomNavIndex = 1; // 1 for Academics

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

  Future<void> _showCreateFolderDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateFolderDialog(),
    );

    if (result != null) {
      setState(() {
        final level = result['level'];
        if (level == 'Pre-Primary') {
          LearningResourcesMockData.prePrimaryFolders.insert(0, result);
        } else if (level == 'Secondary') {
          LearningResourcesMockData.secondaryFolders.insert(0, result);
        } else {
          LearningResourcesMockData.primaryFolders.insert(0, result);
        }
      });
    }
  }

  void _navigateToFolder(Map<String, dynamic> folder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FolderDetailsScreen(folder: folder),
      ),
    );
  }

  void _showRenameDialog(Map<String, dynamic> folder) {
    final controller = TextEditingController(text: folder['subject']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Rename Folder',
          style: GoogleFonts.figtree(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'New folder name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.figtree(color: _textMuted),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() => folder['subject'] = controller.text.trim());
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: _accent),
            child: Text(
              'Save',
              style: GoogleFonts.figtree(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showMoveDialog(Map<String, dynamic> folder) {
    String selectedLevel = folder['level'] ?? 'Primary';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Move Folder',
          style: GoogleFonts.figtree(fontWeight: FontWeight.bold),
        ),
        content: DropdownButtonFormField<String>(
          value: selectedLevel,
          items: [
            'Pre-Primary',
            'Primary',
            'Secondary',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => selectedLevel = v!,
          decoration: InputDecoration(
            labelText: 'Select new level',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.figtree(color: _textMuted),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (_selectedFilterIndex == 1)
                  LearningResourcesMockData.prePrimaryFolders.remove(folder);
                else if (_selectedFilterIndex == 2)
                  LearningResourcesMockData.primaryFolders.remove(folder);
                else
                  LearningResourcesMockData.secondaryFolders.remove(folder);

                folder['level'] = selectedLevel;
                if (selectedLevel == 'Pre-Primary')
                  LearningResourcesMockData.prePrimaryFolders.insert(0, folder);
                else if (selectedLevel == 'Primary')
                  LearningResourcesMockData.primaryFolders.insert(0, folder);
                else
                  LearningResourcesMockData.secondaryFolders.insert(0, folder);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: _accent),
            child: Text(
              'Move',
              style: GoogleFonts.figtree(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _archiveFolder(Map<String, dynamic> folder) {
    setState(() {
      folder['isArchived'] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${folder['subject']} archived successfully.',
          style: GoogleFonts.figtree(),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _currentFolders {
    List<Map<String, dynamic>> folders;
    if (_selectedFilterIndex == 1) {
      folders = LearningResourcesMockData.prePrimaryFolders;
    } else if (_selectedFilterIndex == 2) {
      folders = LearningResourcesMockData.primaryFolders;
    } else {
      folders = LearningResourcesMockData.secondaryFolders;
    }

    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      return folders
          .where((f) => f['subject'].toString().toLowerCase().contains(query))
          .toList();
    }
    return folders;
  }

  int get _totalFoldersCount {
    return _currentFolders.length;
  }

  int get _totalResourcesCount {
    return _currentFolders.fold(
      0,
      (sum, item) => sum + ((item['resourcesCount'] ?? 0) as int),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      drawer: const MenuScreen(activeScreen: 'Learning Resources'),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        _isTablet ? 40 : 16,
                        24,
                        _isTablet ? 40 : 16,
                        24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeaderAndKPIs(),
                          const SizedBox(height: 24),
                          _buildFilterButtons(),
                          const SizedBox(height: 24),
                          _buildSearchAndFilters(),
                          const SizedBox(height: 24),
                          _buildFoldersGrid(),
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
      bottomNavigationBar: const AppBottomNav(),
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
          setState(() {
            _bottomNavIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _accent,
        unselectedItemColor: _textMuted,
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10,
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
            icon: Icon(Icons.show_chart),
            activeIcon: Icon(Icons.show_chart),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Staff',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Messages',
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
                    hintStyle: TextStyle(
                      color: Color(0xFF8F96A3),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF8F96A3),
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
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

  Widget _buildHeaderAndKPIs() {
    if (_isTablet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Learning Resources',
                  style: GoogleFonts.figtree(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Organize and manage study materials by level and subject.',
                  style: GoogleFonts.figtree(fontSize: 14, color: _textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _buildKPICard(
            LucideIcons.folder,
            'Total Folders',
            '$_totalFoldersCount',
            const Color(0xFFF4F1FF),
            _accent,
          ),
          const SizedBox(width: 16),
          _buildKPICard(
            LucideIcons.fileText,
            'Total Resources',
            '$_totalResourcesCount',
            const Color(0xFFF4F1FF),
            _accent,
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: _showCreateFolderDialog,
            icon: const Icon(Icons.add, size: 16, color: Colors.white),
            label: Text(
              'Create Folder',
              style: GoogleFonts.figtree(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Learning Resources',
                style: GoogleFonts.figtree(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _showCreateFolderDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                minimumSize: Size.zero,
              ),
              icon: const Icon(Icons.add, size: 20, color: Colors.white),
              label: Text(
                'Create',
                style: GoogleFonts.figtree(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Organize and manage study materials by level and subject.',
          style: GoogleFonts.figtree(fontSize: 14, color: _textMuted),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildKPICard(
                LucideIcons.folder,
                'Total Folders',
                '$_totalFoldersCount',
                const Color(0xFFF4F1FF),
                _accent,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(
                LucideIcons.fileText,
                'Total Resources',
                '$_totalResourcesCount',
                const Color(0xFFF4F1FF),
                _accent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKPICard(
    IconData icon,
    String title,
    String value,
    Color iconBg,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
              ),
              Text(
                value,
                style: GoogleFonts.figtree(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      children: [
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
                    color: _accent.withValues(alpha: 0.2),
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
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : _textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search folders by subject name...',
                hintStyle: GoogleFonts.figtree(
                  color: const Color(0xFF8F96A3),
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  LucideIcons.search,
                  color: Color(0xFF8F96A3),
                  size: 18,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        if (_isTablet) ...[
          Expanded(
            flex: 1,
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.filter,
                        size: 16,
                        color: _textMuted,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'All Status',
                        style: GoogleFonts.figtree(
                          fontSize: 14,
                          color: _textMuted,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    LucideIcons.chevronDown,
                    size: 16,
                    color: _textMuted,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.graduationCap,
                        size: 16,
                        color: _textMuted,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'All Grades',
                        style: GoogleFonts.figtree(
                          fontSize: 14,
                          color: _textMuted,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    LucideIcons.chevronDown,
                    size: 16,
                    color: _textMuted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFoldersGrid() {
    if (_isTablet) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: _currentFolders.length,
        itemBuilder: (context, index) =>
            _buildFolderCard(_currentFolders[index]),
      );
    } else {
      return Column(
        children: _currentFolders
            .map(
              (folder) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildFolderCard(folder),
              ),
            )
            .toList(),
      );
    }
  }

  Widget _buildFolderCard(Map<String, dynamic> folder) {
    return GestureDetector(
      onTap: () => _navigateToFolder(folder),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0D8FA), // Light purple folder bg
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ), // Adjust to look like folder
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          width: 14,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8463E9),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: _textMuted,
                    size: 20,
                  ),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == 'Open') {
                      _navigateToFolder(folder);
                    } else if (value == 'Rename') {
                      _showRenameDialog(folder);
                    } else if (value == 'Move') {
                      _showMoveDialog(folder);
                    } else if (value == 'Archive') {
                      _archiveFolder(folder);
                    } else if (value == 'Delete') {
                      setState(() {
                        if (_selectedFilterIndex == 1) {
                          LearningResourcesMockData.prePrimaryFolders.remove(
                            folder,
                          );
                        } else if (_selectedFilterIndex == 2) {
                          LearningResourcesMockData.primaryFolders.remove(
                            folder,
                          );
                        } else {
                          LearningResourcesMockData.secondaryFolders.remove(
                            folder,
                          );
                        }
                      });
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'Open',
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.eye,
                            size: 16,
                            color: _textDark,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Open',
                            style: GoogleFonts.figtree(
                              fontSize: 14,
                              color: _textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'Rename',
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.edit2,
                            size: 16,
                            color: _textDark,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Rename',
                            style: GoogleFonts.figtree(
                              fontSize: 14,
                              color: _textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'Move',
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.share2,
                            size: 16,
                            color: _textDark,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Move',
                            style: GoogleFonts.figtree(
                              fontSize: 14,
                              color: _textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'Archive',
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.archive,
                            size: 16,
                            color: _textDark,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Archive',
                            style: GoogleFonts.figtree(
                              fontSize: 14,
                              color: _textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'Delete',
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.trash2,
                            size: 16,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Delete',
                            style: GoogleFonts.figtree(
                              fontSize: 14,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              folder['subject'],
              style: GoogleFonts.figtree(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(LucideIcons.folder, size: 14, color: _textMuted),
                const SizedBox(width: 6),
                Text(
                  '${folder['foldersCount']} • ${folder['resourcesCount']} resources',
                  style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              ((folder['tags'] ?? ['Notes']) as List).join(' • '),
              style: GoogleFonts.figtree(
                fontSize: 13,
                color: const Color(0xFF8F96A3),
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
