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

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  String _priority = 'All';

  final List<Map<String, dynamic>> _tickets = [
    {
      'title': 'Fee receipt PDF not downloading',
      'owner': 'Accounts Desk',
      'priority': 'High',
      'status': 'In progress',
      'time': '12 min ago',
    },
    {
      'title': 'Parent cannot see homework attachment',
      'owner': 'Class 5A',
      'priority': 'Medium',
      'status': 'Open',
      'time': '42 min ago',
    },
    {
      'title': 'Transport route map delay',
      'owner': 'Operations',
      'priority': 'Low',
      'status': 'Waiting',
      'time': 'Yesterday',
    },
  ];

  List<Map<String, dynamic>> get _filteredTickets {
    if (_priority == 'All') return _tickets;
    return _tickets.where((ticket) => ticket['priority'] == _priority).toList();
  }

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      drawer: const MenuScreen(activeScreen: 'Support'),
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
                        _buildContactActions(),
                        const SizedBox(height: 20),
                        _buildTicketFilters(),
                        const SizedBox(height: 14),
                        _buildTickets(),
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
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFF1EDFF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            LucideIcons.messageSquare,
            color: _accent,
            size: 23,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Support',
                style: GoogleFonts.figtree(
                  color: _dark,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Raise issues, track school requests, and contact help desk.',
                style: GoogleFonts.figtree(color: _muted, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactActions() {
    final actions = [
      _SupportAction(
        'New Ticket',
        'Create request',
        LucideIcons.plus,
        _primary,
      ),
      _SupportAction(
        'Call Desk',
        '9 AM - 6 PM',
        LucideIcons.phoneCall,
        const Color(0xFF22C55E),
      ),
      _SupportAction(
        'Knowledge Base',
        'Guides',
        LucideIcons.bookOpen,
        const Color(0xFFF97316),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _isTablet ? 3 : 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 98,
      ),
      itemBuilder: (context, index) => _SupportActionCard(
        action: actions[index],
        onTap: () => _handleSupportAction(actions[index]),
      ),
    );
  }

  Widget _buildTicketFilters() {
    final filters = ['All', 'High', 'Medium', 'Low'];
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = _priority == filter;
          return ChoiceChip(
            label: Text(filter),
            selected: selected,
            onSelected: (_) => setState(() => _priority = filter),
            selectedColor: _primary,
            backgroundColor: _card,
            side: const BorderSide(color: _border),
            labelStyle: GoogleFonts.figtree(
              color: selected ? Colors.white : _dark,
              fontWeight: FontWeight.w800,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTickets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Open Tickets',
          style: GoogleFonts.figtree(
            color: _dark,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        ..._filteredTickets.map(_buildTicketCard),
      ],
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    final priority = ticket['priority'] as String;
    final color = priority == 'High'
        ? const Color(0xFFEF4444)
        : priority == 'Medium'
        ? const Color(0xFFF97316)
        : const Color(0xFF22C55E);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(LucideIcons.alertCircle, color: color, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket['title'] as String,
                  style: GoogleFonts.figtree(
                    color: _dark,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${ticket['owner']} - ${ticket['status']} - ${ticket['time']}',
                  style: GoogleFonts.figtree(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _PriorityPill(label: priority, color: color),
        ],
      ),
    );
  }

  void _handleSupportAction(_SupportAction action) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${action.title} selected')));
  }
}

class _SupportAction {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _SupportAction(this.title, this.subtitle, this.icon, this.color);
}

class _SupportActionCard extends StatelessWidget {
  const _SupportActionCard({required this.action, required this.onTap});

  final _SupportAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: action.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(action.icon, color: action.color, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action.title,
                    style: GoogleFonts.figtree(
                      color: _dark,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    action.subtitle,
                    style: GoogleFonts.figtree(color: _muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: _muted, size: 18),
          ],
        ),
      ),
    );
  }
}

class _PriorityPill extends StatelessWidget {
  const _PriorityPill({required this.label, required this.color});

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
