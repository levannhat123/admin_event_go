import 'dart:io';

import 'package:admin_event_go/core/widgets/app_elevated_button.dart';
import 'package:admin_event_go/core/widgets/custom_dropdown.dart';
import 'package:admin_event_go/core/widgets/custom_switch.dart';
import 'package:admin_event_go/core/widgets/image_picker_widget.dart';
import 'package:admin_event_go/core/widgets/text_field.dart';
import 'package:admin_event_go/data/models/event/ticket_type_model.dart';
import 'package:admin_event_go/data/models/event/event_detail_model.dart';
import 'package:admin_event_go/data/models/category/category_model.dart';
import 'package:admin_event_go/presentation/dialogs/add_edit_ticket_type_dialog.dart';
import 'package:admin_event_go/presentation/widgets/ticket_type_item_widget.dart';
import 'package:admin_event_go/presentation/view_models/event_view_model.dart';
import 'package:admin_event_go/data/services/supabase_storage_service.dart';
import 'package:admin_event_go/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final locationController = TextEditingController();
  final addressController = TextEditingController();
  final orgNameController = TextEditingController();
  final orgDescController = TextEditingController();
  final minPriceController = TextEditingController();
  final idLocationController = TextEditingController();

  String? status = 'ACTIVE';
  String? category;
  String? ticketType;
  bool isFree = false;
  bool isHot = false;
  DateTime? startTime;
  DateTime? endTime;

  List<TicketTypeModel> ticketTypes = [];

  File? bannerImageFile;
  File? logoImageFile;

  final _formKey = GlobalKey<FormState>();

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
          setState(() {
            if (isStartTime) {
              startTime = fullDateTime;
            } else {
              endTime = fullDateTime;
            }
          });
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
            Icon(
              icon,
              color: const Color(0xFF4257b4),
              size: 24,
            ),
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
            Icon(
              Icons.calendar_today,
              color: Colors.grey.shade400,
              size: 20,
            ),
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
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(
        color: Colors.grey.shade300,
        thickness: 1,
      ),
    );
  }

  void _saveEvent() async {
    // Validate form
    if (titleController.text.trim().isEmpty) {
      _showErrorDialog('Vui lòng nhập tiêu đề sự kiện');
      return;
    }

    if (descController.text.trim().isEmpty) {
      _showErrorDialog('Vui lòng nhập mô tả sự kiện');
      return;
    }

    if (locationController.text.trim().isEmpty) {
      _showErrorDialog('Vui lòng nhập địa điểm tổ chức');
      return;
    }

    if (startTime == null) {
      _showErrorDialog('Vui lòng chọn thời gian bắt đầu');
      return;
    }

    if (endTime == null) {
      _showErrorDialog('Vui lòng chọn thời gian kết thúc');
      return;
    }

    if (endTime!.isBefore(startTime!)) {
      _showErrorDialog('Thời gian kết thúc phải sau thời gian bắt đầu');
      return;
    }

    if (bannerImageFile == null) {
      _showErrorDialog('Vui lòng chọn ảnh banner');
      return;
    }

    if (status == null) {
      _showErrorDialog('Vui lòng chọn trạng thái');
      return;
    }

    if (category == null) {
      _showErrorDialog('Vui lòng chọn danh mục');
      return;
    }

    // Show loading
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final storageService = getIt<SupabaseStorageService>();
      final eventViewModel = getIt<EventViewModel>();

      // Upload banner image to Supabase
      String? bannerUrl;
      if (bannerImageFile != null) {
        bannerUrl = await storageService.uploadImage(
          imageFile: bannerImageFile!,
          bucket: 'event_go_image',
          folder: 'banners',
        );
      }

      // Upload logo image to Supabase (if exists)
      String? logoUrl;
      if (logoImageFile != null) {
        logoUrl = await storageService.uploadImage(
          imageFile: logoImageFile!,
          bucket: 'event_go_image',
          folder: 'logos',
        );
      }

      // Create event object
      final eventId = const Uuid().v4();
      final event = EventDetailModel(
        id: eventId,
        title: titleController.text.trim(),
        bannerURL: bannerUrl,
        description: descController.text.trim(),
        venue: locationController.text.trim(),
        categories: CategoryModel(
          id: category == 'Hội thảo' ? '1' : category == 'Ca nhạc' ? '2' : '3',
          name: category!,
        ),
        address: addressController.text.trim().isNotEmpty
            ? addressController.text.trim()
            : null,
        orgLogoURL: logoUrl,
        orgName: orgNameController.text.trim().isNotEmpty
            ? orgNameController.text.trim()
            : null,
        orgDescription: orgDescController.text.trim().isNotEmpty
            ? orgDescController.text.trim()
            : null,
        status: status,
        minTicketPrice: minPriceController.text.trim().isNotEmpty
            ? int.tryParse(minPriceController.text.trim())
            : null,
        isFree: isFree,
        ticketType: ticketTypes.isNotEmpty ? ticketTypes : null,
        startTime: startTime,
        endTime: endTime,
        locationId: idLocationController.text.trim().isNotEmpty
            ? idLocationController.text.trim()
            : null,
        isHot: isHot,
      );

      // Save event to Firebase
      final success = await eventViewModel.addEvent(event);

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (success) {
        _showSuccessDialog('Lưu sự kiện thành công!');
      } else {
        _showErrorDialog(eventViewModel.errorMessage ?? 'Có lỗi xảy ra khi lưu sự kiện');
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      _showErrorDialog('Có lỗi xảy ra: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
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
              Navigator.pop(context);
              context.pop(); // Return to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // === TICKET TYPE MANAGEMENT ===
  Future<void> _showAddEditTicketTypeDialog({TicketTypeModel? ticketType}) async {
    final result = await showDialog<TicketTypeModel>(
      context: context,
      builder: (context) => AddEditTicketTypeDialog(ticketType: ticketType),
    );

    if (result != null) {
      setState(() {
        if (ticketType == null) {
          // Thêm mới
          ticketTypes.add(result);
        } else {
          // Cập nhật
          final index = ticketTypes.indexWhere((t) => t.id == ticketType.id);
          if (index != -1) {
            ticketTypes[index] = result;
          }
        }
      });
    }
  }

  void _deleteTicketType(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa loại vé này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                ticketTypes.removeWhere((t) => t.id == id);
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text('Thêm sự kiện mới'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
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
                    // === THÔNG TIN CƠ BẢN ===
                    _buildSectionTitle('📋 Thông tin cơ bản'),
                    AppTextField(
                      lableText: 'Tiêu đề',
                      controller: titleController,
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
                      imageFile: bannerImageFile,
                      height: 180,
                      onImageSelected: (file) {
                        setState(() {
                          bannerImageFile = file;
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    AppTextField(
                      lableText: 'Mô tả sự kiện',
                      controller: descController,
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
                      value: status,
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
                      onChanged: (v) => setState(() => status = v),
                    ),
                    const SizedBox(height: 10),

                    CustomDropdown<String>(
                      label: 'Danh mục',
                      items: ['Hội thảo', 'Ca nhạc', 'Thể thao'],
                      value: category,
                      getLabel: (v) => v,
                      onChanged: (v) => setState(() => category = v),
                    ),

                    _buildDivider(),

                    // === ĐỊA ĐIỂM ===
                    _buildSectionTitle('📍 Địa điểm tổ chức'),
                    AppTextField(
                      lableText: 'Địa điểm tổ chức (Venue)',
                      controller: locationController,
                      borderColor: Colors.grey.shade300,
                      fillColor: Colors.grey.shade100,
                      focusedBorderColor: const Color(0xFF4257b4),
                      enabledBorderColor: Colors.grey.shade300,
                      shadowColor: AppColors.transparent,
                    ),
                    const SizedBox(height: 10),

                    AppTextField(
                      lableText: 'Địa chỉ chi tiết',
                      controller: addressController,
                      borderColor: Colors.grey.shade300,
                      fillColor: Colors.grey.shade100,
                      focusedBorderColor: const Color(0xFF4257b4),
                      enabledBorderColor: Colors.grey.shade300,
                      shadowColor: AppColors.transparent,
                    ),
                    const SizedBox(height: 10),

                    AppTextField(
                      lableText: 'ID địa điểm',
                      controller: idLocationController,
                      borderColor: Colors.grey.shade300,
                      fillColor: Colors.grey.shade100,
                      focusedBorderColor: const Color(0xFF4257b4),
                      enabledBorderColor: Colors.grey.shade300,
                      shadowColor: AppColors.transparent,
                    ),

                    _buildDivider(),

                    // === THỜI GIAN ===
                    _buildSectionTitle('🕒 Thời gian'),
                    _buildDateTimeField(
                      label: 'Thời gian bắt đầu',
                      dateTime: startTime,
                      onTap: () => _selectDateTime(context, true),
                      icon: Icons.access_time,
                    ),
                    const SizedBox(height: 10),

                    _buildDateTimeField(
                      label: 'Thời gian kết thúc',
                      dateTime: endTime,
                      onTap: () => _selectDateTime(context, false),
                      icon: Icons.event_available,
                    ),

                    _buildDivider(),

                    // === THÔNG TIN VÉ ===
                    _buildSectionTitle('💰 Thông tin giá vé'),
                    AppTextField(
                      lableText: 'Giá vé tối thiểu (VNĐ)',
                      controller: minPriceController,
                      borderColor: Colors.grey.shade300,
                      fillColor: Colors.grey.shade100,
                      focusedBorderColor: const Color(0xFF4257b4),
                      enabledBorderColor: Colors.grey.shade300,
                      shadowColor: AppColors.transparent,
                    ),
                    const SizedBox(height: 10),

                    CustomSwitch(
                      label: 'Sự kiện miễn phí',
                      value: isFree,
                      onChanged: (v) => setState(() => isFree = v),
                    ),

                    _buildDivider(),

                    // === QUẢN LÝ LOẠI VÉ ===
                    _buildSectionTitle('🎫 Quản lý loại vé'),

                    // Nút thêm loại vé
                    InkWell(
                      onTap: () => _showAddEditTicketTypeDialog(),
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
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 24,
                              ),
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

                    // Danh sách loại vé
                    if (ticketTypes.isEmpty)
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
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...ticketTypes.map((ticketType) {
                        return TicketTypeItemWidget(
                          ticketType: ticketType,
                          onEdit: () => _showAddEditTicketTypeDialog(ticketType: ticketType),
                          onDelete: () => _deleteTicketType(ticketType.id),
                        );
                      }),

                    _buildDivider(),

                    // === TỔ CHỨC ===
                    _buildSectionTitle('🏢 Thông tin tổ chức'),
                    ImagePickerWidget(
                      label: 'Logo tổ chức',
                      imageFile: logoImageFile,
                      height: 120,
                      onImageSelected: (file) {
                        setState(() {
                          logoImageFile = file;
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    AppTextField(
                      lableText: 'Tên tổ chức',
                      controller: orgNameController,
                      borderColor: Colors.grey.shade300,
                      fillColor: Colors.grey.shade100,
                      focusedBorderColor: const Color(0xFF4257b4),
                      enabledBorderColor: Colors.grey.shade300,
                      shadowColor: AppColors.transparent,
                    ),
                    const SizedBox(height: 10),

                    AppTextField(
                      lableText: 'Mô tả tổ chức',
                      controller: orgDescController,
                      maxLines: 3,
                      borderColor: Colors.grey.shade300,
                      fillColor: Colors.grey.shade100,
                      focusedBorderColor: const Color(0xFF4257b4),
                      enabledBorderColor: Colors.grey.shade300,
                      shadowColor: AppColors.transparent,
                    ),

                    _buildDivider(),

                    // === TÙY CHỌN KHÁC ===
                    _buildSectionTitle('⚙️ Tùy chọn khác'),
                    CustomSwitch(
                      label: 'Sự kiện nổi bật',
                      value: isHot,
                      onChanged: (v) => setState(() => isHot = v),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // Nút hành động
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
                    onPressed: _saveEvent,
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
      ),
    );
  }
}