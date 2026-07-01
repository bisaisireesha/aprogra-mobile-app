import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/common_app_bar.dart';
import '../auth/menu_screen.dart';
import 'add_vehicle_modal.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterStatus = 'All';

  List<Map<String, dynamic>> _vehicles = [
    {
      'registration': 'DL-1A-2204',
      'model': 'Tata Starbus',
      'type': 'Bus',
      'seats': 48,
      'year': '2021',
      'serviceDate': '12 May 2026',
      'status': 'Active',
      'statusColor': const Color(0xFF10B981),
      'fuel': 72,
      'route': 'Route R-12',
      'driver': 'R. Sharma',
    },
    {
      'registration': 'DL-1A-2118',
      'model': 'Ashok Leyland',
      'type': 'Bus',
      'seats': 52,
      'year': '2020',
      'serviceDate': '08 Apr 2026',
      'status': 'Active',
      'statusColor': const Color(0xFF10B981),
      'fuel': 90,
      'route': 'Route R-07',
      'driver': 'Hannah Cruz',
    },
    {
      'registration': 'DL-1A-2551',
      'model': 'Force Traveller',
      'type': 'Mini-bus',
      'seats': 24,
      'year': '2022',
      'serviceDate': '30 Apr 2026',
      'status': 'Active',
      'statusColor': const Color(0xFF10B981),
      'fuel': 41,
      'route': 'Route R-03',
      'driver': 'Alexi Park',
    },
    {
      'registration': 'DL-1A-2392',
      'model': 'Eicher Skyline',
      'type': 'Bus',
      'seats': 48,
      'year': '2019',
      'serviceDate': '01 Jun 2026',
      'status': 'Idle',
      'statusColor': const Color(0xFF0EA5E9),
      'fuel': 100,
      'route': 'Route R-15',
      'driver': 'David Kim',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadVehicles();
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

  Future<void> _loadVehicles() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('transport_vehicles_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _vehicles = decoded.map((vehicle) {
          final map = Map<String, dynamic>.from(vehicle);
          if (map['statusColor'] is int) {
            map['statusColor'] = Color(map['statusColor'] as int);
          }
          return map;
        }).toList();
      });
    }
  }

  Future<void> _saveVehicles() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _vehicles.map((vehicle) {
      final copy = Map<String, dynamic>.from(vehicle);
      if (copy['statusColor'] is Color) {
        copy['statusColor'] = (copy['statusColor'] as Color).value;
      }
      return copy;
    }).toList();
    await prefs.setString('transport_vehicles_data', jsonEncode(serialized));
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
            ...['All', 'Active', 'Idle', 'Maintenance'].map((status) => RadioListTile(
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
                  if (e.key == 'statusColor') return const SizedBox();
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

  void _showAddVehicleModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => AddVehicleModal(
        onSave: (newVehicle) {
          setState(() {
            _vehicles.insert(0, newVehicle);
          });
          _saveVehicles();
        },
      ),
    );
  }

  void _showEditVehicleModal(BuildContext context, Map<String, dynamic> vehicle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => AddVehicleModal(
        initialVehicle: vehicle,
        title: 'Edit Vehicle',
        saveText: 'Save Changes',
        onSave: (updatedVehicle) {
          setState(() {
            final index = _vehicles.indexWhere((v) => v['registration'] == vehicle['registration']);
            if (index != -1) {
              _vehicles[index] = updatedVehicle;
            }
          });
          _saveVehicles();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: const MenuScreen(activeScreen: 'Vehicles'),
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
                  _buildVehiclesList(),
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
          'Vehicles',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF181821),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Fleet inventory, registrations, capacity and service status.',
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
              onTap: () => _showAddVehicleModal(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                      'Add Vehicle',
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
                'Total Fleet',
                '6',
                '',
                LucideIcons.bus,
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
                'Active',
                '4',
                '',
                LucideIcons.checkCircle2,
                const Color(0xFF10B981),
                const Color(0xFFD1FAE5),
                isPrimary: _filterStatus == 'Active',
                onTap: () {
                  setState(() {
                    _filterStatus = 'Active';
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
                'Idle',
                '1',
                '',
                LucideIcons.shieldCheck,
                const Color(0xFF0EA5E9),
                const Color(0xFFE0F2FE),
                isPrimary: _filterStatus == 'Idle',
                onTap: () {
                  setState(() {
                    _filterStatus = 'Idle';
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Maintenance',
                '1',
                '',
                LucideIcons.wrench,
                const Color(0xFFF59E0B),
                const Color(0xFFFEF3C7),
                isPrimary: _filterStatus == 'Maintenance',
                onTap: () {
                  setState(() {
                    _filterStatus = 'Maintenance';
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
              const Icon(LucideIcons.moreVertical, size: 16, color: Color(0xFF94A3B8)),
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
                      hintText: 'Search registration, model, driver...',
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

  Widget _buildVehiclesList() {
    final filteredVehicles = _vehicles.where((vehicle) {
      final matchesSearch = _searchQuery.isEmpty || 
        vehicle['registration'].toString().toLowerCase().contains(_searchQuery) ||
        vehicle['model'].toString().toLowerCase().contains(_searchQuery) ||
        vehicle['driver'].toString().toLowerCase().contains(_searchQuery);
        
      final matchesFilter = _filterStatus == 'All' || vehicle['status'] == _filterStatus;
      
      return matchesSearch && matchesFilter;
    }).toList();

    if (filteredVehicles.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(LucideIcons.search, size: 48, color: const Color(0xFF94A3B8).withValues(alpha: 0.5)),
              const SizedBox(height: 16),
              Text(
                'No vehicles found',
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
      itemCount: filteredVehicles.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final vehicle = filteredVehicles[index];
        return _buildVehicleCard(vehicle);
      },
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F5FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.car, color: Color(0xFF8B5CF6), size: 24),
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
                          vehicle['registration'],
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF181821),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: vehicle['statusColor'].withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                vehicle['status'],
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: vehicle['statusColor'],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            PopupMenuButton<String>(
                              icon: const Icon(LucideIcons.moreVertical, size: 16, color: Color(0xFF94A3B8)),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              onSelected: (value) {
                                if (value == 'view') {
                                  _showViewDetailsModal(context, vehicle);
                                } else if (value == 'edit') {
                                  _showEditVehicleModal(context, vehicle);
                                } else if (value == 'delete') {
                                  setState(() {
                                    _vehicles.remove(vehicle);
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
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vehicle['model'],
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF181821),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${vehicle['type']} · ${vehicle['seats']} Seats',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF595973),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${vehicle['year']} · Service ${vehicle['serviceDate']}',
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
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(LucideIcons.fuel, size: 14, color: Color(0xFF94A3B8)),
              const SizedBox(width: 6),
              Text(
                'Fuel',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF595973),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: vehicle['fuel'] / 100,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${vehicle['fuel']}%',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF181821),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.gitMerge, size: 14, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 6),
                  Text(
                    vehicle['route'],
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF595973),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(LucideIcons.user, size: 14, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 6),
                  Text(
                    'Driver ${vehicle['driver']}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
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
