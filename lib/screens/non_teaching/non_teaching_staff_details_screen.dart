import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NonTeachingStaffDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> staff;

  const NonTeachingStaffDetailsScreen({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    final status = staff['status'] as String;
    Color statusBg = const Color(0xFFF4F1FF); // Purple light for contract
    Color statusText = const Color(0xFF6366F1); // Purple for contract
    if (status == 'Active') {
      statusBg = const Color(0xFFDCFCE7);
      statusText = const Color(0xFF22C55E);
    } else if (status == 'On Leave') {
      statusBg = const Color(0xFFFEF3C7);
      statusText = const Color(0xFFF59E0B);
    } else if (status == 'Probation') {
      statusBg = const Color(0xFFE0F2FE);
      statusText = const Color(0xFF0EA5E9);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F46E5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Staff Details', style: GoogleFonts.figtree(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: const BoxDecoration(
              color: Color(0xFF4F46E5),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Text(
                    staff['initials'],
                    style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF0EA5E9)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(staff['name'], style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(staff['role'], style: GoogleFonts.figtree(fontSize: 14, color: Colors.white.withValues(alpha: 0.9))),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                        child: Text(status, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildContactCard(),
                  SizedBox(height: 12.h),
                  _buildOverviewCard(statusText, statusBg, status),
                  SizedBox(height: 12.h),
                  _buildAdditionalInfoCard(),
                  SizedBox(height: 12.h),
                  _buildActionsCard(),
                ],
              ),
            ),
          ),
        ],
      ),
      
    );
  }

  Widget _buildContactCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        children: [
          _buildContactRow(LucideIcons.phone, 'Call', staff['contact'] ?? '+91 98450 11208'),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          _buildContactRow(LucideIcons.mail, 'Email', '${staff['name'].toString().split(' ')[0].toLowerCase()}@school.edu'),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          _buildContactRow(LucideIcons.messageSquare, 'Message', 'Send message'),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFF4F1FF), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: const Color(0xFF4F46E5), size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF111827))),
              const SizedBox(height: 2),
              Text(subtitle, style: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFF6B7280))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(Color statusText, Color statusBg, String status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Overview', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF111827))),
          SizedBox(height: 12.h),
          _buildInfoRow('Department', staff['dept']),
          const SizedBox(height: 12),
          _buildInfoRow('Joined On', staff['joined']),
          const SizedBox(height: 12),
          _buildInfoRow('Shift', staff['shift']),
          const SizedBox(height: 12),
          _buildInfoRow('Employee ID', 'EMP-208'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Status', style: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFF6B7280))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                child: Text(status, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: statusText)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Additional Info', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF111827))),
          SizedBox(height: 12.h),
          _buildInfoRow('Date of Birth', '12 Mar 1988'),
          const SizedBox(height: 12),
          _buildInfoRow('Address', 'Hyderabad, Telangana'),
          const SizedBox(height: 12),
          _buildInfoRow('Blood Group', 'O+'),
          const SizedBox(height: 12),
          _buildInfoRow('Emergency Contact', '+91 98850 66777'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFF6B7280))),
        Text(value, style: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFF111827))),
      ],
    );
  }

  Widget _buildActionsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Actions', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF111827))),
          SizedBox(height: 12.h),
          _buildActionRow(LucideIcons.edit2, 'Edit Staff'),
          SizedBox(height: 12.h),
          _buildActionRow(LucideIcons.calendarCheck, 'Mark Attendance'),
          SizedBox(height: 12.h),
          _buildActionRow(LucideIcons.users, 'Assign Department'),
          SizedBox(height: 12.h),
          _buildActionRow(Icons.more_vert, 'More Options'),
        ],
      ),
    );
  }

  Widget _buildActionRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF6B7280)),
        const SizedBox(width: 16),
        Text(label, style: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFF111827))),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.05))),
      ),
      child: BottomNavigationBar(
        currentIndex: 1, // Staff
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4F46E5),
        unselectedItemColor: const Color(0xFF6B7280),
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Staff'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
