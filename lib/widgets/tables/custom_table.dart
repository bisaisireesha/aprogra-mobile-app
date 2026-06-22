import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTable extends StatelessWidget {
  final List<String> columns;
  final List<List<Widget>> rows;

  const CustomTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            child: Row(
              children: columns.map((col) => Expanded(
                child: Text(
                  col,
                  style: GoogleFonts.figtree(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              )).toList(),
            ),
          ),
          ...rows.asMap().entries.map((entry) {
            final isLast = entry.key == rows.length - 1;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Row(
                children: entry.value.map((cell) => Expanded(child: cell)).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }
}
