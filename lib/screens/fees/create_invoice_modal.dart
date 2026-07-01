import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CreateInvoiceModal extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  const CreateInvoiceModal({super.key, this.initialData});

  @override
  State<CreateInvoiceModal> createState() => _CreateInvoiceModalState();
}

class _CreateInvoiceModalState extends State<CreateInvoiceModal> {
  final _dark = const Color(0xFF181821);
  final _muted = const Color(0xFF64748B);
  final _border = const Color(0xFFE2E8F0);
  final _primary = const Color(0xFF6366F1);
  final _bg = const Color(0xFFF9F9FB);

  Map<String, dynamic>? _selectedStudent;
  
  DateTime _invoiceDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));
  String _invoiceType = 'Tuition Fee';
  final _referenceCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  List<Map<String, dynamic>> _items = [
    {
      'title': 'Tuition Fee - Q1',
      'subtitle': 'Quarterly',
      'description': 'Apr - Jun 2025',
      'amount': 18000.0,
      'icon': LucideIcons.bookOpen,
      'iconColor': const Color(0xFF6366F1),
      'iconBg': const Color(0xFFEEEDFD),
    },
    {
      'title': 'Transport Fee',
      'subtitle': 'Monthly',
      'description': 'May 2025',
      'amount': 2000.0,
      'icon': LucideIcons.bus,
      'iconColor': const Color(0xFFF59E0B),
      'iconBg': const Color(0xFFFEF3E1),
    },
    {
      'title': 'Exam Fee',
      'subtitle': 'Term 1',
      'description': 'Term 1',
      'amount': 1500.0,
      'icon': LucideIcons.clipboardList,
      'iconColor': const Color(0xFF22C55E),
      'iconBg': const Color(0xFFEAF8F0),
    },
  ];

  String _selectedTax = 'No Tax';
  String _selectedDiscount = 'No Discount';

  List<Map<String, dynamic>> _dummyStudents = [
    {'name': 'Aarav Sharma', 'class': 'Class 5A', 'adm': 'ADM-2025-0112', 'parent': 'Rajesh Sharma', 'phone': '+91 98210 44312', 'init': 'AS'},
    {'name': 'Priya Nair', 'class': 'Class 8B', 'adm': 'ADM-2025-0113', 'parent': 'Suresh Nair', 'phone': '+91 98765 43210', 'init': 'PN'},
    {'name': 'Rohan Mehta', 'class': 'Class 10A', 'adm': 'ADM-2025-0114', 'parent': 'Amit Mehta', 'phone': '+91 91234 56789', 'init': 'RM'},
  ];

  @override
  void initState() {
    super.initState();
    _loadDummystudents();
    _selectedStudent = _dummyStudents[0];
  }

  @override
  void dispose() {
    _referenceCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  double get _subtotal => _items.fold(0.0, (sum, item) => sum + (item['amount'] as double));
  double get _discountAmt => 0.0;
  double get _total => _subtotal - _discountAmt;

  
  Future<void> _loadDummystudents() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__dummyStudents_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _dummyStudents = decoded.map((item) {
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

  Future<void> _saveDummystudents() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _dummyStudents.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__dummyStudents_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9FB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40, height: 4,
              decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 24, 16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.arrowLeft, size: 22),
                  color: _dark,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create Invoice', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _dark)),
                    Text('Add invoice details and line items', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _buildStudentInfoCard(),
                  const SizedBox(height: 16),
                  _buildInvoiceDetailsCard(),
                  const SizedBox(height: 16),
                  _buildInvoiceItemsCard(),
                  const SizedBox(height: 16),
                  _buildAdditionalSettingsCard(),
                  const SizedBox(height: 24), // padding for bottom bar
                ],
              ),
            ),
          ),
          
          // Sticky Bottom Bar
          Container(
            padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: _border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: _primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Save as Draft', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _primary)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'id': 'INV-2025-${DateTime.now().millisecond}',
                        'student': _selectedStudent!['name'],
                        'class': _selectedStudent!['class'],
                        'type': _invoiceType,
                        'issued': _formatDate(_invoiceDate),
                        'due': _formatDate(_dueDate),
                        'amount': _total.toInt(),
                        'status': 'Pending',
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Create Invoice', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 1. Student Information
  Widget _buildStudentInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Student Information', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
              GestureDetector(
                onTap: _showSelectStudentModal,
                child: Row(
                  children: [
                    Text('Select Student', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _primary)),
                    const SizedBox(width: 4),
                    Icon(LucideIcons.chevronRight, size: 14, color: _primary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_selectedStudent != null) Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFEEEDFD),
                child: Text(_selectedStudent!['init'], style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _primary)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_selectedStudent!['name'], style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
                    const SizedBox(height: 4),
                    Text('${_selectedStudent!['class']}  ·  ${_selectedStudent!['adm']}', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                    const SizedBox(height: 2),
                    Text('${_selectedStudent!['parent']}  ·  ${_selectedStudent!['phone']}', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // ── 2. Invoice Details
  Widget _buildInvoiceDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Invoice Details', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildInputLabel('Invoice Date', _buildDatePicker(_invoiceDate, (d) => setState(() => _invoiceDate = d)))),
              const SizedBox(width: 12),
              Expanded(child: _buildInputLabel('Due Date', _buildDatePicker(_dueDate, (d) => setState(() => _dueDate = d)))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInputLabel('Invoice Type', _buildDropdown(
                  _invoiceType, 
                  ['Tuition Fee', 'Transport', 'Hostel Fee', 'Exam Fee', 'Misc'],
                  (v) => setState(() => _invoiceType = v!)
                )),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputLabel('Reference (Optional)', _buildTextField(_referenceCtrl, 'e.g. April 2025 Fee')),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInputLabel('Notes (Optional)', _buildTextArea(_notesCtrl, 'Add a note for this invoice...')),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.figtree(fontSize: 11, color: const Color(0xFF64748B))),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Widget _buildDatePicker(DateTime date, ValueChanged<DateTime> onPicked) {
    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(
          context: context, initialDate: date, firstDate: DateTime(2020), lastDate: DateTime(2030),
          builder: (context, child) => Theme(data: ThemeData.light().copyWith(colorScheme: ColorScheme.light(primary: _primary)), child: child!),
        );
        if (d != null) onPicked(d);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}', style: GoogleFonts.figtree(fontSize: 13, color: _dark)),
            Icon(LucideIcons.calendar, size: 16, color: _dark),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> options, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          isExpanded: true,
          icon: const Icon(LucideIcons.chevronDown, size: 16),
          items: options.map((o) => DropdownMenuItem(value: o, child: Text(o, style: GoogleFonts.figtree(fontSize: 13, color: _dark)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
      child: TextField(
        controller: ctrl,
        style: GoogleFonts.figtree(fontSize: 13, color: _dark),
        decoration: InputDecoration.collapsed(hintText: hint, hintStyle: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFF94A3B8))),
      ),
    );
  }

  Widget _buildTextArea(TextEditingController ctrl, String hint) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 100,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
      child: Stack(
        children: [
          TextField(
            controller: ctrl,
            maxLines: null,
            style: GoogleFonts.figtree(fontSize: 13, color: _dark),
            onChanged: (_) => setState((){}),
            decoration: InputDecoration.collapsed(hintText: hint, hintStyle: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFF94A3B8))),
          ),
          Positioned(
            bottom: 0, right: 0,
            child: Text('${ctrl.text.length}/200', style: GoogleFonts.figtree(fontSize: 10, color: const Color(0xFF94A3B8))),
          ),
        ],
      ),
    );
  }

  // ── 3. Invoice Items
  Widget _buildInvoiceItemsCard() {
    final amtStr = _total.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    final subStr = _subtotal.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    final discStr = _discountAmt.toStringAsFixed(2);

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Invoice Items', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
                GestureDetector(
                  onTap: _showAddItemModal,
                  child: Row(
                    children: [
                      Icon(LucideIcons.plus, size: 14, color: _primary),
                      const SizedBox(width: 4),
                      Text('Add Item', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _primary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFFF8FAFC),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('ITEM', style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: _muted))),
                Expanded(flex: 2, child: Text('DESCRIPTION', style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: _muted))),
                Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text('AMOUNT', style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: _muted)))),
                const SizedBox(width: 24), // space for 3 dots
              ],
            ),
          ),
          
          ..._items.asMap().entries.map((e) {
            final item = e.value;
            final isLast = e.key == _items.length - 1;
            final aStr = item['amount'].toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
            
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: item['iconBg'], borderRadius: BorderRadius.circular(8)),
                              child: Icon(item['icon'], size: 16, color: item['iconColor']),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['title'], style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _dark)),
                                  Text(item['subtitle'], style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(flex: 2, child: Text(item['description'], style: GoogleFonts.figtree(fontSize: 12, color: _dark))),
                      Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text('₹$aStr', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _dark)))),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() => _items.removeAt(e.key));
                        },
                        child: const Icon(LucideIcons.moreVertical, size: 16, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ),
                if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16),
              ],
            );
          }),
          
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                    Text('₹$subStr', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _dark)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Discount', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                    Text(_discountAmt > 0 ? '- ₹$discStr' : '0.00', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF22C55E))),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Amount', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
                    Text('₹$amtStr', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _primary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 4. Additional Settings
  Widget _buildAdditionalSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Additional Settings', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInputLabel('Tax (Optional)', _buildDropdown(
                  _selectedTax, ['No Tax', 'GST 5%', 'GST 12%', 'GST 18%'],
                  (v) => setState(() => _selectedTax = v!)
                )),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputLabel('Discount (Optional)', _buildDropdown(
                  _selectedDiscount, ['No Discount', 'Staff Discount', 'Sibling Discount', 'Custom'],
                  (v) => setState(() => _selectedDiscount = v!)
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Modals
  void _showSelectStudentModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(margin: const EdgeInsets.only(top: 10, bottom: 10), width: 40, height: 4, decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Select Student', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
          ),
          ..._dummyStudents.map((s) => ListTile(
            onTap: () {
              setState(() => _selectedStudent = s);
              Navigator.pop(context);
            },
            leading: CircleAvatar(backgroundColor: const Color(0xFFEEEDFD), child: Text(s['init'], style: TextStyle(color: _primary, fontSize: 12, fontWeight: FontWeight.bold))),
            title: Text(s['name'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
            subtitle: Text('${s['class']} · ${s['adm']}', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
            trailing: _selectedStudent == s ? Icon(LucideIcons.check, color: _primary) : null,
          )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showAddItemModal() {
    String type = 'Tuition Fee';
    String desc = '';
    String amt = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add Line Item', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _dark)),
                  const SizedBox(height: 24),
                  
                  Text('Item Type', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(border: Border.all(color: _border), borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: type, isExpanded: true,
                        items: ['Tuition Fee', 'Transport Fee', 'Exam Fee', 'Library Fee', 'Misc'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (v) => setModalState(() => type = v!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Text('Description', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                  const SizedBox(height: 6),
                  TextField(
                    onChanged: (v) => desc = v,
                    decoration: InputDecoration(
                      hintText: 'e.g. Q1 2025',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _border)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Text('Amount (₹)', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                  const SizedBox(height: 6),
                  TextField(
                    onChanged: (v) => amt = v,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '0.00',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _border)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (amt.isNotEmpty) {
                          setState(() {
                            IconData icon = LucideIcons.fileText;
                            Color c = _primary;
                            Color bg = const Color(0xFFEEEDFD);
                            if (type == 'Transport Fee') { icon = LucideIcons.bus; c = const Color(0xFFF59E0B); bg = const Color(0xFFFEF3E1); }
                            if (type == 'Exam Fee') { icon = LucideIcons.clipboardList; c = const Color(0xFF22C55E); bg = const Color(0xFFEAF8F0); }
                            if (type == 'Tuition Fee') { icon = LucideIcons.bookOpen; }
                            
                            _items.add({
                              'title': type,
                              'subtitle': 'Added manually',
                              'description': desc.isNotEmpty ? desc : type,
                              'amount': double.tryParse(amt) ?? 0.0,
                              'icon': icon,
                              'iconColor': c,
                              'iconBg': bg,
                            });
                          });
                          Navigator.pop(ctx);
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: _primary, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: Text('Add Item', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  )
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}
