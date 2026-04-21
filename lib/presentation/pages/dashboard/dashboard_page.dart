import 'package:admin_event_go/core/base/base_view.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/data/models/event/event_detail_model.dart';
import 'package:admin_event_go/injection/injection.dart';
import 'package:admin_event_go/presentation/view_models/dashboad_view_model.dart';
import 'package:admin_event_go/routers/router_name.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_event_go/core/constants/app_colors.dart';

import '../../../core/constants/app_sizes.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slateDark,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.slateCard,
        title: const Text(
          AppStrings.dashboardTitle,
          style: TextStyle(
            fontSize: AppSizes.size24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: BaseView<DashboadViewModel>(
        viewModelBuilder: () => getIt<DashboadViewModel>(),
        onModelReady: (vm) {
          vm.watchAll();
          vm.fetchUsers();
          vm.fetchStaff();
        },
        autoDispose: false,
        builder: (context, vm, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(AppSizes.size16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsGrid(vm),
                SizedBox(height: AppSizes.size24),
                _buildChartsSection(vm),
                SizedBox(height: AppSizes.size24),
                Column(
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
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: AppColors.indigoAccent,
                            size: 16,
                          ),
                          label: const Text(
                            AppStrings.viewAll,
                            style: TextStyle(color: AppColors.indigoAccent),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.size16),
                    _buildRecentEventsList(vm),
                  ],
                ),
                SizedBox(height: AppSizes.size24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentEventsList(DashboadViewModel vm) {
    if (vm.isBusy && vm.events.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.events.isEmpty) {
      return const Center(
        child: Text(
          AppStrings.eventsNoEvents,
          style: TextStyle(color: Colors.white60),
        ),
      );
    }

    final now = DateTime.now();
    final sorted = List<EventDetailModel>.from(vm.events);
    sorted.sort((a, b) {
      final da = a.startTime?.difference(now).abs() ?? Duration(days: 36500);
      final db = b.startTime?.difference(now).abs() ?? Duration(days: 36500);
      return da.compareTo(db);
    });
    final recent = sorted.take(5).toList();
    return Column(children: recent.map((e) => _buildRecentCard(e)).toList());
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
            border: Border.all(
              color: AppColors.slateBorder.withAlpha(80),
              width: AppSizes.size1,
            ),
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
                              errorBuilder: (c, o, s) =>
                                  _buildImagePlaceholder(),
                            )
                          : _buildImagePlaceholder(),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.black.withAlpha(40),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.size14,
                      vertical: AppSizes.size14,
                    ),
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
                                      color: AppColors.indigoAccent.withAlpha(
                                        30,
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Icon(
                                      Icons.schedule,
                                      size: 9,
                                      color: AppColors.indigoAccent,
                                    ),
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
                                      subtitle.isEmpty
                                          ? 'No location'
                                          : subtitle,
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
                        Flexible(
                          flex: 1,
                          child: Row(
                            children: [
                              if (category.isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSizes.size6,
                                    vertical: AppSizes.size3,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.indigoAccent.withAlpha(30),
                                        AppColors.violetAccent.withAlpha(30),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: AppColors.indigoAccent.withAlpha(
                                        60,
                                      ),
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
                              if (category.isNotEmpty)
                                SizedBox(width: AppSizes.size6),

                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSizes.size6,
                                  vertical: AppSizes.size3,
                                ),
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
                                      colors: [
                                        AppColors.indigoAccent,
                                        AppColors.violetAccent,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.indigoAccent.withAlpha(
                                          60,
                                        ),
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

  Widget _buildImagePlaceholder() {
    return Container(
      width: AppSizes.size130,
      height: AppSizes.size130,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.indigoAccent.withAlpha(30),
            AppColors.violetAccent.withAlpha(30),
          ],
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
              AppStrings.eventLabel,
              style: TextStyle(
                color: AppColors.indigoAccent,
                fontSize: AppSizes.size10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildStatsGrid(DashboadViewModel vm) {
  return GridView.count(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    crossAxisCount: 2,
    mainAxisSpacing: 16,
    crossAxisSpacing: 16,
    childAspectRatio: 1.5,
    children: [
      _buildStatCard(
        title: AppStrings.totalEvents,
        value: vm.events.length.toString(),
        icon: Icons.event,
        color: AppColors.indigoAccent,
        gradient: [AppColors.indigoAccent, AppColors.violetAccent],
        trend: '+12%',
      ),
      _buildStatCard(
        title: AppStrings.totalOrders,
        value: vm.totalOrdersString,
        icon: Icons.confirmation_number,
        color: AppColors.pinkAccent,
        gradient: [AppColors.pinkAccent, AppColors.roseAccent],
        trend: '+23%',
      ),
      _buildStatCard(
        title: AppStrings.revenue,
        value: vm.totalRevenueString,
        icon: Icons.attach_money,
        color: AppColors.amberAccent,
        gradient: [AppColors.amberAccent, AppColors.redAccent],
        trend: '+18%',
      ),
      _buildStatCard(
        title: AppStrings.newUsers,
        value: vm.users.length.toString(),
        icon: Icons.person_add,
        color: AppColors.violetAccent,
        gradient: [AppColors.violetAccent, AppColors.pinkAccent],
        trend: '+8%',
      ),
    ],
  );
}

Widget _buildStatCard({
  required String title,
  required String value,
  required IconData icon,
  required Color color,
  required List<Color> gradient,
  required String trend,
}) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: gradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.3),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Stack(
      children: [
        Positioned(
          right: -10,
          bottom: -10,
          child: Icon(icon, color: Colors.white.withOpacity(0.2), size: 80),
        ),
        Padding(
          padding: EdgeInsets.all(AppSizes.size10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: Colors.white, size: 24),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.size8,
                      vertical: AppSizes.size4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      trend,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppSizes.size12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppSizes.size18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSizes.size4),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: AppSizes.size10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildChartsSection(DashboadViewModel vm) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        AppStrings.analyticsTitle,
        style: TextStyle(
          fontSize: AppSizes.size20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: AppSizes.size16),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildChartCard(
              title: AppStrings.ticketsSoldLast7Days,
              child: _buildLineChart(vm),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildChartCard({required String title, required Widget child}) {
  return Container(
    padding: EdgeInsets.all(AppSizes.size16),
    decoration: BoxDecoration(
      color: AppColors.slateCard,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.slateBorder, width: AppSizes.size1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: AppSizes.size14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: AppSizes.size16),
        SizedBox(height: AppSizes.size200, child: child),
      ],
    ),
  );
}

Widget _buildLineChart(DashboadViewModel vm) {
  if (vm.dailyTicketSpots.isEmpty) {
    if (vm.isBusy) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.indigoAccent),
      );
    }
    return const Center(
      child: Text(
        AppStrings.noTicketDataYet,
        style: TextStyle(color: Colors.white60),
      ),
    );
  }

  final double maxY = vm.maxDailyTickets;
  double interval;
  if (maxY <= 10) {
    interval = 2;
  } else if (maxY <= 50) {
    interval = 10;
  } else if (maxY <= 100) {
    interval = 25;
  } else {
    interval = (maxY / 4).ceilToDouble();
  }
  if (interval == 0) interval = 1;

  return LineChart(
    LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: interval,
        getDrawingHorizontalLine: (value) {
          return FlLine(color: AppColors.slateBorder, strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final int index = value.toInt();
              if (index >= 0 && index < vm.dayLabels.length) {
                return Text(
                  vm.dayLabels[index],
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: AppSizes.size10,
                  ),
                );
              }
              return Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: interval,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: AppSizes.size10,
                ),
              );
            },
            reservedSize: 40,
          ),
        ),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: vm.dailyTicketSpots,
          isCurved: true,
          gradient: LinearGradient(
            colors: [AppColors.indigoAccent, AppColors.violetAccent],
          ),
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: AppColors.indigoAccent,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppColors.indigoAccent.withOpacity(0.3),
                AppColors.indigoAccent.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    ),
  );
}
