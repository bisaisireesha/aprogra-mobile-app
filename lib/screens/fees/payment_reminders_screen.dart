import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../../screens/auth/menu_screen.dart';
import '../../widgets/app_bottom_nav.dart';

const _bg = Color(0xFFF9F9FB);
const _dark = Color(0xFF181821);
const _muted = Color(0xFF595973);
const _primary = Color(0xFF6366F1);
const _border = Color(0xFFE5E7EB);

class PaymentRemindersScreen extends StatefulWidget {
  const PaymentRemindersScreen({super.key});

  @override
  State<PaymentRemindersScreen> createState() => _PaymentRemindersScreenState();
}

class _PaymentRemindersScreenState extends State<PaymentRemindersScreen> {
  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _activeTemplateTab = 'Email';

  List<Map<String, dynamic>> _templates = [
    {
      'name': 'Friendly Reminder',
      'status': 'Active',
      'preview':
          'Dear {parent_name}, your fee of ₹{amount} is due on {due_date}. Kindly...',
    },
    {
      'name': '2nd Notice',
      'status': 'Active',
      'preview':
          'This is a gentle follow-up regarding an outstanding fee of ₹{amount}...',
    },
    {
      'name': 'Final Notice',
      'status': 'Active',
      'preview':
          'URGENT: Fee dues of ₹{amount} for {student_name} are significantly...',
    },
    {
      'name': 'Receipt Confirmed',
      'status': 'Draft',
      'preview':
          'We have received ₹{amount} towards {invoice_ref}. Your receipt is...',
    },
  ];

  final List<Map<String, dynamic>> _campaigns = [
    {
      'name': 'May 2025 – 1st Reminder',
      'status': 'Scheduled',
      'date': '16 May 2025, 09:00 AM',
      'channels': 'Email & SMS',
      'recipients': '248',
    },
    {
      'name': 'Overdue – WhatsApp Blast',
      'status': 'Sent',
      'date': '15 May 2025, 04:30 PM',
      'channels': 'WhatsApp',
      'recipients': '84',
    },
    {
      'name': 'Apr Final Notice',
      'status': 'Sent',
      'date': '30 Apr 2025, 10:00 AM',
      'channels': 'SMS',
      'recipients': '62',
    },
    {
      'name': 'Apr 2nd Follow-up',
      'status': 'Sent',
      'date': '25 Apr 2025, 09:00 AM',
      'channels': 'Email',
      'recipients': '110',
    },
    {
      'name': 'Welcome + Fee Invoice',
      'status': 'Sent',
      'date': '01 Apr 2025, 08:00 AM',
      'channels': 'Email',
      'recipients': '620',
    },
  ];

  final List<Map<String, dynamic>> _deliveryLogs = [
    {
      'date': '15 May 2025, 10:32 AM',
      'name': 'Rohan Mehta',
      'channel': 'WhatsApp',
      'template': 'Final Reminder',
      'amount': '₹32,400',
      'status': 'Delivered',
      'opened': 'Opened',
      'icon': LucideIcons.calendar,
      'color': const Color(0xFF8B5CF6),
      'bg': const Color(0xFFF3E8FF),
    },
    {
      'date': '15 May 2025, 10:30 AM',
      'name': 'Anaya Verma',
      'channel': 'SMS',
      'template': 'Overdue Notice',
      'amount': '₹19,800',
      'status': 'Delivered',
      'opened': '—',
      'icon': LucideIcons.phone,
      'color': const Color(0xFF22C55E),
      'bg': const Color(0xFFF0FDF4),
    },
    {
      'date': '15 May 2025, 10:28 AM',
      'name': 'Saanvi Iyer',
      'channel': 'Email',
      'template': 'Friendly Reminder',
      'amount': '₹6,800',
      'status': 'Delivered',
      'opened': 'Opened',
      'icon': LucideIcons.mail,
      'color': const Color(0xFF8B5CF6),
      'bg': const Color(0xFFF3E8FF),
    },
    {
      'date': '15 May 2025, 09:55 AM',
      'name': 'Kabir Sharma',
      'channel': 'WhatsApp',
      'template': '2nd Reminder',
      'amount': '₹24,300',
      'status': 'Failed',
      'opened': '—',
      'icon': LucideIcons.messageSquare,
      'color': const Color(0xFF0EA5E9),
      'bg': const Color(0xFFF0F9FF),
    },
    {
      'date': '14 May 2025, 04:12 PM',
      'name': 'Vihaan Joshi',
      'channel': 'Email',
      'template': 'Friendly Reminder',
      'amount': '₹4,500',
      'status': 'Delivered',
      'opened': 'No',
      'icon': LucideIcons.mail,
      'color': const Color(0xFF8B5CF6),
      'bg': const Color(0xFFF3E8FF),
    },
  ];

  Future<void> _loadTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__templates_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _templates = decoded.map((item) {
          final map = Map<String, dynamic>.from(item);
          for (final key in map.keys.toList()) {
            if (key.toLowerCase().contains('color') && map[key] is int) {
              map[key] = Color(map[key] as int);
            }
          }
          return map;
        }).toList();
      });
    }
  }

  Future<void> _saveTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _templates.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__templates_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: const MenuScreen(activeScreen: 'Payment Reminders'),
      bottomNavigationBar: const AppBottomNav(),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: CommonAppBar(showMenu: true),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 24),
                        _buildActionButtons(),
                        const SizedBox(height: 24),
                        _buildSummaryCards(),
                        const SizedBox(height: 32),
                        _buildMessageTemplates(),
                        const SizedBox(height: 32),
                        _buildScheduledCampaigns(),
                        const SizedBox(height: 32),
                        _buildDeliveryLogSection(),
                        const SizedBox(height: 60),
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

  Widget _buildHeader(BuildContext context) {
    final canPop = Navigator.canPop(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (canPop) {
              Navigator.pop(context);
            } else {
              _scaffoldKey.currentState?.openDrawer();
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Icon(
              canPop ? LucideIcons.arrowLeft : LucideIcons.menu,
              size: 24,
              color: _dark,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Reminders',
                style: GoogleFonts.figtree(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _dark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Automate and send reminders across Email, SMS, and WhatsApp channels.',
                style: GoogleFonts.figtree(fontSize: 13, color: _muted),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('New Template clicked')),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.plus, size: 14, color: _dark),
                const SizedBox(width: 6),
                Text(
                  'New Template',
                  style: GoogleFonts.figtree(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _dark,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Create Campaign clicked')),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: _primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.send, size: 14, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  'Create Campaign',
                  style: GoogleFonts.figtree(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    final kpis = [
      {
        'label': 'Sent This Month',
        'value': '1,248',
        'sub': '+84 today',
        'icon': LucideIcons.send,
        'color': const Color(0xFF8B5CF6),
        'bg': const Color(0xFFF3E8FF),
      },
      {
        'label': 'Delivered',
        'value': '1,186',
        'sub': '95.0% rate',
        'icon': LucideIcons.checkCircle,
        'color': const Color(0xFF22C55E),
        'bg': const Color(0xFFF0FDF4),
      },
      {
        'label': 'Opened',
        'value': '834',
        'sub': '70.3% rate',
        'icon': LucideIcons.eye,
        'color': const Color(0xFF0EA5E9),
        'bg': const Color(0xFFF0F9FF),
      },
      {
        'label': 'Responded',
        'value': '312',
        'sub': '37.4% rate',
        'icon': LucideIcons.barChart2,
        'color': const Color(0xFFF59E0B),
        'bg': const Color(0xFFFFFBEB),
      },
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _kpiCard(kpis[0])),
            const SizedBox(width: 12),
            Expanded(child: _kpiCard(kpis[1])),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _kpiCard(kpis[2])),
            const SizedBox(width: 12),
            Expanded(child: _kpiCard(kpis[3])),
          ],
        ),
      ],
    );
  }

  Widget _kpiCard(Map<String, dynamic> k) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: k['bg'] as Color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              k['icon'] as IconData,
              size: 18,
              color: k['color'] as Color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            k['value'] as String,
            style: GoogleFonts.figtree(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _dark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            k['label'] as String,
            style: GoogleFonts.figtree(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _dark,
            ),
          ),
          Text(
            k['sub'] as String,
            style: GoogleFonts.figtree(fontSize: 12, color: _muted),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _primary,
        unselectedItemColor: _muted,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        showUnselectedLabels: true,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Academics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Fees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Staff',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTemplates() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Message Templates',
                  style: GoogleFonts.figtree(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Edit and manage channel-specific templates',
                  style: GoogleFonts.figtree(fontSize: 12, color: _muted),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: _border)),
            ),
            child: Row(
              children: [
                _buildTemplateTab('Email', LucideIcons.mail),
                _buildTemplateTab('SMS', LucideIcons.smartphone),
                _buildTemplateTab('WhatsApp', LucideIcons.messageCircle),
              ],
            ),
          ),
          ..._templates.map((t) => _buildTemplateCard(t)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add template clicked')),
                );
              },
              child: Row(
                children: [
                  const Icon(LucideIcons.plus, size: 16, color: _primary),
                  const SizedBox(width: 8),
                  Text(
                    'Add template',
                    style: GoogleFonts.figtree(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _primary,
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

  Widget _buildTemplateTab(String label, IconData icon) {
    final isActive = _activeTemplateTab == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTemplateTab = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? _primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: isActive ? _primary : _muted),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.figtree(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive ? _primary : _muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateCard(Map<String, dynamic> t) {
    final isActive = t['status'] == 'Active';
    final statusColor = isActive
        ? const Color(0xFF22C55E)
        : const Color(0xFF64748B);
    final statusBg = isActive
        ? const Color(0xFFF0FDF4)
        : const Color(0xFFF1F5F9);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        t['name'] as String,
                        style: GoogleFonts.figtree(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _dark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        t['status'] as String,
                        style: GoogleFonts.figtree(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  t['preview'] as String,
                  style: GoogleFonts.figtree(fontSize: 13, color: _muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              GestureDetector(
                onTap: () => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Edit ${t['name']}'))),
                child: const Icon(LucideIcons.pencil, size: 16, color: _muted),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Duplicate ${t['name']}')),
                ),
                child: const Icon(LucideIcons.copy, size: 16, color: _muted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduledCampaigns() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scheduled Campaigns',
                  style: GoogleFonts.figtree(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Upcoming and past campaign runs',
                  style: GoogleFonts.figtree(fontSize: 12, color: _muted),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _border),
          ..._campaigns.map((c) => _buildCampaignCard(c)),
        ],
      ),
    );
  }

  Widget _buildCampaignCard(Map<String, dynamic> c) {
    final isScheduled = c['status'] == 'Scheduled';
    final statusColor = isScheduled
        ? const Color(0xFFF59E0B)
        : const Color(0xFF0EA5E9);
    final statusBg = isScheduled
        ? const Color(0xFFFFFBEB)
        : const Color(0xFFF0F9FF);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        c['name'] as String,
                        style: GoogleFonts.figtree(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _dark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        c['status'] as String,
                        style: GoogleFonts.figtree(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    const Icon(LucideIcons.calendar, size: 12, color: _muted),
                    const SizedBox(width: 4),
                    Text(
                      c['date'] as String,
                      style: GoogleFonts.figtree(fontSize: 11, color: _muted),
                    ),
                    const SizedBox(width: 12),
                    const Icon(LucideIcons.bell, size: 12, color: _muted),
                    const SizedBox(width: 4),
                    Text(
                      c['channels'] as String,
                      style: GoogleFonts.figtree(fontSize: 11, color: _muted),
                    ),
                    const SizedBox(width: 12),
                    const Icon(LucideIcons.send, size: 12, color: _muted),
                    const SizedBox(width: 4),
                    Text(
                      '${c['recipients']} recipients',
                      style: GoogleFonts.figtree(fontSize: 11, color: _muted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          isScheduled
              ? GestureDetector(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cancel ${c['name']}')),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.trash2,
                        size: 14,
                        color: Color(0xFFEF4444),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Cancel',
                        style: GoogleFonts.figtree(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('View ${c['name']}'))),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.eye, size: 14, color: _muted),
                      const SizedBox(width: 4),
                      Text(
                        'View',
                        style: GoogleFonts.figtree(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _muted,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildDeliveryLogSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              LucideIcons.arrowLeft,
                              size: 20,
                              color: _dark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Delivery Log',
                            style: GoogleFonts.figtree(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _dark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Text(
                          'Real-time delivery and engagement tracking',
                          style: GoogleFonts.figtree(
                            fontSize: 12,
                            color: _muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _border),
                  ),
                  child: const Icon(LucideIcons.filter, size: 16, color: _dark),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _border),
              ),
              child: TextField(
                style: GoogleFonts.figtree(fontSize: 14, color: _dark),
                decoration: InputDecoration(
                  hintText: 'Search by recipient or template...',
                  hintStyle: GoogleFonts.figtree(
                    fontSize: 14,
                    color: _muted.withValues(alpha: 0.6),
                  ),
                  prefixIcon: const Icon(
                    LucideIcons.search,
                    size: 18,
                    color: _muted,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          ..._deliveryLogs.map((d) => _buildDeliveryLogCard(d)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Showing ${_deliveryLogs.length} of ${_deliveryLogs.length} entries',
                style: GoogleFonts.figtree(fontSize: 12, color: _muted),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryLogCard(Map<String, dynamic> d) {
    final isDelivered = d['status'] == 'Delivered';
    final isOpened = d['opened'] == 'Opened';

    final statusColor = isDelivered
        ? const Color(0xFF22C55E)
        : const Color(0xFFEF4444);
    final statusBg = isDelivered
        ? const Color(0xFFF0FDF4)
        : const Color(0xFFFEF2F2);

    final channelColor = d['channel'] == 'WhatsApp'
        ? const Color(0xFF0EA5E9)
        : d['channel'] == 'SMS'
        ? const Color(0xFF22C55E)
        : const Color(0xFF8B5CF6);

    final channelBg = d['channel'] == 'WhatsApp'
        ? const Color(0xFFF0F9FF)
        : d['channel'] == 'SMS'
        ? const Color(0xFFF0FDF4)
        : const Color(0xFFF3E8FF);

    final channelIcon = d['channel'] == 'WhatsApp'
        ? LucideIcons.messageCircle
        : d['channel'] == 'SMS'
        ? LucideIcons.phone
        : LucideIcons.mail;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: d['bg'] as Color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              d['icon'] as IconData,
              size: 20,
              color: d['color'] as Color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d['date'] as String,
                  style: GoogleFonts.figtree(fontSize: 11, color: _muted),
                ),
                const SizedBox(height: 4),
                Text(
                  d['name'] as String,
                  style: GoogleFonts.figtree(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: channelBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(channelIcon, size: 10, color: channelColor),
                      const SizedBox(width: 4),
                      Text(
                        d['channel'] as String,
                        style: GoogleFonts.figtree(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: channelColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${d['template']} · ${d['amount']}',
                  style: GoogleFonts.figtree(fontSize: 12, color: _dark),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  d['status'] as String,
                  style: GoogleFonts.figtree(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (isOpened)
                Row(
                  children: [
                    const Icon(
                      LucideIcons.checkCircle,
                      size: 12,
                      color: Color(0xFF22C55E),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Opened',
                      style: GoogleFonts.figtree(
                        fontSize: 11,
                        color: const Color(0xFF22C55E),
                      ),
                    ),
                  ],
                )
              else
                Text(
                  d['opened'] as String,
                  style: GoogleFonts.figtree(fontSize: 11, color: _muted),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
