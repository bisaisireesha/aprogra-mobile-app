import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../../screens/auth/menu_screen.dart';
import 'create_ptm_screen.dart';
import 'ptm_details_screen.dart';
import 'create_event_screen.dart';
import 'package:intl/intl.dart';

const _bg = Color(0xFFF9F9FB);
const _dark = Color(0xFF181821);
const _muted = Color(0xFF595973);
const _primary = Color(0xFF6366F1);
const _border = Color(0xFFE5E7EB);

class CalendarEvent {
  final String title;
  final String type; // 'event', 'exam', 'holiday', 'ptm', 'meeting', 'trip'
  final DateTime date;
  final String time;
  final String location;
  final Color color;
  final IconData icon;

  CalendarEvent({
    required this.title,
    required this.type,
    required this.date,
    required this.time,
    required this.location,
    required this.color,
    required this.icon,
  });
}

class CategoryItem {
  final String name;
  final String description;
  final String itemText;
  final String actionText;
  final IconData icon;
  final Color color;

  CategoryItem({
    required this.name,
    required this.description,
    required this.itemText,
    required this.actionText,
    required this.icon,
    required this.color,
  });
}

class PtmMeeting {
  final String title;
  final String date;
  final String time;
  final String location;
  final String people;
  final bool isUpcoming;

  PtmMeeting({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.people,
    required this.isUpcoming,
  });
}

class SchoolCalendarScreen extends StatefulWidget {
  final int initialTab;
  const SchoolCalendarScreen({super.key, this.initialTab = 0});

  @override
  State<SchoolCalendarScreen> createState() => _SchoolCalendarScreenState();
}

class _SchoolCalendarScreenState extends State<SchoolCalendarScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  // Calendar tab state
  late DateTime _focusedMonth;
  late DateTime _selectedDate;
  String _selectedFilter = 'All';
  bool _showAddForm = false;

  // Form controllers
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _timeController = TextEditingController();
  String _formType = 'event';

  final List<CalendarEvent> _events = [];

  // Categories tab state
  final List<CategoryItem> _categories = [
    CategoryItem(name: 'PTM Slot Booking', description: 'Manage parent-teacher meeting slots', itemText: 'Open', actionText: '+ Manage', icon: LucideIcons.calendarDays, color: const Color(0xFF6366F1)),
    CategoryItem(name: 'Event', description: 'General school events and announcements', itemText: '3', actionText: '+ New', icon: LucideIcons.calendarRange, color: const Color(0xFF3B82F6)),
    CategoryItem(name: 'Add Holiday', description: 'School closures and breaks', itemText: '2', actionText: '+ New', icon: LucideIcons.partyPopper, color: const Color(0xFFEF4444)),
    CategoryItem(name: 'Schedule Exam', description: 'Tests, mid-terms and final exams', itemText: '3', actionText: '+ New', icon: LucideIcons.graduationCap, color: const Color(0xFFF59E0B)),
    CategoryItem(name: 'Staff Meeting', description: 'Internal staff and council meetings', itemText: '1', actionText: '+ New', icon: LucideIcons.users, color: const Color(0xFF10B981)),
    CategoryItem(name: 'Download Report', description: 'Generate or export event reports', itemText: '0', actionText: '+ New', icon: LucideIcons.download, color: const Color(0xFF6B7280)),
    CategoryItem(name: 'Trip', description: 'Field trips and excursions', itemText: '1', actionText: '+ New', icon: LucideIcons.plane, color: const Color(0xFF06B6D4)),
  ];

  final List<PtmMeeting> _ptmMeetings = [
    PtmMeeting(title: 'Term 1 Parent Teacher Meeting', date: 'Oct 24, 2023', time: '10:00 AM - 1:00 PM', location: 'Main Hall', people: 'Class 10A, 10B', isUpcoming: true),
    PtmMeeting(title: 'Annual Performance Review', date: 'Nov 12, 2023', time: '2:00 PM - 5:00 PM', location: 'Classroom 4', people: 'Class 8C', isUpcoming: true),
    PtmMeeting(title: 'Mid-Term Progress Discussion', date: 'Sep 10, 2023', time: '9:00 AM - 12:00 PM', location: 'Library', people: 'Class 12 Science', isUpcoming: false),
    PtmMeeting(title: 'Pre-Primary Assessment', date: 'Dec 05, 2023', time: '09:00 AM - 12:00 PM', location: 'Kindergarten Wing', people: 'LKG A, LKG B', isUpcoming: true),
  ];



  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTab);
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month, 1);
    _selectedDate = DateTime(now.year, now.month, now.day);
    _loadMockEvents(now);
  }

  void _loadMockEvents(DateTime base) {
    _events.clear();
    _events.addAll([
      CalendarEvent(
        title: 'Staff briefing',
        type: 'event',
        date: DateTime(base.year, base.month, base.day),
        time: '11:00 AM',
        location: 'Conference room',
        color: const Color(0xFF6366F1),
        icon: LucideIcons.users,
      ),
      CalendarEvent(
        title: 'Class 10 mock review',
        type: 'exam',
        date: DateTime(base.year, base.month, base.day),
        time: '02:30 PM',
        location: 'Auditorium',
        color: const Color(0xFFEF4444),
        icon: LucideIcons.fileSpreadsheet,
      ),
      CalendarEvent(
        title: 'Parent-Teacher Meeting',
        type: 'event',
        date: DateTime(base.year, base.month, base.day).add(const Duration(days: 1)),
        time: '09:00 AM',
        location: 'Seminar Hall',
        color: const Color(0xFF3B82F6),
        icon: LucideIcons.messageSquare,
      ),
      CalendarEvent(
        title: 'Mid-Term Exams',
        type: 'exam',
        date: DateTime(base.year, base.month, base.day).add(const Duration(days: 3)),
        time: '08:30 AM',
        location: 'Classrooms',
        color: const Color(0xFFF59E0B),
        icon: LucideIcons.graduationCap,
      ),
      CalendarEvent(
        title: 'Founders\' Day',
        type: 'holiday',
        date: DateTime(base.year, base.month, base.day).add(const Duration(days: 6)),
        time: 'All Day',
        location: 'School Campus',
        color: const Color(0xFF10B981),
        icon: LucideIcons.partyPopper,
      ),
      CalendarEvent(
        title: 'Sports Day',
        type: 'event',
        date: DateTime(base.year, base.month, base.day).add(const Duration(days: 9)),
        time: '08:00 AM',
        location: 'Playground',
        color: const Color(0xFF8B5CF6),
        icon: LucideIcons.trophy,
      ),
    ]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _locationController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  List<CalendarEvent> get _filteredEvents {
    List<CalendarEvent> list = _events;
    if (_selectedFilter != 'All') {
      String filter = _selectedFilter.toLowerCase();
      // Adjust handling for 'Events' vs 'Event'
      String typeKey = filter.endsWith('s') ? filter.substring(0, filter.length - 1) : filter;
      list = list.where((e) => e.type.toLowerCase() == typeKey).toList();
    }
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  List<CalendarEvent> _eventsForDate(DateTime date) {
    return _events.where((e) => e.date.year == date.year && e.date.month == date.month && e.date.day == date.day).toList();
  }

  void _addEvent() {
    if (_titleController.text.isEmpty) return;
    setState(() {
      Color c = const Color(0xFF6366F1);
      IconData icon = LucideIcons.calendar;
      if (_formType == 'exam') {
        c = const Color(0xFFEF4444);
        icon = LucideIcons.fileText;
      } else if (_formType == 'holiday') {
        c = const Color(0xFF10B981);
        icon = LucideIcons.plane;
      }

      _events.add(CalendarEvent(
        title: _titleController.text,
        type: _formType,
        date: _selectedDate,
        time: _timeController.text.isEmpty ? 'All Day' : _timeController.text,
        location: _locationController.text.isEmpty ? 'School Campus' : _locationController.text,
        color: c,
        icon: icon,
      ));

      _titleController.clear();
      _locationController.clear();
      _timeController.clear();
      _showAddForm = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Event added successfully!', style: GoogleFonts.figtree(color: Colors.white)),
      backgroundColor: const Color(0xFF10B981),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: const MenuScreen(activeScreen: 'Calendar'),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: CommonAppBar(showMenu: false),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 16),
                      TabBar(
                        controller: _tabController,
                        indicatorColor: _primary,
                        labelColor: _primary,
                        unselectedLabelColor: _muted,
                        labelStyle: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600),
                        unselectedLabelStyle: GoogleFonts.figtree(fontSize: 13),
                        tabs: const [
                          Tab(text: 'Calendar'),
                          Tab(text: 'Categories'),
                          Tab(text: 'PTM Booking'),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildCalendarTab(),
                      _buildCategoriesTab(),
                      _buildPtmTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
            child: const Icon(LucideIcons.menu, size: 18, color: _dark),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('School Events', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
          Text('Manage school calendar, categories and PTM slots', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
        ])),
      ],
    );
  }

  // ── TAB 1: CALENDAR VIEW ───────────────────────────────────────────────
  Widget _buildCalendarTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCalendarGrid(),
          const SizedBox(height: 20),
          if (_showAddForm) ...[
            _buildAddEventForm(),
            const SizedBox(height: 20),
          ],
          _buildTodaySchedule(),
          _buildEventSectionHeader(),
          const SizedBox(height: 12),
          _buildEventList(),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildTodaySchedule() {
    final list = _eventsForDate(_selectedDate);

    if (list.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Events for ${_selectedDate.day}/${_selectedDate.month}', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...list.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [Icon(e.icon, size: 14, color: e.color), const SizedBox(width: 8), Text(e.title, style: GoogleFonts.figtree(fontSize: 12))]),
              )),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final firstDayOffset = DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday - 1;
    final totalDays = DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
                }),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
                  child: const Icon(LucideIcons.chevronLeft, size: 16, color: _dark),
                ),
              ),
              Text(
                '${monthNames[_focusedMonth.month - 1]} ${_focusedMonth.year}',
                style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
                }),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
                  child: const Icon(LucideIcons.chevronRight, size: 16, color: _dark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.map((d) => Expanded(child: Text(d, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: _muted), textAlign: TextAlign.center))).toList(),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: firstDayOffset + totalDays,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 1.1),
            itemBuilder: (ctx, index) {
              if (index < firstDayOffset) return const SizedBox();
              final day = index - firstDayOffset + 1;
              final currentDate = DateTime(_focusedMonth.year, _focusedMonth.month, day);
              final isSelected = currentDate.year == _selectedDate.year && currentDate.month == _selectedDate.month && currentDate.day == _selectedDate.day;
              final isToday = currentDate.year == DateTime.now().year && currentDate.month == DateTime.now().month && currentDate.day == DateTime.now().day;
              final dateEvents = _eventsForDate(currentDate);

              return GestureDetector(
                onTap: () => setState(() {
                  _selectedDate = currentDate;
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: isSelected ? _primary : isToday ? _primary.withValues(alpha: 0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: isToday && !isSelected ? Border.all(color: _primary, width: 1.5) : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$day',
                        style: GoogleFonts.figtree(
                          fontSize: 13,
                          fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : isToday ? _primary : _dark,
                        ),
                      ),
                      if (dateEvents.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: dateEvents.take(3).map((e) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(color: isSelected ? Colors.white : e.color, shape: BoxShape.circle),
                          )).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddEventForm() {
    final types = ['event', 'exam', 'holiday'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Create New Calendar Entry', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
          const SizedBox(height: 4),
          Text('Adding to: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
          const SizedBox(height: 16),
          Row(
            children: types.map((t) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: t != types.last ? 8.0 : 0.0),
                child: GestureDetector(
                  onTap: () => setState(() => _formType = t),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _formType == t ? _primary : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _formType == t ? _primary : _border),
                    ),
                    child: Text(
                      t.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: _formType == t ? Colors.white : _muted),
                    ),
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),
          _formField('Event Title', LucideIcons.tag, _titleController),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _formField('Time (e.g. 10:00 AM)', LucideIcons.clock, _timeController)),
              const SizedBox(width: 12),
              Expanded(child: _formField('Location', LucideIcons.mapPin, _locationController)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => setState(() => _showAddForm = false),
                child: Text('Cancel', style: GoogleFonts.figtree(color: _muted, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _addEvent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(8)),
                  child: Text('Save Entry', style: GoogleFonts.figtree(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _formField(String label, IconData icon, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w500, color: _muted)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(color: const Color(0xFFFAFAFC), borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
          child: TextField(
            controller: ctrl,
            style: GoogleFonts.figtree(fontSize: 13, color: _dark),
            decoration: InputDecoration(prefixIcon: Icon(icon, size: 14, color: _muted), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 10)),
          ),
        ),
      ],
    );
  }

  Widget _buildEventSectionHeader() {
    final filters = ['All', 'Events', 'Exams', 'Holidays'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters.map((f) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedFilter = f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _selectedFilter == f ? _primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _selectedFilter == f ? _primary : _border),
                    ),
                    child: Text(
                      f,
                      style: GoogleFonts.figtree(fontSize: 11, fontWeight: _selectedFilter == f ? FontWeight.bold : FontWeight.normal, color: _selectedFilter == f ? Colors.white : _muted),
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => setState(() => _showAddForm = !_showAddForm),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: _border)),
            child: Row(
              children: [
                const Icon(LucideIcons.plus, size: 12, color: _dark),
                const SizedBox(width: 4),
                Text('Add New', style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: _dark)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventList() {
    final list = _filteredEvents;
    if (list.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
        child: Center(
          child: Column(
            children: [
              const Icon(LucideIcons.calendarX, size: 36, color: _muted),
              const SizedBox(height: 10),
              Text('No events or schedules match your filter', style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
            ],
          ),
        ),
      );
    }

    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        final e = list[i];
        final typeLabel = e.type[0].toUpperCase() + e.type.substring(1);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: e.color.withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(color: e.color.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 3)),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 5,
                  decoration: BoxDecoration(color: e.color, borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14))),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(color: e.color.withValues(alpha: 0.04), border: Border(right: BorderSide(color: _border.withValues(alpha: 0.5)))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        e.date.day.toString().padLeft(2, '0'),
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: e.color),
                      ),
                      Text(
                        monthNames[e.date.month - 1].toUpperCase(),
                        style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: _muted, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                e.title,
                                style: GoogleFonts.figtree(fontSize: 13.5, fontWeight: FontWeight.bold, color: _dark),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: e.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                              child: Text(
                                typeLabel,
                                style: GoogleFonts.inter(fontSize: 8.5, fontWeight: FontWeight.bold, color: e.color),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(LucideIcons.clock, size: 11, color: _muted),
                            const SizedBox(width: 4),
                            Text(e.time, style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                            const SizedBox(width: 12),
                            Icon(LucideIcons.mapPin, size: 11, color: _muted),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                e.location,
                                style: GoogleFonts.figtree(fontSize: 11, color: _muted),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
      },
    );
  }

  // ── TAB 2: CATEGORIES (Mocking user screenshot exactly) ───────────────
  Widget _buildCategoriesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Categories', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
                    Text('All event categories. Click a row to create a new entry.', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Create Category dialog opened!', style: GoogleFonts.figtree()),
                    backgroundColor: _primary,
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: _primary,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: _primary.withValues(alpha: 0.25), blurRadius: 6, offset: const Offset(0, 3))],
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.plus, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text('Create', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Categories List (Mocking the table design of Lovable)
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(flex: 4, child: Text('CATEGORY', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: _muted, letterSpacing: 0.5))),
                      Expanded(flex: 2, child: Text('ITEM', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: _muted, letterSpacing: 0.5), textAlign: TextAlign.center)),
                      Expanded(flex: 2, child: Text('ACTION', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: _muted, letterSpacing: 0.5), textAlign: TextAlign.center)),
                    ],
                  ),
                ),
                const Divider(height: 1, color: _border),
                ..._categories.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final c = entry.value;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            // Icon + Info
                            Expanded(
                              flex: 4,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(color: c.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                                    child: Icon(c.icon, size: 18, color: c.color),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(c.name, style: GoogleFonts.figtree(fontSize: 13.5, fontWeight: FontWeight.bold, color: _dark)),
                                        const SizedBox(height: 2),
                                        Text(c.description, style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Item count
                            Expanded(
                              flex: 2,
                              child: Text(
                                c.itemText,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: c.itemText == 'Open' ? const Color(0xFF6366F1) : _dark,
                                ),
                              ),
                            ),
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () async {
                                    if (c.actionText == '+ Manage') {
                                      final result = await showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => const CreatePtmScreen(),
                                      );
                                      if (result != null && result is Map<String, dynamic>) {
                                        setState(() {
                                          _ptmMeetings.insert(0, PtmMeeting(
                                            title: result['title'],
                                            date: DateFormat('MMM dd, yyyy').format(result['date']),
                                            time: result['time'],
                                            location: result['location'] ?? 'TBA',
                                            people: (result['classes'] as List).join(', '),
                                            isUpcoming: true,
                                          ));
                                        });
                                        _tabController.animateTo(2); // Switch to PTM tab
                                      }
                                    } else {
                                      final result = await showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => const CreateEventScreen(),
                                      );
                                      if (result != null && result is Map<String, dynamic>) {
                                        setState(() {
                                          _events.add(CalendarEvent(
                                            title: result['title'],
                                            type: result['type'],
                                            date: result['date'],
                                            time: result['time'],
                                            location: result['location'],
                                            color: _getCategoryColor(result['type']),
                                            icon: _getCategoryIcon(result['type']),
                                          ));
                                        });
                                      }
                                    }
                                  },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: c.actionText == '+ Manage' ? const Color(0xFFEEF2FF) : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: c.actionText == '+ Manage' ? const Color(0xFF6366F1).withValues(alpha: 0.3) : _border),
                                  ),
                                  child: Text(
                                    c.actionText,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.figtree(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: c.actionText == '+ Manage' ? const Color(0xFF6366F1) : _dark,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (idx < _categories.length - 1) const Divider(height: 1, color: _border),
                    ],
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Color _getCategoryColor(String type) {
    switch (type) {
      case 'exam': return const Color(0xFFEF4444);
      case 'holiday': return const Color(0xFF10B981);
      case 'meeting': return const Color(0xFFF59E0B);
      case 'trip': return const Color(0xFF06B6D4);
      default: return const Color(0xFF6366F1);
    }
  }

  IconData _getCategoryIcon(String type) {
    switch (type) {
      case 'exam': return LucideIcons.fileSpreadsheet;
      case 'holiday': return LucideIcons.partyPopper;
      case 'meeting': return LucideIcons.users;
      case 'trip': return LucideIcons.plane;
      default: return LucideIcons.calendarRange;
    }
  }

  Widget _buildPtmTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: _ptmMeetings.length,
            itemBuilder: (context, index) {
              final meeting = _ptmMeetings[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(meeting.title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: meeting.isUpcoming ? const Color(0xFFEEF2FF) : const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            meeting.isUpcoming ? 'UPCOMING' : 'COMPLETED',
                            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: meeting.isUpcoming ? const Color(0xFF4F46E5) : const Color(0xFF16A34A)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(LucideIcons.calendarDays, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 8),
                        Text(meeting.date, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF334155))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(LucideIcons.clock, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 8),
                        Text(meeting.time, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF334155))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.users, size: 14, color: Color(0xFF64748B)),
                                const SizedBox(width: 6),
                                Expanded(child: Text(meeting.people, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF334155)), overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => PtmDetailsScreen(
                                title: meeting.title,
                                date: meeting.date,
                                time: meeting.time,
                                location: meeting.location,
                                isUpcoming: meeting.isUpcoming,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(8)),
                            child: Text('View Details', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
