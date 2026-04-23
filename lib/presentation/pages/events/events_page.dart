import 'package:admin_event_go/core/base/base_view.dart';
import 'package:admin_event_go/core/constants/app_sizes.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/data/models/event/event_detail_model.dart';
import 'package:admin_event_go/injection/injection.dart';
import 'package:admin_event_go/presentation/view_models/event_view_model.dart';
import 'package:admin_event_go/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_event_go/core/constants/app_colors.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final modules = [
    {
      "title": AppStrings.eventsTitle,
      "icon": Icons.event,
      "color": AppColors.indigoAccent,
      "gradient": [AppColors.indigoAccent, AppColors.violetAccent],
      "route": RouterPath.eventsList,
    },
    {
      "title": AppStrings.categoriesTitle,
      "icon": Icons.category,
      "color": AppColors.amberAccent,
      "gradient": [AppColors.amberAccent, AppColors.redAccent],
      "route": RouterPath.categories,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slateDark,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.slateCard,
        title: const Text(
          AppStrings.eventManagementTitle,
          style: TextStyle(
              fontSize: AppSizes.size24,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSizes.size200, child: _buildModuleGrid()),
            Padding(
              padding: const EdgeInsets.all(AppSizes.size24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        AppStrings.recentEvents,
                        style: TextStyle(
                          fontSize: AppSizes.size20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                        TextButton.icon(
                          onPressed: () {
                            context.push(RouterPath.eventsList);
                          },
                          icon: const Icon(Icons.arrow_forward,
                              color: AppColors.indigoAccent, size: 16),
                          label: const Text(AppStrings.viewAll,
                              style: TextStyle(color: AppColors.indigoAccent)),
                        ),
                    ],
                  ),
                  SizedBox(height: AppSizes.size16),
                  _buildRecentEventsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSizes.size24),
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 1.0,
      ),
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final m = modules[index];
        return _buildModuleCard(m);
      },
    );
  }

  Widget _buildRecentEventsList() {
    return BaseView<EventViewModel>(
      viewModelBuilder: () => getIt<EventViewModel>(),
      onModelReady: (vm) => vm.watchAll(),
      builder: (context, vm, child) {
        if (vm.isBusy && vm.events.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.events.isEmpty)
          return const Center(
            child: Text(AppStrings.eventsNoEvents, style: TextStyle(color: Colors.white60)),
          );

        final now = DateTime.now();
        final sorted = List<EventDetailModel>.from(vm.events);
        sorted.sort((a, b) {
          final da = a.startTime?.difference(now).abs() ?? Duration(days: 36500);
          final db = b.startTime?.difference(now).abs() ?? Duration(days: 36500);
          return da.compareTo(db);
        });
        final recent = sorted.take(5).toList();
        return Column(children: recent.map((e) => _buildRecentCard(e)).toList());
      },
    );
  }

  Widget _buildRecentCard(EventDetailModel e) {
    String dateLine = '';
    if (e.startTime != null) {
      final d = e.startTime!.toLocal();
      final day = d.day.toString().padLeft(2, '0');
      final month = d.month.toString().padLeft(2, '0');
      final hour = d.hour.toString().padLeft(2, '0');
      final minute = d.minute.toString().padLeft(2, '0');
      dateLine = '$day/$month • $hour:$minute';
    }

    final subtitle = e.venue ?? e.orgName ?? e.address ?? '';
    final category = e.categories?.name ?? '';
    final price = e.isFree == true
        ? AppStrings.freeLabel
        : (e.minTicketPrice != null ? '${e.minTicketPrice}đ' : '-');

    Color statusColor;
    Color statusBgColor;
    switch ((e.status ?? '').toLowerCase()) {
      case 'live':
        statusColor = AppColors.emeraldAccent;
        statusBgColor = AppColors.emeraldAccent.withAlpha(25);
        break;
      case 'completed':
        statusColor = AppColors.grayStatus;
        statusBgColor = AppColors.grayStatus.withAlpha(25);
        break;
      case 'upcoming':
        statusColor = AppColors.blueStatus;
        statusBgColor = AppColors.blueStatus.withAlpha(25);
        break;
      default:
        statusColor = AppColors.grayLight;
        statusBgColor = AppColors.grayLight.withAlpha(25);
    }

    return Stack(
      children: [
        Container(
          height: AppSizes.size130,
          margin: const EdgeInsets.only(bottom: AppSizes.size16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.slateCard, AppColors.slateDark],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.slateBorder.withAlpha(80), width: AppSizes.size1),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withAlpha(40),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
              BoxShadow(
                color: AppColors.indigoAccent.withAlpha(15),
                blurRadius: 16,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                Container(
                  width: AppSizes.size120,
                  height: AppSizes.size130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: Stack(
                    children: [
                      e.bannerURL != null && e.bannerURL!.isNotEmpty
                          ? Image.network(
                              e.bannerURL!,
                              width: AppSizes.size130,
                              height: AppSizes.size130,
                              fit: BoxFit.cover,
                              errorBuilder: (c, o, s) => _buildImagePlaceholder(),
                            )
                          : _buildImagePlaceholder(),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, AppColors.black.withAlpha(40)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.size14, vertical: AppSizes.size14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                e.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppSizes.size13,
                                  fontWeight: FontWeight.w700,
                                  height: AppSizes.size1_1,
                                ),
                              ),
                              const SizedBox(height: AppSizes.size4),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(AppSizes.size2),
                                    decoration: BoxDecoration(
                                      color: AppColors.indigoAccent.withAlpha(30),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Icon(Icons.schedule, size: 9, color: AppColors.indigoAccent),
                                  ),
                                  const SizedBox(width: AppSizes.size3),
                                  Expanded(
                                    child: Text(
                                      dateLine,
                                      style: TextStyle(
                                        color: AppColors.slateLight,
                                        fontSize: AppSizes.size10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSizes.size2),

                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(AppSizes.size2),
                                    decoration: BoxDecoration(
                                      color: AppColors.pinkAccent.withAlpha(30),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Icon(
                                      Icons.location_on,
                                      size: 9,
                                      color: AppColors.pinkAccent,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.size3),
                                  Expanded(
                                    child: Text(
                                      subtitle.isEmpty ? 'No location' : subtitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColors.slateLight,
                                        fontSize: AppSizes.size10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Bottom row: category, price, action
                        Flexible(
                          flex: 1,
                          child: Row(
                            children: [
                              if (category.isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: AppSizes.size6, vertical: AppSizes.size3),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.indigoAccent.withAlpha(30),
                                        AppColors.violetAccent.withAlpha(30),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: AppColors.indigoAccent.withAlpha(60),
                                      width: AppSizes.size1,
                                    ),
                                  ),
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      color: AppColors.indigoAccent,
                                      fontSize: AppSizes.size10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              if (category.isNotEmpty) SizedBox(width: AppSizes.size6),

                              Container(
                                padding: EdgeInsets.symmetric(horizontal: AppSizes.size6, vertical: AppSizes.size3),
                                decoration: BoxDecoration(
                                  color: AppColors.pinkAccent.withAlpha(20),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  price,
                                  style: TextStyle(
                                    color: AppColors.pinkAccent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: AppSizes.size11,
                                  ),
                                ),
                              ),

                              Spacer(),

                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(AppSizes.size6),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [AppColors.indigoAccent, AppColors.violetAccent],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.indigoAccent.withAlpha(60),
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModuleCard(Map<String, dynamic> module) {
    return GestureDetector(
      onTap: () {
        context.push(module['route'] as String);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: module['gradient'] as List<Color>,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: (module['color'] as Color).withAlpha((0.3 * 255).round()),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                module['icon'] as IconData,
                color: Colors.white.withAlpha((0.2 * 255).round()),
                size: 120,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.size20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(AppSizes.size12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha((0.2 * 255).round()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(module['icon'] as IconData, color: Colors.white, size: 32),
                  ),
                  Spacer(),
                  Text(
                    module['title'] as String,
                    style: TextStyle(
                      fontSize: AppSizes.size18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: AppSizes.size4),
                  Text(
                    'Manage ${module['title']}',
                    style: TextStyle(
                      fontSize: AppSizes.size12,
                      color: Colors.white.withAlpha((0.8 * 255).round()),
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

  Widget _buildImagePlaceholder() {
    return Container(
      width: AppSizes.size130,
      height: AppSizes.size130,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.indigoAccent.withAlpha(30), AppColors.violetAccent.withAlpha(30)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.size12),
              decoration: BoxDecoration(
                color: AppColors.indigoAccent.withAlpha(40),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.event, color: AppColors.indigoAccent, size: 28),
            ),
            SizedBox(height: AppSizes.size4),
            Text(
              'Event',
              style: TextStyle(
                  color: AppColors.indigoAccent,
                  fontSize: AppSizes.size10,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
