import 'package:flutter/material.dart';

const _textDark = Color(0xFF181821);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);
const _bgPrimary = Color(0xFFF9F9FB);

class CommonAppBar extends StatelessWidget {
  const CommonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: const Icon(Icons.menu, color: _textDark, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFF0F0F0)),
            ),
            child: Row(
              children: const [
                Icon(Icons.search, color: _textMuted, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Search anything...',
                    style: TextStyle(color: _textMuted, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Stack(
          children: [
            const Icon(Icons.notifications_none, color: _textDark, size: 28),
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: _bgPrimary, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        const CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xFFE5DCF3),
          child: Icon(Icons.person, color: _accent, size: 20),
        ),
      ],
    );
  }
}
