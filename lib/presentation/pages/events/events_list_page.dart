import 'package:admin_event_go/core/base/base_view.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/data/models/event/event_detail_model.dart';
import 'package:admin_event_go/injection/injection.dart';
import 'package:admin_event_go/presentation/view_models/event_view_model.dart';
import 'package:admin_event_go/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_event_go/core/constants/app_colors.dart';

import '../../../core/constants/app_sizes.dart';

class EventsListPage extends StatefulWidget {
  const EventsListPage({Key? key}) : super(key: key);

  @override
  State<EventsListPage> createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slateDark,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.slateCard,
        title: const Text(
          AppStrings.eventsTitle,
          style: TextStyle(
              fontSize: AppSizes.size24,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BaseView<EventViewModel>(
        padding: false,
        viewModelBuilder: () => getIt<EventViewModel>(),
        onModelReady: (vm) => vm.watchAll(),
        builder: (context, vm, child) {
          if (vm.isBusy && vm.events.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.events.isEmpty) {
            return const Center(
              child: Text(AppStrings.eventsNoEvents, style: TextStyle(color: Colors.white70)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.size16),
            itemCount: vm.events.length,
            itemBuilder: (context, index) => _buildEventItem(vm, vm.events[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(RouterPath.addEvent);
        },
        backgroundColor: AppColors.indigoAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          AppStrings.eventsAddEvent,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEventItem(EventViewModel vm, EventDetailModel event) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.size16),
      decoration: BoxDecoration(
        color: AppColors.slateCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color.fromRGBO(99, 102, 241, 0.3), width: AppSizes.size1),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(AppSizes.size16),
        leading: event.bannerURL != null && event.bannerURL!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  event.bannerURL!,
                  width: AppSizes.size56,
                  height: AppSizes.size56,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Icon(Icons.event, color: AppColors.indigoAccent),
                ),
              )
            : Container(
                padding: EdgeInsets.all(AppSizes.size12),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(99, 102, 241, 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.event, color: AppColors.indigoAccent, size: 24),
              ),
        title: Text(
          event.title,
          style: TextStyle(
              fontSize: AppSizes.size16,
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppSizes.size8),
          child: Text(
            event.categories?.name ?? '',
            style: TextStyle(
                fontSize: AppSizes.size14,
                color: Color.fromRGBO(255, 255, 255, 0.6)),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.indigoAccent),
              onPressed: () async {
                await context.push(RouterPath.addEvent, extra: {'event': event, 'isEditing': true});
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirmed =
                    await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(AppStrings.confirmDeleteTitle),
                        content: Text(
                          AppStrings.deleteCategoryContentPrefix +
                              event.title +
                              AppStrings.deleteCategoryContentSuffix,
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => context.pop(false),
                              child:
                                  const Text(AppStrings.ticketTypeDeleteCancel)),
                          TextButton(
                            onPressed: () => context.pop(true),
                            child: const Text(AppStrings.ticketTypeDeleteConfirm,
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ) ??
                    false;

                if (confirmed) {
                  final success = await vm.deleteEvent(event.id);
                  if (!success) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(vm.errorMessage ?? AppStrings.eventSaveFailed)));
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
