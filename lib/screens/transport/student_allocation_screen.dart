import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/common_app_bar.dart';
import '../auth/menu_screen.dart';
import 'add_admission_modal.dart';

class StudentAllocationScreen extends StatefulWidget {
  const StudentAllocationScreen({super.key});

  @override
  State<StudentAllocationScreen> createState() => _StudentAllocationScreenState();
}

class _StudentAllocationScreenState extends State<StudentAllocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterStatus = 'All';

  List<Map<String, dynamic>> _students = [
    {
      'name': 'Aarav Mehta',
      'id': 'S-1042',
      'class': 'VII-B',
      'route': 'R-12',
      'stop': 'Park Lane',
      'pickup': '07:05 AM',
      'drop': '03:25 PM',
      'feeStatus': 'Paid',
      'status': 'Allocated',
      'admissionDate': '12 May 2024',
      'parent': 'Rohit Mehta',
      'phone': '+91 98xxxx 1023',
      'totalFee': '₹12,000',
      'paidAmount': '₹12,000',
      'dueAmount': '₹0',
    },
    {
      'name': 'Diya Kapoor',
      'id': 'S-1078',
      'class': 'X-A',
      'route': 'R-07',
      'stop': 'Mehrauli Gate',
      'pickup': '06:55 AM',
      'drop': '03:35 PM',
      'feeStatus': 'Paid',
      'status': 'Allocated',
    },
    {
      'name': 'Kabir Singh',
      'id': 'S-1112',
      'class': 'V-C',
      'route': 'R-03',
      'stop': 'Ring Road',
      'pickup': '07:15 AM',
      'drop': '03:15 PM',
      'feeStatus': 'Due',
      'status': 'Allocated',
    },
    {
      'name': 'Anaya Verma',
      'id': 'S-1156',
      'class': 'IX-B',
      'route': 'R-09',
      'stop': 'Hauz Khas',
      'pickup': '07:00 AM',
      'drop': '03:30 PM',
      'feeStatus': 'Paid',
      'status': 'Allocated',
    },
    {
      'name': 'Vihaan Iyer',
      'id': 'S-1188',
      'class': 'III-A',
      'route': '-',
      'stop': '-',
      'pickup': '-',
      'drop': '-',
      'feeStatus': 'Due',
      'status': 'Pending',
    },
    {
      'name': 'Ishaan Rao',
      'id': 'S-1204',
      'class': 'VIII-A',
      'route': 'R-12',
      'stop': 'Sector 42 Mkt',
      'pickup': '07:20 AM',
      'drop': '03:45 PM',
      'feeStatus': 'Paid',
      'status': 'Allocated',
    },
    {
      'name': 'Myra Joshi',
      'id': 'S-1221',
      'class': 'VI-B',
      'route': 'R-15',
      'stop': 'GK-II',
      'pickup': '-',
      'drop': '-',
      'feeStatus': 'Paid',
      'status': 'Opted Out',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadAllocations();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllocations() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('transport_allocations_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _students = decoded.map((student) {
          return Map<String, dynamic>.from(student);
        }).toList();
      });
    }
  }

  Future<void> _saveAllocations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('transport_allocations_data', jsonEncode(_students));
  }

  void _showAllocateStudentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => AddAdmissionModal(
        onSave: (newStudent) {
          setState(() {
            _students.insert(0, newStudent);
          });
          _saveAllocations();
        },
      ),
    );
  }

  void _showEditAdmissionModal(BuildContext context, Map<String, dynamic> student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => AddAdmissionModal(
        title: 'Edit Admission',
        saveText: 'Save Changes',
        initialData: student,
        onSave: (updatedStudent) {
          setState(() {
            final index = _students.indexWhere((s) => s['id'] == student['id']);
            if (index != -1) {
              _students[index] = updatedStudent;
            }
          });
          _saveAllocations();
        },
      ),
    );
  }

  void _showViewDetailsModal(BuildContext context, Map<String, dynamic> student) {
    String getInitials(String name) {
      return name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').join('').toUpperCase().substring(0, 2);
    }

    Color getStatusColor(String status) {
      if (status == 'Allocated') return const Color(0xFF10B981);
      if (status == 'Pending') return const Color(0xFFF59E0B);
      return const Color(0xFF94A3B8); // Opted Out
    }

    Widget _buildDetailRow(String label, String value, {bool isBadge = false, Color? badgeColor}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  label == 'Class' ? LucideIcons.bookOpen :
                  label == 'Route' ? LucideIcons.mapPin :
                  label == 'Stop' ? LucideIcons.mapPin :
                  label == 'Pickup / Drop' ? LucideIcons.clock :
                  label == 'Fee Status' ? LucideIcons.dollarSign :
                  label == 'Status' ? LucideIcons.settings :
                  label == 'Admission Date' ? LucideIcons.calendar :
                  label == 'Parent / Guardian' ? LucideIcons.users :
                  LucideIcons.phone,
                  size: 16,
                  color: const Color(0xFF94A3B8),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF595973),
                  ),
                ),
              ],
            ),
            if (isBadge)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor!.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (label == 'Status') ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: badgeColor,
                      ),
                    ),
                  ],
                ),
              )
            else
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF181821),
                ),
              ),
          ],
        ),
      );
    }

    Widget _buildSectionCard(IconData icon, String title, List<Widget> children) {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: const Color(0xFF6366F1)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF181821),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      );
    }

    Widget _buildSectionRow(String label, String value, {Color? valueColor}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF595973))),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? const Color(0xFF181821),
              ),
            ),
          ],
        ),
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(LucideIcons.chevronLeft, size: 24, color: Color(0xFF181821)),
                      ),
                      Text(
                        'Admission Details',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF181821),
                        ),
                      ),
                      const Icon(LucideIcons.moreVertical, size: 24, color: Color(0xFF181821)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF8F5FF),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    getInitials(student['name']),
                                    style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF6366F1),
                                    ),
                                  ),
                                ),
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
                                          student['name'],
                                          style: GoogleFonts.inter(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF181821),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: getStatusColor(student['status']).withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 6,
                                                height: 6,
                                                decoration: BoxDecoration(color: getStatusColor(student['status']), shape: BoxShape.circle),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                student['status'],
                                                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: getStatusColor(student['status'])),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      student['id'],
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildDetailRow('Class', student['class']),
                          _buildDetailRow('Route', student['route']),
                          _buildDetailRow('Stop', student['stop']),
                          _buildDetailRow('Pickup / Drop', '${student['pickup']} - ${student['drop']}'),
                          _buildDetailRow('Fee Status', student['feeStatus'], isBadge: true, badgeColor: student['feeStatus'] == 'Paid' ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
                          _buildDetailRow('Status', student['status'], isBadge: true, badgeColor: getStatusColor(student['status'])),
                          _buildDetailRow('Admission Date', student['admissionDate'] ?? 'Unknown'),
                          _buildDetailRow('Parent / Guardian', student['parent'] ?? 'Unknown'),
                          _buildDetailRow('Phone', student['phone'] ?? 'Unknown'),
                        ],
                      ),
                    ),
                    
                    _buildSectionCard(LucideIcons.fileText, 'Fee Details', [
                      _buildSectionRow('Total Fee', student['totalFee'] ?? '-'),
                      _buildSectionRow('Paid Amount', student['paidAmount'] ?? '-'),
                      _buildSectionRow('Due Amount', student['dueAmount'] ?? '-', valueColor: (student['dueAmount'] ?? '₹0') != '₹0' ? const Color(0xFFEF4444) : const Color(0xFF10B981)),
                    ]),
                    
                    _buildSectionCard(LucideIcons.bus, 'Route & Stop', [
                      _buildSectionRow('Route', student['route']),
                      _buildSectionRow('Stop', student['stop']),
                      _buildSectionRow('Pickup Time', student['pickup']),
                      _buildSectionRow('Drop Time', student['drop']),
                    ]),
                    
                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              _showEditAdmissionModal(context, student);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF6366F1)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(LucideIcons.edit2, size: 16, color: Color(0xFF6366F1)),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Edit Admission',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF6366F1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                _students.remove(student);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFEF4444)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(LucideIcons.trash2, size: 16, color: Color(0xFFEF4444)),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Delete Admission',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFFEF4444),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter by Status', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ...['All', 'Allocated', 'Pending', 'Opted Out'].map((status) => RadioListTile(
              title: Text(status, style: GoogleFonts.inter(fontSize: 15)),
              activeColor: const Color(0xFF6366F1),
              value: status,
              groupValue: _filterStatus,
              onChanged: (val) {
                setState(() {
                  _filterStatus = val.toString();
                });
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: const MenuScreen(activeScreen: 'Student Allocation'),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.bus), label: 'Transport'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.settings), label: 'Settings'),
        ],
        currentIndex: 1,
        selectedItemColor: const Color(0xFF6366F1),
        unselectedItemColor: const Color(0xFF94A3B8),
        showUnselectedLabels: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: CommonAppBar(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildStatsGrid(),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildStudentsList(),
                ],
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
        Text(
          'Student Allocation',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF181821),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Map students to bus routes, stops and pickup timings.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF595973),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () => _showAllocateStudentModal(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.userPlus, size: 16, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      'Allocate Student',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Students',
                '7',
                '',
                LucideIcons.users,
                const Color(0xFF8B5CF6),
                const Color(0xFFEDE9FE),
                isPrimary: _filterStatus == 'All',
                onTap: () {
                  setState(() {
                    _filterStatus = 'All';
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Allocated',
                '5',
                '',
                LucideIcons.checkCircle2,
                const Color(0xFF10B981),
                const Color(0xFFD1FAE5),
                isPrimary: _filterStatus == 'Allocated',
                onTap: () {
                  setState(() {
                    _filterStatus = 'Allocated';
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Pending',
                '1',
                '',
                LucideIcons.alertCircle,
                const Color(0xFFF59E0B),
                const Color(0xFFFEF3C7),
                isPrimary: _filterStatus == 'Pending',
                onTap: () {
                  setState(() {
                    _filterStatus = 'Pending';
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Opted Out',
                '1',
                '',
                LucideIcons.userMinus,
                const Color(0xFF0EA5E9),
                const Color(0xFFE0F2FE),
                isPrimary: _filterStatus == 'Opted Out',
                onTap: () {
                  setState(() {
                    _filterStatus = 'Opted Out';
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color iconColor,
    Color iconBgColor, {
    bool isPrimary = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFFF8F5FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary ? const Color(0xFF7F61EA).withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.1),
          ),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF181821),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF595973),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: const Color(0xFF94A3B8),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.search, color: Color(0xFF94A3B8), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF181821),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search students...',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF94A3B8),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => _showFilterModal(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: const Icon(LucideIcons.filter, color: Color(0xFF595973), size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentsList() {
    final filtered = _students.where((s) {
      final matchesSearch = s['name'].toLowerCase().contains(_searchQuery) ||
                            s['id'].toLowerCase().contains(_searchQuery) ||
                            s['route'].toLowerCase().contains(_searchQuery) ||
                            s['stop'].toLowerCase().contains(_searchQuery);
      final matchesStatus = _filterStatus == 'All' || s['status'] == _filterStatus;
      return matchesSearch && matchesStatus;
    }).toList();

    if (filtered.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(LucideIcons.users, size: 48, color: const Color(0xFF94A3B8).withValues(alpha: 0.5)),
              const SizedBox(height: 16),
              Text(
                'No students found',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF181821),
                ),
              ),
            ],
          ),
        ),
      );
    }

    String getInitials(String name) {
      return name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').join('').toUpperCase().substring(0, 2);
    }

    Color getStatusColor(String status) {
      if (status == 'Allocated') return const Color(0xFF10B981);
      if (status == 'Pending') return const Color(0xFFF59E0B);
      return const Color(0xFF94A3B8);
    }

    return Column(
      children: filtered.map((student) {
        final feePaid = student['feeStatus'] == 'Paid';
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F5FF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    getInitials(student['name']),
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student['name'],
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF181821),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      student['id'],
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF595973),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${student['class']}  •  ${student['route']}  •  ${student['stop']}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF595973),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(LucideIcons.clock, size: 14, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 6),
                        Text(
                          '${student['pickup']}  -  ${student['drop']}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF595973),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: feePaid ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          student['feeStatus'],
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: feePaid ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        icon: const Icon(LucideIcons.moreVertical, size: 20, color: Color(0xFF595973)),
                        color: Colors.white,
                        onSelected: (value) {
                          if (value == 'view') {
                            _showViewDetailsModal(context, student);
                          } else if (value == 'edit') {
                            _showEditAdmissionModal(context, student);
                          } else if (value == 'delete') {
                            setState(() {
                              _students.remove(student);
                            });
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'view',
                            child: Row(
                              children: [
                                const Icon(LucideIcons.eye, size: 16, color: Color(0xFF595973)),
                                const SizedBox(width: 8),
                                Text('View Details', style: GoogleFonts.inter(fontSize: 14)),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                const Icon(LucideIcons.edit2, size: 16, color: Color(0xFF595973)),
                                const SizedBox(width: 8),
                                Text('Edit', style: GoogleFonts.inter(fontSize: 14)),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                const Icon(LucideIcons.trash2, size: 16, color: Colors.red),
                                const SizedBox(width: 8),
                                Text('Delete', style: GoogleFonts.inter(fontSize: 14, color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: getStatusColor(student['status']).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: getStatusColor(student['status']),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          student['status'],
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: getStatusColor(student['status']),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
