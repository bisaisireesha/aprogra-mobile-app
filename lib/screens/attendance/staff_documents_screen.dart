import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../auth/menu_screen.dart';
import '../../widgets/app_bottom_nav.dart';

const _bgPrimary = Color(0xFFF6F6F8);
const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);

class StaffDocumentsScreen extends StatefulWidget {
  const StaffDocumentsScreen({super.key});

  @override
  State<StaffDocumentsScreen> createState() => _StaffDocumentsScreenState();
}

class _StaffDocumentsScreenState extends State<StaffDocumentsScreen> {
  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  int _bottomNavIndex = 3; // 'Staff' is index 3
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _documents = [
    {
      'title': 'Aadhaar Card',
      'name': 'Priya Sharma',
      'department': 'Mathematics',
      'uploaded': '10 Jan 2025',
      'expiry': 'No expiry',
      'status': 'Verified',
    },
    {
      'title': 'Employment Contract',
      'name': 'Priya Sharma',
      'department': 'Mathematics',
      'uploaded': '01 Apr 2022',
      'expiry': 'Expires: 31 Mar 2025',
      'status': 'Expired',
    },
    {
      'title': 'B.Ed Certificate',
      'name': 'Rajan Pillai',
      'department': 'Science',
      'uploaded': '15 Jun 2023',
      'expiry': 'No expiry',
      'status': 'Verified',
    },
    {
      'title': 'PAN Card',
      'name': 'Rajan Pillai',
      'department': 'Science',
      'uploaded': '15 Jun 2023',
      'expiry': 'No expiry',
      'status': 'Verified',
    },
    {
      'title': 'Employment Contract',
      'name': 'Meena Krishnamurthy',
      'department': 'English',
      'uploaded': '01 Jul 2023',
      'expiry': 'Expires: 15 Jun 2025',
      'status': 'Verified',
    },
    {
      'title': 'TET Certificate',
      'name': 'Suresh Kumar',
      'department': 'Social Studies',
      'uploaded': '20 Aug 2021',
      'expiry': 'Expires: 30 Jun 2025',
      'status': 'Verified',
    },
  ];

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDocuments() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__documents_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _documents = decoded.map((item) {
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

  Future<void> _saveDocuments() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _documents.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__documents_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      drawer: const MenuScreen(activeScreen: 'Documents'),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Expanded(child: _buildHeader())],
                          ),
                          const SizedBox(height: 24),
                          _buildTopControls(),
                          const SizedBox(height: 24),
                          _buildStatsRow(),
                          const SizedBox(height: 32),
                          _buildSearchAndFilter(),
                          const SizedBox(height: 24),
                          _buildDocumentGrid(),
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

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(LucideIcons.menu, color: _textDark),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Home',
              style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
            ),
            const Icon(Icons.chevron_right, size: 14, color: Color(0xFF6B7280)),
            Text(
              'Staff',
              style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
            ),
            const Icon(Icons.chevron_right, size: 14, color: Color(0xFF6B7280)),
            Text(
              'Documents',
              style: GoogleFonts.figtree(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Staff Documents',
          style: GoogleFonts.figtree(
            fontSize: _isTablet ? 32 : 28,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Central repository for contracts, ID proofs, certifications, and compliance documents.",
          style: GoogleFonts.figtree(
            fontSize: _isTablet ? 16 : 14,
            color: _textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildTopControls() {
    return Row(
      children: [
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: _accent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.upload, size: 16, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Upload Document',
                style: GoogleFonts.figtree(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          crossAxisCount: _isTablet ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: _isTablet ? 1.4 : 1.1,
          children: [
            _buildKpiCard(
              '186',
              'Total Documents',
              LucideIcons.fileText,
              const Color(0xFF8463E9),
              const Color(0xFFF4F1FF),
            ),
            _buildKpiCard(
              '142',
              'Verified',
              LucideIcons.checkCircle2,
              const Color(0xFF10B981),
              const Color(0xFFD1FAE5),
            ),
            _buildKpiCard(
              '31',
              'Pending Verification',
              LucideIcons.clock,
              const Color(0xFFF59E0B),
              const Color(0xFFFEF3C7),
            ),
            _buildKpiCard(
              '13',
              'Expiring in 30 Days',
              LucideIcons.alertTriangle,
              const Color(0xFFEF4444),
              const Color(0xFFFEE2E2),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard(
    String value,
    String title,
    IconData icon,
    Color iconColor,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.figtree(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: _textDark,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.figtree(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const TextField(
            decoration: InputDecoration(
              icon: Icon(
                LucideIcons.search,
                size: 20,
                color: Color(0xFF9CA3AF),
              ),
              hintText: 'Search staff or document...',
              hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildDropdown('All'),
                const SizedBox(width: 12),
                _buildDropdown('All'),
              ],
            ),
            Text(
              '12 documents',
              style: GoogleFonts.figtree(fontSize: 13, color: _textMuted),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: GoogleFonts.figtree(
              fontSize: 14,
              color: _textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(LucideIcons.chevronDown, size: 16, color: _textDark),
        ],
      ),
    );
  }

  Widget _buildDocumentGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        int cols = _isTablet ? 3 : 2;
        if (width < 350) cols = 1;

        final double cardWidth = (width - ((cols - 1) * 16)) / cols;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _documents.map((doc) {
            return SizedBox(width: cardWidth, child: _buildDocumentCard(doc));
          }).toList(),
        );
      },
    );
  }

  Widget _buildDocumentCard(Map<String, dynamic> doc) {
    bool isExpired = doc['status'] == 'Expired';
    bool isExpiringSoon =
        doc['expiry'].toString().contains('2025') &&
        doc['status'] == 'Verified' &&
        doc['expiry'] != 'No expiry';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F1FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  LucideIcons.fileText,
                  size: 20,
                  color: Color(0xFF8463E9),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isExpired
                      ? const Color(0xFFFEE2E2)
                      : const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  doc['status'],
                  style: GoogleFonts.figtree(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isExpired
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            doc['title'],
            style: GoogleFonts.figtree(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            doc['name'],
            style: GoogleFonts.figtree(fontSize: 13, color: _textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            doc['department'],
            style: GoogleFonts.figtree(fontSize: 13, color: _textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Text(
            'Uploaded: ${doc['uploaded']}',
            style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (isExpiringSoon)
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(
                    LucideIcons.alertTriangle,
                    size: 12,
                    color: Color(0xFFEF4444),
                  ),
                ),
              Expanded(
                child: Text(
                  doc['expiry'],
                  style: GoogleFonts.figtree(
                    fontSize: 12,
                    fontWeight: isExpiringSoon
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isExpiringSoon
                        ? const Color(0xFFEF4444)
                        : _textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showDocumentDetails(context, doc),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.eye, size: 14, color: _accent),
                          const SizedBox(width: 4),
                          Text(
                            'View',
                            style: GoogleFonts.figtree(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Downloading ${doc['title']}...'),
                        backgroundColor: _textDark,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            LucideIcons.download,
                            size: 14,
                            color: _textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Download',
                            style: GoogleFonts.figtree(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDocumentDetails(BuildContext context, Map<String, dynamic> doc) {
    final bool isExpired = doc['status'] == 'Expired';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: icon + title + badge + close
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F1FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LucideIcons.fileText,
                        color: _accent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        doc['title'],
                        style: GoogleFonts.figtree(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: _textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isExpired
                            ? const Color(0xFFFEE2E2)
                            : const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        doc['status'],
                        style: GoogleFonts.figtree(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isExpired
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF10B981),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: _textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Detail rows
                _buildPopupDetailRow('Staff', doc['name']),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                _buildPopupDetailRow('Department', doc['department']),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                _buildPopupDetailRow('Uploaded On', doc['uploaded']),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                _buildPopupDetailRow(
                  'Expires On',
                  doc['expiry'] == 'No expiry'
                      ? 'N/A'
                      : doc['expiry'].toString().replaceAll('Expires: ', ''),
                ),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                _buildPopupDetailRow('Status', doc['status'], isStatus: true),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopupDetailRow(
    String label,
    String value, {
    bool isStatus = false,
  }) {
    Color valueColor = _textDark;
    if (isStatus) {
      if (value == 'Expired') {
        valueColor = const Color(0xFFEF4444);
      } else if (value == 'Verified') {
        valueColor = const Color(0xFF10B981);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.figtree(fontSize: 14, color: _textMuted),
          ),
          Text(
            value,
            style: GoogleFonts.figtree(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        border: const Border(top: BorderSide(color: Color(0xFFEBEBEB))),
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
        onTap: (index) => setState(() => _bottomNavIndex = index),
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
}
