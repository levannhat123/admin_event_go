import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/core/constants/app_sizes.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/data/models/event/ticket_type_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin_event_go/core/constants/app_colors.dart';

class TicketTypeItemWidget extends StatelessWidget {
  final TicketTypeModel ticketType;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TicketTypeItemWidget({
    super.key,
    required this.ticketType,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.size12),
      padding: const EdgeInsets.all(AppSizes.size16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Tên vé và actions
          Row(
            children: [
              Expanded(
                child: Text(
                  ticketType.name,
                  style: const TextStyle(
                    fontSize: AppSizes.size16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slateDark,
                  ),
                ),
              ),
              if (ticketType.isFree == true)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.size8, vertical: AppSizes.size4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    AppStrings.ticketTypeFreeBadge,
                    style: TextStyle(
                      fontSize: AppSizes.size12,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(width: AppSizes.size8),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: onEdit,
                color: AppColors.brandPrimary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: AppSizes.size8),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: onDelete,
                color: Colors.red.shade400,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          // Mô tả
          if (ticketType.description != null && ticketType.description!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.size8),
            Text(
              ticketType.description!,
              style: TextStyle(
                fontSize: AppSizes.size14,
                color: Colors.grey.shade600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          const SizedBox(height: AppSizes.size12),

          // Chi tiết vé
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              // Giá vé
              if (ticketType.price != null)
                _buildInfoChip(
                  icon: Icons.attach_money,
                  label:
                      '${NumberFormat('#,###').format(ticketType.price)} VNĐ',
                  color: Colors.blue,
                ),

              if (ticketType.totalQuantity != null) ...{
                // Số lượng vé
                _buildInfoChip(
                  icon: Icons.confirmation_num,
                  label:
                      '${AppStrings.ticketTypeTotalQuantityPrefix}${ticketType.totalQuantity}',
                  color: Colors.teal,
                ),

              }  ,
              // Số lượng min
              if (ticketType.minQtyPerOrder != null)
                _buildInfoChip(
                  icon: Icons.arrow_downward,
                  label:
                      '${AppStrings.ticketTypeMinPrefix}${ticketType.minQtyPerOrder}',
                  color: Colors.orange,
                ),

              // Số lượng max
              if (ticketType.maxQtyPerOrder != null)
                _buildInfoChip(
                  icon: Icons.arrow_upward,
                  label:
                      '${AppStrings.ticketTypeMaxPrefix}${ticketType.maxQtyPerOrder}',
                  color: Colors.purple,
                ),

              // Trạng thái
              if (ticketType.status != null)
                _buildInfoChip(
                  icon: Icons.info_outline,
                  label: _getStatusLabel(ticketType.status!),
                  color: _getStatusColor(ticketType.status!),
                ),
            ],
          ),

          // Thời gian bán vé
          if (ticketType.startTime != null || ticketType.endTime != null) ...[
            const SizedBox(height: AppSizes.size12),
            Container(
              padding: const EdgeInsets.all(AppSizes.size12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: AppSizes.size8),
                  Expanded(
                    child: Text(
                      _getTimeRangeText(),
                      style: TextStyle(
                        fontSize: AppSizes.size13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.size10, vertical: AppSizes.size6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: AppSizes.size4),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSizes.size12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return AppStrings.ticketTypeStatusActive;
      case 'INACTIVE':
        return AppStrings.ticketTypeStatusInactive;
      case 'SOLD_OUT':
        return AppStrings.ticketTypeStatusSoldOut;
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return Colors.green;
      case 'INACTIVE':
        return Colors.orange;
      case 'SOLD_OUT':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getTimeRangeText() {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    if (ticketType.startTime != null && ticketType.endTime != null) {
      return '${AppStrings.ticketTypeSaleRangePrefix}'
          '${formatter.format(ticketType.startTime!)} - '
          '${formatter.format(ticketType.endTime!)}';
    } else if (ticketType.startTime != null) {
      return '${AppStrings.ticketTypeSaleStartPrefix}'
          '${formatter.format(ticketType.startTime!)}';
    } else if (ticketType.endTime != null) {
      return '${AppStrings.ticketTypeSaleEndPrefix}'
          '${formatter.format(ticketType.endTime!)}';
    }
    return '';
  }
}
