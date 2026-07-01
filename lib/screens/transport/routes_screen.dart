import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/common_app_bar.dart';
import '../auth/menu_screen.dart';
import 'add_route_modal.dart';

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _filterStatus = 'All';

  List<Map<String, dynamic>> _routes = [
    {
      'code': 'R-03',
      'name': 'Vasant Kunj Loop',
      'students': 42,
      'duration': '55m',
      'from': 'Campus',
      'to': 'Vasant Kunj',
      'bus': 'BUS-551',
      'driver': 'Alexi Park',
      'status': 'Active',
      'color': const Color(0xFF10B981),
    },
    {
      'code': 'R-07',
      'name': 'Mehrauli Express',
      'students': 48,
      'duration': '1h 05m',
      'from': 'Mehrauli',
      'to': 'Campus',
      'bus': 'BUS-118',
      'driver': 'Hannah Cruz',
      'status': 'Active',
      'color': const Color(0xFF0EA5E9),
    },
    {
      'code': 'R-09',
      'name': 'Saket Corridor',
      'students': 44,
      'duration': '48m',
      'from': 'Saket',
      'to': 'Campus',
      'bus': 'BUS-405',
      'driver': 'Marcus Lee',
      'status': 'Active',
      'color': const Color(0xFF10B981),
    },
    {
      'code': 'R-12',
      'name': 'Sector 42 Route',
      'students': 38,
      'duration': '58m',
      'from': 'Campus',
      'to': 'Sector 42',
      'bus': 'BUS-204',
      'driver': 'R. Sharma',
      'status': 'Active',
      'color': const Color(0xFF10B981),
    },
    {
      'code': 'R-15',
      'name': 'Greater Kailash',
      'students': 0,
      'duration': '42m',
      'from': 'Campus',
      'to': 'GK-II',
      'bus': 'BUS-392',
      'driver': 'David Kim',
      'status': 'Paused',
      'color': const Color(0xFFF59E0B),
    },
    {
      'code': 'R-21',
      'name': 'Dwarka Sector 18',
      'students': 0,
      'duration': '1h 20m',
      'from': 'Campus',
      'to': 'Dwarka',
      'bus': '—',
      'driver': 'Unassigned',
      'status': 'Draft',
      'color': const Color(0xFF8B5CF6),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadRoutes();
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

  Future<void> _loadRoutes() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('transport_routes_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _routes = decoded.map((route) {
          final map = Map<String, dynamic>.from(route);
          if (map['color'] is int) {
            map['color'] = Color(map['color'] as int);
          }
          return map;
        }).toList();
      });
    }
  }

  Future<void> _saveRoutes() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _routes.map((route) {
      final copy = Map<String, dynamic>.from(route);
      if (copy['color'] is Color) {
        copy['color'] = (copy['color'] as Color).value;
      }
      return copy;
    }).toList();
    await prefs.setString('transport_routes_data', jsonEncode(serialized));
  }

  void _showAddRouteModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => AddRouteModal(
        onSave: (newRoute) {
          setState(() {
            _routes.insert(0, newRoute);
          });
          _saveRoutes();
        },
      ),
    );
  }

  void _showEditRouteModal(BuildContext context, Map<String, dynamic> route) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => AddRouteModal(
        initialRoute: route,
        title: 'Edit Route',
        saveText: 'Save Changes',
        onSave: (updatedRoute) {
          setState(() {
            final index = _routes.indexWhere((r) => r['code'] == route['code']);
            if (index != -1) {
              _routes[index] = updatedRoute;
            }
          });
          _saveRoutes();
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
                  if (e.key == 'color') return const SizedBox();
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
            ...['All', 'Active', 'Paused', 'Draft'].map((status) => RadioListTile(
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
      backgroundColor: const Color(0xFFF9F9FB),
      drawer: const MenuScreen(activeScreen: 'Routes'),
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
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildRoutesList(),
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
          'Routes',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF181821),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Define and manage bus routes, stops and assigned vehicles.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF595973),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildPrimaryButton('New Route', LucideIcons.plus, () {
              _showAddRouteModal(context);
            }),
          ],
        ),
      ],
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

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Routes',
                '6',
                '',
                LucideIcons.gitMerge,
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
                LucideIcons.navigation,
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
                'Paused',
                '1',
                '',
                LucideIcons.clock,
                const Color(0xFFF59E0B),
                const Color(0xFFFEF3C7),
                isPrimary: _filterStatus == 'Paused',
                onTap: () {
                  setState(() {
                    _filterStatus = 'Paused';
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Drafts',
                '1',
                '',
                LucideIcons.mapPin,
                const Color(0xFF0EA5E9),
                const Color(0xFFE0F2FE),
                isPrimary: _filterStatus == 'Draft',
                onTap: () {
                  setState(() {
                    _filterStatus = 'Draft';
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
          Row(
            children: [
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
            ],
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
          ]
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
                const Icon(LucideIcons.search, color: Color(0xFF94A3B8), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search route, code, driver or bus',
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

  Widget _buildRoutesList() {
    final filteredRoutes = _routes.where((route) {
      final matchesSearch = _searchQuery.isEmpty || 
        route['code'].toString().toLowerCase().contains(_searchQuery) ||
        route['name'].toString().toLowerCase().contains(_searchQuery) ||
        route['driver'].toString().toLowerCase().contains(_searchQuery) ||
        route['bus'].toString().toLowerCase().contains(_searchQuery);
        
      final matchesFilter = _filterStatus == 'All' || route['status'] == _filterStatus;
      
      return matchesSearch && matchesFilter;
    }).toList();

    if (filteredRoutes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(LucideIcons.search, size: 48, color: const Color(0xFF94A3B8).withValues(alpha: 0.5)),
              const SizedBox(height: 16),
              Text(
                'No routes found',
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
      itemCount: filteredRoutes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final route = filteredRoutes[index];
        final isDraft = route['status'] == 'Draft';
        return Container(
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
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left color strip
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: isDraft ? const Color(0xFF94A3B8) : route['color'],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Route Code Box
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: isDraft ? const Color(0xFFF1F5F9) : route['color'].withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            route['code'],
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDraft ? const Color(0xFF64748B) : route['color'],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    route['name'],
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF181821),
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(LucideIcons.moreVertical, size: 16, color: Color(0xFF94A3B8)),
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    onSelected: (value) {
                                      if (value == 'view') {
                                        _showViewDetailsModal(context, route);
                                      } else if (value == 'edit') {
                                        _showEditRouteModal(context, route);
                                      } else if (value == 'delete') {
                                        setState(() {
                                          _routes.remove(route);
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
                              const SizedBox(height: 6),
                              Text(
                                '${route['students']} students · ${route['duration']}',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: const Color(0xFF595973),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              route['from'],
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: const Color(0xFF595973),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(LucideIcons.arrowRight, size: 12, color: Color(0xFF94A3B8)),
                                            const SizedBox(width: 4),
                                            Text(
                                              route['to'],
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: const Color(0xFF595973),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${route['bus']} · ${route['driver']}',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF595973),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Status badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isDraft ? const Color(0xFFF1F5F9) : route['color'].withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (isDraft) ...[
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF64748B),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                        ],
                                        Text(
                                          route['status'],
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: isDraft ? const Color(0xFF64748B) : route['color'],
                                          ),
                                        ),
                                      ],
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
