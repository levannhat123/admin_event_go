import 'package:admin_event_go/core/base/base_view.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/data/models/event/event_detail_model.dart';
import 'package:admin_event_go/injection/injection.dart';
import 'package:admin_event_go/presentation/view_models/event_view_model.dart';
import 'package:admin_event_go/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventsListPage extends StatefulWidget {
  const EventsListPage({Key? key}) : super(key: key);

  @override
  State<EventsListPage> createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F172A),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF1E293B),
        title: const Text(
          AppStrings.eventsTitle,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
            padding: const EdgeInsets.all(16),
            itemCount: vm.events.length,
            itemBuilder: (context, index) => _buildEventItem(vm, vm.events[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(RouterPath.addEvent);
        },
        backgroundColor: Color(0xFF6366F1),
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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color.fromRGBO(99, 102, 241, 0.3), width: 1),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: event.bannerURL != null && event.bannerURL!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  event.bannerURL!,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Icon(Icons.event, color: Color(0xFF6366F1)),
                ),
              )
            : Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(99, 102, 241, 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.event, color: Color(0xFF6366F1), size: 24),
              ),
        title: Text(
          event.title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            event.categories?.name ?? '',
            style: TextStyle(fontSize: 14, color: Color.fromRGBO(255, 255, 255, 0.6)),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Color(0xFF6366F1)),
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
                        title: Text('Xác nhận xóa'),
                        content: Text(AppStrings.deleteCategoryContentPrefix +
                            event.title +
                            AppStrings.deleteCategoryContentSuffix),
                        actions: [
                          TextButton(
                              onPressed: () => context.pop(false),
                              child: const Text(AppStrings.ticketTypeDeleteCancel)),
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
