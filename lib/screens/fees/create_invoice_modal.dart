import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CreateInvoiceModal extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  const CreateInvoiceModal({super.key, this.initialData});

  @override
  State<CreateInvoiceModal> createState() => _CreateInvoiceModalState();
}

class _CreateInvoiceModalState extends State<CreateInvoiceModal> {
  final _dark = const Color(0xFF0F172A);
  final _muted = const Color(0xFF64748B);
  final _border = const Color(0xFFE2E8F0);
  final _primary = const Color(0xFF6366F1);
  final _bg = const Color(0xFFF8FAFC);

  String? _selectedStudent = 'Aryan Reddy';
  DateTime _invoiceDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  String? _selectedFeeType = 'Tuition Fee';
  final _remarksController = TextEditingController();
  late TextEditingController _invoiceNoController;
  
  final List<Map<String, dynamic>> _items = [
    {
      'titleCtrl': TextEditingController(text: 'Tuition Fee - May 2025'),
      'descCtrl': TextEditingController(text: 'Monthly tuition fee'),
      'qtyCtrl': TextEditingController(text: '1'),
      'rateCtrl': TextEditingController(text: '24500'),
      'discountCtrl': TextEditingController(text: '0'),
    }
  ];

  String _paymentOption = 'Cash';
  bool _sendWhatsapp = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _selectedStudent = widget.initialData!['student'];
      _selectedFeeType = widget.initialData!['type'];
      _paymentOption = widget.initialData!['payment'] ?? 'Cash';
      
      final dueStr = widget.initialData!['due'] as String?;
      if (dueStr != null) {
        try {
          final parts = dueStr.split(' ');
          if (parts.length == 3) {
            final day = int.parse(parts[0]);
            final monthStr = parts[1];
            final year = int.parse(parts[2]);
            const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            final month = months.indexOf(monthStr) + 1;
            if (month > 0) {
              _dueDate = DateTime(year, month, day);
              _invoiceDate = _dueDate.subtract(const Duration(days: 7));
            }
          }
        } catch (e) {
          // ignore error
        }
      }
    }
    _invoiceNoController = TextEditingController(
      text: widget.initialData != null ? widget.initialData!['id'] : 'INV-2025-1049',
    );
  }

  @override
  void dispose() {
    _remarksController.dispose();
    _invoiceNoController.dispose();
    for (var item in _items) {
      (item['titleCtrl'] as TextEditingController).dispose();
      (item['descCtrl'] as TextEditingController).dispose();
      (item['qtyCtrl'] as TextEditingController).dispose();
      (item['rateCtrl'] as TextEditingController).dispose();
      (item['discountCtrl'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, bool isDue) async {
    final initDate = isDue ? _dueDate : _invoiceDate;
    final today = DateTime.now();
    final firstDate = initDate.isBefore(today) ? initDate : today;

    final picked = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: firstDate,
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: _primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isDue) {
          _dueDate = picked;
        } else {
          _invoiceDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  int get _subTotal => _items.fold(0, (sum, item) => sum + ((int.tryParse((item['qtyCtrl'] as TextEditingController).text) ?? 0) * (int.tryParse((item['rateCtrl'] as TextEditingController).text) ?? 0)));
  int get _totalDiscount => _items.fold(0, (sum, item) => sum + (int.tryParse((item['discountCtrl'] as TextEditingController).text) ?? 0));
  int get _totalAmount => _subTotal - _totalDiscount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.initialData != null ? 'Edit Invoice' : 'Create Invoice',
                      style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.initialData != null ? 'Update existing student fee invoice.' : 'Generate a new invoice for student fee.',
                      style: GoogleFonts.figtree(fontSize: 13, color: _muted),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.x, size: 24),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Student Details'),
                  _buildStudentDropdown(),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle('Invoice Details'),
                  _buildInvoiceDetails(),
                  
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Invoice Items'),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _items.add({
                              'titleCtrl': TextEditingController(text: 'New Item'),
                              'descCtrl': TextEditingController(text: 'Description'),
                              'qtyCtrl': TextEditingController(text: '1'),
                              'rateCtrl': TextEditingController(text: '0'),
                              'discountCtrl': TextEditingController(text: '0'),
                            });
                          });
                        },
                        icon: Icon(LucideIcons.plusCircle, size: 16, color: _primary),
                        label: Text('Add Item', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _primary)),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._items.asMap().entries.map((e) => _buildItemCard(e.key, e.value)),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle('Amounts'),
                  _buildAmounts(),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle('Payment Options'),
                  _buildPaymentOptions(),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle('Additional Options'),
                  _buildAdditionalOptions(),
                  
                  const SizedBox(height: 32),
                  _buildActionButtons(),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark),
      ),
    );
  }

  Widget _buildStudentDropdown() {
    final students = [
      {'name': 'Aryan Reddy', 'details': 'Class 6A • Roll No. 12', 'init': 'AR'},
      {'name': 'Priya Sharma', 'details': 'Class 8B • Roll No. 5', 'init': 'PS'},
      {'name': 'Rohan Mehta', 'details': 'Class 10A • Roll No. 21', 'init': 'RM'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStudent,
          isExpanded: true,
          itemHeight: 56,
          icon: const Icon(LucideIcons.chevronDown, size: 20, color: Color(0xFF6366F1)),
          onChanged: (v) {
            if (v != null) setState(() => _selectedStudent = v);
          },
          items: students.map((s) {
            return DropdownMenuItem(
              value: s['name'],
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(color: Color(0xFFEEF2FF), shape: BoxShape.circle),
                    child: Center(child: Text(s['init']!, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _primary))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(s['name']!, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
                        Text(s['details']!, style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInvoiceDetails() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Invoice No.', style: GoogleFonts.figtree(fontSize: 12, color: const Color(0xFF94A3B8))),
                    TextField(
                      controller: _invoiceNoController,
                      style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _dark),
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.only(top: 4, bottom: 4), border: InputBorder.none),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: _buildInputCard('Invoice Date', _formatDate(_invoiceDate), LucideIcons.calendar, onTap: () => _pickDate(context, false))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildInputCard('Due Date', _formatDate(_dueDate), LucideIcons.calendar, onTap: () => _pickDate(context, true))),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Fee Type', style: GoogleFonts.figtree(fontSize: 12, color: const Color(0xFF94A3B8))),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedFeeType,
                        isExpanded: true,
                        isDense: true,
                        icon: const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF64748B)),
                        onChanged: (v) {
                          if (v != null) {
                            setState(() {
                              _selectedFeeType = v;
                              if (_items.isNotEmpty) {
                                final item = _items.first;
                                (item['titleCtrl'] as TextEditingController).text = '$v - May 2025';
                                (item['descCtrl'] as TextEditingController).text = 'Monthly $v payment';
                                
                                if (v == 'Transport') {
                                  (item['rateCtrl'] as TextEditingController).text = '3200';
                                } else if (v == 'Hostel Fee') {
                                  (item['rateCtrl'] as TextEditingController).text = '18000';
                                } else if (v == 'Tuition Fee') {
                                  (item['rateCtrl'] as TextEditingController).text = '24500';
                                } else {
                                  (item['rateCtrl'] as TextEditingController).text = '2000';
                                }
                              }
                            });
                          }
                        },
                        items: ['Tuition Fee', 'Transport', 'Hostel Fee', 'Exam Fee', 'Misc'].map((t) {
                          return DropdownMenuItem(value: t, child: Text(t, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _dark)));
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Remarks (Optional)', style: GoogleFonts.figtree(fontSize: 12, color: const Color(0xFF94A3B8))),
              TextField(
                controller: _remarksController,
                style: GoogleFonts.figtree(fontSize: 14, color: _dark),
                decoration: InputDecoration(
                  hintText: 'Add a note or remark (optional)',
                  hintStyle: GoogleFonts.figtree(fontSize: 14, color: _muted),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.only(top: 8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputCard(String label, String value, IconData? trailingIcon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: GoogleFonts.figtree(fontSize: 12, color: const Color(0xFF94A3B8))),
                  const SizedBox(height: 4),
                  Text(value, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _dark)),
                ],
              ),
            ),
            if (trailingIcon != null) Icon(trailingIcon, size: 16, color: _muted),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(int index, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: Color(0xFFF5F3FF), shape: BoxShape.circle),
                child: const Icon(LucideIcons.graduationCap, size: 20, color: Color(0xFF6366F1)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: item['titleCtrl'] as TextEditingController,
                      style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark),
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.zero, border: InputBorder.none),
                    ),
                    const SizedBox(height: 2),
                    TextField(
                      controller: item['descCtrl'] as TextEditingController,
                      style: GoogleFonts.figtree(fontSize: 12, color: _muted),
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.zero, border: InputBorder.none),
                    ),
                  ],
                ),
              ),
              Text('₹${(item['rateCtrl'] as TextEditingController).text}', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  if (_items.length > 1) {
                    setState(() => _items.removeAt(index));
                  }
                },
                child: const Icon(LucideIcons.trash2, size: 18, color: Color(0xFFEF4444)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildItemInput('Quantity', item['qtyCtrl'] as TextEditingController)),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: _buildItemInput('Rate (₹)', item['rateCtrl'] as TextEditingController)),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: _buildItemInput('Discount (₹)', item['discountCtrl'] as TextEditingController)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemInput(String label, TextEditingController ctrl) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.figtree(fontSize: 10, color: const Color(0xFF94A3B8))),
          TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.only(top: 4, bottom: 4),
              border: InputBorder.none,
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildAmounts() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
      child: Column(
        children: [
          _buildAmountRow('Sub Total', '₹$_subTotal'),
          const SizedBox(height: 12),
          _buildAmountRow('Discount', '- ₹$_totalDiscount', color: const Color(0xFFEF4444)),
          const SizedBox(height: 12),
          _buildAmountRow('Tax (0%)', '₹0'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFE2E8F0)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
              Text('₹$_totalAmount', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _primary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, String amount, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
        Text(amount, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: color ?? _dark)),
      ],
    );
  }

  Widget _buildPaymentOptions() {
    return Row(
      children: [
        Expanded(child: _buildPaymentBtn('Cash', LucideIcons.banknote)),
        const SizedBox(width: 8),
        Expanded(child: _buildPaymentBtn('UPI', LucideIcons.smartphone)),
        const SizedBox(width: 8),
        Expanded(child: _buildPaymentBtn('Bank Transfer', LucideIcons.building2)),
      ],
    );
  }

  Widget _buildPaymentBtn(String label, IconData icon) {
    final isSelected = _paymentOption == label;
    return GestureDetector(
      onTap: () => setState(() => _paymentOption = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _primary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? _primary : _border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : _muted),
            const SizedBox(width: 6),
            Text(label, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : _muted)),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => _sendWhatsapp = !_sendWhatsapp),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: _sendWhatsapp ? _primary : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: _sendWhatsapp ? _primary : const Color(0xFFCBD5E1)),
              ),
              child: _sendWhatsapp ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
          ),
          const SizedBox(width: 12),
          Text('Send invoice to parent via WhatsApp', style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
          const Spacer(),
          const Icon(LucideIcons.messageCircle, size: 20, color: Color(0xFF22C55E)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Return mock data
              Navigator.pop(context, {
                'id': widget.initialData != null ? widget.initialData!['id'] : 'INV-2025-${1048 + DateTime.now().millisecond % 100}',
                'student': _selectedStudent,
                'class': 'Class 6A',
                'type': _selectedFeeType,
                'due': _formatDate(_dueDate),
                'amount': '₹${_totalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                'status': 'Pending',
                'payment': _paymentOption,
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(widget.initialData != null ? 'Update Invoice' : 'Create Invoice', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: _primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Save as Draft', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _primary)),
          ),
        ),
      ],
    );
  }
}
