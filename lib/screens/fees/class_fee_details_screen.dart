import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ClassFeeDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> classData;

  const ClassFeeDetailsScreen({super.key, required this.classData});

  final _bg = const Color(0xFFF9F9FB);
  final _dark = const Color(0xFF181821);
  final _muted = const Color(0xFF64748B);
  final _primary = const Color(0xFF6366F1);
  final _border = const Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCard(),
                    const SizedBox(height: 24),
                    Text('Fee Head Breakdown', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
                    const SizedBox(height: 12),
                    _buildBreakdownTable(),
                    const SizedBox(height: 24),
                    _buildInfoBanner(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 20, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(LucideIcons.arrowLeft, size: 22),
            color: _dark,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(classData['name'], style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
              Text(classData['subtitle'], style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFF3E8FF), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(LucideIcons.layers, size: 20, color: Color(0xFF8B5CF6)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(classData['name'], style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Annual Total', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                    Text(classData['annual'], style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _primary)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _termSummary('TERM 1', classData['t1']),
                _termSummary('TERM 2', classData['t2']),
                _termSummary('TERM 3', classData['t3']),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _termSummary(String label, String amount) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w600, color: _muted)),
        const SizedBox(height: 4),
        Text(amount, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
      ],
    );
  }

  Widget _buildBreakdownTable() {
    final rows = classData['breakdown'] as List<Map<String, dynamic>>;
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(color: Color(0xFFF8FAFC), borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('FEE HEAD', style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: _muted))),
                Expanded(flex: 1, child: Text('TERM 1', style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: _muted))),
                Expanded(flex: 1, child: Text('TERM 2', style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: _muted))),
                Expanded(flex: 1, child: Text('TERM 3', style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: _muted))),
                Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text('ANNUAL', style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: _muted)))),
              ],
            ),
          ),
          
          // Rows
          ...rows.map((row) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: (row['color'] as Color).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                          child: Icon(row['icon'] as IconData, size: 14, color: row['color'] as Color),
                        ),
                        const SizedBox(height: 6),
                        Text(row['title'], style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: _dark)),
                      ],
                    ),
                  ),
                  Expanded(flex: 1, child: Text(row['t1'], style: GoogleFonts.figtree(fontSize: 11, color: _dark))),
                  Expanded(flex: 1, child: Text(row['t2'], style: GoogleFonts.figtree(fontSize: 11, color: _dark))),
                  Expanded(flex: 1, child: Text(row['t3'], style: GoogleFonts.figtree(fontSize: 11, color: _dark))),
                  Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text(row['ann'], style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: _dark)))),
                ],
              ),
            );
          }),
          
          // Footer
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('Total', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _dark))),
                Expanded(flex: 1, child: Text(classData['t1'], style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w600, color: _primary))),
                Expanded(flex: 1, child: Text(classData['t2'], style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w600, color: _primary))),
                Expanded(flex: 1, child: Text(classData['t3'], style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w600, color: _primary))),
                Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text(classData['annual'], style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: _primary)))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF5F3FF), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFEDE9FE))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.info, size: 16, color: Color(0xFF6366F1)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Annual total is the sum of all terms.\nLate fee and discounts are applied at invoice level.',
              style: GoogleFonts.figtree(fontSize: 11, height: 1.5, color: const Color(0xFF6366F1)),
            ),
          )
        ],
      ),
    );
  }
}
