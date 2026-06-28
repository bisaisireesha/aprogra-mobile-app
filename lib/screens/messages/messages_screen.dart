import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../auth/menu_screen.dart';
import 'chat_screen.dart';

const _bgPrimary = Color(0xFFFFFFFF);
const _textDark = Color(0xFF111827);
const _textMuted = Color(0xFF6B7280);
const _accent = Color(0xFF6366F1); // Indigo color for messages based on image

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int _bottomNavIndex = 4; // 'Messages' is index 4 in app nav
  String _filter = 'All'; // 'All' or 'Unread'
  String _searchQuery = '';
  String _selectedRole = 'All Roles';

  final List<Map<String, dynamic>> _messages = [
    {
      'name': 'Priya Sharma',
      'initials': 'PS',
      'role': 'PARENT',
      'roleColor': const Color(0xFF818CF8), // Indigo light
      'roleBg': const Color(0xFFEEF2FF),
      'avatarBg': const Color(0xFFEEF2FF),
      'avatarText': const Color(0xFF6366F1),
      'message': 'Regarding annual examination sche...',
      'time': '10:24 AM',
      'unread': true,
      'hasAttachment': false,
      'isStarred': false,
    },
    {
      'name': 'Mr. Arun Kumar',
      'initials': 'AK',
      'role': 'TEACHER',
      'roleColor': const Color(0xFF38BDF8), // Light blue
      'roleBg': const Color(0xFFE0F2FE),
      'avatarBg': const Color(0xFFE0F2FE),
      'avatarText': const Color(0xFF0284C7),
      'message': 'Class 10 attendance report attached.',
      'time': 'Yesterday',
      'unread': false,
      'hasAttachment': true,
      'isStarred': true,
    },
    {
      'name': 'Finance Department',
      'initials': 'FD',
      'role': 'STAFF',
      'roleColor': const Color(0xFFFBBF24), // Amber
      'roleBg': const Color(0xFFFEF3C7),
      'avatarBg': const Color(0xFFFEF3C7),
      'avatarText': const Color(0xFFD97706),
      'message': 'Pending fee follow-up list updated.',
      'time': 'Yesterday',
      'unread': false,
      'hasAttachment': true,
      'isStarred': false,
    },
    {
      'name': 'Grade 8 Parents Group',
      'initials': 'G8',
      'role': 'GROUP',
      'roleColor': const Color(0xFF34D399), // Emerald
      'roleBg': const Color(0xFFD1FAE5),
      'avatarBg': const Color(0xFFD1FAE5),
      'avatarText': const Color(0xFF059669),
      'message': 'Field trip confirmation details...',
      'time': 'May 21',
      'unread': true,
      'hasAttachment': false,
      'isStarred': false,
    },
    {
      'name': 'Rohan Mehta',
      'initials': 'RM',
      'role': 'PARENT',
      'roleColor': const Color(0xFF818CF8),
      'roleBg': const Color(0xFFEEF2FF),
      'avatarBg': const Color(0xFFF3F4F6), // Grey bg
      'avatarText': const Color(0xFF4B5563),
      'message': 'Thank you for the quick response.',
      'time': 'May 22',
      'unread': false,
      'hasAttachment': false,
      'isStarred': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      drawer: const MenuScreen(activeScreen: 'Messages'),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildAppBar(),
            _buildHeader(),
            _buildMessageList(),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(LucideIcons.menu, color: _textDark),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          Text(
            'Messages',
            style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark),
          ),
          IconButton(
            icon: const Icon(LucideIcons.edit, color: _textDark, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // New Message Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: _accent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text('New Message', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Search and Filter
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.search, size: 18, color: _textMuted),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          onChanged: (val) => setState(() => _searchQuery = val),
                          decoration: InputDecoration(
                            hintText: 'Search messages...',
                            hintStyle: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFF9CA3AF)),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: GoogleFonts.figtree(fontSize: 14, color: _textDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _showFilterBottomSheet,
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: _selectedRole == 'All Roles' ? Colors.white : _accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _selectedRole == 'All Roles' ? const Color(0xFFE5E7EB) : _accent),
                  ),
                  child: Icon(LucideIcons.filter, size: 18, color: _selectedRole == 'All Roles' ? _textMuted : _accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Toggle All / Unread
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _filter = 'All'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: _filter == 'All' ? _accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'All',
                    style: GoogleFonts.figtree(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _filter == 'All' ? Colors.white : _textMuted,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => _filter = 'Unread'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: _filter == 'Unread' ? _accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Unread',
                    style: GoogleFonts.figtree(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _filter == 'Unread' ? Colors.white : _textMuted,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // All Messages Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('All Messages', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Builder(
                      builder: (context) {
                        final filteredCount = _getFilteredMessages().length;
                        return Text('$filteredCount item${filteredCount == 1 ? '' : 's'}', style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: _accent));
                      }
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Most Recent', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
                  const SizedBox(width: 4),
                  const Icon(LucideIcons.chevronDown, size: 14, color: _textMuted),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredMessages() {
    return _messages.where((msg) {
      if (_filter == 'Unread' && !(msg['unread'] as bool)) return false;
      if (_selectedRole != 'All Roles' && msg['role'] != _selectedRole.toUpperCase()) return false;
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final name = msg['name'].toString().toLowerCase();
        final message = msg['message'].toString().toLowerCase();
        if (!name.contains(searchLower) && !message.contains(searchLower)) return false;
      }
      return true;
    }).toList();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        final roles = ['All Roles', 'Parent', 'Teacher', 'Staff', 'Group'];
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filter by Role', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: roles.map((role) {
                  final isSelected = _selectedRole == role;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedRole = role);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? _accent : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? _accent : const Color(0xFFE5E7EB)),
                      ),
                      child: Text(
                        role,
                        style: GoogleFonts.figtree(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? Colors.white : _textDark,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageList() {
    final filteredMessages = _getFilteredMessages();

    if (filteredMessages.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.searchX, size: 48, color: _textMuted.withOpacity(0.5)),
              const SizedBox(height: 16),
              Text('No messages found', style: GoogleFonts.figtree(fontSize: 16, color: _textMuted)),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: filteredMessages.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF3F4F6), indent: 76),
        itemBuilder: (context, index) {
          final msg = filteredMessages[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen(chatData: msg)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: msg['avatarBg'],
                    child: Text(msg['initials'], style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: msg['avatarText'])),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(msg['name'], style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
                            Text(msg['time'], style: GoogleFonts.figtree(fontSize: 12, color: const Color(0xFF9CA3AF))),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: msg['roleBg'],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(msg['role'], style: GoogleFonts.figtree(fontSize: 9, fontWeight: FontWeight.bold, color: msg['roleColor'])),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                msg['message'],
                                style: GoogleFonts.figtree(
                                  fontSize: 14,
                                  color: msg['unread'] ? _textDark : _textMuted,
                                  fontWeight: msg['unread'] ? FontWeight.w600 : FontWeight.normal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                if (msg['isStarred'])
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(Icons.star, size: 14, color: Color(0xFFFBBF24)),
                                  ),
                                if (msg['hasAttachment'])
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(LucideIcons.paperclip, size: 14, color: Color(0xFF9CA3AF)),
                                  ),
                                if (msg['unread'])
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: _accent,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        border: const Border(top: BorderSide(color: Color(0xFFEBEBEB))),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _accent,
        unselectedItemColor: _textMuted,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'Academics'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Staff'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Messages'),
        ],
      ),
    );
  }
}
