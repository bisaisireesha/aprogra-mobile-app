import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../../screens/auth/menu_screen.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedChannel = 'WhatsApp';
  bool _autoReminders = true;
  bool _showTemplateEditor = false;
  String _activeTemplate = 'Due Tomorrow';

  final List<Map<String, dynamic>> _schedules = [
    {'name': '3 Days Before', 'channel': 'WhatsApp', 'time': '09:00 AM', 'active': true, 'sentCount': 124},
    {'name': 'Due Day', 'channel': 'SMS', 'time': '08:00 AM', 'active': true, 'sentCount': 89},
    {'name': 'Due Tomorrow', 'channel': 'WhatsApp', 'time': '06:00 PM', 'active': true, 'sentCount': 112},
    {'name': '3 Days After', 'channel': 'Email', 'time': '10:00 AM', 'active': false, 'sentCount': 45},
    {'name': '7 Days After', 'channel': 'WhatsApp', 'time': '09:00 AM', 'active': true, 'sentCount': 67},
  ];

  final List<Map<String, dynamic>> _recentSent = [
    {'student': 'Rohan Verma', 'class': 'IX-B', 'channel': 'WhatsApp', 'amount': '₹32,500', 'time': '2 hours ago', 'status': 'Delivered'},
    {'student': 'Meera Nair', 'class': 'X-B', 'channel': 'SMS', 'amount': '₹41,200', 'time': '3 hours ago', 'status': 'Delivered'},
    {'student': 'Ishaan Patel', 'class': 'VIII-C', 'channel': 'Email', 'amount': '₹27,400', 'time': '5 hours ago', 'status': 'Opened'},
    {'student': 'Anaya Bose', 'class': 'VII-A', 'channel': 'WhatsApp', 'amount': '₹18,750', 'time': '1 day ago', 'status': 'Read'},
    {'student': 'Kavya Singh', 'class': 'XI-C', 'channel': 'WhatsApp', 'amount': '₹28,000', 'time': '1 day ago', 'status': 'Delivered'},
  ];

  final Map<String, String> _templates = {
    'Due Tomorrow': 'Dear Parent, this is a reminder that the fee payment of *₹{amount}* for *{student}* ({class}) is due tomorrow. Kindly make the payment to avoid late charges. — Saraswati Vidyalaya',
    'Overdue': 'Dear Parent, the fee payment of *₹{amount}* for *{student}* ({class}) is *overdue by {days} days*. Please make the payment immediately to avoid further penalties. — Saraswati Vidyalaya',
    'Due Today': 'Dear Parent, the fee payment of *₹{amount}* for *{student}* ({class}) is due today. Please complete the payment before 5 PM to avoid late charges. — Saraswati Vidyalaya',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: const MenuScreen(activeScreen: 'Fees & Invoices'),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.fromLTRB(20, 16, 20, 0), child: CommonAppBar(showMenu: false)),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 20),
                        _buildStatsRow(),
                        const SizedBox(height: 20),
                        _buildAutoReminderToggle(),
                        const SizedBox(height: 20),
                        _buildChannelSelector(),
                        const SizedBox(height: 20),
                        _buildScheduleList(),
                        const SizedBox(height: 20),
                        _buildTemplateSection(),
                        const SizedBox(height: 20),
                        _buildRecentlySent(),
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
    return Row(children: [
      GestureDetector(
        onTap: () {
          if (canPop) {
            Navigator.pop(context);
          } else {
            _scaffoldKey.currentState?.openDrawer();
          }
        },
        child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
          child: Icon(canPop ? LucideIcons.arrowLeft : LucideIcons.menu, size: 18, color: _dark))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Payment Reminders', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
        Text('Automate and manage fee payment reminders', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
      ])),
      GestureDetector(
        onTap: _sendBulkNow,
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]), borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: _primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))]),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(LucideIcons.send, size: 13, color: Colors.white),
            const SizedBox(width: 6),
            Text('Send Now', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
          ])),
      ),
    ]);
  }

  void _sendBulkNow() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(LucideIcons.send, size: 16, color: Colors.white),
        const SizedBox(width: 8),
        Text('Reminders sent to 47 students!', style: GoogleFonts.figtree(color: Colors.white)),
      ]),
      backgroundColor: _primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Widget _buildStatsRow() {
    return Row(children: [
      Expanded(child: _statCard('Sent Today', '47', LucideIcons.send, _primary)),
      const SizedBox(width: 10),
      Expanded(child: _statCard('Delivered', '44', LucideIcons.checkCheck, const Color(0xFF22C55E))),
      const SizedBox(width: 10),
      Expanded(child: _statCard('Read Rate', '82%', LucideIcons.eye, const Color(0xFF3B82F6))),
      const SizedBox(width: 10),
      Expanded(child: _statCard('Paid After', '12', LucideIcons.wallet, const Color(0xFFF59E0B))),
    ]);
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 8),
        Text(value, style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
        Text(label, style: GoogleFonts.figtree(fontSize: 10, color: _muted)),
      ]),
    );
  }

  Widget _buildAutoReminderToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _autoReminders ? _primary.withValues(alpha: 0.3) : _border)),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: _autoReminders ? const Color(0xFFEEF2FF) : const Color(0xFFF3F4F6), shape: BoxShape.circle),
          child: Icon(LucideIcons.bot, size: 18, color: _autoReminders ? _primary : _muted)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Auto Reminders', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
          Text(_autoReminders ? 'Active — reminders sending automatically' : 'Disabled — all schedules paused', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
        ])),
        Switch(value: _autoReminders, onChanged: (v) => setState(() => _autoReminders = v), activeColor: _primary),
      ]),
    );
  }

  Widget _buildChannelSelector() {
    final channels = [
      {'name': 'WhatsApp', 'icon': LucideIcons.messageCircle, 'color': const Color(0xFF25D366)},
      {'name': 'SMS', 'icon': LucideIcons.messageSquare, 'color': const Color(0xFF3B82F6)},
      {'name': 'Email', 'icon': LucideIcons.mail, 'color': const Color(0xFF6366F1)},
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Default Channel', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
      const SizedBox(height: 10),
      Row(children: channels.map((c) {
        final sel = _selectedChannel == c['name'];
        final color = c['color'] as Color;
        return Expanded(child: Padding(
          padding: EdgeInsets.only(right: c['name'] != 'Email' ? 8 : 0),
          child: GestureDetector(
            onTap: () => setState(() => _selectedChannel = c['name'] as String),
            child: AnimatedContainer(duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(color: sel ? color.withValues(alpha: 0.1) : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: sel ? color : _border, width: sel ? 1.5 : 1)),
              child: Column(children: [
                Icon(c['icon'] as IconData, size: 22, color: sel ? color : _muted),
                const SizedBox(height: 6),
                Text(c['name'] as String, style: GoogleFonts.figtree(fontSize: 12, fontWeight: sel ? FontWeight.w700 : FontWeight.normal, color: sel ? color : _dark)),
              ]),
            ),
          ),
        ));
      }).toList()),
    ]);
  }

  Widget _buildScheduleList() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Reminder Schedules', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
      const SizedBox(height: 10),
      ..._schedules.asMap().entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: StatefulBuilder(builder: (ctx, ss) => Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: e.value['active'] ? _primary.withValues(alpha: 0.2) : _border)),
          child: Row(children: [
            Container(width: 4, height: 40, decoration: BoxDecoration(color: e.value['active'] ? _primary : _border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e.value['name'], style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
              Text('${e.value['channel']} · ${e.value['time']} · ${e.value['sentCount']} sent', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
            ])),
            Switch(value: e.value['active'], onChanged: (v) => ss(() => e.value['active'] = v), activeColor: _primary, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
          ]),
        )),
      )),
    ]);
  }

  Widget _buildTemplateSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Message Templates', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
        GestureDetector(onTap: () => setState(() => _showTemplateEditor = !_showTemplateEditor),
          child: Text(_showTemplateEditor ? 'Close' : 'Edit Templates', style: GoogleFonts.figtree(fontSize: 12, color: _primary, fontWeight: FontWeight.w600))),
      ]),
      const SizedBox(height: 10),
      ..._templates.entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: GestureDetector(
          onTap: () => setState(() => _activeTemplate = e.key),
          child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: _activeTemplate == e.key ? const Color(0xFFEEF2FF) : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _activeTemplate == e.key ? _primary : _border, width: _activeTemplate == e.key ? 1.5 : 1)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(LucideIcons.messageSquare, size: 14, color: _activeTemplate == e.key ? _primary : _muted),
                const SizedBox(width: 8),
                Text(e.key, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _activeTemplate == e.key ? _primary : _dark)),
                const Spacer(),
                if (_activeTemplate == e.key) const Icon(LucideIcons.check, size: 14, color: _primary),
              ]),
              if (_showTemplateEditor && _activeTemplate == e.key) ...[
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: _primary.withValues(alpha: 0.3)), color: Colors.white),
                  child: TextField(maxLines: 4, style: GoogleFonts.figtree(fontSize: 12, color: _dark),
                    controller: TextEditingController(text: e.value),
                    decoration: InputDecoration(border: InputBorder.none, contentPadding: const EdgeInsets.all(12), hintStyle: GoogleFonts.figtree(fontSize: 12, color: _muted))),
                ),
                const SizedBox(height: 8),
                Text('{student}, {class}, {amount}, {days} = dynamic values', style: GoogleFonts.figtree(fontSize: 10, color: _muted)),
              ],
            ])),
        ),
      )),
    ]);
  }

  Widget _buildRecentlySent() {
    final channelColors = {'WhatsApp': const Color(0xFF25D366), 'SMS': const Color(0xFF3B82F6), 'Email': const Color(0xFF6366F1)};
    final statusColors = {'Delivered': const Color(0xFF6366F1), 'Read': const Color(0xFF22C55E), 'Opened': const Color(0xFF3B82F6)};
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Recently Sent', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
      const SizedBox(height: 10),
      Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
        child: Column(children: _recentSent.asMap().entries.map((e) => Column(children: [
          Padding(padding: const EdgeInsets.all(14), child: Row(children: [
            CircleAvatar(radius: 18, backgroundColor: (channelColors[e.value['channel']] ?? _primary).withValues(alpha: 0.1),
              child: Icon(e.value['channel'] == 'WhatsApp' ? LucideIcons.messageCircle : e.value['channel'] == 'SMS' ? LucideIcons.messageSquare : LucideIcons.mail,
                size: 14, color: channelColors[e.value['channel']] ?? _primary)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e.value['student'], style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
              Text('${e.value['class']} · ${e.value['amount']} due · ${e.value['time']}', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: (statusColors[e.value['status']] ?? _primary).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Text(e.value['status'], style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: statusColors[e.value['status']] ?? _primary))),
          ])),
          if (e.key < _recentSent.length - 1) const Divider(height: 1, color: _border),
        ])).toList()),
      ),
    ]);
  }
}
