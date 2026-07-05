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

class DaycareInsightsScreen extends StatelessWidget {
  const DaycareInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).width >= 600;
    return Scaffold(
      backgroundColor: _bg,
      drawer: const MenuScreen(activeScreen: 'Daycare Insights'),
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
                      isTablet ? 32 : 20,
                      20,
                      isTablet ? 32 : 20,
                      40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 20),
                        _buildMetrics(isTablet),
                        const SizedBox(height: 20),
                        _buildLiveRoomStatus(),
                        const SizedBox(height: 20),
                        _buildPickupQueue(),
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
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFF1EDFF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(LucideIcons.baby, color: _accent, size: 23),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daycare Insights',
                style: GoogleFonts.figtree(
                  color: _dark,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Track attendance, nap logs, meals, and pickup readiness.',
                style: GoogleFonts.figtree(color: _muted, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetrics(bool isTablet) {
    final metrics = const [
      _Metric('Children In', '34', '6 rooms active', LucideIcons.users),
      _Metric('Checked Out', '18', 'today', LucideIcons.checkCircle2),
      _Metric('Meal Updates', '29', 'served lunch', LucideIcons.clipboardList),
      _Metric('Pickup Queue', '7', 'next 30 mins', LucideIcons.clock),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 4 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 122,
      ),
      itemBuilder: (context, index) => _MetricCard(metric: metrics[index]),
    );
  }

  Widget _buildLiveRoomStatus() {
    final rooms = const [
      ['Toddler A', '8 / 10 present', 0.80, Color(0xFF22C55E)],
      ['Toddler B', '7 / 9 present', 0.78, Color(0xFF6366F1)],
      ['Pre-K Care', '12 / 14 present', 0.86, Color(0xFF8B5CF6)],
      ['After School', '7 / 12 present', 0.58, Color(0xFFF97316)],
    ];

    return _SectionCard(
      title: 'Live Room Status',
      children: rooms
          .map((room) {
            final color = room[3] as Color;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          room[0] as String,
                          style: GoogleFonts.figtree(
                            color: _dark,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Text(
                        room[1] as String,
                        style: GoogleFonts.figtree(color: _muted, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: room[2] as double,
                      minHeight: 7,
                      backgroundColor: const Color(0xFFF0F2F7),
                      color: color,
                    ),
                  ),
                ],
              ),
            );
          })
          .toList(growable: false),
    );
  }

  Widget _buildPickupQueue() {
    final pickups = const [
      ['Ira Kapoor', 'Toddler A', 'Parent arrived'],
      ['Kabir Sharma', 'Pre-K Care', 'Ready by 3:30 PM'],
      ['Anaya Verma', 'Toddler B', 'Guardian verified'],
    ];

    return _SectionCard(
      title: 'Pickup Queue',
      children: pickups
          .map((pickup) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FC),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFF1EDFF),
                    child: Icon(LucideIcons.user, color: _accent, size: 17),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pickup[0],
                          style: GoogleFonts.figtree(
                            color: _dark,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '${pickup[1]} - ${pickup[2]}',
                          style: GoogleFonts.figtree(
                            color: _muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(LucideIcons.chevronRight, color: _muted, size: 18),
                ],
              ),
            );
          })
          .toList(growable: false),
    );
  }
}

class _Metric {
  final String label;
  final String value;
  final String note;
  final IconData icon;

  const _Metric(this.label, this.value, this.note, this.icon);
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _Metric metric;

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
          Icon(metric.icon, color: _accent, size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metric.value,
                style: GoogleFonts.figtree(
                  color: _dark,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                metric.label,
                style: GoogleFonts.figtree(color: _muted, fontSize: 12),
              ),
              Text(
                metric.note,
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.figtree(
              color: _dark,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}
