import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardContent(),
    const Center(child: Text('Events Page')),
    const Center(child: Text('Users Page')),
    const Center(child: Text('Orders Page')),
    const Center(child: Text('Settings Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Cards thống kê
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              StatCard(title: "Tổng sự kiện", value: "25", color: Colors.green),
              StatCard(title: "Vé bán hôm nay", value: "120", color: Colors.orange),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              StatCard(title: "Doanh thu hôm nay", value: "₫5,000,000", color: Colors.blue),
              StatCard(title: "Người dùng mới", value: "15", color: Colors.purple),
            ],
          ),
          const SizedBox(height: 32),

          // 2. Line Chart
          const Text('Vé bán theo ngày', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 200, child: LineChartSample()),

          const SizedBox(height: 32),

          // 3. Pie Chart
          const Text('Phân loại sự kiện', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 200, child: PieChartSample()),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const StatCard({super.key, required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class LineChartSample extends StatelessWidget {
  const LineChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => Text('Day ${value.toInt() + 1}', style: const TextStyle(fontSize: 10)),
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, interval: 20),
        ),
      ),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 10),
            FlSpot(1, 30),
            FlSpot(2, 25),
            FlSpot(3, 50),
            FlSpot(4, 40),
            FlSpot(5, 60),
            FlSpot(6, 55),
          ],
          isCurved: true,
          barWidth: 3,
          color: Colors.blue,
          dotData: FlDotData(show: true),
        )
      ],
    ));
  }
}

class PieChartSample extends StatelessWidget {
  const PieChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(value: 40, color: Colors.green, title: 'Âm nhạc'),
          PieChartSectionData(value: 30, color: Colors.orange, title: 'Hội thảo'),
          PieChartSectionData(value: 20, color: Colors.blue, title: 'Triển lãm'),
          PieChartSectionData(value: 10, color: Colors.purple, title: 'Thể thao'),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }
}