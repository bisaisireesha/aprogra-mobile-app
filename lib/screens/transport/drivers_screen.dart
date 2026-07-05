import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/common_app_bar.dart';
import '../auth/menu_screen.dart';
import 'add_driver_modal.dart';
import '../../widgets/app_bottom_nav.dart';

class DriversScreen extends StatefulWidget {
  const DriversScreen({super.key});

  @override
  State<DriversScreen> createState() => _DriversScreenState();
}

class _DriversScreenState extends State<DriversScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterStatus = 'All';

  List<Map<String, dynamic>> _drivers = [
    {
      'name': 'R. Sharma',
      'id': '0001',
      'license': 'DL-1320110012345',
      'exp': '12 Aug 2027',
      'expiringSoon': false,
      'bus': 'BUS-204',
      'route': 'R-12',
      'status': 'On Duty',
      'statusColor': const Color(0xFF10B981),
    },
    {
      'name': 'Hannah Cruz',
      'id': '0002',
      'license': 'DL-1320110054872',
      'exp': '03 Mar 2026',
      'expiringSoon': true,
      'bus': 'BUS-118',
      'route': 'R-07',
      'status': 'On Duty',
      'statusColor': const Color(0xFF10B981),
    },
    {
      'name': 'Alexi Park',
      'id': '0003',
      'license': 'DL-1320110099821',
      'exp': '29 Nov 2027',
      'expiringSoon': false,
      'bus': 'BUS-551',
      'route': 'R-03',
      'status': 'On Duty',
      'statusColor': const Color(0xFF10B981),
    },
    {
      'name': 'David Kim',
      'id': '0004',
      'license': 'DL-1320110044120',
      'exp': '18 Jun 2026',
      'expiringSoon': true,
      'bus': 'BUS-392',
      'route': 'R-15',
      'status': 'Available',
      'statusColor': const Color(0xFF0EA5E9),
    },
    {
      'name': 'Marcus Lee',
      'id': '0005',
      'license': 'DL-1320110077310',
      'exp': '22 Oct 2028',
      'expiringSoon': false,
      'bus': 'BUS-405',
      'route': 'R-09',
      'status': 'On Duty',
      'statusColor': const Color(0xFF10B981),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadDrivers();
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

  Future<void> _loadDrivers() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('transport_drivers_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _drivers = decoded.map((driver) {
          final map = Map<String, dynamic>.from(driver);
          if (map['statusColor'] is int) {
            map['statusColor'] = Color(map['statusColor'] as int);
          }
          return map;
        }).toList();
      });
    }
  }

  Future<void> _saveDrivers() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _drivers.map((driver) {
      final copy = Map<String, dynamic>.from(driver);
      if (copy['statusColor'] is Color) {
        copy['statusColor'] = (copy['statusColor'] as Color).value;
      }
      return copy;
    }).toList();
    await prefs.setString('transport_drivers_data', jsonEncode(serialized));
  }

  void _showAddDriverModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => AddDriverModal(
        onSave: (newDriver) {
          setState(() {
            _drivers.insert(0, newDriver);
          });
          _saveDrivers();
        },
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
            Text(
              'Filter by Status',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            ...['All', 'On Duty', 'Available', 'On Leave'].map(
              (status) => RadioListTile(
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showViewDetailsModal(BuildContext context, Map<String, dynamic> item) {
    String getInitials(String name) {
      return name
          .split(' ')
          .map((e) => e.isNotEmpty ? e[0] : '')
          .join('')
          .toUpperCase()
          .substring(0, 2);
    }

    Widget _buildDetailRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF595973),
              ),
            ),
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

    Widget _buildSectionHeader(IconData icon, String title) {
      return Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF6366F1)),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF6366F1),
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
                border: Border(
                  bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
                ),
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
                        child: const Icon(
                          LucideIcons.x,
                          size: 24,
                          color: Color(0xFF181821),
                        ),
                      ),
                      Text(
                        'Driver Details',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF181821),
                        ),
                      ),
                      const SizedBox(width: 24), // For balance
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8F5FF),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              getInitials(item['name']),
                              style: GoogleFonts.inter(
                                fontSize: 24,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item['name'],
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF181821),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: item['statusColor'].withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: item['statusColor'],
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          item['status'],
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: item['statusColor'],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'ID #${item['id']}',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    LucideIcons.phone,
                                    size: 14,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+91 98xxxx 1023',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: const Color(0xFF595973),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.grey.withValues(alpha: 0.1)),

                    _buildSectionHeader(
                      LucideIcons.contact,
                      'License Information',
                    ),
                    _buildDetailRow('License Number', item['license']),
                    _buildDetailRow('Issue Date', '12 Aug 2017'),
                    _buildDetailRow(
                      'Expiry Date',
                      '${item['exp']} (14 yrs left)',
                    ),

                    const SizedBox(height: 16),
                    Divider(color: Colors.grey.withValues(alpha: 0.1)),

                    _buildSectionHeader(LucideIcons.car, 'Vehicle & Route'),
                    _buildDetailRow('Vehicle', item['bus']),
                    _buildDetailRow('Route', item['route']),

                    const SizedBox(height: 16),
                    Divider(color: Colors.grey.withValues(alpha: 0.1)),

                    _buildSectionHeader(LucideIcons.info, 'Other Information'),
                    _buildDetailRow('Experience', '14 yrs'),
                    _buildDetailRow('Address', 'Sector 42, Delhi - 110001'),

                    const SizedBox(height: 40),

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _showEditDriverModal(context, item);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF6366F1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              LucideIcons.edit2,
                              size: 18,
                              color: Color(0xFF6366F1),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Edit Driver',
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

                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _drivers.remove(item);
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              LucideIcons.trash2,
                              size: 18,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Deactivate Driver',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDriverModal(BuildContext context, Map<String, dynamic> driver) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => AddDriverModal(
        initialDriver: driver,
        title: 'Edit Driver',
        saveText: 'Save Changes',
        onSave: (updatedDriver) {
          setState(() {
            final index = _drivers.indexWhere((d) => d['id'] == driver['id']);
            if (index != -1) {
              _drivers[index] = updatedDriver;
            }
          });
          _saveDrivers();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: const MenuScreen(activeScreen: 'Drivers'),
      bottomNavigationBar: const AppBottomNav(),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: CommonAppBar(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildStatsGrid(),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildDriversList(),
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
          'Drivers',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF181821),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Licensed drivers, their assigned vehicles and duty status.',
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
              onTap: () => _showAddDriverModal(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.plus, size: 16, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      'Add Driver',
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
                'Total Drivers',
                '6',
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
                'On Duty',
                '4',
                '',
                LucideIcons.userCheck,
                const Color(0xFF10B981),
                const Color(0xFFD1FAE5),
                isPrimary: _filterStatus == 'On Duty',
                onTap: () {
                  setState(() {
                    _filterStatus = 'On Duty';
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
                'Available',
                '1',
                '',
                LucideIcons.badge,
                const Color(0xFF0EA5E9),
                const Color(0xFFE0F2FE),
                isPrimary: _filterStatus == 'Available',
                onTap: () {
                  setState(() {
                    _filterStatus = 'Available';
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'On Leave',
                '1',
                '',
                LucideIcons.shieldAlert,
                const Color(0xFFF59E0B),
                const Color(0xFFFEF3C7),
                isPrimary: _filterStatus == 'On Leave',
                onTap: () {
                  setState(() {
                    _filterStatus = 'On Leave';
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
            color: isPrimary
                ? const Color(0xFF7F61EA).withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.1),
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
                const Icon(
                  LucideIcons.search,
                  color: Color(0xFF94A3B8),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF181821),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search drivers...',
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
            child: const Icon(
              LucideIcons.filter,
              color: Color(0xFF595973),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDriversList() {
    final filteredDrivers = _drivers.where((driver) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          driver['name'].toString().toLowerCase().contains(_searchQuery) ||
          driver['id'].toString().toLowerCase().contains(_searchQuery) ||
          driver['license'].toString().toLowerCase().contains(_searchQuery) ||
          driver['bus'].toString().toLowerCase().contains(_searchQuery);

      final matchesFilter =
          _filterStatus == 'All' || driver['status'] == _filterStatus;

      return matchesSearch && matchesFilter;
    }).toList();

    if (filteredDrivers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(
                LucideIcons.users,
                size: 48,
                color: const Color(0xFF94A3B8).withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No drivers found',
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

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredDrivers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final driver = filteredDrivers[index];
        return _buildDriverCard(driver);
      },
    );
  }

  Widget _buildDriverCard(Map<String, dynamic> driver) {
    String getInitials(String name) {
      return name
          .split(' ')
          .map((e) => e.isNotEmpty ? e[0] : '')
          .join('')
          .toUpperCase()
          .substring(0, 2);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F5FF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    getInitials(driver['name']),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver['name'],
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF181821),
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(
                            LucideIcons.moreVertical,
                            size: 20,
                            color: Color(0xFF94A3B8),
                          ),
                          padding: EdgeInsets.zero,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onSelected: (value) {
                            if (value == 'view') {
                              _showViewDetailsModal(context, driver);
                            } else if (value == 'edit') {
                              _showEditDriverModal(context, driver);
                            } else if (value == 'delete') {
                              setState(() {
                                _drivers.remove(driver);
                              });
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'view',
                              child: Row(
                                children: [
                                  const Icon(
                                    LucideIcons.eye,
                                    size: 16,
                                    color: Color(0xFF595973),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'View Details',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: const Color(0xFF181821),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  const Icon(
                                    LucideIcons.edit2,
                                    size: 16,
                                    color: Color(0xFF595973),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Edit',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: const Color(0xFF181821),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  const Icon(
                                    LucideIcons.trash2,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Delete',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
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
                    Text(
                      'ID #${driver['id']}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                driver['license'],
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF181821),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Exp: ${driver['exp']}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: driver['expiringSoon']
                                      ? const Color(0xFFF59E0B)
                                      : const Color(0xFF595973),
                                  fontWeight: driver['expiringSoon']
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                              if (driver['expiringSoon']) ...[
                                const SizedBox(height: 2),
                                Text(
                                  'renew soon',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFFF59E0B),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                driver['bus'],
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF181821),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                driver['route'],
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF595973),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: driver['statusColor'].withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: driver['statusColor'],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              driver['status'],
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: driver['statusColor'],
                              ),
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
        ],
      ),
    );
  }
}
