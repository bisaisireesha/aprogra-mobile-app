import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/app_bottom_nav.dart';
import '../../widgets/common_app_bar.dart';
import '../auth/menu_screen.dart';

const _bg = Color(0xFFF9F9FB);
const _card = Colors.white;
const _dark = Color(0xFF181821);
const _muted = Color(0xFF595973);
const _primary = Color(0xFF6366F1);
const _accent = Color(0xFF8463E9);
const _border = Color(0xFFE7E9F2);

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedTab = 0;
  final _tabs = const ['All', 'Drafts', 'Scheduled', 'Sent'];

  final List<Map<String, dynamic>> _notices = [
    {
      'title': 'Class 10 mock review tomorrow',
      'audience': 'Class 10 parents and students',
      'channel': 'App + SMS',
      'status': 'Scheduled',
      'time': 'Today, 4:30 PM',
      'reach': '118 recipients',
      'color': Color(0xFF6366F1),
      'bg': Color(0xFFEEF2FF),
      'icon': LucideIcons.calendar,
    },
    {
      'title': 'Fee reminder - July installment',
      'audience': '42 fee defaulters',
      'channel': 'WhatsApp + Email',
      'status': 'Draft',
      'time': 'Needs approval',
      'reach': '42 recipients',
      'color': Color(0xFFF97316),
      'bg': Color(0xFFFFF7ED),
      'icon': LucideIcons.wallet,
    },
    {
      'title': 'Sports day rehearsal update',
      'audience': 'Primary school families',
      'channel': 'App notification',
      'status': 'Sent',
      'time': 'Yesterday, 6:10 PM',
      'reach': '312 opened',
      'color': Color(0xFF22C55E),
      'bg': Color(0xFFF0FDF4),
      'icon': LucideIcons.megaphone,
    },
    {
      'title': 'Staff briefing notes',
      'audience': 'All staff members',
      'channel': 'App + Email',
      'status': 'Sent',
      'time': '2 Jul, 8:15 AM',
      'reach': '91 opened',
      'color': Color(0xFF8B5CF6),
      'bg': Color(0xFFF3E8FF),
      'icon': LucideIcons.users,
    },
  ];

  List<Map<String, dynamic>> get _filteredNotices {
    final tab = _tabs[_selectedTab];
    if (tab == 'All') return _notices;
    return _notices.where((notice) => notice['status'] == tab).toList();
  }

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      drawer: const MenuScreen(activeScreen: 'Notifications'),
      bottomNavigationBar: const AppBottomNav(),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: CommonAppBar(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      _isTablet ? 32 : 20,
                      20,
                      _isTablet ? 32 : 20,
                      40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 20),
                        _buildSummaryGrid(),
                        const SizedBox(height: 20),
                        _buildTabs(),
                        const SizedBox(height: 16),
                        _buildNoticeList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notice Center',
                style: GoogleFonts.figtree(
                  color: _dark,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Create, schedule, and track school notices across channels.',
                style: GoogleFonts.figtree(
                  color: _muted,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _PrimaryButton(
          label: 'Compose',
          icon: LucideIcons.plus,
          onTap: _showComposeSheet,
        ),
      ],
    );
  }

  Widget _buildSummaryGrid() {
    final items = [
      _SummaryData('Active notices', '12', '+3 today', LucideIcons.megaphone),
      _SummaryData('Scheduled', '4', 'next 24 hours', LucideIcons.clock),
      _SummaryData('Drafts', '3', 'needs approval', LucideIcons.fileText),
      _SummaryData('Open rate', '78%', '+6% weekly', LucideIcons.barChart2),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _isTablet ? 4 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 126,
      ),
      itemBuilder: (context, index) => _SummaryCard(data: items[index]),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final selected = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? _primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  _tabs[index],
                  style: GoogleFonts.figtree(
                    color: selected ? Colors.white : _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNoticeList() {
    final notices = _filteredNotices;
    if (notices.isEmpty) {
      return _EmptyState(tab: _tabs[_selectedTab]);
    }

    return Column(
      children: notices.map(_buildNoticeCard).toList(growable: false),
    );
  }

  Widget _buildNoticeCard(Map<String, dynamic> notice) {
    final color = notice['color'] as Color;
    final status = notice['status'] as String;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: notice['bg'] as Color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(notice['icon'] as IconData, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notice['title'] as String,
                      style: GoogleFonts.figtree(
                        color: _dark,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notice['audience'] as String,
                      style: GoogleFonts.figtree(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _StatusPill(label: status, color: color),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetaChip(
                icon: LucideIcons.send,
                label: notice['channel'] as String,
              ),
              _MetaChip(
                icon: LucideIcons.clock,
                label: notice['time'] as String,
              ),
              _MetaChip(
                icon: LucideIcons.eye,
                label: notice['reach'] as String,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showPreview(notice),
                  icon: const Icon(LucideIcons.eye, size: 16),
                  label: const Text('Preview'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _dark,
                    side: const BorderSide(color: _border),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _sendNotice(notice),
                  icon: Icon(
                    status == 'Draft'
                        ? LucideIcons.send
                        : LucideIcons.rotateCcw,
                    size: 16,
                  ),
                  label: Text(status == 'Draft' ? 'Send' : 'Remind'),
                  style: FilledButton.styleFrom(backgroundColor: _primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showComposeSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _NoticeComposeSheet(
          onCreate: (title) {
            setState(() {
              _notices.insert(0, {
                'title': title,
                'audience': 'All parents and staff',
                'channel': 'App notification',
                'status': 'Draft',
                'time': 'Needs approval',
                'reach': '0 recipients',
                'color': const Color(0xFF6366F1),
                'bg': const Color(0xFFEEF2FF),
                'icon': LucideIcons.megaphone,
              });
              _selectedTab = 1;
            });
          },
        );
      },
    );
  }

  void _showPreview(Map<String, dynamic> notice) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notice Preview',
                style: GoogleFonts.figtree(
                  color: _dark,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                notice['title'] as String,
                style: GoogleFonts.figtree(
                  color: _dark,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Audience: ${notice['audience']}\nChannel: ${notice['channel']}\nDelivery: ${notice['time']}',
                style: GoogleFonts.figtree(
                  color: _muted,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(backgroundColor: _primary),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendNotice(Map<String, dynamic> notice) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${notice['title']} queued successfully')),
    );
  }
}

class _SummaryData {
  final String label;
  final String value;
  final String note;
  final IconData icon;

  const _SummaryData(this.label, this.value, this.note, this.icon);
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data});

  final _SummaryData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF1EDFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: _accent, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.value,
                style: GoogleFonts.figtree(
                  color: _dark,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.figtree(color: _muted, fontSize: 12),
              ),
              Text(
                data.note,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.figtree(
                  color: _primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.figtree(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FC),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _muted, size: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.figtree(
              color: _muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: _primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _primary.withValues(alpha: 0.22),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 17),
            const SizedBox(width: 7),
            Text(
              label,
              style: GoogleFonts.figtree(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.tab});

  final String tab;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          const Icon(LucideIcons.fileText, color: _muted, size: 32),
          const SizedBox(height: 10),
          Text(
            'No $tab notices',
            style: GoogleFonts.figtree(
              color: _dark,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticeComposeSheet extends StatefulWidget {
  const _NoticeComposeSheet({required this.onCreate});

  final ValueChanged<String> onCreate;

  @override
  State<_NoticeComposeSheet> createState() => _NoticeComposeSheetState();
}

class _NoticeComposeSheetState extends State<_NoticeComposeSheet> {
  final _titleController = TextEditingController();
  String _audience = 'All parents';
  String _channel = 'App notification';

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compose Notice',
            style: GoogleFonts.figtree(
              color: _dark,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Notice title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _audience,
            decoration: const InputDecoration(
              labelText: 'Audience',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'All parents',
                child: Text('All parents'),
              ),
              DropdownMenuItem(value: 'All staff', child: Text('All staff')),
              DropdownMenuItem(
                value: 'Fee defaulters',
                child: Text('Fee defaulters'),
              ),
            ],
            onChanged: (value) =>
                setState(() => _audience = value ?? _audience),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _channel,
            decoration: const InputDecoration(
              labelText: 'Channel',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'App notification',
                child: Text('App notification'),
              ),
              DropdownMenuItem(value: 'SMS', child: Text('SMS')),
              DropdownMenuItem(value: 'Email', child: Text('Email')),
              DropdownMenuItem(value: 'WhatsApp', child: Text('WhatsApp')),
            ],
            onChanged: (value) => setState(() => _channel = value ?? _channel),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                final title = _titleController.text.trim().isEmpty
                    ? 'Untitled notice'
                    : _titleController.text.trim();
                widget.onCreate(title);
                Navigator.pop(context);
              },
              icon: const Icon(LucideIcons.fileText, size: 16),
              label: Text('Save Draft for $_audience'),
              style: FilledButton.styleFrom(backgroundColor: _primary),
            ),
          ),
        ],
      ),
    );
  }
}
