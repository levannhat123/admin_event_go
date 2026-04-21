import 'package:admin_event_go/core/constants/app_sizes.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin_event_go/core/constants/app_colors.dart';

class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> orderData;
  const OrderDetailScreen({Key? key, required this.orderData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slateDark,
      appBar: AppBar(
        backgroundColor: AppColors.slateCard,
        title: const Text(
          AppStrings.orderDetailTitle,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.size16),
        child: _buildBodyContent(orderData),
      ),
    );
  }

  Widget _buildBodyContent(Map<String, dynamic> order) {
    final tickets = order['tickets'] as List<dynamic>? ?? [];
    DateTime? createdAt;
    if (order['createdAt'] is Timestamp) {
      createdAt = (order['createdAt'] as Timestamp).toDate();
    } else if (order['createdAt'] is DateTime) {
      createdAt = order['createdAt'];
    }

    DateTime? checkinTimestamp;
    if (order['checkinTimestamp'] is Timestamp) {
      checkinTimestamp = (order['checkinTimestamp'] as Timestamp).toDate();
    }

    return Column(
      children: [
        _headerCard(order),
        const SizedBox(height: AppSizes.size20),
        _infoSection(
          title: AppStrings.orderUserInformation,
          icon: Icons.person,
          children: [_infoRow(AppStrings.emailLabel, order["userEmail"])],
        ),
        const SizedBox(height: AppSizes.size20),
        _infoSection(
          title: AppStrings.orderEventInformation,
          icon: Icons.event,
          children: [
            _infoRow(AppStrings.eventNameLabel, order["eventName"]),
            _infoRow(AppStrings.venueLabel, order["venue"]),
          ],
        ),
        const SizedBox(height: AppSizes.size20),
        _infoSection(
          title: AppStrings.orderInfo,
          icon: Icons.receipt_long,
          children: [
            _infoRow(
              AppStrings.orderTotalAmount,
              NumberFormat.currency(
                locale: 'vi_VN',
                symbol: 'đ',
              ).format(order["totalAmount"] ?? 0),
            ),
            _infoRow(AppStrings.orderPaymentMethod, order["paymentMethod"]),
            _infoRow(AppStrings.orderPaymentStatus, order["paymentStatus"]),
            _infoRow(
              AppStrings.orderCreatedAt,
              createdAt != null
                  ? DateFormat('dd/MM/yyyy HH:mm').format(createdAt)
                  : AppStrings.notAvailableShort,
            ),
          ],
        ),
        const SizedBox(height: AppSizes.size20),
        _infoSection(
          title: AppStrings.orderCheckinStatusTitle,
          icon: Icons.qr_code_scanner,
          children: [
            _infoRow(
              AppStrings.orderCheckinStatus,
              order["checkinStatus"] ?? 'pending',
            ),
            _infoRow(
              AppStrings.orderCheckedIn,
              "${order["checkedIn"] ?? 0} người",
            ),
            _infoRow(
              AppStrings.orderCheckinTime,
              checkinTimestamp != null
                  ? DateFormat('dd/MM/yyyy HH:mm').format(checkinTimestamp)
                  : AppStrings.orderCheckinTimeNotYet,
            ),
          ],
        ),
        const SizedBox(height: AppSizes.size20),
        _ticketSection(tickets),
      ],
    );
  }

  Widget _headerCard(Map<String, dynamic> order) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.size20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.indigoAccent, AppColors.violetAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt, size: 40, color: Colors.white),
          const SizedBox(width: AppSizes.size16),
          Expanded(
            child: Text(
              order["id"]?.toString() ?? "N/A",
              style: const TextStyle(
                color: Colors.white,
                fontSize: AppSizes.size20,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
  Widget _infoSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.size16),
      decoration: BoxDecoration(
        color: AppColors.slateCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.indigoAccent),
              const SizedBox(width: AppSizes.size8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppSizes.size18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.size12),
          ...children,
        ],
      ),
    );
  }

  Widget _ticketSection(List tickets) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.size16),
      decoration: BoxDecoration(
        color: AppColors.slateCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.confirmation_number, color: AppColors.amberAccent),
              SizedBox(width: AppSizes.size8),
              Text(
                AppStrings.orderTickets,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppSizes.size18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.size12),
          if (tickets.isEmpty)
            const Text(
              "Không có thông tin vé",
              style: TextStyle(color: Colors.white54),
            ),
          ...tickets.map((t) {
            return Container(
              margin: const EdgeInsets.only(bottom: AppSizes.size10),
              padding: const EdgeInsets.all(AppSizes.size14),
              decoration: BoxDecoration(
                color: AppColors.slateBorder,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t["name"]?.toString() ?? AppStrings.unknownText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppSizes.size16,
                    ),
                  ),
                  Text(
                    "x${t["quantity"]}",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: AppSizes.size14,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.size6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Flexible(
            child: Text(
              value ?? AppStrings.notAvailableShort,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
