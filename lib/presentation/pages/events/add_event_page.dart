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
import '../../../core/constants/app_sizes.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
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
  Future<void> _selectDateTime(
    BuildContext context,
    bool isStartTime,
    EventViewModel vm,
  ) async {
    FocusScope.of(context).unfocus();
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

      if (isStartTime) {
        vm.setStartTime(fullDateTime);
      } else {
        vm.setEndTime(fullDateTime);
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
        padding: const EdgeInsets.all(AppSizes.size16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.brandPrimary, size: 24),
            const SizedBox(width: AppSizes.size12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: AppSizes.size12,
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
                      fontSize: AppSizes.size16,
                      color: dateTime != null
                          ? Colors.black87
                          : Colors.grey.shade400,
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
      padding: const EdgeInsets.only(bottom: AppSizes.size12, top: AppSizes.size8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: AppSizes.size18,
          fontWeight: FontWeight.bold,
          color: AppColors.slateDark,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.size16),
      child: Divider(color: Colors.grey.shade300, thickness: 1),
    );
  }

  void _saveEvent(EventViewModel vm) async {
    if (vm.titleController.text.trim().isEmpty) {
      _showErrorDialog(AppStrings.eventTitleRequired);
      return;
    }
    if (vm.descController.text.trim().isEmpty) {
      _showErrorDialog(AppStrings.eventDescriptionRequired);
      return;
    }
    if (vm.selectedCategory == null) {
      _showErrorDialog(AppStrings.eventCategoryRequired);
      return;
    }
    if (vm.locationController.text.trim().isEmpty) {
      _showErrorDialog(AppStrings.eventVenueRequired);
      return;
    }
    if (vm.startTime == null) {
      _showErrorDialog(AppStrings.eventStartTimeRequired);
      return;
    }
    if (vm.endTime == null) {
      _showErrorDialog(AppStrings.eventEndTimeRequired);
      return;
    }
    if (vm.endTime!.isBefore(vm.startTime!)) {
      _showErrorDialog(AppStrings.eventEndTimeAfterStart);
      return;
    }
    if (vm.bannerImageFile == null &&
        !(isEdit &&
            vm.existingBannerUrl != null &&
            vm.existingBannerUrl!.isNotEmpty)) {
      _showErrorDialog(AppStrings.eventBannerRequired);
      return;
    }

    if (vm.status == null) {
      _showErrorDialog(AppStrings.eventStatusRequired);
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
        _showSuccessDialog(AppStrings.eventSaveSuccess);
      } else {
        _showErrorDialog(
          eventViewModel.errorMessage ?? AppStrings.eventSaveFailed,
        );
      }
    } catch (e) {
      if (!mounted) return;
      context.pop();
      _showErrorDialog('${AppStrings.genericErrorPrefix}${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSizes.size24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
                const SizedBox(width: AppSizes.size12),
                const Text(
                  AppStrings.errorTitle,
                  style: TextStyle(fontSize: AppSizes.size20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.size16),
            Text(
              message,
              style: const TextStyle(fontSize: AppSizes.size16, color: Colors.grey),
            ),
            const SizedBox(height: AppSizes.size30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.size16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(AppStrings.closeButton),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(String message) async {
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.successTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              dialogContext.pop();
            },
            child: const Text(AppStrings.dialogOkButton),
          ),
        ],
      ),
    );

    if (mounted) {
      context.go(RouterPath.events);
    }
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
        title: const Text(AppStrings.ticketTypeDeleteConfirmTitle),
        content: const Text(AppStrings.ticketTypeDeleteConfirmContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.ticketTypeDeleteCancel),
          ),
          TextButton(
            onPressed: () {
              vm.deleteTicketType(id);
              context.pop();
            },
            child: const Text(
              AppStrings.ticketTypeDeleteConfirm,
              style: TextStyle(color: Colors.red),
            ),
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
        backgroundColor: AppColors.slateDark,
        title: Text(
          isEdit ? AppStrings.eventEditTitle : AppStrings.eventAddTitle,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
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
                      padding: const EdgeInsets.all(AppSizes.size20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(AppStrings.eventBasicInfoSection),
                          AppTextField(
                            lableText: AppStrings.eventTitleLabel,
                            controller: vm.titleController,
                            borderColor: Colors.grey.shade300,
                            fillColor: Colors.grey.shade100,
                            focusedBorderColor: AppColors.brandPrimary,
                            enabledBorderColor: Colors.grey.shade300,
                            shadowColor: AppColors.transparent,
                          ),
                          const SizedBox(height: AppSizes.size10),
                          ImagePickerWidget(
                            label: AppStrings.eventBannerLabel,
                            imageFile: vm.bannerImageFile,
                            imageUrl: vm.existingBannerUrl,
                            height: AppSizes.size180,
                            onImageSelected: (file) {
                              vm.setBannerImage(file);
                            },
                          ),
                          const SizedBox(height: AppSizes.size10),

                          AppTextField(
                            lableText: AppStrings.eventDescriptionLabel,
                            controller: vm.descController,
                            maxLines: 4,
                            borderColor: Colors.grey.shade300,
                            fillColor: Colors.grey.shade100,
                            focusedBorderColor: AppColors.brandPrimary,
                            enabledBorderColor: Colors.grey.shade300,
                            shadowColor: AppColors.transparent,
                          ),
                          const SizedBox(height: AppSizes.size10),

                          BaseView<CategoryViewModel>(
                            padding: false,
                            viewModelBuilder: () => getIt<CategoryViewModel>(),
                            onModelReady: (catVm) => catVm.watchAll(),
                            builder: (context, catVm, child) {
                              if (catVm.isBusy && catVm.categories.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppSizes.size8,
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      height: AppSizes.size24,
                                      width: AppSizes.size24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return CustomDropdown<CategoryModel>(
                                label: AppStrings.eventCategoryLabel,
                                items: catVm.categories,
                                value: vm.selectedCategory,
                                getLabel: (c) => c.name,
                                onChanged: (v) => vm.setCategory(v!),
                              );
                            },
                          ),

                          _buildDivider(),
                          _buildSectionTitle(AppStrings.eventLocationSection),
                          AppTextField(
                            lableText: AppStrings.eventVenueLabel,
                            controller: vm.locationController,
                            borderColor: Colors.grey.shade300,
                            fillColor: Colors.grey.shade100,
                            focusedBorderColor: AppColors.brandPrimary,
                            enabledBorderColor: Colors.grey.shade300,
                            shadowColor: AppColors.transparent,
                          ),
                          const SizedBox(height: AppSizes.size10),
                          AppTextField(
                            lableText: AppStrings.eventAddressLabel,
                            controller: vm.addressController,
                            borderColor: Colors.grey.shade300,
                            fillColor: Colors.grey.shade100,
                            focusedBorderColor: AppColors.brandPrimary,
                            enabledBorderColor: Colors.grey.shade300,
                            shadowColor: AppColors.transparent,
                          ),
                          const SizedBox(height: AppSizes.size10),

                          AppTextField(
                            lableText: AppStrings.eventLocationIdLabel,
                            controller: vm.idLocationController,
                            borderColor: Colors.grey.shade300,
                            fillColor: Colors.grey.shade100,
                            focusedBorderColor: AppColors.brandPrimary,
                            enabledBorderColor: Colors.grey.shade300,
                            shadowColor: AppColors.transparent,
                          ),
                          _buildDivider(),
                          _buildSectionTitle(AppStrings.eventTimeSection),
                          _buildDateTimeField(
                            label: AppStrings.eventStartTimeLabel,
                            dateTime: vm.startTime,
                            onTap: () => _selectDateTime(context, true, vm),
                            icon: Icons.access_time,
                          ),
                          const SizedBox(height: AppSizes.size10),

                          _buildDateTimeField(
                            label: AppStrings.eventEndTimeLabel,
                            dateTime: vm.endTime,
                            onTap: () => _selectDateTime(context, false, vm),
                            icon: Icons.event_available,
                          ),
                          _buildDivider(),
                          _buildSectionTitle(AppStrings.eventPriceSection),
                          AppTextField(
                            lableText: AppStrings.eventMinPriceLabel,
                            controller: vm.minPriceController,
                            borderColor: Colors.grey.shade300,
                            fillColor: Colors.grey.shade100,
                            focusedBorderColor: AppColors.brandPrimary,
                            enabledBorderColor: Colors.grey.shade300,
                            shadowColor: AppColors.transparent,
                          ),
                          const SizedBox(height: AppSizes.size10),
                          CustomSwitch(
                            label: AppStrings.eventIsFreeLabel,
                            value: vm.isFree,
                            onChanged: (v) => vm.setIsFree(v),
                          ),
                          _buildDivider(),
                          _buildSectionTitle(AppStrings.eventTicketTypeSection),
                          InkWell(
                            onTap: () => _showAddEditTicketTypeDialog(vm),
                            child: Container(
                              padding: const EdgeInsets.all(AppSizes.size16),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF4257b4,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.brandPrimary,
                                  width: AppSizes.size2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(AppSizes.size8),
                                    decoration: BoxDecoration(
                                      color: AppColors.brandPrimary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.size12),
                                  const Text(
                                    AppStrings.eventAddTicketTypeButton,
                                    style: TextStyle(
                                      fontSize: AppSizes.size16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.brandPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSizes.size16),
                          if (vm.ticketTypes.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(AppSizes.size24),
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
                                  const SizedBox(height: AppSizes.size12),
                                  Text(
                                    AppStrings.eventNoTicketType,
                                    style: TextStyle(
                                      fontSize: AppSizes.size16,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.size4),
                                  Text(
                                    AppStrings.eventAddTicketTypeGuide,
                                    style: TextStyle(
                                      fontSize: AppSizes.size14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            ...vm.ticketTypes.map((ticketType) {
                              return TicketTypeItemWidget(
                                ticketType: ticketType,
                                onEdit: () => _showAddEditTicketTypeDialog(
                                  vm,
                                  ticketType: ticketType,
                                ),
                                onDelete: () =>
                                    _deleteTicketType(ticketType.id, vm),
                              );
                            }),
                          _buildDivider(),
                          _buildSectionTitle(AppStrings.eventOrgSection),
                          ImagePickerWidget(
                            label: AppStrings.eventOrgLogoLabel,
                            imageFile: vm.logoImageFile,
                            imageUrl: vm.existingLogoUrl,
                            height: AppSizes.size120,
                            onImageSelected: (file) {
                              vm.setLogoImage(file);
                            },
                          ),
                          const SizedBox(height: AppSizes.size10),
                          AppTextField(
                            lableText: AppStrings.eventOrgNameLabel,
                            controller: vm.orgNameController,
                            borderColor: Colors.grey.shade300,
                            fillColor: Colors.grey.shade100,
                            focusedBorderColor: AppColors.brandPrimary,
                            enabledBorderColor: Colors.grey.shade300,
                            shadowColor: AppColors.transparent,
                          ),
                          const SizedBox(height: AppSizes.size10),
                          AppTextField(
                            lableText: AppStrings.eventOrgDescLabel,
                            controller: vm.orgDescController,
                            maxLines: 3,
                            borderColor: Colors.grey.shade300,
                            fillColor: Colors.grey.shade100,
                            focusedBorderColor: AppColors.brandPrimary,
                            enabledBorderColor: Colors.grey.shade300,
                            shadowColor: AppColors.transparent,
                          ),
                          _buildDivider(),
                          _buildSectionTitle(
                            AppStrings.eventOtherOptionsSection,
                          ),
                          CustomSwitch(
                            label: AppStrings.eventIsHotLabel,
                            value: vm.isHot,
                            onChanged: (v) => vm.setIsHot(v),
                          ),
                          const SizedBox(height: AppSizes.size20),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(AppSizes.size20),
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
                          text: AppStrings.eventCancelButton,
                          borderColor: Colors.grey.shade300,
                          color: Colors.white,
                          textColor: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: AppSizes.size12),
                      Expanded(
                        child: AppElevatedButton(
                          onPressed: () => _saveEvent(vm),
                          text: AppStrings.eventSaveButton,
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
          );
        },
      ),
    );
  }
}
