import 'package:admin_event_go/core/base/base_view.dart';
import 'package:admin_event_go/core/constants/app_sizes.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/injection/injection.dart';
import 'package:admin_event_go/presentation/view_models/order_view_model.dart';
import 'package:admin_event_go/routers/router_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:admin_event_go/core/constants/app_colors.dart';

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
          backgroundColor: AppColors.slateDark,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: AppColors.slateCard,
            title: const Text(
              AppStrings.ordersTitle,
              style: TextStyle(
                  fontSize: AppSizes.size24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.indigoAccent,
              labelColor: AppColors.indigoAccent,
              unselectedLabelColor: Colors.white60,
              tabs: const [
                Tab(text: AppStrings.ordersTabAll),
                Tab(text: AppStrings.ordersTabCompleted),
                Tab(text: AppStrings.ordersTabCancelled),
              ],
            ),
          ),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: viewModel.ordersStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _buildEmptyState(
                    AppStrings.ordersErrorTitle,
                    "${AppStrings.ordersErrorLoading}: ${snapshot.error}");
              }
              if (!snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(color: AppColors.indigoAccent));
                }
                return _buildEmptyState(AppStrings.ordersTabAll, AppStrings.ordersEmpty);
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
      padding: const EdgeInsets.all(AppSizes.size16),
      child: Column(
        children: [
          _buildStatCard(
            AppStrings.totalOrders,
            totalOrdersStr,
            Icons.shopping_cart,
            AppColors.indigoAccent,
            const [AppColors.indigoAccent, AppColors.violetAccent],
          ),
          const SizedBox(height: AppSizes.size12),
          _buildStatCard(
            AppStrings.revenue,
            totalRevenueStr,
            Icons.attach_money,
            AppColors.emeraldAccent,
            const [AppColors.emeraldAccent, AppColors.cyanAccent],
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
      padding: const EdgeInsets.all(AppSizes.size16),
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
          const SizedBox(width: AppSizes.size12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: AppSizes.size20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.size4),
                Text(title,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: AppSizes.size12)),
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
      return _buildEmptyState(filter, AppStrings.ordersEmpty);
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
      padding: const EdgeInsets.all(AppSizes.size16),
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
          const SizedBox(height: AppSizes.size16),
          Text(
            message ??
                '${AppStrings.ordersEmptyWithFilterPrefix}'
                '${filter == 'all' ? '' : filter} '
                '${AppStrings.ordersEmptyWithFilterSuffix.trim()}',
            style: const TextStyle(
                color: Colors.white60, fontSize: AppSizes.size16),
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
    final String ticketsStr = '$totalTickets '
        '${totalTickets > 1 ? AppStrings.ticketPlural : AppStrings.ticketSingular}';

    return GestureDetector(
      onTap: () {
        context.push(RouterPath.orders_detail, extra: order);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.size16),
        decoration: BoxDecoration(
          color: AppColors.slateCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: statusColor.withOpacity(0.3), width: AppSizes.size1),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.size16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSizes.size12),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.receipt_long, color: statusColor, size: 24),
                  ),
                  const SizedBox(width: AppSizes.size12),
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
                                  fontSize: AppSizes.size14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: AppSizes.size12, vertical: AppSizes.size6),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(statusIcon, size: 14, color: statusColor),
                                  const SizedBox(width: AppSizes.size4),
                                  Text(
                                    status.toUpperCase(),
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: AppSizes.size11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.size8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 12, color: Colors.white60),
                            const SizedBox(width: AppSizes.size4),
                            Text(
                              dateStr,
                              style: const TextStyle(
                                  color: Colors.white60, fontSize: AppSizes.size12),
                            ),
                            const SizedBox(width: AppSizes.size12),
                            const Icon(Icons.access_time, size: 12, color: Colors.white60),
                            const SizedBox(width: AppSizes.size4),
                            Text(
                              timeStr,
                              style: const TextStyle(
                                  color: Colors.white60, fontSize: AppSizes.size12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.slateBorder, height: AppSizes.size1),
            Padding(
              padding: const EdgeInsets.all(AppSizes.size16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: AppColors.indigoAccent),
                      const SizedBox(width: AppSizes.size8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order['userEmail'] as String? ?? 'N/A',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: AppSizes.size14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.size12),
                  Row(
                    children: [
                      const Icon(Icons.event, size: 16, color: AppColors.pinkAccent),
                      const SizedBox(width: AppSizes.size8),
                      Expanded(
                        child: Text(
                          order['eventName'] as String? ?? 'N/A',
                          style: const TextStyle(
                              color: Colors.white, fontSize: AppSizes.size14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.size12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.confirmation_number, size: 16, color: AppColors.amberAccent),
                          const SizedBox(width: AppSizes.size8),
                          Text(ticketsStr,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: AppSizes.size14)),
                        ],
                      ),
                      Text(
                        amountStr,
                        style: const TextStyle(
                          color: AppColors.emeraldAccent,
                          fontSize: AppSizes.size18,
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
        return AppColors.emeraldAccent;
      case 'pending':
        return AppColors.amberAccent;
      case 'cancelled':
      case 'failed':
        return AppColors.redAccent;
      default:
        return AppColors.slateText;
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
