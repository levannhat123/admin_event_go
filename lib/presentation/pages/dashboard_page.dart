import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F172A),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF1E293B),
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            _buildStatsGrid(),
            SizedBox(height: 24),

            // Charts Section
            _buildChartsSection(),
            SizedBox(height: 24),

            // Recent Events
            _buildRecentEvents(),
            SizedBox(height: 24),

            // Recent Activities
            _buildRecentActivities(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          title: 'Total Events',
          value: '125',
          icon: Icons.event,
          color: Color(0xFF6366F1),
          gradient: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          trend: '+12%',
        ),
        _buildStatCard(
          title: 'Live Events',
          value: '8',
          icon: Icons.play_circle_filled,
          color: Color(0xFF10B981),
          gradient: [Color(0xFF10B981), Color(0xFF06B6D4)],
          trend: '+5%',
        ),
        _buildStatCard(
          title: 'Tickets Sold',
          value: '1,234',
          icon: Icons.confirmation_number,
          color: Color(0xFFEC4899),
          gradient: [Color(0xFFEC4899), Color(0xFFF43F5E)],
          trend: '+23%',
        ),
        _buildStatCard(
          title: 'Revenue',
          value: '\$45.2K',
          icon: Icons.attach_money,
          color: Color(0xFFF59E0B),
          gradient: [Color(0xFFF59E0B), Color(0xFFEF4444)],
          trend: '+18%',
        ),
        _buildStatCard(
          title: 'New Users',
          value: '89',
          icon: Icons.person_add,
          color: Color(0xFF8B5CF6),
          gradient: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
          trend: '+8%',
        ),
        _buildStatCard(
          title: 'Fill Rate',
          value: '78%',
          icon: Icons.trending_up,
          color: Color(0xFF06B6D4),
          gradient: [Color(0xFF06B6D4), Color(0xFF6366F1)],
          trend: '+3%',
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
            child: Icon(
              icon,
              color: Colors.white.withOpacity(0.2),
              size: 80,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icon, color: Colors.white, size: 24),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        trend,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
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

  Widget _buildChartsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analytics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildChartCard(
                title: 'Tickets Sold (Last 7 Days)',
                child: _buildLineChart(),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildChartCard(
                title: 'Event Categories',
                child: _buildPieChart(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChartCard({required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFF334155),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          SizedBox(height: 200, child: child),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 50,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Color(0xFF334155),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                if (value.toInt() >= 0 && value.toInt() < days.length) {
                  return Text(
                    days[value.toInt()],
                    style: TextStyle(color: Colors.white60, fontSize: 10),
                  );
                }
                return Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(color: Colors.white60, fontSize: 10),
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
            spots: [
              FlSpot(0, 80),
              FlSpot(1, 120),
              FlSpot(2, 100),
              FlSpot(3, 150),
              FlSpot(4, 140),
              FlSpot(5, 180),
              FlSpot(6, 160),
            ],
            isCurved: true,
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ),
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: Color(0xFF6366F1),
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6366F1).withOpacity(0.3),
                  Color(0xFF6366F1).withOpacity(0.0),
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

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
            value: 35,
            color: Color(0xFF6366F1),
            title: 'Music\n35%',
            radius: 60,
            titleStyle: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: 25,
            color: Color(0xFF10B981),
            title: 'Sports\n25%',
            radius: 60,
            titleStyle: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: 20,
            color: Color(0xFFEC4899),
            title: 'Tech\n20%',
            radius: 60,
            titleStyle: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: 20,
            color: Color(0xFFF59E0B),
            title: 'Arts\n20%',
            radius: 60,
            titleStyle: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Events',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: TextStyle(color: Color(0xFF6366F1)),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xFF334155)),
          ),
          child: Column(
            children: [
              _buildEventItem(
                'Summer Music Festival 2024',
                'Jun 15, 2024',
                'Live',
                Color(0xFF10B981),
                '450/500',
              ),
              Divider(color: Color(0xFF334155), height: 1),
              _buildEventItem(
                'Tech Conference Asia',
                'Jun 20, 2024',
                'Upcoming',
                Color(0xFF6366F1),
                '320/400',
              ),
              Divider(color: Color(0xFF334155), height: 1),
              _buildEventItem(
                'Food & Wine Expo',
                'Jun 25, 2024',
                'Upcoming',
                Color(0xFF6366F1),
                '180/300',
              ),
              Divider(color: Color(0xFF334155), height: 1),
              _buildEventItem(
                'Art Gallery Opening',
                'Jun 10, 2024',
                'Completed',
                Color(0xFF64748B),
                '250/250',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventItem(
    String title,
    String date,
    String status,
    Color statusColor,
    String tickets,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.event, color: Colors.white),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 12, color: Colors.white60),
            SizedBox(width: 4),
            Flexible(
              child: Text(
                date,
                style: TextStyle(color: Colors.white60, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.confirmation_number, size: 12, color: Colors.white60),
            SizedBox(width: 4),
            Flexible(
              child: Text(
                tickets,
                style: TextStyle(color: Colors.white60, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: statusColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activities',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xFF334155)),
          ),
          child: Column(
            children: [
              _buildActivityItem(
                Icons.add_circle,
                'New event created',
                'Summer Music Festival 2024',
                '2 hours ago',
                Color(0xFF10B981),
              ),
              Divider(color: Color(0xFF334155), height: 1),
              _buildActivityItem(
                Icons.shopping_cart,
                'New ticket purchase',
                '5 tickets for Tech Conference',
                '3 hours ago',
                Color(0xFF6366F1),
              ),
              Divider(color: Color(0xFF334155), height: 1),
              _buildActivityItem(
                Icons.person_add,
                'New user registered',
                'john.doe@example.com',
                '5 hours ago',
                Color(0xFFEC4899),
              ),
              Divider(color: Color(0xFF334155), height: 1),
              _buildActivityItem(
                Icons.edit,
                'Event updated',
                'Food & Wine Expo details changed',
                '1 day ago',
                Color(0xFFF59E0B),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    IconData icon,
    String title,
    String subtitle,
    String time,
    Color color,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: TextStyle(color: Colors.white60, fontSize: 12),
        ),
      ),
      trailing: Text(
        time,
        style: TextStyle(color: Colors.white38, fontSize: 11),
      ),
    );
  }
}

