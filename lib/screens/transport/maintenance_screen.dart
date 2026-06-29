import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../auth/menu_screen.dart';
import 'maintenance_job_details_modal.dart';
import 'add_log_job_screen.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _jobs = [
    {
      'id': 'M-2401',
      'bus': 'BUS-622',
      'type': 'Repair',
      'title': 'Gearbox overhaul',
      'date': '14 Jun 2026',
      'mechanic': 'Verma Motors',
      'cost': '38,500',
      'status': 'In Service',
    },
    {
      'id': 'M-2402',
      'bus': 'BUS-204',
      'type': 'Preventive',
      'title': 'Engine oil & filter',
      'date': '16 Jun 2026',
      'mechanic': 'In-house',
      'cost': '4,200',
      'status': 'Scheduled',
    },
    {
      'id': 'M-2403',
      'bus': 'BUS-118',
      'type': 'Inspection',
      'title': 'Quarterly safety check',
      'date': '18 Jun 2026',
      'mechanic': 'RTO Authority',
      'cost': '2,500',
      'status': 'Scheduled',
    },
    {
      'id': 'M-2404',
      'bus': 'BUS-392',
      'type': 'Repair',
      'title': 'AC compressor replacement',
      'date': '08 Jun 2026',
      'mechanic': 'Cool Cars',
      'cost': '22,000',
      'status': 'Completed',
    },
    {
      'id': 'M-2405',
      'bus': 'BUS-405',
      'type': 'Preventive',
      'title': 'Brake pad replacement',
      'date': '02 Jun 2026',
      'mechanic': 'In-house',
      'cost': '6,800',
      'status': 'Completed',
    },
    {
      'id': 'M-2406',
      'bus': 'BUS-551',
      'type': 'Repair',
      'title': 'Tyre alignment & balancing',
      'date': '29 May 2026',
      'mechanic': 'Tyre Hub',
      'cost': '3,400',
      'status': 'Completed',
    },
  ];

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: const MenuScreen(activeScreen: 'Maintenance'),
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
                  _buildJobsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transport Maintenance',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF181821),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Scheduled service, repair jobs and workshop expenses.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF595973),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.currency_rupee, size: 14, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 4),
                      Text(
                        'Spend this month ',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF595973),
                        ),
                      ),
                      Text(
                        '₹32,200',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF181821),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddLogJobScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                          'Log Job',
                          style: GoogleFonts.inter(
                            fontSize: 14,
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
                'Total Jobs',
                '6',
                LucideIcons.wrench,
                const Color(0xFF6366F1),
                const Color(0xFFF8F5FF),
                borderColor: const Color(0xFF6366F1).withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Scheduled',
                '2',
                LucideIcons.calendar,
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
                'In Service',
                '1',
                LucideIcons.clock,
                const Color(0xFFF59E0B),
                const Color(0xFFFEF3C7),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Completed',
                '3',
                LucideIcons.checkCircle2,
                const Color(0xFF10B981),
                const Color(0xFFD1FAE5),
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
    IconData icon,
    Color iconColor,
    Color iconBgColor, {
    Color? borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor ?? Colors.grey.withValues(alpha: 0.1)),
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
        ],
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
                      hintText: 'Search job ID, vehicle, mechanic...',
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
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: const Icon(LucideIcons.filter, color: Color(0xFF595973), size: 20),
        ),
      ],
    );
  }

  Widget _buildJobsList() {
    final filteredJobs = _jobs.where((job) {
      final searchLower = _searchQuery.toLowerCase();
      return job['id'].toString().toLowerCase().contains(searchLower) ||
             job['bus'].toString().toLowerCase().contains(searchLower) ||
             job['mechanic'].toString().toLowerCase().contains(searchLower);
    }).toList();

    if (filteredJobs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(LucideIcons.settings, size: 48, color: const Color(0xFF94A3B8).withValues(alpha: 0.5)),
              const SizedBox(height: 16),
              Text(
                'No maintenance jobs found',
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

    return Column(
      children: List.generate(filteredJobs.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildJobCard(filteredJobs[index]),
        );
      }),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    IconData getIconForType(String type) {
      if (type == 'Repair') return LucideIcons.wrench;
      if (type == 'Preventive') return LucideIcons.shield;
      if (type == 'Inspection') return LucideIcons.clipboardCheck;
      return LucideIcons.settings;
    }

    Color getColorForType(String type) {
      if (type == 'Repair') return const Color(0xFFEF4444);
      if (type == 'Preventive') return const Color(0xFF6366F1);
      if (type == 'Inspection') return const Color(0xFF64748B);
      return const Color(0xFF94A3B8);
    }

    Color getStatusColor(String status) {
      if (status == 'Completed') return const Color(0xFF10B981);
      if (status == 'Scheduled') return const Color(0xFF0EA5E9);
      if (status == 'In Service') return const Color(0xFFF59E0B);
      return const Color(0xFF94A3B8);
    }

    final typeColor = getColorForType(job['type']);
    final statusColor = getStatusColor(job['status']);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
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
                color: typeColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(getIconForType(job['type']), color: typeColor, size: 24),
                        ),
                        const SizedBox(width: 16),
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    job['id'],
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
                                          color: statusColor.withValues(alpha: 0.1),
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
                                              job['status'],
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: statusColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      PopupMenuButton<String>(
                                        icon: const Icon(LucideIcons.moreVertical, size: 20, color: Color(0xFF94A3B8)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        onSelected: (value) {
                                          if (value == 'view') {
                                            _showJobDetailsModal(job);
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$value ${job['id']}')));
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: 'view',
                                            child: Text('View Details'),
                                          ),
                                          const PopupMenuItem(
                                            value: 'edit',
                                            child: Text('Edit'),
                                          ),
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Text('Delete', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    job['bus'],
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF595973),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '·',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: typeColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      job['type'],
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: typeColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    job['title'],
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: const Color(0xFF181821),
                                    ),
                                  ),
                                  Text(
                                    '₹${job['cost']}',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF181821),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF94A3B8)),
                                  const SizedBox(width: 6),
                                  Text(
                                    job['date'],
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF595973),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(LucideIcons.user, size: 14, color: Color(0xFF94A3B8)),
                                  const SizedBox(width: 6),
                                  Text(
                                    job['mechanic'],
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showJobDetailsModal(Map<String, dynamic> job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MaintenanceJobDetailsModal(job: job),
    );
  }
}
