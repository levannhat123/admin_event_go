import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title:
            const Text(AppStrings.orderDetailTitle, style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("tickets")
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(AppStrings.orderNotFound,
                  style: TextStyle(color: Colors.white)),
            );
          }

          final order = snapshot.data!.data()!;
          order["id"] = orderId;

          final tickets = order['tickets'] as List<dynamic>? ?? [];
          final createdAt = (order['createdAt'] as Timestamp?)?.toDate();
          final checkinTimestamp =
          (order['checkinTimestamp'] as Timestamp?)?.toDate();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _headerCard(order),

                const SizedBox(height: 20),
                _infoSection(
                  title: AppStrings.orderUserInformation,
                  icon: Icons.person,
                  children: [
                    _infoRow(AppStrings.emailLabel, order["userEmail"]),
                  ],
                ),

                const SizedBox(height: 20),
                _infoSection(
                  title: AppStrings.orderEventInformation,
                  icon: Icons.event,
                  children: [
                    _infoRow(AppStrings.eventNameLabel, order["eventName"]),
                    _infoRow(AppStrings.venueLabel, order["venue"]),
                  ],
                ),

                const SizedBox(height: 20),
                _infoSection(
                  title: AppStrings.orderInfo,
                  icon: Icons.receipt_long,
                  children: [
                    _infoRow(
                      AppStrings.orderTotalAmount,
                      NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
                          .format(order["totalAmount"]),
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

                const SizedBox(height: 20),
                _infoSection(
                  title: AppStrings.orderCheckinStatusTitle,
                  icon: Icons.qr_code_scanner,
                  children: [
                    _infoRow(AppStrings.orderCheckinStatus, order["checkinStatus"]),
                    _infoRow(AppStrings.orderCheckedIn, "${order["checkedIn"]} người"),
                    _infoRow(
                      AppStrings.orderCheckinTime,
                      checkinTimestamp != null
                          ? DateFormat('dd/MM/yyyy HH:mm')
                          .format(checkinTimestamp)
                          : AppStrings.orderCheckinTimeNotYet,
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                _ticketSection(tickets),
              ],
            ),
          );
        },
      ),
    );
  }

  // HEADER CARD
  Widget _headerCard(Map<String, dynamic> order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt, size: 40, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              order["id"],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
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

  // SECTION CARD
  Widget _infoSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF6366F1)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  // TICKET LIST
  Widget _ticketSection(List tickets) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.confirmation_number, color: Color(0xFFF59E0B)),
              SizedBox(width: 8),
              Text(AppStrings.orderTickets,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          ...tickets.map((t) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF334155),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(t["name"] ?? AppStrings.unknownText,
                      style:
                      const TextStyle(color: Colors.white, fontSize: 16)),
                  Text("x${t["quantity"]}",
                      style:
                      const TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // ROW ITEM
  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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
