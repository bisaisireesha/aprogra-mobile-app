import 'package:flutter/material.dart';

class InventoryMockData {
  static final List<Map<String, dynamic>> assetKPIs = [
    {
      'title': 'Total Inventory Items',
      'value': '3,248',
      'subtitle': 'Items tracked',
      'icon': Icons.inventory_2,
      'colorType': 'purple',
    },
    {
      'title': 'Low Stock Items',
      'value': '18',
      'subtitle': 'Require reorder',
      'icon': Icons.warning_amber_rounded,
      'colorType': 'yellow',
    },
    {
      'title': 'Pending Purchase Requests',
      'value': '7',
      'subtitle': 'Awaiting approval',
      'icon': Icons.assignment_outlined,
      'colorType': 'blue',
    },
    {
      'title': 'Out of Stock Items',
      'value': '3',
      'subtitle': 'Critical attention',
      'icon': Icons.remove_shopping_cart_outlined,
      'colorType': 'red',
    },
    {
      'title': 'Damaged Items',
      'value': '12',
      'subtitle': 'Require review',
      'icon': Icons.build_outlined,
      'colorType': 'orange',
    },
    {
      'title': 'Recent Deliveries',
      'value': '5',
      'subtitle': 'Received today',
      'icon': Icons.local_shipping_outlined,
      'colorType': 'green',
    },
  ];

  static final List<Map<String, dynamic>> criticalAlerts = [
    {
      'title': 'A4 Printing Paper',
      'department': 'Administration',
      'detail': 'Remaining: 2 packs',
      'status': 'Reorder Immediately',
      'colorType': 'red',
    },
    {
      'title': 'Science Lab Chemicals',
      'department': 'Science Dept',
      'detail': 'Below minimum threshold',
      'status': 'Restock This Week',
      'colorType': 'yellow',
    },
    {
      'title': 'Sports Uniforms',
      'department': 'Sports Dept',
      'detail': 'Out of stock',
      'status': 'Purchase Required',
      'colorType': 'red',
    },
    {
      'title': 'Whiteboard Markers',
      'department': 'Classrooms',
      'detail': 'Remaining: 12 units',
      'status': 'Reorder Soon',
      'colorType': 'yellow',
    },
    {
      'title': 'First-Aid Supplies',
      'department': 'Infirmary',
      'detail': 'Bandages low',
      'status': 'Restock',
      'colorType': 'yellow',
    },
    {
      'title': 'Toner Cartridges',
      'department': 'IT Dept',
      'detail': 'Out of stock',
      'status': 'Purchase Required',
      'colorType': 'red',
    },
  ];

  static final List<Map<String, dynamic>> purchaseRequests = [
    {
      'title': 'Computer Lab',
      'items': '20 Keyboards',
      'requestedBy': 'IT Department',
      'status': 'Pending Approval',
      'colorType': 'orange',
    },
    {
      'title': 'Science Department',
      'items': 'Microscope Slides x 50',
      'requestedBy': 'Lab Coordinator',
      'status': 'Pending Review',
      'colorType': 'blue',
    },
    {
      'title': 'Sports Department',
      'items': 'Football Kits',
      'requestedBy': 'Sports Coach',
      'status': 'Pending Procurement',
      'colorType': 'purple',
    },
    {
      'title': 'Library',
      'items': 'Bookshelves x 4',
      'requestedBy': 'Librarian',
      'status': 'Approved - Sourcing',
      'colorType': 'green',
    },
    {
      'title': 'Administration',
      'items': 'Office Chairs x 8',
      'requestedBy': 'Admin Officer',
      'status': 'Pending Approval',
      'colorType': 'orange',
    },
  ];

  static final List<Map<String, dynamic>> statusBoard = [
    {
      'title': 'Stationery',
      'items': '842 items',
      'low': '4',
      'out': '0',
      'pending': '0',
      'health': '100%',
      'healthValue': 1.0,
      'status': 'Healthy',
      'colorType': 'green',
      'icon': Icons.edit_outlined,
    },
    {
      'title': 'Laboratory Equipment',
      'items': '312 items',
      'low': '8',
      'out': '0',
      'pending': '2',
      'health': '97%',
      'healthValue': 0.97,
      'status': 'Attention Needed',
      'colorType': 'yellow',
      'icon': Icons.science_outlined,
    },
    {
      'title': 'Sports Equipment',
      'items': '428 items',
      'low': '3',
      'out': '2',
      'pending': '1',
      'health': '99%',
      'healthValue': 0.99,
      'status': 'Action Required',
      'colorType': 'red',
      'icon': Icons.sports_soccer_outlined,
    },
    {
      'title': 'Library Supplies',
      'items': '156 items',
      'low': '1',
      'out': '0',
      'pending': '0',
      'health': '99%',
      'healthValue': 0.99,
      'status': 'Healthy',
      'colorType': 'green',
      'icon': Icons.menu_book_outlined,
    },
    {
      'title': 'Computer Equipment',
      'items': '198 items',
      'low': '2',
      'out': '0',
      'pending': '3',
      'health': '99%',
      'healthValue': 0.99,
      'status': 'Procurement',
      'colorType': 'blue',
      'icon': Icons.computer_outlined,
    },
    {
      'title': 'Maintenance Supplies',
      'items': '264 items',
      'low': '0',
      'out': '0',
      'pending': '0',
      'health': '100%',
      'healthValue': 1.0,
      'status': 'Healthy',
      'colorType': 'green',
      'icon': Icons.build_circle_outlined,
    },
  ];

  static final List<Map<String, dynamic>> incomingDeliveries = [
    {
      'title': 'Stationery Supplies',
      'vendor': 'OfficeMart',
      'detail': 'Stockroom A - 500 Units',
      'status': 'Received Today',
      'colorType': 'green',
      'icon': Icons.inventory_2_outlined,
    },
    {
      'title': 'Science Equipment',
      'vendor': 'ABC Scientific',
      'detail': 'Stockroom A - 32 Units',
      'status': 'Expected Tomorrow',
      'colorType': 'blue',
      'icon': Icons.inventory_2_outlined,
    },
    {
      'title': 'Library Furniture',
      'vendor': 'WoodCraft Co.',
      'detail': 'Stockroom A - 12 Units',
      'status': 'In Transit - 3 days',
      'colorType': 'purple',
      'icon': Icons.local_shipping_outlined,
    },
    {
      'title': 'Computer Peripherals',
      'vendor': 'TechHub',
      'detail': 'Stockroom A - 45 Units',
      'status': 'Dispatched',
      'colorType': 'purple',
      'icon': Icons.local_shipping_outlined,
    },
    {
      'title': 'Sports Gear Restock',
      'vendor': 'SportsPro',
      'detail': 'Stockroom A - 28 Units',
      'status': 'Delayed',
      'colorType': 'red',
      'icon': Icons.inventory_2_outlined,
    },
    {
      'title': 'Lab Consumables',
      'vendor': 'ChemSource',
      'detail': 'Stockroom A - 120 Units',
      'status': 'Received Today',
      'colorType': 'green',
      'icon': Icons.inventory_2_outlined,
    },
  ];

  static final List<Map<String, dynamic>> inventoryHealth = [
    {
      'category': 'Stationery',
      'status': 'Healthy',
      'colorType': 'green',
    },
    {
      'category': 'Library Supplies',
      'status': 'Healthy',
      'colorType': 'green',
    },
    {
      'category': 'Maintenance Supplies',
      'status': 'Recently Restocked',
      'colorType': 'blue',
    },
    {
      'category': 'Laboratory',
      'status': 'Needs Restocking',
      'colorType': 'yellow',
    },
    {
      'category': 'Computer Equipment',
      'status': 'Procurement Active',
      'colorType': 'purple',
    },
    {
      'category': 'Sports',
      'status': 'Critical Stock Level',
      'colorType': 'red',
    },
  ];

  static final List<Map<String, dynamic>> damagedMissingItems = [
    {
      'title': 'Projector',
      'location': 'Computer Lab',
      'status': 'Reported Damaged',
      'colorType': 'red',
      'icon': Icons.warning_amber_rounded,
    },
    {
      'title': 'Basketball Set',
      'location': 'Sports Department',
      'status': 'Missing Inventory',
      'colorType': 'yellow',
      'icon': Icons.inventory_2_outlined,
    },
    {
      'title': 'Classroom Chairs × 6',
      'location': 'Block B',
      'status': 'Pending Inspection',
      'colorType': 'orange',
      'icon': Icons.build_outlined,
    },
    {
      'title': 'Bunsen Burner',
      'location': 'Chemistry Lab',
      'status': 'Sent for Repair',
      'colorType': 'blue',
      'icon': Icons.build_outlined,
    },
    {
      'title': 'Library Tablet',
      'location': 'Library',
      'status': 'Missing Inventory',
      'colorType': 'yellow',
      'icon': Icons.inventory_2_outlined,
    },
    {
      'title': 'Whiteboard',
      'location': 'Grade 7C',
      'status': 'Reported Damaged',
      'colorType': 'red',
      'icon': Icons.warning_amber_rounded,
    },
  ];

  static final List<Map<String, dynamic>> departmentUsage = [
    {
      'department': 'Science Department',
      'items': '328 active items',
      'usage': 0.95,
      'colorType': 'green',
    },
    {
      'department': 'Sports Department',
      'items': '218 active items',
      'usage': 0.65,
      'colorType': 'red',
    },
    {
      'department': 'Administration',
      'items': '145 active items',
      'usage': 0.45,
      'colorType': 'blue',
    },
    {
      'department': 'Library',
      'items': '186 active items',
      'usage': 0.55,
      'colorType': 'lightBlue',
    },
    {
      'department': 'Computer Lab',
      'items': '162 active items',
      'usage': 0.5,
      'colorType': 'purple',
    },
    {
      'department': 'Maintenance',
      'items': '94 active items',
      'usage': 0.3,
      'colorType': 'orange',
    },
  ];

  static final List<Map<String, dynamic>> assetMonitoring = [
    {
      'title': 'Smart Boards',
      'total': '20 total units',
      'operational': 18,
      'operationalLabel': 'Operational: 18',
      'status': '2 Under Repair',
      'statusColor': 'orange',
      'icon': Icons.desktop_windows_outlined,
      'healthValue': 18 / 20,
    },
    {
      'title': 'Projectors',
      'total': '13 total units',
      'operational': 12,
      'operationalLabel': 'Operational: 12',
      'status': '1 Maintenance',
      'statusColor': 'yellow',
      'icon': Icons.videocam_outlined,
      'healthValue': 12 / 13,
    },
    {
      'title': 'Computers',
      'total': '100 total units',
      'operational': 96,
      'operationalLabel': 'Operational: 96',
      'status': '4 Under Service',
      'statusColor': 'lightBlue',
      'icon': Icons.computer_outlined,
      'healthValue': 96 / 100,
    },
    {
      'title': 'Lab Instruments',
      'total': '87 total units',
      'operational': 64,
      'operationalLabel': 'Operational: 64',
      'status': '3 Calibration Due',
      'statusColor': 'purple',
      'icon': Icons.science_outlined,
      'healthValue': 64 / 87,
    },
  ];

  static final List<Map<String, dynamic>> activityFeed = [
    {
      'title': 'Stationery Stock Received',
      'subtitle': '500 units logged to Stockroom A',
      'time': '09:15 AM',
      'icon': Icons.inventory_2,
      'colorType': 'green',
    },
    {
      'title': 'Purchase Request Submitted',
      'subtitle': 'Science Department - Microscope slides x 50',
      'time': '10:42 AM',
      'icon': Icons.assignment,
      'colorType': 'blue',
    },
    {
      'title': 'Inventory Audit Completed',
      'subtitle': 'Computer Lab - 0 discrepancies',
      'time': '11:20 AM',
      'icon': Icons.verified,
      'colorType': 'purple',
    },
    {
      'title': 'Vendor Shipment Dispatched',
      'subtitle': 'TechHub - 45 peripherals en route',
      'time': '12:05 PM',
      'icon': Icons.local_shipping,
      'colorType': 'purple',
    },
    {
      'title': 'Low Stock Alert Triggered',
      'subtitle': 'Printer paper - below threshold',
      'time': '01:35 PM',
      'icon': Icons.warning_amber_rounded,
      'colorType': 'orange',
    },
    {
      'title': 'Damage Reported',
      'subtitle': 'Projector - Computer Lab - ticket opened',
      'time': '02:20 PM',
      'icon': Icons.error_outline,
      'colorType': 'red',
    },
    {
      'title': 'New Inventory Added',
      'subtitle': 'Sports equipment - 28 items catalogued',
      'time': '03:00 PM',
      'icon': Icons.inventory_2,
      'colorType': 'green',
    },
  ];

  static final List<Map<String, dynamic>> alertsCenter = [
    {
      'title': '18 Items Below Minimum Stock',
      'subtitle': 'Across 4 categories',
      'icon': Icons.warning_amber_rounded,
      'colorType': 'yellow',
    },
    {
      'title': '3 Items Out of Stock',
      'subtitle': 'Sports & IT departments',
      'icon': Icons.inventory_2_outlined,
      'colorType': 'red',
    },
    {
      'title': '7 Purchase Requests Pending',
      'subtitle': 'Awaiting approval',
      'icon': Icons.assignment_outlined,
      'colorType': 'lightBlue',
    },
    {
      'title': '12 Damaged Items',
      'subtitle': 'Awaiting review',
      'icon': Icons.build_outlined,
      'colorType': 'orange',
    },
    {
      'title': 'Vendor Delivery Delayed',
      'subtitle': 'SportsPro - Restock ETA +2 days',
      'icon': Icons.schedule,
      'colorType': 'purple',
    },
  ];

  static final List<Map<String, dynamic>> todayHighlights = [
    {
      'value': '5',
      'subtitle': 'Deliveries Received',
      'icon': Icons.local_shipping_outlined,
      'colorType': 'green',
    },
    {
      'value': '18',
      'subtitle': 'Low Stock Items',
      'icon': Icons.warning_amber_rounded,
      'colorType': 'yellow',
    },
    {
      'value': '7',
      'subtitle': 'Purchase Requests',
      'icon': Icons.assignment_outlined,
      'colorType': 'blue',
    },
    {
      'value': '12',
      'subtitle': 'Damaged Items Reported',
      'icon': Icons.build_outlined,
      'colorType': 'orange',
    },
    {
      'value': '3',
      'subtitle': 'Critical Reorders',
      'icon': Icons.inventory_2_outlined,
      'colorType': 'red',
    },
    {
      'value': '0',
      'subtitle': 'Major Incidents',
      'icon': Icons.check_circle_outline,
      'colorType': 'green',
    },
  ];
}
