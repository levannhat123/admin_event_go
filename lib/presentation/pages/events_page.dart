import 'package:admin_event_go/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final modules = [
    {
      "title": "Events",
      "icon": Icons.event,
      "color": Color(0xFF6366F1),
      "gradient": [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      "route": RouterPath.eventsList,
    },
    {
      "title": "Categories",
      "icon": Icons.category,
      "color": Color(0xFFF59E0B),
      "gradient": [Color(0xFFF59E0B), Color(0xFFEF4444)],
      "route": RouterPath.categories,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F172A),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF1E293B),
        title: Text(
          "Event Management",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Module Grid
            SizedBox(height: 200, child: _buildModuleGrid()),

            // Recent Events Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
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
                      TextButton.icon(
                        onPressed: () {
                          context.push(RouterPath.eventsList);
                        },
                        icon: Icon(Icons.arrow_forward, color: Color(0xFF6366F1), size: 16),
                        label: Text('View All', style: TextStyle(color: Color(0xFF6366F1))),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
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
      padding: const EdgeInsets.all(24),
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
    final recentEvents = [
      {
        'title': 'Summer Music Festival 2024',
        'date': 'Jun 15, 2024',
        'status': 'Live',
        'statusColor': Color(0xFF10B981),
        'tickets': '450/500',
        'category': 'Music',
      },
      {
        'title': 'Tech Conference Asia',
        'date': 'Jun 20, 2024',
        'status': 'Upcoming',
        'statusColor': Color(0xFF6366F1),
        'tickets': '320/400',
        'category': 'Technology',
      },
      {
        'title': 'Food & Wine Expo',
        'date': 'Jun 25, 2024',
        'status': 'Upcoming',
        'statusColor': Color(0xFF6366F1),
        'tickets': '180/300',
        'category': 'Food',
      },
      {
        'title': 'Art Gallery Opening',
        'date': 'Jun 10, 2024',
        'status': 'Completed',
        'statusColor': Color(0xFF64748B),
        'tickets': '250/250',
        'category': 'Arts',
      },
      {
        'title': 'Sports Championship Final',
        'date': 'Jul 5, 2024',
        'status': 'Upcoming',
        'statusColor': Color(0xFF6366F1),
        'tickets': '890/1000',
        'category': 'Sports',
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: recentEvents.length,
      itemBuilder: (context, index) {
        final event = recentEvents[index];
        return _buildEventItem(
          event['title'] as String,
          event['date'] as String,
          event['status'] as String,
          event['statusColor'] as Color,
          event['tickets'] as String,
          event['category'] as String,
        );
      },
    );
  }

  Widget _buildEventItem(
    String title,
    String date,
    String status,
    Color statusColor,
    String tickets,
    String category,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF334155), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Event Image/Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.event, color: Colors.white, size: 30),
            ),
            SizedBox(width: 16),

            // Event Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.white60),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          date,
                          style: TextStyle(color: Colors.white60, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.category, size: 14, color: Colors.white60),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          category,
                          style: TextStyle(color: Colors.white60, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.confirmation_number, size: 14, color: Color(0xFFEC4899)),
                      SizedBox(width: 4),
                      Text(
                        tickets,
                        style: TextStyle(
                          color: Color(0xFFEC4899),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      Container(
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
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, color: Color(0xFF6366F1), size: 18),
              onPressed: () {},
            ),
          ],
        ),
      ),
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
              color: (module['color'] as Color).withOpacity(0.3),
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
                color: Colors.white.withOpacity(0.2),
                size: 120,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(module['icon'] as IconData, color: Colors.white, size: 32),
                  ),
                  Spacer(),
                  Text(
                    module['title'] as String,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Manage ${module['title']}',
                    style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
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
