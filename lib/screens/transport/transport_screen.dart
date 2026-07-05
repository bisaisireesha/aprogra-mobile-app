import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../screens/auth/menu_screen.dart';
import '../../widgets/app_bottom_nav.dart';

const _bgColor = Color(0xFFF9F9FB);
const _textDark = Color(0xFF181821);
const _textMuted = Color(0xFF595973);
const _primary = Color(0xFF7F61EA); // Purple matching the design
const _cardBorder = Color(0xFFF3F4F6);

class TransportInsightsScreen extends StatefulWidget {
  const TransportInsightsScreen({super.key});

  @override
  State<TransportInsightsScreen> createState() =>
      _TransportInsightsScreenState();
}

class _TransportInsightsScreenState extends State<TransportInsightsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _vehicles = [];
  String _searchQuery = '';
  String _activeFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadVehicles();
    _vehicles = [
      {
        'status': 'Ready',
        'statusColor': const Color(0xFF10B981),
        'bayNumber': 'Bay A-12',
        'vehicleNo': 'KA01AB1234',
        'route': 'Route 01 • Indiranagar',
        'capacity': '50 seats',
        'driver': 'Ravi Kumar',
        'progress': 0.92,
        'progressText': '92%',
        'isReady': true,
        'isIdle': false,
      },
      {
        'status': 'Loading',
        'statusColor': const Color(0xFF7F61EA),
        'bayNumber': 'Bay B-04',
        'vehicleNo': 'KA02CD9876',
        'route': 'Route 05 • Whitefield',
        'capacity': '40 seats',
        'driver': 'Anil Sharma',
        'progress': 0.68,
        'progressText': '68%',
        'isReady': false,
        'isIdle': false,
      },
      {
        'status': 'Loading',
        'statusColor': const Color(0xFF7F61EA),
        'bayNumber': 'Bay A-07',
        'vehicleNo': 'KA03EF4455',
        'route': 'Route 03 • HSR Layout',
        'capacity': '45 seats',
        'driver': 'Suresh Naidu',
        'progress': 0.54,
        'progressText': '54%',
        'isReady': false,
        'isIdle': false,
      },
      {
        'status': 'Idle',
        'statusColor': const Color(0xFF6B7280),
        'bayNumber': 'Bay C-01',
        'vehicleNo': 'KA05XY1122',
        'route': 'Route 08 • Koramangala',
        'capacity': '45 seats',
        'driver': 'Unassigned',
        'progress': 0.35,
        'progressText': '35%',
        'isReady': false,
        'isIdle': true,
      },
      {
        'status': 'Ready',
        'statusColor': const Color(0xFF10B981),
        'bayNumber': 'Bay A-03',
        'vehicleNo': 'KA09LM2211',
        'route': 'Route 14 • Bellandur',
        'capacity': '50 seats',
        'driver': 'Vinod Reddy',
        'progress': 0.88,
        'progressText': '88%',
        'isReady': true,
        'isIdle': false,
      },
      {
        'status': 'Ready',
        'statusColor': const Color(0xFF10B981),
        'bayNumber': 'Bay B-09',
        'vehicleNo': 'KA12RT9090',
        'route': 'Route 20 • Jayanagar',
        'capacity': '45 seats',
        'driver': 'Karthik Iyer',
        'progress': 0.78,
        'progressText': '78%',
        'isReady': true,
        'isIdle': false,
      },
    ];
  }

  List<Map<String, dynamic>> get _filteredVehicles {
    return _vehicles.where((v) {
      final matchesSearch =
          v['vehicleNo'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          v['route'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          v['driver'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      final matchesFilter =
          _activeFilter == 'All' || v['status'] == _activeFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadVehicles() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__vehicles_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _vehicles = decoded.map((item) {
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

  Future<void> _saveVehicles() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _vehicles.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__vehicles_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      drawer: const MenuScreen(activeScreen: 'Transport Insights'),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 24),
                    _buildKPIs(),
                    const SizedBox(height: 24),
                    _buildSearchAndFilter(),
                    const SizedBox(height: 24),
                    ..._filteredVehicles.map(
                      (v) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildVehicleCard(
                          status: v['status'] as String,
                          statusColor: v['statusColor'] as Color,
                          bayNumber: v['bayNumber'] as String,
                          vehicleNo: v['vehicleNo'] as String,
                          route: v['route'] as String,
                          capacity: v['capacity'] as String,
                          driver: v['driver'] as String,
                          progress: v['progress'] as double,
                          progressText: v['progressText'] as String,
                          isReady: v['isReady'] as bool,
                          isIdle: v['isIdle'] as bool? ?? false,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFEBEBEB)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, color: _textMuted, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Search vehicle, route, driver...',
                      style: TextStyle(color: _textMuted, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Stack(
            children: [
              const Icon(Icons.notifications_none, color: _textDark, size: 28),
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: _bgColor, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFE5DCF3),
            child: Icon(Icons.person, color: _primary, size: 20),
          ),
        ],
      ),
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
        currentIndex: 0,
        onTap: (index) {},
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _primary,
        unselectedItemColor: _textMuted,
        selectedLabelStyle: GoogleFonts.figtree(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.figtree(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.layoutGrid),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(LucideIcons.map), label: 'Routes'),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.bus),
            label: 'Vehicles',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.bell),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Transport Overview',
                style: GoogleFonts.figtree(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Live yard view of vehicles, routes and dispatch readiness.',
                style: GoogleFonts.figtree(
                  fontSize: 13,
                  color: _textMuted,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.download, size: 16, color: _textDark),
                  const SizedBox(width: 8),
                  Text(
                    'Export',
                    style: GoogleFonts.figtree(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _textDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => _showAddRouteDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF7F61EA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, size: 16, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      'Add Route',
                      style: GoogleFonts.figtree(
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

  Widget _buildKPIs() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5, // Making cards even shorter
      children: [
        _buildSmallKPI(
          LucideIcons.bus,
          const Color(0xFFF4F1FD),
          const Color(0xFF7F61EA),
          '8',
          'Vehicles Inside',
        ),
        _buildSmallKPI(
          LucideIcons.mapPin,
          const Color(0xFFFFF7ED),
          const Color(0xFFF59E0B),
          '1',
          'Unassigned Routes',
        ),
        _buildSmallKPI(
          LucideIcons.user,
          const Color(0xFFE0F2FE),
          const Color(0xFF0EA5E9),
          '32',
          'Active Pickup Points',
        ),
        _buildSmallKPI(
          LucideIcons.checkCircle2,
          const Color(0xFFDCFCE7),
          const Color(0xFF10B981),
          '4',
          'Dispatch Ready',
        ),
      ],
    );
  }

  Widget _buildSmallKPI(
    IconData icon,
    Color bg,
    Color iconColor,
    String value,
    String title,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 4, right: 2),
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.figtree(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _textDark,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: GoogleFonts.figtree(
              fontSize: 11,
              color: _textMuted,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _cardBorder, width: 1.5),
          ),
          child: Row(
            children: [
              const Icon(
                LucideIcons.search,
                size: 18,
                color: Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search vehicle, route, driver...',
                    hintStyle: GoogleFonts.figtree(
                      fontSize: 14,
                      color: const Color(0xFF9CA3AF),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  style: GoogleFonts.figtree(fontSize: 14, color: _textDark),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('All', null),
              const SizedBox(width: 8),
              _buildFilterChip('Ready', const Color(0xFF10B981)),
              const SizedBox(width: 8),
              _buildFilterChip('Loading', const Color(0xFF7F61EA)),
              const SizedBox(width: 8),
              _buildFilterChip('Idle', const Color(0xFF6B7280)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, Color? dotColor) {
    final bool isActive = _activeFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF4F1FD) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? const Color(0xFF7F61EA) : _cardBorder,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dotColor != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: GoogleFonts.figtree(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                color: isActive ? const Color(0xFF7F61EA) : _textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard({
    required String status,
    required Color statusColor,
    required String bayNumber,
    required String vehicleNo,
    required String route,
    required String capacity,
    required String driver,
    required double progress,
    required String progressText,
    required bool isReady,
    bool isIdle = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isReady
                      ? const Color(0xFFDCFCE7)
                      : (isIdle
                            ? const Color(0xFFF3F4F6)
                            : const Color(0xFFF4F1FD)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
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
                      style: GoogleFonts.figtree(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                bayNumber,
                style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F1FD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(LucideIcons.bus, size: 40, color: _primary),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            vehicleNo,
            style: GoogleFonts.figtree(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            route,
            style: GoogleFonts.figtree(fontSize: 13, color: _textMuted),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CAPACITY',
                      style: GoogleFonts.figtree(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _textMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      capacity,
                      style: GoogleFonts.figtree(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DRIVER',
                      style: GoogleFonts.figtree(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _textMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      driver,
                      style: GoogleFonts.figtree(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isIdle ? const Color(0xFFEF4444) : _textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Loading progress',
                style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
              ),
              Text(
                progressText,
                style: GoogleFonts.figtree(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bayNumber,
                style: GoogleFonts.figtree(fontSize: 13, color: _textMuted),
              ),
              GestureDetector(
                onTap: () {
                  _showVehicleDetailsDialog(
                    context,
                    vehicleNo: vehicleNo,
                    route: route,
                    capacity: capacity,
                    driver: driver,
                    bayNumber: bayNumber,
                    status: status,
                    loaded: progressText,
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'View details',
                      style: GoogleFonts.figtree(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      LucideIcons.arrowRight,
                      size: 16,
                      color: _primary,
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

  void _showAddRouteDialog(BuildContext context) {
    final plateController = TextEditingController();
    final capacityController = TextEditingController();
    final routeController = TextEditingController();
    final driverController = TextEditingController();
    final bayController = TextEditingController();

    String selectedType = 'Buses';
    String selectedStatus = 'Idle';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.all(16),
              child: Container(
                width: 500,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Route',
                          style: GoogleFonts.figtree(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close, color: _textMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFormField(
                            'Plate',
                            'KA00XX0000',
                            plateController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildFormField(
                            'Capacity',
                            '45',
                            capacityController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      'Route',
                      'Route 02 • Area',
                      routeController,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFormField(
                            'Driver',
                            'Unassigned',
                            driverController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildFormField(
                            'Bay',
                            'Bay A-01',
                            bayController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            'Type',
                            selectedType,
                            ['Buses', 'Vans'],
                            (val) => setModalState(() => selectedType = val!),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdownField(
                            'Status',
                            selectedStatus,
                            ['Idle', 'Ready', 'Loading'],
                            (val) => setModalState(() => selectedStatus = val!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.figtree(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _textDark,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _vehicles.insert(0, {
                                'status': selectedStatus,
                                'statusColor': selectedStatus == 'Ready'
                                    ? const Color(0xFF10B981)
                                    : (selectedStatus == 'Loading'
                                          ? const Color(0xFF7F61EA)
                                          : const Color(0xFF6B7280)),
                                'bayNumber': bayController.text.isNotEmpty
                                    ? bayController.text
                                    : 'Bay A-01',
                                'vehicleNo': plateController.text.isNotEmpty
                                    ? plateController.text
                                    : 'KA00XX0000',
                                'route': routeController.text.isNotEmpty
                                    ? routeController.text
                                    : 'Route 02 • Area',
                                'capacity': capacityController.text.isNotEmpty
                                    ? '${capacityController.text} seats'
                                    : '45 seats',
                                'driver': driverController.text.isNotEmpty
                                    ? driverController.text
                                    : 'Unassigned',
                                'progress': 0.0,
                                'progressText': '0%',
                                'isReady': selectedStatus == 'Ready',
                                'isIdle': selectedStatus == 'Idle',
                              });
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7F61EA),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Create',
                              style: GoogleFonts.figtree(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFormField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.figtree(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: GoogleFonts.figtree(
                color: _textMuted.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
            style: GoogleFonts.figtree(fontSize: 14, color: _textDark),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.figtree(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: _textDark),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.figtree(fontSize: 14, color: _textDark),
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

  void _showVehicleDetailsDialog(
    BuildContext context, {
    required String vehicleNo,
    required String route,
    required String capacity,
    required String driver,
    required String bayNumber,
    required String status,
    required String loaded,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        String activeTab = 'Bus Details';
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(24),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                  maxWidth: 600,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top Header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F1FD),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                LucideIcons.bus,
                                color: Color(0xFF7F61EA),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    vehicleNo,
                                    style: GoogleFonts.figtree(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    route,
                                    style: GoogleFonts.figtree(
                                      fontSize: 14,
                                      color: _textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.close,
                                color: _textMuted,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Tabs
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const SizedBox(width: 24),
                              GestureDetector(
                                onTap: () => setModalState(
                                  () => activeTab = 'Bus Details',
                                ),
                                child: _buildTab(
                                  'Bus Details',
                                  LucideIcons.bus,
                                  activeTab == 'Bus Details',
                                ),
                              ),
                              const SizedBox(width: 24),
                              GestureDetector(
                                onTap: () => setModalState(
                                  () => activeTab = 'Route Map',
                                ),
                                child: _buildTab(
                                  'Route Map',
                                  LucideIcons.map,
                                  activeTab == 'Route Map',
                                ),
                              ),
                              const SizedBox(width: 24),
                              GestureDetector(
                                onTap: () =>
                                    setModalState(() => activeTab = 'Students'),
                                child: _buildTab(
                                  'Students',
                                  LucideIcons.users,
                                  activeTab == 'Students',
                                ),
                              ),
                              const SizedBox(width: 24),
                              GestureDetector(
                                onTap: () =>
                                    setModalState(() => activeTab = 'Staff'),
                                child: _buildTab(
                                  'Staff',
                                  LucideIcons.user,
                                  activeTab == 'Staff',
                                ),
                              ),
                              const SizedBox(width: 24),
                            ],
                          ),
                        ),
                      ),
                      // Body
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: activeTab == 'Students'
                            ? _buildStudentsTab(vehicleNo)
                            : activeTab == 'Staff'
                            ? _buildStaffTab(vehicleNo)
                            : activeTab == 'Route Map'
                            ? _buildRouteMapTab(vehicleNo, route)
                            : _buildBusDetailsTab(
                                vehicleNo,
                                capacity,
                                driver,
                                bayNumber,
                                status,
                                loaded,
                              ),
                      ),
                      // Footer
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(24),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _vehicles.removeWhere(
                                    (v) => v['vehicleNo'] == vehicleNo,
                                  );
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(
                                      0xFFEF4444,
                                    ).withValues(alpha: 0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Remove',
                                  style: GoogleFonts.figtree(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFEF4444),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFE5E7EB),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Close',
                                      style: GoogleFonts.figtree(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _textDark,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7F61EA),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '+10% Loaded',
                                    style: GoogleFonts.figtree(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
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
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBusDetailsTab(
    String vehicleNo,
    String capacity,
    String driver,
    String bayNumber,
    String status,
    String loaded,
  ) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(LucideIcons.bus, size: 64, color: Color(0xFF7F61EA)),
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: constraints.maxWidth > 600 ? 2.5 : 2.0,
              children: [
                _buildStatBox('PLATE', vehicleNo),
                _buildStatBox('TYPE', 'Buses'),
                _buildStatBox('CAPACITY', capacity),
                _buildStatBox('DRIVER', driver),
                _buildStatBox('BAY', bayNumber),
                _buildStatBox('STATUS', status),
                _buildStatBox('LOADED', loaded),
                _buildStatBox('PICKUP POINTS', '5'),
                _buildStatBox('FITNESS', 'Valid • Apr 2026'),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildRouteMapTab(String vehicleNo, String route) {
    final int seed = vehicleNo.hashCode.abs();

    final List<List<Map<String, dynamic>>> mockRoutes = [
      [
        {'title': 'Depot — Bay A-03', 'time': '7:05 AM', 'action': 'Start'},
        {
          'title': 'Indiranagar 12th Main',
          'time': '7:18 AM',
          'action': 'Picked 12',
        },
        {'title': 'CMH Road', 'time': '7:26 AM', 'action': 'Picked 8'},
        {'title': 'Jeevan Bima Nagar', 'time': '7:35 AM', 'action': 'Picked 6'},
        {'title': 'Domlur Signal', 'time': '7:48 AM', 'action': 'Picked 9'},
        {'title': 'School Campus', 'time': '8:05 AM', 'action': 'Drop'},
      ],
      [
        {'title': 'Depot — Bay B-01', 'time': '6:45 AM', 'action': 'Start'},
        {'title': 'Whitefield Forum', 'time': '7:10 AM', 'action': 'Picked 15'},
        {'title': 'ITPL Gate 2', 'time': '7:25 AM', 'action': 'Picked 10'},
        {'title': 'Kundalahalli Gate', 'time': '7:40 AM', 'action': 'Picked 8'},
        {'title': 'School Campus', 'time': '8:15 AM', 'action': 'Drop'},
      ],
      [
        {'title': 'Depot — Bay C-05', 'time': '6:50 AM', 'action': 'Start'},
        {
          'title': 'Jayanagar 4th Block',
          'time': '7:15 AM',
          'action': 'Picked 11',
        },
        {
          'title': 'JP Nagar 1st Phase',
          'time': '7:30 AM',
          'action': 'Picked 9',
        },
        {'title': 'Banashankari', 'time': '7:45 AM', 'action': 'Picked 14'},
        {'title': 'School Campus', 'time': '8:10 AM', 'action': 'Drop'},
      ],
    ];

    final stops = mockRoutes[seed % mockRoutes.length];

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFFF8FAFC)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  LucideIcons.mapPin,
                  size: 36,
                  color: Color(0xFF7F61EA),
                ),
                const SizedBox(height: 8),
                Text(
                  route,
                  style: GoogleFonts.figtree(
                    fontSize: 14,
                    color: const Color(0xFF7F61EA),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(stops.length, (index) {
          final isFirst = index == 0;
          final isLast = index == stops.length - 1;
          final stop = stops[index];
          return _buildTimelineStop(
            stop['title']!,
            stop['time']!,
            stop['action']!,
            isFirst,
            isLast,
          );
        }),
      ],
    );
  }

  Widget _buildStudentsTab(String vehicleNo) {
    final int seed = vehicleNo.hashCode.abs();

    final List<List<Map<String, String>>> mockStudentsLists = [
      [
        {
          'name': 'Aarav Sharma',
          'class': 'Grade 6-A',
          'stop': 'Indiranagar 12th Main',
        },
        {'name': 'Diya Patel', 'class': 'Grade 4-B', 'stop': 'CMH Road'},
        {
          'name': 'Ishaan Verma',
          'class': 'Grade 8-C',
          'stop': 'Jeevan Bima Nagar',
        },
        {'name': 'Sara Khan', 'class': 'Grade 5-A', 'stop': '100 Feet Road'},
        {'name': 'Kabir Reddy', 'class': 'Grade 9-B', 'stop': 'Domlur'},
        {'name': 'Meera Iyer', 'class': 'Grade 3-A', 'stop': 'Old Madras Road'},
      ],
      [
        {
          'name': 'Priya Singh',
          'class': 'Grade 7-A',
          'stop': 'Whitefield Forum',
        },
        {'name': 'Rahul Gupta', 'class': 'Grade 5-C', 'stop': 'ITPL Gate 2'},
        {
          'name': 'Riya Patel',
          'class': 'Grade 6-B',
          'stop': 'Kundalahalli Gate',
        },
        {
          'name': 'Arjun Kumar',
          'class': 'Grade 4-A',
          'stop': 'Whitefield Forum',
        },
        {'name': 'Sneha Reddy', 'class': 'Grade 8-A', 'stop': 'ITPL Gate 2'},
      ],
      [
        {
          'name': 'Ananya Reddy',
          'class': 'Grade 9-A',
          'stop': 'Jayanagar 4th Block',
        },
        {
          'name': 'Rohan Iyer',
          'class': 'Grade 6-C',
          'stop': 'JP Nagar 1st Phase',
        },
        {'name': 'Neha Sharma', 'class': 'Grade 7-B', 'stop': 'Banashankari'},
        {
          'name': 'Aditya Rao',
          'class': 'Grade 5-B',
          'stop': 'Jayanagar 4th Block',
        },
      ],
    ];

    final students = mockStudentsLists[seed % mockStudentsLists.length];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'STUDENT',
                style: GoogleFonts.figtree(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _textMuted,
                ),
              ),
            ),
            Expanded(
              flex: 1,
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
                'PICKUP STOP',
                style: GoogleFonts.figtree(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _textMuted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(color: Color(0xFFE5E7EB), height: 1),
        ...students.map(
          (s) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        s['name']!,
                        style: GoogleFonts.figtree(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _textDark,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        s['class']!,
                        style: GoogleFonts.figtree(
                          fontSize: 14,
                          color: _textMuted,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        s['stop']!,
                        style: GoogleFonts.figtree(
                          fontSize: 14,
                          color: _textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFFE5E7EB), height: 1),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStaffTab(String vehicleNo) {
    final int seed = vehicleNo.hashCode.abs();

    final List<List<Map<String, String>>> mockStaffLists = [
      [
        {
          'name': 'Vinod Reddy',
          'role': 'Driver · Morning · 6:30 AM',
          'phone': '+91 98xxx 12345',
          'initial': 'V',
        },
        {
          'name': 'Lakshmi Devi',
          'role': 'Attendant · Morning · 6:45 AM',
          'phone': '+91 98xxx 22113',
          'initial': 'L',
        },
        {
          'name': 'Manjunath S.',
          'role': 'Co-Driver · Afternoon · 2:30 PM',
          'phone': '+91 98xxx 55421',
          'initial': 'M',
        },
      ],
      [
        {
          'name': 'Ramesh B.',
          'role': 'Driver · Morning · 6:15 AM',
          'phone': '+91 98xxx 33445',
          'initial': 'R',
        },
        {
          'name': 'Sunita K.',
          'role': 'Attendant · Morning · 6:30 AM',
          'phone': '+91 98xxx 77889',
          'initial': 'S',
        },
      ],
      [
        {
          'name': 'Suresh N.',
          'role': 'Driver · Morning · 6:20 AM',
          'phone': '+91 98xxx 11223',
          'initial': 'S',
        },
        {
          'name': 'Kavitha R.',
          'role': 'Attendant · Morning · 6:30 AM',
          'phone': '+91 98xxx 99887',
          'initial': 'K',
        },
        {
          'name': 'Ashok M.',
          'role': 'Co-Driver · Afternoon · 2:15 PM',
          'phone': '+91 98xxx 55667',
          'initial': 'A',
        },
      ],
    ];

    final staff = mockStaffLists[seed % mockStaffLists.length];

    return Column(
      children: staff
          .map(
            (s) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF4F1FD),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            s['initial']!,
                            style: GoogleFonts.figtree(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF7F61EA),
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
                              s['name']!,
                              style: GoogleFonts.figtree(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              s['role']!,
                              style: GoogleFonts.figtree(
                                fontSize: 13,
                                color: _textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        s['phone']!,
                        style: GoogleFonts.figtree(
                          fontSize: 13,
                          color: _textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFFE5E7EB), height: 1),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildTimelineStop(
    String title,
    String time,
    String action,
    bool isFirst,
    bool isLast,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 16,
                  color: isFirst ? Colors.transparent : const Color(0xFFE5E7EB),
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isFirst || isLast
                        ? const Color(0xFF7F61EA)
                        : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF7F61EA),
                      width: isFirst || isLast ? 0 : 2,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : const Color(0xFFE5E7EB),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.figtree(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          time,
                          style: GoogleFonts.figtree(
                            fontSize: 12,
                            color: _textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    action,
                    style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isActive ? const Color(0xFF7F61EA) : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isActive ? const Color(0xFF7F61EA) : _textMuted,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.figtree(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? const Color(0xFF7F61EA) : _textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.figtree(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: _textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.figtree(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
        ],
      ),
    );
  }
}
