import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

const _bg = Color(0xFFF9F9FB);
const _dark = Color(0xFF181821);
const _muted = Color(0xFF595973);
const _primary = Color(0xFF6366F1);
const _border = Color(0xFFE5E7EB);

class SchemesListScreen extends StatefulWidget {
  const SchemesListScreen({super.key});

  @override
  State<SchemesListScreen> createState() => _SchemesListScreenState();
}

class _SchemesListScreenState extends State<SchemesListScreen> {


  
  @override
  void initState() {
    super.initState();
    _loadSchemes();
  }

  String _activeTab = 'All';

  List<Map<String, dynamic>> _schemes = [
    {
      'name': 'Merit Scholarship',
      'type': 'Scholarship',
      'status': 'Active',
      'eligibility': '≥ 90% marks',
      'award': '50% of Tuition',
      'beneficiaries': '48',
      'icon': LucideIcons.graduationCap,
    },
    {
      'name': 'Sibling Discount',
      'type': 'Discount',
      'status': 'Active',
      'eligibility': '2+ children enrolled',
      'award': '10% flat',
      'beneficiaries': '132',
      'icon': LucideIcons.tag,
    },
    {
      'name': 'Sports Excellence',
      'type': 'Scholarship',
      'status': 'Active',
      'eligibility': 'State-level player',
      'award': '₹15,000 fixed',
      'beneficiaries': '22',
      'icon': LucideIcons.trophy,
    },
    {
      'name': 'Staff Ward',
      'type': 'Discount',
      'status': 'Active',
      'eligibility': 'Children of staff',
      'award': '75% of Tuition',
      'beneficiaries': '18',
      'icon': LucideIcons.users,
    },
    {
      'name': 'Need-based Aid',
      'type': 'Scholarship',
      'status': 'Active',
      'eligibility': 'Annual income < 3L',
      'award': 'Up to 100%',
      'beneficiaries': '64',
      'icon': LucideIcons.heartHandshake,
    },
    {
      'name': 'Early Bird',
      'type': 'Discount',
      'status': 'Expired',
      'eligibility': 'Pay before May 1',
      'award': '5% flat',
      'beneficiaries': '28',
      'icon': LucideIcons.clock,
    },
  ];

  
  Future<void> _loadSchemes() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__schemes_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _schemes = decoded.map((item) {
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

  Future<void> _saveSchemes() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _schemes.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__schemes_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(LucideIcons.arrowLeft, size: 24, color: _dark),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'Schemes ', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
                          TextSpan(text: '(${_schemes.length})', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.w600, color: _muted)),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add Scheme clicked')));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: _primary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: _primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.plus, size: 14, color: Colors.white),
                          const SizedBox(width: 6),
                          Text('Add Scheme', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Segmented Control
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
                child: Row(
                  children: [
                    _buildTab('All'),
                    Container(width: 1, height: 24, color: _border),
                    _buildTab('Scholarship'),
                    Container(width: 1, height: 24, color: _border),
                    _buildTab('Discount'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
                      child: TextField(
                        style: GoogleFonts.figtree(fontSize: 14, color: _dark),
                        decoration: InputDecoration(
                          hintText: 'Search schemes...',
                          hintStyle: GoogleFonts.figtree(fontSize: 14, color: _muted.withValues(alpha: 0.6)),
                          prefixIcon: const Icon(LucideIcons.search, size: 18, color: _muted),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
                    child: const Icon(LucideIcons.filter, size: 18, color: _dark),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: _schemes.length,
                itemBuilder: (context, index) {
                  return _buildSchemeCard(_schemes[index]);
                },
              ),
            ),

            // Footer
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
              color: _bg,
              alignment: Alignment.center,
              child: Text('Showing ${_schemes.length} of ${_schemes.length} schemes', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label) {
    final isActive = _activeTab == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFF5F3FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.figtree(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? _primary : _muted,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSchemeCard(Map<String, dynamic> s) {
    final isScholarship = s['type'] == 'Scholarship';
    final isActive = s['status'] == 'Active';

    final typeColor = isScholarship ? const Color(0xFF7C3AED) : const Color(0xFF0EA5E9);
    final typeBg = isScholarship ? const Color(0xFFF3E8FF) : const Color(0xFFE0F2FE);

    final statusColor = isActive ? const Color(0xFF22C55E) : const Color(0xFF64748B);
    final statusBg = isActive ? const Color(0xFFF0FDF4) : const Color(0xFFF1F5F9);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10)),
                      child: Icon(s['icon'] as IconData, size: 20, color: typeColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s['name'] as String, style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: typeBg, borderRadius: BorderRadius.circular(12)),
                            child: Text(s['type'] as String, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.w600, color: typeColor)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                      child: Text(s['status'] as String, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
                    ),
                    const SizedBox(width: 12),
                    const Icon(LucideIcons.chevronRight, size: 18, color: _muted),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Eligibility', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                          const SizedBox(height: 4),
                          Text(s['eligibility'] as String, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Award Value', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                          const SizedBox(height: 4),
                          Text(s['award'] as String, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF6366F1))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Beneficiaries', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                          const SizedBox(height: 4),
                          Text(s['beneficiaries'] as String, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _border),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Edit ${s['name']}')));
                  },
                  child: const Icon(LucideIcons.pencil, size: 16, color: _muted),
                ),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete ${s['name']}')));
                  },
                  child: const Icon(LucideIcons.trash2, size: 16, color: Color(0xFFEF4444)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
