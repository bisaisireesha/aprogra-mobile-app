import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

const _bg = Color(0xFFF9F9FB);
const _dark = Color(0xFF181821);
const _muted = Color(0xFF595973);
const _primary = Color(0xFF6366F1);
const _border = Color(0xFFE5E7EB);

class DefaultersListScreen extends StatefulWidget {
  const DefaultersListScreen({super.key});

  @override
  State<DefaultersListScreen> createState() => _DefaultersListScreenState();
}

class _DefaultersListScreenState extends State<DefaultersListScreen> {
  final List<Map<String, dynamic>> _defaulters = [
    {
      'name': 'Rohan Mehta', 'initials': 'RM', 'class': 'Class 10A', 'parent': 'Mr. Mehta', 'phone': '+91 98765 43210',
      'amount': '₹32,400', 'days': '38 days', 'date': '12 Apr 2025',
      'avatarColor': const Color(0xFF6366F1), 'avatarBg': const Color(0xFFEEEDFD), 'tagColor': const Color(0xFFEF4444), 'tagBg': const Color(0xFFFEF2F2)
    },
    {
      'name': 'Anaya Verma', 'initials': 'AV', 'class': 'Class 5A', 'parent': 'Mrs. Verma', 'phone': '+91 98765 11122',
      'amount': '₹19,800', 'days': '32 days', 'date': '18 Apr 2025',
      'avatarColor': const Color(0xFFF97316), 'avatarBg': const Color(0xFFFFF7ED), 'tagColor': const Color(0xFFEF4444), 'tagBg': const Color(0xFFFEF2F2)
    },
    {
      'name': 'Saanvi Iyer', 'initials': 'SI', 'class': 'Class 9B', 'parent': 'Mr. Iyer', 'phone': '+91 98700 33344',
      'amount': '₹12,600', 'days': '18 days', 'date': '01 May 2025',
      'avatarColor': const Color(0xFFF59E0B), 'avatarBg': const Color(0xFFFFFBEB), 'tagColor': const Color(0xFFF59E0B), 'tagBg': const Color(0xFFFFFBEB)
    },
    {
      'name': 'Kabir Sharma', 'initials': 'KS', 'class': 'Class 8B', 'parent': 'Mrs. Sharma', 'phone': '+91 98700 55667',
      'amount': '₹24,300', 'days': '14 days', 'date': '05 May 2025',
      'avatarColor': const Color(0xFF22C55E), 'avatarBg': const Color(0xFFF0FDF4), 'tagColor': const Color(0xFFF59E0B), 'tagBg': const Color(0xFFFFFBEB)
    },
    {
      'name': 'Vihaan Joshi', 'initials': 'VJ', 'class': 'Class 10B', 'parent': 'Mr. Joshi', 'phone': '+91 99000 12345',
      'amount': '₹9,500', 'days': '9 days', 'date': '10 May 2025',
      'avatarColor': const Color(0xFF0EA5E9), 'avatarBg': const Color(0xFFF0F9FF), 'tagColor': const Color(0xFFF59E0B), 'tagBg': const Color(0xFFFFFBEB)
    },
    {
      'name': 'Meera Nair', 'initials': 'MN', 'class': 'Class 4A', 'parent': 'Mrs. Nair', 'phone': '+91 99887 76655',
      'amount': '₹7,200', 'days': '6 days', 'date': '13 May 2025',
      'avatarColor': const Color(0xFF8B5CF6), 'avatarBg': const Color(0xFFF3E8FF), 'tagColor': const Color(0xFF0EA5E9), 'tagBg': const Color(0xFFE0F2FE)
    },
    {
      'name': 'Priya Krishnan', 'initials': 'PK', 'class': 'Class 11A', 'parent': 'Mr. Krishnan', 'phone': '+91 98881 22334',
      'amount': '₹34,500', 'days': '41 days', 'date': '08 Apr 2025',
      'avatarColor': const Color(0xFFEF4444), 'avatarBg': const Color(0xFFFEF2F2), 'tagColor': const Color(0xFFEF4444), 'tagBg': const Color(0xFFFEF2F2)
    },
    {
      'name': 'Aditya Rao', 'initials': 'AR', 'class': 'Class 12B', 'parent': 'Mrs. Rao', 'phone': '+91 97777 44556',
      'amount': '₹36,000', 'days': '35 days', 'date': '11 Apr 2025',
      'avatarColor': const Color(0xFFF59E0B), 'avatarBg': const Color(0xFFFFFBEB), 'tagColor': const Color(0xFFEF4444), 'tagBg': const Color(0xFFFEF2F2)
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(LucideIcons.arrowLeft, size: 24, color: _dark),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'Defaulters List ', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
                          TextSpan(text: '(8)', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.w600, color: _muted)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
                    child: const Icon(LucideIcons.filter, size: 18, color: _dark),
                  ),
                ],
              ),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
                child: TextField(
                  style: GoogleFonts.figtree(fontSize: 14, color: _dark),
                  decoration: InputDecoration(
                    hintText: 'Search defaulter by name...',
                    hintStyle: GoogleFonts.figtree(fontSize: 14, color: _muted.withValues(alpha: 0.6)),
                    prefixIcon: const Icon(LucideIcons.search, size: 18, color: _muted),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: _defaulters.length,
                itemBuilder: (context, index) {
                  return _buildDefaulterCard(_defaulters[index]);
                },
              ),
            ),

            // Footer
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
              color: _bg,
              alignment: Alignment.center,
              child: Text('Showing ${_defaulters.length} of ${_defaulters.length} defaulters', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaulterCard(Map<String, dynamic> d) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: d['avatarBg'] as Color,
                  child: Text(d['initials'] as String, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: d['avatarColor'] as Color)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d['name'] as String, style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
                      Text(d['class'] as String, style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                      const SizedBox(height: 6),
                      Text(d['parent'] as String, style: GoogleFonts.figtree(fontSize: 12, color: _dark)),
                      Text(d['phone'] as String, style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(d['amount'] as String, style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFFEF4444))),
                        const SizedBox(width: 8),
                        const Icon(LucideIcons.moreVertical, size: 18, color: _muted),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: d['tagBg'] as Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(d['days'] as String, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.w600, color: d['tagColor'] as Color)),
                    ),
                    const SizedBox(height: 4),
                    Text(d['date'] as String, style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _border),
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calling ${d['parent']}...')));
                    },
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.phone, size: 14, color: Color(0xFF22C55E)),
                          const SizedBox(width: 6),
                          Text('Call', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF22C55E))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(width: 1, height: 20, color: _border),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notification sent to ${d['parent']}!')));
                    },
                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.send, size: 14, color: _primary),
                          const SizedBox(width: 6),
                          Text('Notify', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _primary)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
