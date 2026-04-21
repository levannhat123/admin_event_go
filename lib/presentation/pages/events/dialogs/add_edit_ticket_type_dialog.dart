import 'package:admin_event_go/core/constants/app_colors.dart';
import 'package:admin_event_go/core/constants/app_sizes.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/core/widgets/app_elevated_button.dart';
import 'package:admin_event_go/core/widgets/custom_dropdown.dart';
import 'package:admin_event_go/core/widgets/custom_switch.dart';
import 'package:admin_event_go/core/widgets/text_field.dart';
import 'package:admin_event_go/data/models/event/ticket_type_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddEditTicketTypeDialog extends StatefulWidget {
  final TicketTypeModel? ticketType;

  const AddEditTicketTypeDialog({super.key, this.ticketType});

  @override
  State<AddEditTicketTypeDialog> createState() =>
      _AddEditTicketTypeDialogState();
}

class _AddEditTicketTypeDialogState extends State<AddEditTicketTypeDialog> {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final maxQtyController = TextEditingController();
  final minQtyController = TextEditingController();
  final totalQuantity = TextEditingController();

  bool isFree = false;
  String? status = 'ACTIVE';
  DateTime? startTime;
  DateTime? endTime;

  @override
  void initState() {
    super.initState();
    if (widget.ticketType != null) {
      nameController.text = widget.ticketType!.name;
      descController.text = widget.ticketType!.description ?? '';
      priceController.text = widget.ticketType!.price?.toString() ?? '';
      maxQtyController.text =
          widget.ticketType!.maxQtyPerOrder?.toString() ?? '';
      minQtyController.text =
          widget.ticketType!.minQtyPerOrder?.toString() ?? '';
      totalQuantity.text = widget.ticketType!.totalQuantity?.toString() ?? '';
      isFree = widget.ticketType!.isFree ?? false;
      status = widget.ticketType!.status ?? 'ACTIVE';
      startTime = widget.ticketType!.startTime;
      endTime = widget.ticketType!.endTime;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    maxQtyController.dispose();
    minQtyController.dispose();
    totalQuantity.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartTime) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartTime
          ? (startTime ?? DateTime.now())
          : (endTime ?? startTime ?? DateTime.now()),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.brandPrimary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (!mounted) return;

      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.brandPrimary,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime == null || !mounted) return;
      final DateTime fullDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      setState(() {
        if (isStartTime) {
          startTime = fullDateTime;
        } else {
          endTime = fullDateTime;
        }
      });
    }
  }

  Widget _buildDateTimeField({
    required String label,
    required DateTime? dateTime,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.size12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.brandPrimary, size: 20),
            const SizedBox(width: AppSizes.size12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: AppSizes.size11,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSizes.size4),
                  Text(
                    dateTime != null
                        ? DateFormat('dd/MM/yyyy - HH:mm').format(dateTime)
                        : AppStrings.notAvailableShort,
                    style: TextStyle(
                      fontSize: AppSizes.size14,
                      color: dateTime != null
                          ? Colors.black87
                          : Colors.grey.shade400,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.calendar_today, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }

  void _saveTicketType() {
    if (nameController.text.trim().isEmpty) {
      _showErrorDialog(AppStrings.ticketTypeNameRequired);
      return;
    }

    if (!isFree && priceController.text.trim().isEmpty) {
      _showErrorDialog(AppStrings.ticketTypePriceRequired);
      return;
    }

    final ticketType = TicketTypeModel(
      id: widget.ticketType?.id ?? const Uuid().v4(),
      name: nameController.text.trim(),
      description: descController.text.trim().isEmpty
          ? null
          : descController.text.trim(),
      isFree: isFree,
      price: isFree ? 0 : (int.tryParse(priceController.text.trim()) ?? 0),
      maxQtyPerOrder: int.tryParse(maxQtyController.text.trim()),
      minQtyPerOrder: int.tryParse(minQtyController.text.trim()),
      totalQuantity: int.tryParse(totalQuantity.text.trim()),
      status: status,
      startTime: startTime,
      endTime: endTime,
    );

    Navigator.of(context).pop(ticketType);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.errorTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text(AppStrings.closeButton),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSizes.size20),
              decoration: BoxDecoration(
                color: AppColors.brandPrimary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.confirmation_number,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: AppSizes.size12),
                  Expanded(
                    child: Text(
                      widget.ticketType == null
                          ? AppStrings.ticketTypeDialogTitleAdd
                          : AppStrings.ticketTypeDialogTitleEdit,
                      style: const TextStyle(
                        fontSize: AppSizes.size20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Form
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.size20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      lableText: AppStrings.ticketTypeNameLabel,
                      controller: nameController,
                      borderColor: Colors.grey.shade300,
                      fillColor: Colors.grey.shade100,
                      focusedBorderColor: AppColors.brandPrimary,
                      enabledBorderColor: Colors.grey.shade300,
                      shadowColor: AppColors.transparent,
                    ),
                    const SizedBox(height: AppSizes.size12),
                    AppTextField(
                      lableText: AppStrings.ticketTypeDescriptionLabel,
                      controller: descController,
                      maxLines: 3,
                      borderColor: Colors.grey.shade300,
                      fillColor: Colors.grey.shade100,
                      focusedBorderColor: AppColors.brandPrimary,
                      enabledBorderColor: Colors.grey.shade300,
                      shadowColor: AppColors.transparent,
                    ),
                    const SizedBox(height: AppSizes.size12),
                    CustomSwitch(
                      label: AppStrings.ticketTypeFreeLabel,
                      value: isFree,
                      onChanged: (v) => setState(() {
                        isFree = v;
                        if (v) {
                          priceController.text = '0';
                        }
                      }),
                    ),
                    const SizedBox(height: AppSizes.size12),
                    AppTextField(
                      lableText: AppStrings.ticketTypePriceLabel,
                      controller: priceController,
                      borderColor: Colors.grey.shade300,
                      fillColor: isFree
                          ? Colors.grey.shade200
                          : Colors.grey.shade100,
                      focusedBorderColor: AppColors.brandPrimary,
                      enabledBorderColor: Colors.grey.shade300,
                      shadowColor: AppColors.transparent,
                    ),
                    const SizedBox(height: AppSizes.size12),
                    AppTextField(
                      lableText: AppStrings.ticketTypeTotalQuantityLabel,
                      controller: totalQuantity,
                      borderColor: Colors.grey.shade300,
                      fillColor: Colors.grey.shade100,
                      focusedBorderColor: AppColors.brandPrimary,
                      enabledBorderColor: Colors.grey.shade300,
                      shadowColor: AppColors.transparent,
                    ),
                    const SizedBox(height: AppSizes.size12),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            lableText: AppStrings.ticketTypeMinPerOrderLabel,
                            controller: minQtyController,
                            borderColor: Colors.grey.shade300,
                            fillColor: Colors.grey.shade100,
                            focusedBorderColor: AppColors.brandPrimary,
                            enabledBorderColor: Colors.grey.shade300,
                            shadowColor: AppColors.transparent,
                          ),
                        ),
                        const SizedBox(width: AppSizes.size12),
                        Expanded(
                          child: AppTextField(
                            lableText: AppStrings.ticketTypeMaxPerOrderLabel,
                            controller: maxQtyController,
                            borderColor: Colors.grey.shade300,
                            fillColor: Colors.grey.shade100,
                            focusedBorderColor: AppColors.brandPrimary,
                            enabledBorderColor: Colors.grey.shade300,
                            shadowColor: AppColors.transparent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.size12),
                    CustomDropdown<String>(
                      label: AppStrings.ticketTypeStatusLabel,
                      items: ['ACTIVE', 'INACTIVE', 'SOLD_OUT'],
                      value: status,
                      getLabel: (v) {
                        switch (v) {
                          case 'ACTIVE':
                            return AppStrings.ticketTypeStatusActive;
                          case 'INACTIVE':
                            return AppStrings.ticketTypeStatusInactive;
                          case 'SOLD_OUT':
                            return AppStrings.ticketTypeStatusSoldOut;
                          default:
                            return v;
                        }
                      },
                      onChanged: (v) => setState(() => status = v),
                    ),
                    const SizedBox(height: AppSizes.size12),
                    const Text(
                      AppStrings.ticketTypeSaleTimeTitle,
                      style: TextStyle(
                        fontSize: AppSizes.size14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slateDark,
                      ),
                    ),
                    const SizedBox(height: AppSizes.size8),
                    _buildDateTimeField(
                      label: AppStrings.ticketTypeSaleStartLabel,
                      dateTime: startTime,
                      onTap: () => _selectDateTime(context, true),
                      icon: Icons.access_time,
                    ),
                    const SizedBox(height: AppSizes.size8),
                    _buildDateTimeField(
                      label: AppStrings.ticketTypeSaleEndLabel,
                      dateTime: endTime,
                      onTap: () => _selectDateTime(context, false),
                      icon: Icons.event_available,
                    ),
                  ],
                ),
              ),
            ),
            // Footer buttons
            Container(
              padding: const EdgeInsets.all(AppSizes.size20),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppElevatedButton(
                      onPressed: () => context.pop(),
                      text: AppStrings.ticketTypeDialogCancel,
                      borderColor: Colors.grey.shade300,
                      color: Colors.white,
                      textColor: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: AppSizes.size12),
                  Expanded(
                    child: AppElevatedButton(
                      onPressed: _saveTicketType,
                      text: widget.ticketType == null
                          ? AppStrings.ticketTypeDialogAdd
                          : AppStrings.ticketTypeDialogUpdate,
                      borderColor: AppColors.brandPrimary,
                      color: AppColors.brandPrimary,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
