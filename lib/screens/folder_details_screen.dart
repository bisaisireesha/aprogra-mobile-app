import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'upload_resource_dialog.dart';

class FolderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> folder;

  const FolderDetailsScreen({super.key, required this.folder});

  @override
  State<FolderDetailsScreen> createState() => _FolderDetailsScreenState();
}

class _FolderDetailsScreenState extends State<FolderDetailsScreen> {
  String _selectedTag = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _resources = [
    {
      'title': 'Notes 01',
      'type': 'Notes',
      'size': '0.3 MB',
      'author': 'Anita Rao',
      'date': '2026-01-01',
      'fileType': 'PDF',
      'color': const Color(0xFFEF4444),
      'bgColor': const Color(0xFFFEE2E2),
    },
    {
      'title': 'Question Bank 02',
      'type': 'Question Bank',
      'size': '0.7 MB',
      'author': 'R. Khan',
      'date': '2026-02-02',
      'fileType': 'DOC',
      'color': const Color(0xFF3B82F6),
      'bgColor': const Color(0xFFDBEAFE),
    },
    {
      'title': 'Worksheets 03',
      'type': 'Worksheets',
      'size': '1.1 MB',
      'author': 'P. Iyer',
      'date': '2026-03-03',
      'fileType': 'Link',
      'color': const Color(0xFF10B981),
      'bgColor': const Color(0xFFD1FAE5),
    },
    {
      'title': 'Assignments 04',
      'type': 'Assignments',
      'size': '1.5 MB',
      'author': 'V. Gupta',
      'date': '2026-04-04',
      'fileType': 'Video',
      'color': const Color(0xFF8B5CF6),
      'bgColor': const Color(0xFFEDE9FE),
    },
    {
      'title': 'Practice Papers 05',
      'type': 'Practice Papers',
      'size': '1.9 MB',
      'author': 'Anita Rao',
      'date': '2026-05-05',
      'fileType': 'PDF',
      'color': const Color(0xFFEF4444),
      'bgColor': const Color(0xFFFEE2E2),
    },
    {
      'title': 'Notes 06',
      'type': 'Notes',
      'size': '2.3 MB',
      'author': 'R. Khan',
      'date': '2026-06-06',
      'fileType': 'DOC',
      'color': const Color(0xFF3B82F6),
      'bgColor': const Color(0xFFDBEAFE),
    },
  ];

  Future<void> _showUploadDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const UploadResourceDialog(),
    );

    if (result != null) {
      setState(() {
        _resources.insert(0, result);
        if (widget.folder['resourcesCount'] != null) {
          widget.folder['resourcesCount'] = (widget.folder['resourcesCount'] as int) + 1;
        }
      });
    }
  }

  void _viewResource(Map<String, dynamic> res) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Viewing ${res['fileType']}', style: GoogleFonts.figtree(fontWeight: FontWeight.bold, color: const Color(0xFF181B20))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('File Details:', style: GoogleFonts.figtree(fontWeight: FontWeight.bold, color: const Color(0xFF595973))),
            const SizedBox(height: 8),
            Text('Name: ${res['title']}', style: GoogleFonts.figtree(color: const Color(0xFF181B20))),
            Text('Type: ${res['fileType']} Document', style: GoogleFonts.figtree(color: const Color(0xFF181B20))),
            Text('Size: ${res['size']}', style: GoogleFonts.figtree(color: const Color(0xFF181B20))),
            Text('Uploaded by: ${res['author']}', style: GoogleFonts.figtree(color: const Color(0xFF181B20))),
            const SizedBox(height: 16),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E7EB))),
              alignment: Alignment.center,
              child: Icon(LucideIcons.fileText, size: 40, color: const Color(0xFF8F96A3)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Close', style: GoogleFonts.figtree(color: const Color(0xFF595973)))),
        ],
      ),
    );
  }

  void _downloadResource(Map<String, dynamic> res) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${res['title']} downloaded successfully.', style: GoogleFonts.figtree()),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _shareResource(Map<String, dynamic> res) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${res['title']} shared successfully.', style: GoogleFonts.figtree()),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _deleteResource(Map<String, dynamic> res) {
    setState(() {
      _resources.remove(res);
      if (widget.folder['resourcesCount'] != null && (widget.folder['resourcesCount'] as int) > 0) {
        widget.folder['resourcesCount'] = (widget.folder['resourcesCount'] as int) - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF595973), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Back to folders', style: GoogleFonts.figtree(fontSize: 15, color: const Color(0xFF595973))),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildTags(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 24),
              if (_filteredResources.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Text('No resources found.', style: GoogleFonts.figtree(color: const Color(0xFF8F96A3))),
                  ),
                )
              else ...[
                ..._filteredResources.map((res) => _buildResourceCard(res)),
                const SizedBox(height: 16),
                Center(
                  child: Text('Showing 1–${_filteredResources.length} of ${widget.folder['resourcesCount'] ?? 248} resources', style: GoogleFonts.figtree(fontSize: 12, color: const Color(0xFF8F96A3))),
                ),
              ],
              const SizedBox(height: 32),
            ],
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
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFE0D8FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 14,
                left: 14,
                child: Container(width: 20, height: 8, decoration: BoxDecoration(color: const Color(0xFF8463E9), borderRadius: BorderRadius.circular(3))),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(widget.folder['subject'] ?? 'Mathematics', style: GoogleFonts.figtree(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF181B20)))),
                  Row(
                    children: [
                      const Icon(LucideIcons.star, size: 20, color: Color(0xFF595973)),
                      const SizedBox(width: 12),
                      const Icon(Icons.more_vert, size: 20, color: Color(0xFF595973)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text('${widget.folder['level'] ?? 'Primary'} • Grade 5 • ${widget.folder['resourcesCount'] ?? 248} resources', style: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFF595973))),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _showUploadDialog,
                icon: const Icon(LucideIcons.upload, size: 16, color: Colors.white),
                label: Text('Upload Resource', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1), // Indigo color from image
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    final tags = ['All', 'Notes', 'Question Bank', 'Worksheets', 'Assignments', 'Practice Papers'];
    final counts = {'All': widget.folder['resourcesCount'] ?? 248, 'Notes': 50, 'Question Bank': 50, 'Worksheets': 50, 'Assignments': 49, 'Practice Papers': 49};

    return Wrap(
      spacing: 8,
      runSpacing: 12,
      children: tags.map((tag) {
        final isSelected = _selectedTag == tag;
        return GestureDetector(
          onTap: () => setState(() => _selectedTag = tag),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF6366F1) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE5E7EB)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(tag, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : const Color(0xFF595973))),
                const SizedBox(width: 6),
                Text('${counts[tag]}', style: GoogleFonts.figtree(fontSize: 13, color: isSelected ? Colors.white.withOpacity(0.8) : const Color(0xFF8F96A3))),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Map<String, dynamic>> get _filteredResources {
    var list = _resources;
    if (_selectedTag != 'All') {
      list = list.where((res) => res['type'] == _selectedTag || res['category'] == _selectedTag).toList();
    }
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((res) => (res['title']?.toString().toLowerCase() ?? '').contains(query)).toList();
    }
    return list;
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search resources...',
                hintStyle: GoogleFonts.figtree(color: const Color(0xFF8F96A3), fontSize: 14),
                prefixIcon: const Icon(LucideIcons.search, color: Color(0xFF8F96A3), size: 18),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Icon(LucideIcons.filter, size: 18, color: Color(0xFF595973)),
        ),
      ],
    );
  }

  Widget _buildResourceCard(Map<String, dynamic> res) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: res['bgColor'], borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  res['fileType'] == 'PDF' ? LucideIcons.fileText : 
                  res['fileType'] == 'DOC' ? LucideIcons.file : 
                  res['fileType'] == 'Video' ? LucideIcons.video : LucideIcons.link2, 
                  color: res['color'], size: 16
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(color: res['color'], borderRadius: BorderRadius.circular(4)),
                  child: Text(res['fileType'], style: GoogleFonts.figtree(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(res['title'], style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF181B20)))),
                    const Icon(Icons.more_vert, size: 18, color: Color(0xFF8F96A3)),
                  ],
                ),
                const SizedBox(height: 6),
                Text('${res['type']} • ${res['size']}', style: GoogleFonts.figtree(fontSize: 12, color: const Color(0xFF595973))),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${res['author']} • ${res['date']}', style: GoogleFonts.figtree(fontSize: 12, color: const Color(0xFF8F96A3))),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _viewResource(res),
                          child: const Icon(LucideIcons.eye, size: 16, color: Color(0xFF595973)),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => _downloadResource(res),
                          child: const Icon(LucideIcons.download, size: 16, color: Color(0xFF595973)),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => _shareResource(res),
                          child: const Icon(LucideIcons.share2, size: 16, color: Color(0xFF595973)),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => _deleteResource(res),
                          child: const Icon(LucideIcons.trash2, size: 16, color: Color(0xFFEF4444)),
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
    );
  }
}
