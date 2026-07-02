import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MaintenanceJobDetailsModal extends StatelessWidget {
  final Map<String, dynamic> job;

  const MaintenanceJobDetailsModal({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Header Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildDetailsList(),
                    const SizedBox(height: 24),
                    _buildStatusStepper(),
                    const SizedBox(height: 24),
                    _buildPartsUsed(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              // Bottom Actions
              _buildBottomActions(),
            ],
          ),
        );
      },
    );
  }

    Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '·',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildDetailsList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          _buildDetailRow(LucideIcons.calendar, 'Job Date', job['date']),
          _buildDetailRow(LucideIcons.tag, 'Type', job['type'], isPill: true),
          _buildDetailRow(LucideIcons.bus, 'Vehicle', job['bus'], hasArrow: true),
          _buildDetailRow(LucideIcons.user, 'Mechanic', job['mechanic'], hasArrow: true),
          _buildDetailRow(Icons.currency_rupee, 'Cost', '₹${job['cost']}'),
          _buildDetailRow(LucideIcons.list, 'Description', 'Gearbox full inspection and overhaul with part replacement.', isMultiLine: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {bool isPill = false, bool hasArrow = false, bool isMultiLine = false}) {
    Widget valueWidget;
    
    if (isPill) {
      Color pillColor;
      if (value == 'Repair') {
        pillColor = const Color(0xFFEF4444);
      } else if (value == 'Preventive') {
        pillColor = const Color(0xFF6366F1);
      } else {
        pillColor = const Color(0xFF64748B);
      }

      valueWidget = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: pillColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: pillColor,
          ),
        ),
      );
    } else {
      valueWidget = Text(
        value,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF181821),
        ),
        textAlign: isMultiLine ? TextAlign.right : TextAlign.left,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF595973),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: valueWidget,
            ),
          ),
          if (hasArrow) ...[
            const SizedBox(width: 8),
            const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFF94A3B8)),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusStepper() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Status',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF181821),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildStep('Created', '10 Jun 2026', LucideIcons.fileText, isCompleted: true)),
              Expanded(child: _buildStep('In Service', '14 Jun 2026', LucideIcons.wrench, isActive: true)),
              Expanded(child: _buildStep('Completed', '', LucideIcons.checkSquare, isNext: true)),
              Expanded(child: _buildStep('Closed', '', LucideIcons.lock, isNext: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String title, String date, IconData icon, {bool isCompleted = false, bool isActive = false, bool isNext = false}) {
    Color iconColor;
    Color bgColor;
    Color titleColor;
    
    if (isCompleted) {
      iconColor = const Color(0xFFF59E0B);
      bgColor = const Color(0xFFFEF3C7);
      titleColor = const Color(0xFF595973);
    } else if (isActive) {
      iconColor = Colors.white;
      bgColor = const Color(0xFFF59E0B);
      titleColor = const Color(0xFFF59E0B);
    } else {
      iconColor = const Color(0xFF94A3B8);
      bgColor = const Color(0xFFF1F5F9);
      titleColor = const Color(0xFF595973);
    }

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: titleColor,
          ),
          textAlign: TextAlign.center,
        ),
        if (date.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            date,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: const Color(0xFF94A3B8),
            ),
            textAlign: TextAlign.center,
          ),
        ]
      ],
    );
  }

  Widget _buildPartsUsed() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Parts Used (3)',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF181821),
            ),
          ),
          SizedBox(height: 12.h),
          _buildPartItem('Gear Oil', 'Qty: 5 L', '₹2,500'),
          SizedBox(height: 12.h),
          _buildPartItem('Clutch Plate', 'Qty: 1', '₹6,800'),
          SizedBox(height: 12.h),
          _buildPartItem('Seal Kit', 'Qty: 1', '₹1,200'),
          SizedBox(height: 12.h),
          Divider(color: Colors.grey.withValues(alpha: 0.2), height: 1),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'View all parts',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6366F1),
                ),
              ),
              const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFF181821)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartItem(String name, String qty, String cost) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF181821),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              qty,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF595973),
              ),
            ),
          ],
        ),
        Text(
          cost,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF181821),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF6366F1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.edit2, size: 18, color: Color(0xFF6366F1)),
                  const SizedBox(width: 8),
                  Text(
                    'Edit Job',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.checkCircle2, size: 18, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Mark as Completed',
                    style: GoogleFonts.inter(
                      fontSize: 15,
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
    );
  }
}
