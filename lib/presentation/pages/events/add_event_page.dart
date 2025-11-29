import 'package:admin_event_go/core/widgets/app_elevated_button.dart';
import 'package:admin_event_go/core/widgets/custom_dropdown.dart';
import 'package:admin_event_go/core/widgets/custom_switch.dart';
import 'package:admin_event_go/core/widgets/image_picker_widget.dart';
import 'package:admin_event_go/core/widgets/text_field.dart';
import 'package:admin_event_go/data/models/event/ticket_type_model.dart';
import 'package:admin_event_go/data/models/event/event_detail_model.dart';
import 'package:admin_event_go/data/models/category/category_model.dart';
import 'package:admin_event_go/presentation/widgets/ticket_type_item_widget.dart';
import 'package:admin_event_go/presentation/view_models/event_view_model.dart';
import 'package:admin_event_go/data/services/supabase_storage_service.dart';
import 'package:admin_event_go/injection/injection.dart';
import 'package:admin_event_go/core/base/base_view.dart';
import 'package:admin_event_go/presentation/view_models/category_view_model.dart';
import 'package:admin_event_go/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import 'dialogs/add_edit_ticket_type_dialog.dart';

class AddEventPage extends StatefulWidget {
  final EventDetailModel? event;
  final bool? isEditing;
  const AddEventPage({super.key, this.event, this.isEditing});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();

  bool get isEdit => widget.isEditing ?? widget.event != null;
  Future<void> _selectDateTime(BuildContext context, bool isStartTime, EventViewModel vm) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartTime
          ? (vm.startTime ?? DateTime.now())
          : (vm.endTime ?? vm.startTime ?? DateTime.now()),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4257b4),
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
                primary: Color(0xFF4257b4),
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );
      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        if (mounted) {
          if (isStartTime) {
            vm.setStartTime(fullDateTime);
          } else {
            vm.setEndTime(fullDateTime);
          }
        }
      }
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF4257b4), size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateTime != null
                        ? DateFormat('dd/MM/yyyy - HH:mm').format(dateTime)
                        : 'Chưa chọn',
                    style: TextStyle(
                      fontSize: 16,
                      color: dateTime != null ? Colors.black87 : Colors.grey.shade400,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.calendar_today, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(color: Colors.grey.shade300, thickness: 1),
    );
  }

  void _saveEvent(EventViewModel vm) async {
    if (vm.titleController.text.trim().isEmpty) {
      _showErrorDialog('Vui lòng nhập tiêu đề sự kiện');
      return;
    }
    if (vm.descController.text.trim().isEmpty) {
      _showErrorDialog('Vui lòng nhập mô tả sự kiện');
      return;
    }
    if (vm.locationController.text.trim().isEmpty) {
      _showErrorDialog('Vui lòng nhập địa điểm tổ chức');
      return;
    }
    if (vm.startTime == null) {
      _showErrorDialog('Vui lòng chọn thời gian bắt đầu');
      return;
    }
    if (vm.endTime == null) {
      _showErrorDialog('Vui lòng chọn thời gian kết thúc');
      return;
    }
    if (vm.endTime!.isBefore(vm.startTime!)) {
      _showErrorDialog('Thời gian kết thúc phải sau thời gian bắt đầu');
      return;
    }
    if (vm.bannerImageFile == null &&
        !(isEdit && vm.existingBannerUrl != null && vm.existingBannerUrl!.isNotEmpty)) {
      _showErrorDialog('Vui lòng chọn ảnh banner');
      return;
    }

    if (vm.status == null) {
      _showErrorDialog('Vui lòng chọn trạng thái');
      return;
    }

    if (vm.selectedCategory == null) {
      _showErrorDialog('Vui lòng chọn danh mục');
      return;
    }

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final storageService = getIt<SupabaseStorageService>();
      final eventViewModel = vm;
      String? bannerUrl;
      if (vm.bannerImageFile != null) {
        bannerUrl = await storageService.uploadImage(
          imageFile: vm.bannerImageFile!,
          bucket: 'event_go_image',
          folder: 'banners',
        );
      } else if (isEdit) {
        bannerUrl = vm.existingBannerUrl;
      }
      String? logoUrl;
      if (vm.logoImageFile != null) {
        logoUrl = await storageService.uploadImage(
          imageFile: vm.logoImageFile!,
          bucket: 'event_go_image',
          folder: 'logos',
        );
      } else if (isEdit) {
        logoUrl = vm.existingLogoUrl;
      }
      final eventId = isEdit ? widget.event!.id : const Uuid().v4();
      final event = EventDetailModel(
        id: eventId,
        title: vm.titleController.text.trim(),
        bannerURL: bannerUrl,
        description: vm.descController.text.trim(),
        venue: vm.locationController.text.trim(),
        categories: vm.selectedCategory!,
        address: vm.addressController.text.trim().isNotEmpty
            ? vm.addressController.text.trim()
            : null,
        orgLogoURL: logoUrl,
        orgName: vm.orgNameController.text.trim().isNotEmpty
            ? vm.orgNameController.text.trim()
            : null,
        orgDescription: vm.orgDescController.text.trim().isNotEmpty
            ? vm.orgDescController.text.trim()
            : null,
        status: vm.status,
        minTicketPrice: vm.minPriceController.text.trim().isNotEmpty
            ? int.tryParse(vm.minPriceController.text.trim())
            : null,
        isFree: vm.isFree,
        ticketType: vm.ticketTypes.isNotEmpty ? vm.ticketTypes : null,
        startTime: vm.startTime,
        endTime: vm.endTime,
        locationId: vm.idLocationController.text.trim().isNotEmpty
            ? vm.idLocationController.text.trim()
            : null,
        isHot: vm.isHot,
      );
      bool success;
      if (isEdit) {
        success = await eventViewModel.updateEvent(eventId, event);
      } else {
        success = await eventViewModel.addEvent(event);
      }
      if (!mounted) return;
      context.pop();

      if (success) {
        _showSuccessDialog('Lưu sự kiện thành công!');
      } else {
        _showErrorDialog(eventViewModel.errorMessage ?? 'Có lỗi xảy ra khi lưu sự kiện');
      }
    } catch (e) {
      if (!mounted) return;
      context.pop();
      _showErrorDialog('Có lỗi xảy ra: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [TextButton(onPressed: () => context.pop(), child: const Text('Đóng'))],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thành công'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
             context.push(RouterPath.events);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddEditTicketTypeDialog(
    EventViewModel vm, {
    TicketTypeModel? ticketType,
  }) async {
    final result = await showDialog<TicketTypeModel>(
      context: context,
      builder: (context) => AddEditTicketTypeDialog(ticketType: ticketType),
    );
    if (result != null) {
      if (ticketType == null) {
        vm.addTicketType(result);
      } else {
        vm.updateTicketType(result);
      }
    }
  }

  void _deleteTicketType(String id, EventViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa loại vé này?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              vm.deleteTicketType(id);
              context.pop();
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {

    getIt<EventViewModel>().clearForm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: Text(isEdit ? 'Chỉnh sửa sự kiện' : 'Thêm sự kiện mới'),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: BaseView<EventViewModel>(
        viewModelBuilder: () => getIt<EventViewModel>(),
        onModelReady: (vm) {
          if (isEdit) {
            vm.loadEventForEdit(widget.event!);
          } else {
            vm.clearForm();
          }
        },
        builder: (context, vm, child) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('📋 Thông tin cơ bản'),
                          AppTextField(
                            lableText: 'Tiêu đề',
                            controller: vm.titleController,
                            borderColor: Colors.grey.shade300,
                            fillColor: Colors.grey.shade100,
                            focusedBorderColor: const Color(0xFF4257b4),
                            enabledBorderColor: Colors.grey.shade300,
                            shadowColor: AppColors.transparent,
                          ),
                          const SizedBox(height: 10),

                          // Ảnh banner
                          ImagePickerWidget(
                            label: 'Ảnh banner sự kiện',
                            imageFile: vm.bannerImageFile,
                            imageUrl: vm.existingBannerUrl,
                            height: 180,
                            onImageSelected: (file) {
                              vm.setBannerImage(file);
                            },
                          ),
                          const SizedBox(height: 10),

                          AppTextField(
                            lableText: 'Mô tả sự kiện',
                            controller: vm.descController,
                            maxLines: 4,
                            borderColor: Colors.grey.shade300,
                            fillColor: Colors.grey.shade100,
                            focusedBorderColor: const Color(0xFF4257b4),
                            enabledBorderColor: Colors.grey.shade300,
                            shadowColor: AppColors.transparent,
                          ),
                          const SizedBox(height: 10),

                          CustomDropdown<String>(
                            label: 'Trạng thái',
                            items: ['ACTIVE', 'INACTIVE', 'COMPLETED'],
                            value: vm.status,
                            getLabel: (v) {
                              switch (v) {
                                case 'ACTIVE':
                                  return 'Đang hoạt động';
                                case 'INACTIVE':
                                  return 'Tạm dừng';
                                case 'COMPLETED':
                                  return 'Đã kết thúc';
                                default:
                                  return v;
                              }
                            },
                            onChanged: (v) => vm.setStatus(v!),
                          ),
                          const SizedBox(height: 10),

                          BaseView<CategoryViewModel>(
                            padding: false,
                            viewModelBuilder: () => getIt<CategoryViewModel>(),
                            onModelReady: (catVm) => catVm.watchAll(),
                            builder: (context, catVm, child) {
                              if (catVm.isBusy && catVm.categories.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Center(
                                    child: SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  ),
                                );
                              }

                              return CustomDropdown<CategoryModel>(
                                label: 'Danh mục',
                                items: catVm.categories,
                                value: vm.selectedCategory,
                                getLabel: (c) => c.name,
                                onChanged: (v) => vm.setCategory(v!),
                              );
                            },
                          ),

                          _buildDivider(),
                          _buildSectionTitle('📍 Địa điểm tổ chức'),
                          AppTextField(
                            lableText: 'Địa điểm tổ chức (Venue)',
                            controller: vm.locationController,
                            borderColor: Colors.grey.shade300,
                            fillColor: Colors.grey.shade100,
                            focusedBorderColor: const Color(0xFF4257b4),
                            enabledBorderColor: Colors.grey.shade300,
                            shadowColor: AppColors.transparent,
                          ),
                          const SizedBox(height: 10),
                          AppTextField(
                            lableText: 'Địa chỉ chi tiết',
                            controller: vm.addressController,
                            borderColor: Colors.grey.shade300,
                            fillColor: Colors.grey.shade100,
                            focusedBorderColor: const Color(0xFF4257b4),
                            enabledBorderColor: Colors.grey.shade300,
                            shadowColor: AppColors.transparent,
                          ),
                          const SizedBox(height: 10),

                          AppTextField(
                            lableText: 'ID địa điểm',
                            controller: vm.idLocationController,
                            borderColor: Colors.grey.shade300,
                            fillColor: Colors.grey.shade100,
                            focusedBorderColor: const Color(0xFF4257b4),
                            enabledBorderColor: Colors.grey.shade300,
                            shadowColor: AppColors.transparent,
                          ),
                          _buildDivider(),
                          _buildSectionTitle('🕒 Thời gian'),
                          _buildDateTimeField(
                            label: 'Thời gian bắt đầu',
                            dateTime: vm.startTime,
                            onTap: () => _selectDateTime(context, true, vm),
                            icon: Icons.access_time,
                          ),
                          const SizedBox(height: 10),

                          _buildDateTimeField(
                            label: 'Thời gian kết thúc',
                            dateTime: vm.endTime,
                            onTap: () => _selectDateTime(context, false, vm),
                            icon: Icons.event_available,
                          ),
                          _buildDivider(),
                          _buildSectionTitle('💰 Thông tin giá vé'),
                          AppTextField(
                            lableText: 'Giá vé tối thiểu (VNĐ)',
                            controller: vm.minPriceController,
                            borderColor: Colors.grey.shade300,
                            fillColor: Colors.grey.shade100,
                            focusedBorderColor: const Color(0xFF4257b4),
                            enabledBorderColor: Colors.grey.shade300,
                            shadowColor: AppColors.transparent,
                          ),
                          const SizedBox(height: 10),
                          CustomSwitch(
                            label: 'Sự kiện miễn phí',
                            value: vm.isFree,
                            onChanged: (v) => vm.setIsFree(v),
                          ),
                          _buildDivider(),
                          _buildSectionTitle('🎫 Quản lý loại vé'),
                          InkWell(
                            onTap: () => _showAddEditTicketTypeDialog(vm),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4257b4).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF4257b4),
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4257b4),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.add, color: Colors.white, size: 24),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Thêm loại vé mới',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4257b4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (vm.ticketTypes.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.confirmation_number_outlined,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Chưa có loại vé nào',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Nhấn nút "Thêm loại vé mới" để bắt đầu',
                                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            )
                          else
                            ...vm.ticketTypes.map((ticketType) {
                              return TicketTypeItemWidget(
                                ticketType: ticketType,
                                onEdit: () =>
                                    _showAddEditTicketTypeDialog(vm, ticketType: ticketType),
                                onDelete: () =>
                                    _deleteTicketType(ticketType.id, vm),
                              );
                            }),
                          _buildDivider(),
                          _buildSectionTitle('🏢 Thông tin tổ chức'),
                          ImagePickerWidget(
                            label: 'Logo tổ chức',
                            imageFile: vm.logoImageFile,
                            imageUrl: vm.existingLogoUrl,
                            height: 120,
                            onImageSelected: (file) {
                              vm.setLogoImage(file);
                            },
                          ),
                          const SizedBox(height: 10),
                          AppTextField(
                            lableText: 'Tên tổ chức',
                            controller: vm.orgNameController,
                            borderColor: Colors.grey.shade300,
                            fillColor: Colors.grey.shade100,
                            focusedBorderColor: const Color(0xFF4257b4),
                            enabledBorderColor: Colors.grey.shade300,
                            shadowColor: AppColors.transparent,
                          ),
                          const SizedBox(height: 10),
                          AppTextField(
                            lableText: 'Mô tả tổ chức',
                            controller: vm.orgDescController,
                            maxLines: 3,
                            borderColor: Colors.grey.shade300,
                            fillColor: Colors.grey.shade100,
                            focusedBorderColor: const Color(0xFF4257b4),
                            enabledBorderColor: Colors.grey.shade300,
                            shadowColor: AppColors.transparent,
                          ),
                          _buildDivider(),
                          _buildSectionTitle('⚙️ Tùy chọn khác'),
                          CustomSwitch(
                            label: 'Sự kiện nổi bật',
                            value: vm.isHot,
                            onChanged: (v) => vm.setIsHot(v),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppElevatedButton(
                          onPressed: () => context.pop(),
                          text: 'Hủy',
                          borderColor: Colors.grey.shade300,
                          color: Colors.white,
                          textColor: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppElevatedButton(
                          onPressed: () => _saveEvent(vm),
                          text: 'Lưu sự kiện',
                          borderColor: const Color(0xFF4257b4),
                          color: const Color(0xFF4257b4),
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
