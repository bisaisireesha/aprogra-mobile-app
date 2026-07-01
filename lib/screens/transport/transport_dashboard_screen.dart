import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/common_app_bar.dart';
import '../auth/menu_screen.dart';

class TransportDashboardScreen extends StatefulWidget {
  const TransportDashboardScreen({super.key});

  @override
  State<TransportDashboardScreen> createState() => _TransportDashboardScreenState();
}

class _TransportDashboardScreenState extends State<TransportDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterStatus = 'All';

  List<Map<String, dynamic>> _allBuses = [
    {
      'status': 'On Route',
      'statusColor': const Color(0xFF10B981),
      'busId': 'BUS-204',
      'details': '48 seater · Route R-12',
      'from': 'Campus',
      'to': 'Sector 42',
      'driver': 'R. Sharma',
      'occupancyText': '38/48 · 79%',
      'progress': 0.79,
      'progressColor': const Color(0xFF10B981),
      'location': 'Park Lane',
      'fuel': '72%',
    },
    {
      'status': 'At School',
      'statusColor': const Color(0xFF0EA5E9),
      'busId': 'BUS-118',
      'details': '52 seater · Route R-07',
      'from': 'Mehrauli',
      'to': 'Campus',
      'driver': 'Hannah Cruz',
      'occupancyText': '0/52 · 0%',
      'progress': 0.0,
      'progressColor': const Color(0xFF10B981),
      'location': 'Bay #3',
      'fuel': '90%',
    },
    {
      'status': 'On Route',
      'statusColor': const Color(0xFF10B981),
      'busId': 'BUS-551',
      'details': '24 seater · Route R-03',
      'from': 'Campus',
      'to': 'Vasant Kunj',
      'driver': 'Alexi Park',
      'occupancyText': '22/24 · 92%',
      'progress': 0.92,
      'progressColor': const Color(0xFFF59E0B),
      'location': 'Ring Road',
      'fuel': '41%',
    },
    {
      'status': 'Idle',
      'statusColor': const Color(0xFF94A3B8),
      'busId': 'BUS-392',
      'details': '48 seater · Route R-15',
      'from': 'Depot',
      'to': '—',
      'driver': 'David Kim',
      'occupancyText': '0/48 · 0%',
      'progress': 0.0,
      'progressColor': const Color(0xFF94A3B8),
      'location': 'Depot Bay 5',
      'fuel': '100%',
    },
    {
      'status': 'Maintenance',
      'statusColor': const Color(0xFFF59E0B),
      'busId': 'BUS-622',
      'details': '24 seater · Route R-21',
      'from': 'Workshop',
      'to': '—',
      'driver': 'Unassigned',
      'occupancyText': '0/24 · 0%',
      'progress': 0.0,
      'progressColor': const Color(0xFF94A3B8),
      'location': 'Service Bay',
      'fuel': '35%',
    },
    {
      'status': 'On Route',
      'statusColor': const Color(0xFF10B981),
      'busId': 'BUS-405',
      'details': '52 seater · Route R-09',
      'from': 'Saket',
      'to': 'Campus',
      'driver': 'Marcus Lee',
      'occupancyText': '44/52 · 85%',
      'progress': 0.85,
      'progressColor': const Color(0xFF10B981),
      'location': 'Hauz Khas',
      'fuel': '58%',
    },
    {
      'status': 'On Route',
      'statusColor': const Color(0xFF10B981),
      'busId': 'BUS-102',
      'details': '40 seater · Route R-01',
      'from': 'Campus',
      'to': 'Green Park',
      'driver': 'J. Singh',
      'occupancyText': '35/40 · 87%',
      'progress': 0.87,
      'progressColor': const Color(0xFF10B981),
      'location': 'Metro Station',
      'fuel': '81%',
    },
    {
      'status': 'Idle',
      'statusColor': const Color(0xFF94A3B8),
      'busId': 'BUS-207',
      'details': '24 seater · Route R-05',
      'from': 'Depot',
      'to': '—',
      'driver': 'K. Patel',
      'occupancyText': '0/24 · 0%',
      'progress': 0.0,
      'progressColor': const Color(0xFF94A3B8),
      'location': 'Depot Bay 2',
      'fuel': '65%',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadBuses();
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

  Future<void> _loadBuses() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('transport_buses_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _allBuses = decoded.map((bus) {
          final map = Map<String, dynamic>.from(bus);
          if (map['statusColor'] is int) {
            map['statusColor'] = Color(map['statusColor'] as int);
          }
          if (map['progressColor'] is int) {
            map['progressColor'] = Color(map['progressColor'] as int);
          }
          return map;
        }).toList();
      });
    }
  }

  Future<void> _saveBuses() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _allBuses.map((bus) {
      final copy = Map<String, dynamic>.from(bus);
      if (copy['statusColor'] is Color) {
        copy['statusColor'] = (copy['statusColor'] as Color).value;
      }
      if (copy['progressColor'] is Color) {
        copy['progressColor'] = (copy['progressColor'] as Color).value;
      }
      return copy;
    }).toList();
    await prefs.setString('transport_buses_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      drawer: const MenuScreen(activeScreen: 'Transport Dashboard'),
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
                  const SizedBox(height: 32),
                  _buildListHeader(),
                  const SizedBox(height: 16),
                  _buildBusesList(),
                  const SizedBox(height: 24),
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
          'Transport Dashboard',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF181821),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Live overview of school buses, routes and on-road status.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF595973),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildPrimaryButton('Add Bus', LucideIcons.plus, () {
              _showAddBusModal(context);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondaryButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF595973)),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF595973),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF6366F1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBusModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => AddBusModal(
        onSave: (newBus) {
          setState(() {
            _allBuses.insert(0, newBus);
          });
          _saveBuses();
        },
      ),
    );
  }

  void _showEditBusModal(BuildContext context, Map<String, dynamic> bus) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => AddBusModal(
        initialBus: bus,
        title: 'Edit Bus',
        saveText: 'Save Changes',
        onSave: (updatedBus) {
          setState(() {
            final index = _allBuses.indexWhere((b) => b['busId'] == bus['busId']);
            if (index != -1) {
              _allBuses[index] = updatedBus;
            }
          });
          _saveBuses();
        },
      ),
    );
  }

  void _showViewDetailsModal(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Details',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF181821),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(LucideIcons.x, size: 24, color: Color(0xFF181821)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: item.entries.map((e) {
                  if (e.key == 'color' || e.key == 'statusColor' || e.key == 'progressColor') return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.key.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          e.value.toString(),
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF181821),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
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
            ...['All', 'On Route', 'At School', 'Idle', 'Maintenance'].map((status) => RadioListTile(
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

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Active buses',
                '18',
                'out of 22 fleet',
                LucideIcons.bus,
                const Color(0xFF8B5CF6),
                const Color(0xFFEDE9FE),
                isPrimary: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Routes operating',
                '14',
                '2 paused today',
                LucideIcons.route,
                const Color(0xFF0EA5E9),
                const Color(0xFFE0F2FE),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Students transported',
                '1,284',
                '92% boarded',
                LucideIcons.users,
                const Color(0xFF10B981),
                const Color(0xFFD1FAE5),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Under maintenance',
                '03',
                '1 scheduled today',
                LucideIcons.wrench,
                const Color(0xFFF59E0B),
                const Color(0xFFFEF3C7),
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
  }) {
    return Container(
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
      ),
    );
  }

  Widget _buildListHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Buses on the road',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF181821),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Live status, occupancy and fuel level for each vehicle.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF595973),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.search, color: Color(0xFF94A3B8), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search by bus ID or route...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF94A3B8),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 11),
                        ),
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF181821),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.filter, color: Color(0xFF181821), size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Filter',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF181821),
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

  Widget _buildBusesList() {
    final filteredBuses = _allBuses.where((bus) {
      final busId = bus['busId'].toString().toLowerCase();
      final route = bus['details'].toString().toLowerCase();
      final driver = bus['driver'].toString().toLowerCase();
      
      final matchesSearch = _searchQuery.isEmpty ||
             busId.contains(_searchQuery) || 
             route.contains(_searchQuery) || 
             driver.contains(_searchQuery);
             
      final matchesFilter = _filterStatus == 'All' || bus['status'] == _filterStatus;
      
      return matchesSearch && matchesFilter;
    }).toList();

    if (filteredBuses.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(LucideIcons.search, size: 48, color: const Color(0xFF94A3B8).withValues(alpha: 0.5)),
              const SizedBox(height: 16),
              Text(
                'No buses found',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF181821),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Try searching with a different term',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF595973),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: filteredBuses.map((bus) => _buildBusCard(
        status: bus['status'],
        statusColor: bus['statusColor'],
        busId: bus['busId'],
        details: bus['details'],
        from: bus['from'],
        to: bus['to'],
        driver: bus['driver'],
        occupancyText: bus['occupancyText'],
        progress: bus['progress'],
        progressColor: bus['progressColor'],
        location: bus['location'],
        fuel: bus['fuel'],
        onView: () {
          _showViewDetailsModal(context, bus);
        },
        onEdit: () {
          _showEditBusModal(context, bus);
        },
        onDelete: () {
          setState(() {
            _allBuses.remove(bus);
          });
        },
      )).toList(),
    );
  }

  Widget _buildBusCard({
    required String status,
    required Color statusColor,
    required String busId,
    required String details,
    required String from,
    required String to,
    required String driver,
    required String occupancyText,
    required double progress,
    required Color progressColor,
    required String location,
    required String fuel,
    required VoidCallback onView,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        children: [
          // Row 1: Status & More options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      status,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(LucideIcons.moreVertical, size: 18, color: Color(0xFF94A3B8)),
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                onSelected: (value) {
                  if (value == 'view') {
                    onView();
                  } else if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        const Icon(LucideIcons.eye, size: 16, color: Color(0xFF595973)),
                        const SizedBox(width: 8),
                        Text('View Details', style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF181821))),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(LucideIcons.edit2, size: 16, color: Color(0xFF595973)),
                        const SizedBox(width: 8),
                        Text('Edit', style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF181821))),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(LucideIcons.trash2, size: 16, color: Colors.red),
                        const SizedBox(width: 8),
                        Text('Delete', style: GoogleFonts.inter(fontSize: 13, color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Row 2: Image & Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bus Image Placeholder
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 64,
                  color: const Color(0xFFF8F5FF),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(LucideIcons.bus, color: Color(0xFFD8B4FE), size: 32),
                      Image.asset(
                        'assets/images/school_bus.png',
                        width: 80,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      busId,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF181821),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      details,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF595973),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          from,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF181821),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(LucideIcons.arrowRight, size: 12, color: Color(0xFF94A3B8)),
                        ),
                        Text(
                          to,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF181821),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      driver,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF595973),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      occupancyText,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF181821),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Stack(
                      children: [
                        Container(
                          height: 6,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: progress,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: progressColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
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
          // Row 3: Footer (Location & Fuel)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.mapPin, size: 14, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 4),
                  Text(
                    location,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF595973),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(LucideIcons.fuel, size: 14, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 4),
                  Text(
                    fuel,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF595973),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddBusModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic>? initialBus;
  final String title;
  final String saveText;

  const AddBusModal({
    super.key,
    required this.onSave,
    this.initialBus,
    this.title = 'Add New Bus',
    this.saveText = 'Save Bus',
  });

  @override
  State<AddBusModal> createState() => _AddBusModalState();
}

class _AddBusModalState extends State<AddBusModal> {
  final _busIdController = TextEditingController();
  final _capacityController = TextEditingController();
  final _locationController = TextEditingController();
  final _routeController = TextEditingController();

  String _status = 'On Route';
  String _busType = 'Select bus type';
  String _fuelType = 'Select fuel type';
  String _color = 'Select color';
  String _driver = 'Select driver';
  String _assistant = 'Select assistant';

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialBus != null) {
      _busIdController.text = widget.initialBus!['busId'] ?? '';
      _locationController.text = widget.initialBus!['location'] ?? '';
      
      final validStatuses = ['On Route', 'At School', 'Idle', 'Maintenance'];
      if (validStatuses.contains(widget.initialBus!['status'])) {
        _status = widget.initialBus!['status'];
      }
      
      final details = widget.initialBus!['details'] as String? ?? '';
      if (details.contains('Route ')) {
        _routeController.text = details.split('Route ').last;
      }
      
      if (details.contains('seater')) {
        _capacityController.text = details.split(' ').first;
      }
      
      final validDrivers = ['Select driver', 'R. Sharma', 'Hannah Cruz', 'Alexi Park', 'David Kim'];
      if (validDrivers.contains(widget.initialBus!['driver'])) {
        _driver = widget.initialBus!['driver'];
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    _busIdController.dispose();
    _capacityController.dispose();
    _locationController.dispose();
    _routeController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final busId = _busIdController.text.isNotEmpty ? _busIdController.text : 'BUS-XXX';
    final capacity = _capacityController.text.isNotEmpty ? _capacityController.text : '52';
    final route = _routeController.text.isNotEmpty ? _routeController.text : 'R-00';
    final driver = _driver != 'Select driver' ? _driver : 'Unassigned';
    final location = _locationController.text.isNotEmpty ? _locationController.text : 'Unknown Location';

    Color statusColor;
    if (_status == 'On Route') {
      statusColor = const Color(0xFF10B981); // Green
    } else if (_status == 'At School') {
      statusColor = const Color(0xFF0EA5E9); // Blue
    } else if (_status == 'Idle') {
      statusColor = const Color(0xFF94A3B8); // Gray
    } else {
      statusColor = const Color(0xFFF59E0B); // Orange/Maintenance
    }

    widget.onSave({
      'status': _status,
      'statusColor': statusColor,
      'busId': busId,
      'details': '$capacity seater · Route $route',
      'from': 'Campus',
      'to': '—',
      'driver': driver,
      'occupancyText': '0/$capacity · 0%',
      'progress': 0.0,
      'progressColor': statusColor,
      'location': location,
      'fuel': '100%',
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9FB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // AppBar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(LucideIcons.x, size: 24, color: Color(0xFF181821)),
                ),
                Text(
                  widget.title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF181821),
                  ),
                ),
                GestureDetector(
                  onTap: _handleSave,
                  child: Text(
                    'Save',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionCard(
                  'Bus Information',
                  LucideIcons.bus,
                  [
                    Row(
                      children: [
                        Expanded(child: _buildTextField('Bus ID *', 'e.g. BUS-123', _busIdController)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField('Registration Number *', 'e.g. KA01AB1234', null)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            'Bus Type *',
                            _busType,
                            ['Select bus type', 'Standard Bus', 'Mini Bus', 'Van'],
                            onChanged: (val) => setState(() => _busType = val!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField('Seating Capacity *', 'e.g. 52', _capacityController)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            'Fuel Type',
                            _fuelType,
                            ['Select fuel type', 'Diesel', 'Petrol', 'Electric', 'CNG'],
                            onChanged: (val) => setState(() => _fuelType = val!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField('Model / Year', 'e.g. 2023', null)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildDropdown(
                      'Color',
                      _color,
                      ['Select color', 'Yellow', 'White', 'Blue', 'Silver'],
                      onChanged: (val) => setState(() => _color = val!),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  'Route & Assignment',
                  LucideIcons.map,
                  [
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField('Route *', 'e.g. Route R-12', _routeController),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDropdown(
                            'Assigned Driver',
                            _driver,
                            ['Select driver', 'R. Sharma', 'Hannah Cruz', 'Alexi Park', 'David Kim'],
                            onChanged: (val) => setState(() => _driver = val!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildDropdown(
                      'Assistant / Conductor (Optional)',
                      _assistant,
                      ['Select assistant', 'A. Kumar', 'S. Singh', 'M. Patel'],
                      onChanged: (val) => setState(() => _assistant = val!),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  'Current Location',
                  LucideIcons.mapPin,
                  [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            'Current Status *',
                            _status,
                            ['On Route', 'At School', 'Idle', 'Maintenance'],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _status = val);
                              }
                            },
                            showDot: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField('Current Location', 'e.g. Park Lane', _locationController)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('Next Stop', 'e.g. Sector 42', null)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField('Live Tracking Device ID', 'e.g. TRK123456', null)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  'Bus Image',
                  LucideIcons.image,
                  [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F5FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFD8B4FE), style: BorderStyle.solid), // Should be dashed in reality
                      ),
                      child: _selectedImage != null
                          ? Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(_selectedImage!, height: 150, width: double.infinity, fit: BoxFit.cover),
                                ),
                                const SizedBox(height: 16),
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Text('Change Image', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF6366F1))),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(LucideIcons.uploadCloud, color: Color(0xFF8B5CF6), size: 24),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Upload bus image',
                                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF181821)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'JPG, PNG up to 5MB',
                                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8)),
                                ),
                                const SizedBox(height: 16),
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(LucideIcons.image, size: 14, color: Color(0xFF6366F1)),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Choose from Gallery',
                                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF6366F1)),
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
                const SizedBox(height: 32),
              ],
            ),
          ),
          // Bottom button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
            ),
            child: GestureDetector(
              onTap: _handleSave,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    widget.saveText,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
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
                  fontWeight: FontWeight.w600,
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

  Widget _buildTextField(String label, String hint, TextEditingController? controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label.replaceAll(' *', ''),
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF595973)),
            children: [
              if (label.contains('*')) TextSpan(text: ' *', style: GoogleFonts.inter(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 11),
            ),
            style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF181821)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, {Function(String?)? onChanged, bool showDot = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label.replaceAll(' *', ''),
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF595973)),
            children: [
              if (label.contains('*')) TextSpan(text: ' *', style: GoogleFonts.inter(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: Colors.white,
              isExpanded: true,
              value: value,
              icon: const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF94A3B8)),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Row(
                    children: [
                      if (showDot) ...[
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: item == 'On Route' ? const Color(0xFF10B981) : (item == 'At School' ? const Color(0xFF0EA5E9) : (item == 'Idle' ? const Color(0xFF94A3B8) : const Color(0xFFF59E0B))),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(item, style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF181821))),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
