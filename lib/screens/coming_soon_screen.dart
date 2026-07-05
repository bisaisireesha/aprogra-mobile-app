import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/common_app_bar.dart';
import '../widgets/app_bottom_nav.dart';
import 'auth/menu_screen.dart';

const _bgColor = Color(0xFFF9F9FB);
const _cardColor = Colors.white;
const _textDark = Color(0xFF181821);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);
const _borderColor = Color(0xFFEDECF4);

class ComingSoonScreen extends StatelessWidget {
  final String title;
  final String? activeScreen;
  final String? description;

  const ComingSoonScreen({
    super.key,
    required this.title,
    this.activeScreen,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 600;

    return Scaffold(
      backgroundColor: _bgColor,
      drawer: MenuScreen(activeScreen: activeScreen ?? title),
      bottomNavigationBar: const AppBottomNav(),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
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
                        const SizedBox(height: 24),
                        _buildStatusPanel(isTablet),
                        const SizedBox(height: 24),
                        _buildPreviewGrid(isTablet),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF1EDFF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(LucideIcons.sparkles, color: _accent, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.figtree(
                      color: _textDark,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      height: 1.08,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Route connected and ready for full feature buildout',
                    style: GoogleFonts.figtree(
                      color: _textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          description ??
              'This screen is part of the web parity map. Navigation is live, and the final workflow can be added here without changing redirects again.',
          style: GoogleFonts.figtree(
            color: _textMuted,
            fontSize: 14,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusPanel(bool isTablet) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: isTablet
          ? Row(
              children: _statusItems()
                  .map((item) => Expanded(child: item))
                  .toList(),
            )
          : Column(children: _statusItems()),
    );
  }

  List<Widget> _statusItems() {
    return [
      _statusItem(LucideIcons.route, 'Route', 'Connected'),
      _statusItem(LucideIcons.layoutDashboard, 'Screen', 'Feature shell'),
      _statusItem(LucideIcons.smartphone, 'Mobile UX', 'Responsive'),
    ];
  }

  Widget _statusItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _accent, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.figtree(
                    color: _textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.figtree(
                    color: _textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewGrid(bool isTablet) {
    final cards = [
      _previewCard(
        LucideIcons.listChecks,
        'Workflow',
        'Primary actions, review queues, and detail views will live here.',
      ),
      _previewCard(
        LucideIcons.database,
        'Data',
        'Connect this shell to the final API or mock data module.',
      ),
      _previewCard(
        LucideIcons.shieldCheck,
        'Access',
        'Role-based states can be added without changing the route.',
      ),
    ];

    if (isTablet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cards
            .map(
              (card) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: card,
                ),
              ),
            )
            .toList(),
      );
    }

    return Column(
      children: cards
          .map(
            (card) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: card,
            ),
          )
          .toList(),
    );
  }

  Widget _previewCard(IconData icon, String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _accent, size: 22),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.figtree(
              color: _textDark,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.figtree(
              color: _textMuted,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
