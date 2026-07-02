import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PtmBooking {
  final String parentName;
  final String studentName;
  final String grade;
  final String time;
  final String phone;
  final String email;
  final String status;
  final String initials;
  final Color avatarColor;

  PtmBooking({
    required this.parentName,
    required this.studentName,
    required this.grade,
    required this.time,
    required this.phone,
    required this.email,
    required this.status,
    required this.initials,
    required this.avatarColor,
  });
}

class PtmDetailsScreen extends StatefulWidget {
  final String title;
  final String date;
  final String time;
  final String location;
  final bool isUpcoming;

  const PtmDetailsScreen({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.isUpcoming,
  });

  @override
  State<PtmDetailsScreen> createState() => _PtmDetailsScreenState();
}

class _PtmDetailsScreenState extends State<PtmDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedClass = 'All Classes';

  late List<PtmBooking> _bookings;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Generate some dynamic mock data based on title
    final isSecondary = widget.title.toLowerCase().contains('class') || widget.title.toLowerCase().contains('secondary');
    final p1 = isSecondary ? 'Arjun Verma' : 'Riya Singh';
    final p2 = isSecondary ? 'Kavya Reddy' : 'Arjun Sharma';
    final p3 = isSecondary ? 'Rohan Das' : 'Sara Nair';
    
    _bookings = [
      PtmBooking(parentName: 'Nisha Singh', studentName: p1, grade: isSecondary ? 'Class 9' : 'Grade 1', time: '10:00 AM', phone: '+91 9800006987', email: 'nisha@email.com', status: 'BOOKED', initials: 'NS', avatarColor: const Color(0xFFE0E7FF)),
      PtmBooking(parentName: 'Manoj Sharma', studentName: p2, grade: isSecondary ? 'Class 10' : 'Grade 2', time: '10:10 AM', phone: '+91 9800007124', email: 'manoj@email.com', status: 'BOOKED', initials: 'MS', avatarColor: const Color(0xFFF3E8FF)),
      PtmBooking(parentName: 'Sunita Nair', studentName: p3, grade: isSecondary ? 'Class 9' : 'Grade 3', time: '10:20 AM', phone: '+91 9800007261', email: 'sunita@email.com', status: 'BOOKED', initials: 'SN', avatarColor: const Color(0xFFDCFCE7)),
      PtmBooking(parentName: 'Ritu Joshi', studentName: 'Vihaan Joshi', grade: 'Grade 1', time: '10:30 AM', phone: '+91 9800007398', email: 'ritu@email.com', status: 'BOOKED', initials: 'RJ', avatarColor: const Color(0xFFE0E7FF)),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 12.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: () {}, child: Text('Reset', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF6366F1)))),
                    Text('Filters', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                    TextButton(onPressed: () => Navigator.pop(context), child: Text('Apply', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF6366F1)))),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildFilterSection('Search', TextField(
                      decoration: InputDecoration(
                        hintText: 'Search parent or student...',
                        hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 14),
                        suffixIcon: const Icon(LucideIcons.search, size: 18, color: Color(0xFF94A3B8)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    )),
                    const SizedBox(height: 24),
                    _buildFilterSection('Class', _buildDropdown('All Classes')),
                    const SizedBox(height: 24),
                    _buildFilterSection('Status', _buildDropdown('All Status')),
                    const SizedBox(height: 24),
                    _buildFilterSection('Booking Time', Row(
                      children: [
                        Expanded(child: _buildTimePicker('From Time')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTimePicker('To Time')),
                      ],
                    )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildDropdown(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF0F172A))),
          const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF64748B)),
        ],
      ),
    );
  }

  Widget _buildTimePicker(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF94A3B8))),
          const Icon(LucideIcons.clock, size: 16, color: Color(0xFF64748B)),
        ],
      ),
    );
  }

  void _showRescheduleBottomSheet(PtmBooking booking) {
    Navigator.pop(context); // Close details bottom sheet first
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 12.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF0F172A)), onPressed: () => Navigator.pop(context)),
                    Expanded(child: Center(child: Text('Select Date & Time', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))))),
                    TextButton(onPressed: () => Navigator.pop(context), child: Text('Done', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF6366F1)))),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Mock Calendar Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('August 2026', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                        const SizedBox(width: 40),
                        const Icon(LucideIcons.chevronLeft, size: 20, color: Color(0xFF64748B)),
                        const SizedBox(width: 16),
                        const Icon(LucideIcons.chevronRight, size: 20, color: Color(0xFF0F172A)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Days of week
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'].map((d) => 
                        SizedBox(width: 30, child: Center(child: Text(d, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF64748B)))))
                      ).toList(),
                    ),
                    SizedBox(height: 12.h),
                    // Calendar grid mock
                    ...List.generate(5, (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(7, (col) {
                          final day = row * 7 + col - 2; // Offset for August 2026 mock
                          final isSelected = day == 9;
                          final isCurrentMonth = day > 0 && day <= 31;
                          
                          if (!isCurrentMonth) {
                            return SizedBox(
                              width: 36, height: 36, 
                              child: Center(child: Text('${day <= 0 ? 31 + day : day - 31}', style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFFCBD5E1))))
                            );
                          }
                          
                          return Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$day', 
                                style: GoogleFonts.inter(
                                  fontSize: 14, 
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? Colors.white : const Color(0xFF0F172A)
                                )
                              )
                            ),
                          );
                        }),
                      ),
                    )),
                    
                    const SizedBox(height: 24),
                    Text('Select Time', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildTimeChip('09:30 AM', false),
                        _buildTimeChip('10:00 AM', true),
                        _buildTimeChip('10:30 AM', false),
                        _buildTimeChip('11:00 AM', false),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildTimeChip(String time, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6366F1) : Colors.white,
        border: Border.all(color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(time, style: GoogleFonts.inter(fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? Colors.white : const Color(0xFF334155))),
    );
  }

  void _showBookingDetails(PtmBooking booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 12.h),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(LucideIcons.x, color: Color(0xFF64748B)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 56, height: 56,
                          decoration: BoxDecoration(color: booking.avatarColor, shape: BoxShape.circle),
                          child: Center(child: Text(booking.initials, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF4F46E5)))),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(booking.parentName, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                              const SizedBox(height: 4),
                              Text('${booking.studentName} • ${booking.grade}', style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(6)),
                          child: Text(booking.status, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF4F46E5))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildDetailRow(LucideIcons.phone, booking.phone, trailingIcon: LucideIcons.phoneCall),
                    const SizedBox(height: 24),
                    _buildDetailRow(LucideIcons.mail, booking.email, trailingIcon: LucideIcons.mail),
                    const SizedBox(height: 24),
                    _buildDetailRow(LucideIcons.clock, '${booking.time} - 10:10 AM'),
                    const SizedBox(height: 24),
                    _buildDetailRow(LucideIcons.mapPin, widget.location),
                    const SizedBox(height: 24),
                    _buildDetailRow(LucideIcons.user, 'Teacher Assigned', value: '—'),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _bookings.remove(booking);
                          });
                          Navigator.pop(context); // Close the booking details modal
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Slot for ${booking.studentName} cancelled.'),
                            backgroundColor: const Color(0xFFEF4444),
                          ));
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Color(0xFFFECACA)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Cancel Slot', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFFEF4444))),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _showRescheduleBottomSheet(booking),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: Text('Reschedule', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String text, {IconData? trailingIcon, String? value}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF64748B)),
        const SizedBox(width: 16),
        Expanded(child: Text(text, style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF0F172A)))),
        if (value != null) Text(value, style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF64748B))),
        if (trailingIcon != null) Icon(trailingIcon, size: 18, color: const Color(0xFF6366F1)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2))),
          SizedBox(height: 12.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(icon: const Icon(LucideIcons.x, color: Color(0xFF0F172A)), onPressed: () => Navigator.pop(context)),
                Expanded(child: Center(child: Text(widget.title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))))),
                IconButton(icon: const Icon(LucideIcons.calendarDays, color: Color(0xFF6366F1)), onPressed: () {}),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.date, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(LucideIcons.clock, size: 12, color: Color(0xFF64748B)),
                    const SizedBox(width: 6),
                    Text('${widget.time} • ${widget.location}', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.isUpcoming ? const Color(0xFFEEF2FF) : const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.isUpcoming ? LucideIcons.clock : LucideIcons.checkCircle2, size: 12, color: widget.isUpcoming ? const Color(0xFF4F46E5) : const Color(0xFF16A34A)),
                      const SizedBox(width: 6),
                      Text(widget.isUpcoming ? 'UPCOMING' : 'COMPLETED', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: widget.isUpcoming ? const Color(0xFF4F46E5) : const Color(0xFF16A34A))),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Stats Grid
                Row(
                  children: [
                    Expanded(child: _buildStatCard('TOTAL INVITED', '80', '', LucideIcons.users, const Color(0xFFDBEAFE), const Color(0xFF3B82F6))),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard('SLOT BOOKED', '52', '(65%)', LucideIcons.calendarCheck, const Color(0xFFF3E8FF), const Color(0xFF9333EA))),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildStatCard('PENDING', '28', '(35%)', LucideIcons.clock, const Color(0xFFFFEDD5), const Color(0xFFEA580C))),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard('CLASSES', '3', '\nGrade 1, Grade 2...', LucideIcons.graduationCap, const Color(0xFFFEF9C3), const Color(0xFFCA8A04), subtitleSize: 9)),
                  ],
                ),
              ],
            ),
          ),
          
          // Tabs
          Container(
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF6366F1),
              unselectedLabelColor: const Color(0xFF64748B),
              labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
              unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
              indicatorColor: const Color(0xFF6366F1),
              indicatorWeight: 2,
              tabs: const [
                Tab(text: 'Slot Booked (52)'),
                Tab(text: 'Pending (28)'),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookingsTab(),
                const Center(child: Text('Pending list goes here')),
              ],
            ),
          ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color bgColor, Color iconColor, {double subtitleSize = 11}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF64748B), letterSpacing: 0.5)),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(value, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                    const SizedBox(width: 4),
                    Expanded(child: Text(subtitle, style: GoogleFonts.inter(fontSize: subtitleSize, color: const Color(0xFF64748B)), overflow: TextOverflow.ellipsis, maxLines: 2)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search parent, student...',
                      hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 13),
                      prefixIcon: const Icon(LucideIcons.search, size: 16, color: Color(0xFF94A3B8)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _showFilters,
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Center(child: Icon(LucideIcons.slidersHorizontal, size: 18, color: Color(0xFF64748B))),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: () {
              // Show simple class dropdown
              showModalBottomSheet(context: context, builder: (c) => ListView(
                shrinkWrap: true,
                children: ['All Classes', 'Grade 1', 'Grade 2', 'Grade 3'].map((cls) => ListTile(
                  title: Text(cls, style: GoogleFonts.inter(fontSize: 14)),
                  onTap: () { setState(() => _selectedClass = cls); Navigator.pop(context); },
                )).toList(),
              ));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedClass, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A))),
                  const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF64748B)),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: _bookings.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final b = _bookings[index];
              return GestureDetector(
                onTap: () => _showBookingDetails(b),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(color: b.avatarColor, shape: BoxShape.circle),
                        child: Center(child: Text(b.initials, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF4F46E5)))),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(b.parentName, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                            const SizedBox(height: 4),
                            Text('${b.studentName} • ${b.grade}', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                            const SizedBox(height: 6),
                            Text(b.phone, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Icon(LucideIcons.clock, size: 12, color: Color(0xFF64748B)),
                              const SizedBox(width: 4),
                              Text(b.time, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A))),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(6)),
                            child: Text(b.status, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF4F46E5))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
