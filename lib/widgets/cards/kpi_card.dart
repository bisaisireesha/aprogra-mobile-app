import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KPICard extends StatelessWidget {
  final String title;
  final String value;
  final String trendValue;
  final String trendLabel;
  final IconData trendIcon;
  final bool isPositive;
  final Color iconBg;
  final Color iconColor;
  final IconData icon;

  const KPICard({
    super.key,
    required this.title,
    required this.value,
    required this.trendValue,
    required this.trendLabel,
    required this.trendIcon,
    required this.isPositive,
    required this.iconBg,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
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
              Text(
                title,
                style: GoogleFonts.figtree(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B7280),
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 16, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.figtree(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111827),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(trendIcon, size: 14, color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
              const SizedBox(width: 4),
              Text(
                trendValue,
                style: GoogleFonts.figtree(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                trendLabel,
                style: GoogleFonts.figtree(
                  fontSize: 13,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
