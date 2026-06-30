import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class InvoiceDetailsModal extends StatelessWidget {
  final Map<String, dynamic> invoice;
  const InvoiceDetailsModal({super.key, required this.invoice});

  final _dark = const Color(0xFF181821);
  final _muted = const Color(0xFF64748B);
  final _border = const Color(0xFFE2E8F0);
  final _primary = const Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusBg;
    switch (invoice['status']) {
      case 'Paid':    statusColor = const Color(0xFF16A34A); statusBg = const Color(0xFFDCFCE7); break;
      case 'Overdue': statusColor = const Color(0xFFDC2626); statusBg = const Color(0xFFFEE2E2); break;
      case 'Draft':   statusColor = const Color(0xFF0EA5E9); statusBg = const Color(0xFFE0F2FE); break;
      default:        statusColor = const Color(0xFFD97706); statusBg = const Color(0xFFFEF3C7);
    }

    final amtStr = (invoice['amount'] as int).toStringAsFixed(2)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9FB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40, height: 4,
              decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 24, 16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.arrowLeft, size: 22),
                  color: _dark,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Invoice Details', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _dark)),
                      Text(invoice['id'], style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
                  child: Text(invoice['status'], style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _buildStudentInfoCard(),
                  const SizedBox(height: 16),
                  _buildInvoiceDetailsCard(),
                  const SizedBox(height: 16),
                  _buildInvoiceItemsCard(amtStr),
                  const SizedBox(height: 24), // padding for bottom bar
                ],
              ),
            ),
          ),
          
          // Sticky Bottom Bar
          Container(
            padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: _border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: _border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Close', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _dark)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.download, size: 16, color: Colors.white),
                        const SizedBox(width: 6),
                        Text('Download PDF', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 1. Student Information
  Widget _buildStudentInfoCard() {
    final nameParts = (invoice['student'] as String).split(' ');
    final initials  = nameParts.length >= 2
        ? '${nameParts[0][0]}${nameParts[1][0]}'
        : (invoice['student'] as String).substring(0, 2).toUpperCase();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Student Information', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFEEEDFD),
                child: Text(initials, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _primary)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(invoice['student'], style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
                    const SizedBox(height: 4),
                    Text('${invoice['class']}  ·  ADM-2025-0112', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                    const SizedBox(height: 2),
                    Text('Parent Name  ·  +91 98210 44312', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // ── 2. Invoice Details
  Widget _buildInvoiceDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Invoice Details', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildReadonlyField('Invoice Date', invoice['issued'] ?? 'N/A')),
              const SizedBox(width: 12),
              Expanded(child: _buildReadonlyField('Due Date', invoice['due'] ?? 'N/A')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildReadonlyField('Invoice Type', invoice['type'] ?? 'Tuition Fee')),
              const SizedBox(width: 12),
              Expanded(child: _buildReadonlyField('Reference', '-')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReadonlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.figtree(fontSize: 11, color: const Color(0xFF64748B))),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
      ],
    );
  }

  // ── 3. Invoice Items
  Widget _buildInvoiceItemsCard(String totalAmtStr) {
    final type = invoice['type'] ?? 'Tuition Fee';
    IconData icon = LucideIcons.fileText;
    Color c = _primary;
    Color bg = const Color(0xFFEEEDFD);
    if (type == 'Transport Fee' || type == 'Transport') { icon = LucideIcons.bus; c = const Color(0xFFF59E0B); bg = const Color(0xFFFEF3E1); }
    if (type == 'Exam Fee') { icon = LucideIcons.clipboardList; c = const Color(0xFF22C55E); bg = const Color(0xFFEAF8F0); }
    if (type == 'Tuition Fee') { icon = LucideIcons.bookOpen; }

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Invoice Items', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFFF8FAFC),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('ITEM', style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: _muted))),
                Expanded(flex: 2, child: Text('DESCRIPTION', style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: _muted))),
                Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text('AMOUNT', style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: _muted)))),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
                        child: Icon(icon, size: 16, color: c),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(type, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _dark)),
                            Text('Term Fee', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(flex: 2, child: Text('Standard Fee', style: GoogleFonts.figtree(fontSize: 12, color: _dark))),
                Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text('₹$totalAmtStr', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _dark)))),
              ],
            ),
          ),
          
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                    Text('₹$totalAmtStr', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _dark)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Discount', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                    Text('0.00', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF22C55E))),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Amount', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
                    Text('₹$totalAmtStr', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _primary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
