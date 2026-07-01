import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

const _bgPrimary = Color(0xFFFFFFFF);
const _textDark = Color(0xFF111827);
const _textMuted = Color(0xFF6B7280);
const _accent = Color(0xFF6366F1); // Indigo

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> chatData;

  const ChatScreen({super.key, required this.chatData});

  
  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  List<Map<String, dynamic>> _messages = [
    {
      'isSentByMe': false,
      'text': 'Hello Admin, I would like to confirm whether the annual examination timetable has been finalized for Grade 10 students.',
      'time': '10:24 AM',
    },
    {
      'isSentByMe': true,
      'text': 'Hello Mrs. Sharma, the annual examination timetable has been published today. You can also find it under the Examinations section in your parent portal.',
      'time': '10:45 AM',
    }
  ];

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;

    final now = DateTime.now();
    final timeStr = '${now.hour > 12 ? now.hour - 12 : now.hour == 0 ? 12 : now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';

    setState(() {
      _messages.add({
        'isSentByMe': true,
        'text': _msgController.text.trim(),
        'time': timeStr,
      });
      _msgController.clear();
    });
  }

  
  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__messages_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _messages = decoded.map((item) {
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

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _messages.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__messages_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.chevronLeft, color: _textDark),
                  onPressed: () => Navigator.pop(context),
                ),
                GestureDetector(
                  onTap: () => _showChatInfo(context),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: widget.chatData['avatarBg'],
                            child: Text(widget.chatData['initials'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: widget.chatData['avatarText'])),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: const Color(0xFF22C55E), // Online green dot
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(widget.chatData['name'], style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: widget.chatData['roleBg'],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(widget.chatData['role'], style: GoogleFonts.figtree(fontSize: 9, fontWeight: FontWeight.bold, color: widget.chatData['roleColor'])),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text('Parent of Aarav Sharma • Grade 10-A', style: GoogleFonts.figtree(fontSize: 11, color: const Color(0xFF9CA3AF))),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(LucideIcons.moreVertical, color: _textDark, size: 20),
                  onPressed: () => _showChatInfo(context),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Today', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                  ),
                ),
                ..._messages.map((msg) => msg['isSentByMe'] ? _buildSentMessage(msg) : _buildReceivedMessage(msg)),
              ],
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildReceivedMessage(Map<String, dynamic> msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: widget.chatData['avatarBg'],
            child: Text(widget.chatData['initials'], style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: widget.chatData['avatarText'])),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F4F6), // Light grey for received
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    msg['text'],
                    style: GoogleFonts.figtree(fontSize: 14, color: _textDark, height: 1.4),
                  ),
                ),
                const SizedBox(height: 4),
                Text(msg['time'], style: GoogleFonts.figtree(fontSize: 11, color: const Color(0xFF9CA3AF))),
              ],
            ),
          ),
          const SizedBox(width: 40), // Right padding
        ],
      ),
    );
  }

  Widget _buildSentMessage(Map<String, dynamic> msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 40), // Left padding
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: _accent, // Indigo for sent
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    msg['text'],
                    style: GoogleFonts.figtree(fontSize: 14, color: Colors.white, height: 1.4),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(msg['time'], style: GoogleFonts.figtree(fontSize: 11, color: const Color(0xFF9CA3AF))),
                    const SizedBox(width: 4),
                    const Icon(Icons.done_all, size: 14, color: _accent),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFF9CA3AF)),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        style: GoogleFonts.figtree(fontSize: 14, color: _textDark),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.paperclip, color: _textMuted, size: 20),
                      onPressed: () {},
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.image, color: _textMuted, size: 20),
                      onPressed: () {},
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.smile, color: _textMuted, size: 20),
                      onPressed: () {},
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.zap, color: _textMuted, size: 20),
                      onPressed: () {},
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.only(left: 8, right: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: _accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.send, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChatInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 24),
                // Avatar
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: widget.chatData['avatarBg'],
                      child: Text(widget.chatData['initials'], style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: widget.chatData['avatarText'])),
                    ),
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.chatData['name'], style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: widget.chatData['roleBg'],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(widget.chatData['role'], style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: widget.chatData['roleColor'])),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Parent of Aarav Sharma • Grade 10-A', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
                const SizedBox(height: 32),
                // Circular Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionCircle(LucideIcons.star, 'Star'),
                    _buildActionCircle(LucideIcons.bellOff, 'Mute'),
                    _buildActionCircle(LucideIcons.archive, 'Archive'),
                    _buildActionCircle(LucideIcons.trash2, 'Delete', isDestructive: true),
                  ],
                ),
                const SizedBox(height: 24),
                // List items
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                    ),
                    child: Column(
                      children: [
                        _buildListItem(LucideIcons.user, 'View Profile'),
                        const Divider(height: 1, color: Color(0xFFF3F4F6), indent: 48),
                        _buildListItem(LucideIcons.search, 'Search in Conversation'),
                        const Divider(height: 1, color: Color(0xFFF3F4F6), indent: 48),
                        _buildListItem(LucideIcons.folder, 'Shared Files & Media', badge: '12'),
                        const Divider(height: 1, color: Color(0xFFF3F4F6), indent: 48),
                        _buildListItem(LucideIcons.clock, 'Schedule Message'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFEE2E2)),
                    ),
                    child: ListTile(
                      leading: const Icon(LucideIcons.trash, color: Color(0xFFEF4444), size: 20),
                      title: Text('Clear Conversation', style: GoogleFonts.figtree(fontSize: 15, color: const Color(0xFFEF4444))),
                      onTap: () {},
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionCircle(IconData icon, String label, {bool isDestructive = false}) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: isDestructive ? const Color(0xFFFEE2E2) : const Color(0xFFE5E7EB)),
          ),
          child: Icon(icon, size: 20, color: isDestructive ? const Color(0xFFEF4444) : _textDark),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.figtree(fontSize: 12, color: _textDark, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildListItem(IconData icon, String title, {String? badge}) {
    return ListTile(
      leading: Icon(icon, color: _textMuted, size: 20),
      title: Text(title, style: GoogleFonts.figtree(fontSize: 15, color: _textDark)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(badge, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: _accent)),
            ),
          const SizedBox(width: 8),
          const Icon(LucideIcons.chevronRight, size: 18, color: Color(0xFFD1D5DB)),
        ],
      ),
      onTap: () {},
    );
  }
}
