import 'package:admin_event_go/core/base/base_view.dart';
import 'package:admin_event_go/injection/injection.dart';
import 'package:admin_event_go/presentation/view_models/order_view_model.dart';
import 'package:admin_event_go/routers/router_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<OrderViewModel>(
      viewModelBuilder: () => getIt<OrderViewModel>(),
      autoDispose: false,
      padding: false,
      onModelReady: (viewModel) {
        viewModel.init();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF0F172A),
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: const Color(0xFF1E293B),
            title: const Text(
              'Orders',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF6366F1),
              labelColor: const Color(0xFF6366F1),
              unselectedLabelColor: Colors.white60,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: viewModel.ordersStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _buildEmptyState("Error", "Error loading orders: ${snapshot.error}");
              }
              if (!snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)));
                }
                return _buildEmptyState("All", "No orders found.");
              }

              final allOrders = snapshot.data!.docs;
              return Column(
                children: [
                  _buildDynamicStats(allOrders),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOrdersList(allOrders, 'all'),
                        _buildOrdersList(allOrders, 'completed'),
                        _buildOrdersList(allOrders, 'cancelled'),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDynamicStats(List<QueryDocumentSnapshot<Map<String, dynamic>>> allOrders) {
    String totalOrdersStr = allOrders.length.toString();
    double totalRevenue = 0.0;
    for (var doc in allOrders) {
      final data = doc.data();
      if (data['paymentStatus'] == 'completed') {
        totalRevenue += (data['totalAmount'] as num?)?.toDouble() ?? 0.0;
      }
    }
    var totalRevenueStr = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(totalRevenue);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStatCard(
            'Total Orders',
            totalOrdersStr,
            Icons.shopping_cart,
            const Color(0xFF6366F1),
            const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            'Revenue',
            totalRevenueStr,
            Icons.attach_money,
            const Color(0xFF10B981),
            const [Color(0xFF10B981), Color(0xFF06B6D4)],
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(title, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allOrders,
    String filter,
  ) {
    if (allOrders.isEmpty) {
      return _buildEmptyState(filter, "No orders found.");
    }

    final List<DocumentSnapshot<Map<String, dynamic>>> filteredOrders;

    if (filter == 'all') {
      filteredOrders = allOrders;
    } else {
      filteredOrders = allOrders.where((doc) {
        final status = (doc.data()['paymentStatus'] as String?)?.toLowerCase();
        return status == filter;
      }).toList();
    }

    if (filteredOrders.isEmpty) {
      return _buildEmptyState(filter, null);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final orderDoc = filteredOrders[index];
        final orderData = orderDoc.data();
        orderData!['id'] = orderDoc.id;
        return _buildOrderCard(orderData);
      },
    );
  }

  Widget _buildEmptyState(String filter, String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long, size: 64, color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            message ?? 'No ${filter == 'all' ? '' : filter} orders',
            style: const TextStyle(color: Colors.white60, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final String status = order['paymentStatus'] as String? ?? 'unknown';
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);
    final orderDate = (order['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
    final String dateStr = DateFormat('MMM dd, yyyy').format(orderDate);
    final String timeStr = DateFormat('h:mm a').format(orderDate);

    final double amount = (order['totalAmount'] as num?)?.toDouble() ?? 0.0;
    final String amountStr = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(amount);
    final ticketsList = (order['tickets'] as List<dynamic>?) ?? [];
    final int totalTickets = ticketsList.fold<int>(
      0,
      (sum, item) => sum + (item['quantity'] as int? ?? 0),
    );
    final String ticketsStr = '$totalTickets ${totalTickets > 1 ? 'tickets' : 'ticket'}';

    return GestureDetector(
      onTap: () {
       context.push(RouterPath.orders_detail, extra: order['id']);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.receipt_long, color: statusColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${order['id'] as String}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(statusIcon, size: 14, color: statusColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    status.toUpperCase(),
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
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 12, color: Colors.white60),
                            const SizedBox(width: 4),
                            Text(
                              dateStr,
                              style: const TextStyle(color: Colors.white60, fontSize: 12),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.access_time, size: 12, color: Colors.white60),
                            const SizedBox(width: 4),
                            Text(
                              timeStr,
                              style: const TextStyle(color: Colors.white60, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF334155), height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Color(0xFF6366F1)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order['userEmail'] as String? ?? 'N/A',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.event, size: 16, color: Color(0xFFEC4899)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          order['eventName'] as String? ?? 'N/A',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.confirmation_number, size: 16, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 8),
                          Text(ticketsStr, style: const TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                      Text(
                        amountStr,
                        style: const TextStyle(
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

          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'cancelled':
      case 'failed':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF64748B);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.check_circle;
      case 'pending':
        return Icons.access_time;
      case 'cancelled':
      case 'failed':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }
}
