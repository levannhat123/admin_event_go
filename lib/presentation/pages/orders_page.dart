import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F172A),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF1E293B),
        title: Text(
          'Orders',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFF6366F1),
          labelColor: Color(0xFF6366F1),
          unselectedLabelColor: Colors.white60,
          tabs: [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Stats Cards
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Orders',
                    '1,234',
                    Icons.shopping_cart,
                    Color(0xFF6366F1),
                    [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Revenue',
                    '\$45.2K',
                    Icons.attach_money,
                    Color(0xFF10B981),
                    [Color(0xFF10B981), Color(0xFF06B6D4)],
                  ),
                ),
              ],
            ),
          ),

          // Orders List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOrdersList('all'),
                _buildOrdersList('pending'),
                _buildOrdersList('completed'),
                _buildOrdersList('cancelled'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    List<Color> gradient,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(String filter) {
    final orders = _getFilteredOrders(filter);

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.white24),
            SizedBox(height: 16),
            Text(
              'No ${filter == 'all' ? '' : filter} orders',
              style: TextStyle(color: Colors.white60, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  List<Map<String, dynamic>> _getFilteredOrders(String filter) {
    final allOrders = [
      {
        'id': '#ORD-001',
        'customerName': 'John Doe',
        'customerEmail': 'john.doe@example.com',
        'eventName': 'Summer Music Festival 2024',
        'tickets': '2x VIP Tickets',
        'amount': '\$250.00',
        'status': 'completed',
        'date': 'Jun 15, 2024',
        'time': '10:30 AM',
      },
      {
        'id': '#ORD-002',
        'customerName': 'Jane Smith',
        'customerEmail': 'jane.smith@example.com',
        'eventName': 'Tech Conference Asia',
        'tickets': '1x Regular Ticket',
        'amount': '\$80.00',
        'status': 'pending',
        'date': 'Jun 16, 2024',
        'time': '2:15 PM',
      },
      {
        'id': '#ORD-003',
        'customerName': 'Mike Johnson',
        'customerEmail': 'mike.j@example.com',
        'eventName': 'Food & Wine Expo',
        'tickets': '4x Standard Tickets',
        'amount': '\$320.00',
        'status': 'completed',
        'date': 'Jun 14, 2024',
        'time': '11:00 AM',
      },
      {
        'id': '#ORD-004',
        'customerName': 'Sarah Williams',
        'customerEmail': 'sarah.w@example.com',
        'eventName': 'Art Gallery Opening',
        'tickets': '2x Early Bird',
        'amount': '\$120.00',
        'status': 'cancelled',
        'date': 'Jun 13, 2024',
        'time': '9:45 AM',
      },
      {
        'id': '#ORD-005',
        'customerName': 'David Brown',
        'customerEmail': 'david.b@example.com',
        'eventName': 'Sports Championship',
        'tickets': '3x VIP Tickets',
        'amount': '\$450.00',
        'status': 'pending',
        'date': 'Jun 17, 2024',
        'time': '3:30 PM',
      },
    ];

    if (filter == 'all') return allOrders;
    return allOrders.where((order) => order['status'] == filter).toList();
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final statusColor = _getStatusColor(order['status'] as String);
    final statusIcon = _getStatusIcon(order['status'] as String);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Order Header
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.receipt_long,
                    color: statusColor,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            order['id'] as String,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(statusIcon, size: 14, color: statusColor),
                                SizedBox(width: 4),
                                Text(
                                  (order['status'] as String).toUpperCase(),
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: Colors.white60),
                          SizedBox(width: 4),
                          Text(
                            order['date'] as String,
                            style: TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.access_time, size: 12, color: Colors.white60),
                          SizedBox(width: 4),
                          Text(
                            order['time'] as String,
                            style: TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(color: Color(0xFF334155), height: 1),

          // Order Details
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Info
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Color(0xFF6366F1)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['customerName'] as String,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            order['customerEmail'] as String,
                            style: TextStyle(color: Colors.white60, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Event Info
                Row(
                  children: [
                    Icon(Icons.event, size: 16, color: Color(0xFFEC4899)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order['eventName'] as String,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Tickets & Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.confirmation_number, size: 16, color: Color(0xFFF59E0B)),
                        SizedBox(width: 8),
                        Text(
                          order['tickets'] as String,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    Text(
                      order['amount'] as String,
                      style: TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Actions
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF0F172A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.visibility, size: 16),
                    label: Text('View Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF6366F1),
                      side: BorderSide(color: Color(0xFF6366F1)),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.print, size: 16),
                    label: Text('Print'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Color(0xFF10B981);
      case 'pending':
        return Color(0xFFF59E0B);
      case 'cancelled':
        return Color(0xFFEF4444);
      default:
        return Color(0xFF64748B);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.check_circle;
      case 'pending':
        return Icons.access_time;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }
}
