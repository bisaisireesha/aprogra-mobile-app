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

class ReceiptsListScreen extends StatefulWidget {
  const ReceiptsListScreen({super.key});

  @override
  State<ReceiptsListScreen> createState() => _ReceiptsListScreenState();
}

class _ReceiptsListScreenState extends State<ReceiptsListScreen> {


  
  @override
  void initState() {
    super.initState();
    _loadReceipts();
  }

  List<Map<String, dynamic>> _receipts = [
    {
      'id': 'RCT-2025-3401', 'date': '15 May 2025', 'student': 'Aryan Reddy', 'class': 'Class 6A', 'invoice': 'INV-2025-0841',
      'mode': 'UPI', 'amount': '₹24,500', 'status': 'Paid',
      'modeColor': const Color(0xFF22C55E), 'modeBg': const Color(0xFFF0FDF4),
    },
    {
      'id': 'RCT-2025-3402', 'date': '15 May 2025', 'student': 'Ishita Kapoor', 'class': 'Class 7C', 'invoice': 'INV-2025-0839',
      'mode': 'Card', 'amount': '₹22,000', 'status': 'Paid',
      'modeColor': const Color(0xFF0EA5E9), 'modeBg': const Color(0xFFF0F9FF),
    },
    {
      'id': 'RCT-2025-3403', 'date': '14 May 2025', 'student': 'Meera Nair', 'class': 'Class 4A', 'invoice': 'INV-2025-0836',
      'mode': 'Cash', 'amount': '₹18,500', 'status': 'Paid',
      'modeColor': const Color(0xFFF59E0B), 'modeBg': const Color(0xFFFFFBEB),
    },
    {
      'id': 'RCT-2025-3404', 'date': '14 May 2025', 'student': 'Kabir Sharma', 'class': 'Class 8B', 'invoice': 'INV-2025-0832',
      'mode': 'Bank Transfer', 'amount': '₹14,100', 'status': 'Paid',
      'modeColor': const Color(0xFF8B5CF6), 'modeBg': const Color(0xFFF3E8FF),
    },
    {
      'id': 'RCT-2025-3405', 'date': '13 May 2025', 'student': 'Saanvi Iyer', 'class': 'Class 9B', 'invoice': 'INV-2025-0828',
      'mode': 'UPI', 'amount': '₹6,800', 'status': 'Paid',
      'modeColor': const Color(0xFF22C55E), 'modeBg': const Color(0xFFF0FDF4),
    },
    {
      'id': 'RCT-2025-3406', 'date': '13 May 2025', 'student': 'Vihaan Joshi', 'class': 'Class 10B', 'invoice': 'INV-2025-0825',
      'mode': 'UPI', 'amount': '₹4,500', 'status': 'Paid',
      'modeColor': const Color(0xFF22C55E), 'modeBg': const Color(0xFFF0FDF4),
    },
  ];

  
  Future<void> _loadReceipts() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__receipts_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _receipts = decoded.map((item) {
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

  Future<void> _saveReceipts() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _receipts.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__receipts_data', jsonEncode(serialized));
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
                          TextSpan(text: 'Receipts ', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
                          TextSpan(text: '(17)', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.w600, color: _muted)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF5F3FF), borderRadius: BorderRadius.circular(10), border: Border.all(color: _primary.withValues(alpha: 0.2))),
                    child: const Icon(LucideIcons.filter, size: 18, color: _primary),
                  ),
                ],
              ),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
                child: TextField(
                  style: GoogleFonts.figtree(fontSize: 14, color: _dark),
                  decoration: InputDecoration(
                    hintText: 'Search receipt # or student...',
                    hintStyle: GoogleFonts.figtree(fontSize: 14, color: _muted.withValues(alpha: 0.6)),
                    prefixIcon: const Icon(LucideIcons.search, size: 18, color: _muted),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Date Filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(child: _datePicker('dd/mm/yyyy')),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('-', style: GoogleFonts.figtree(color: _muted)),
                  ),
                  Expanded(child: _datePicker('dd/mm/yyyy')),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.filter, size: 14, color: _dark),
                        const SizedBox(width: 6),
                        Text('More Filters', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _dark)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: _receipts.length,
                itemBuilder: (context, index) {
                  return _buildReceiptCard(_receipts[index]);
                },
              ),
            ),

            // Footer
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
              color: _bg,
              alignment: Alignment.center,
              child: Text('Showing 6 of 17 receipts', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datePicker(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(LucideIcons.calendar, size: 14, color: _muted),
          const SizedBox(width: 8),
          Expanded(child: Text(hint, style: GoogleFonts.figtree(fontSize: 12, color: _dark))),
          const Icon(LucideIcons.calendar, size: 14, color: _dark),
        ],
      ),
    );
  }

  Widget _buildReceiptCard(Map<String, dynamic> r) {
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFF5F3FF), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(LucideIcons.receipt, size: 20, color: _primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r['id'] as String, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
                      Text(r['date'] as String, style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                      const SizedBox(height: 6),
                      Text(r['student'] as String, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
                      Text(r['class'] as String, style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                      const SizedBox(height: 2),
                      Text(r['invoice'] as String, style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
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
                          decoration: BoxDecoration(color: r['modeBg'] as Color, borderRadius: BorderRadius.circular(12)),
                          child: Text(r['mode'] as String, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.w600, color: r['modeColor'] as Color)),
                        ),
                        const SizedBox(width: 16),
                        Text(r['amount'] as String, style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF22C55E))),
                        const SizedBox(width: 8),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(12)),
                      child: Text(r['status'] as String, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF22C55E))),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _border),
          Row(
            children: [
              _actionBtn(LucideIcons.eye, 'View', const Color(0xFF595973)),
              Container(width: 1, height: 20, color: _border),
              _actionBtn(LucideIcons.mail, 'Email', const Color(0xFF595973)),
              Container(width: 1, height: 20, color: _border),
              _actionBtn(LucideIcons.printer, 'Print', const Color(0xFF595973)),
              Container(width: 1, height: 20, color: _border),
              _actionBtn(LucideIcons.download, 'Download', _primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(IconData icon, String label, Color color) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label clicked')));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 6),
                Text(label, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
