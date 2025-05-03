import 'package:flutter/material.dart';
import 'trainer.dart';
import 'profile.dart'; // Import the new profile screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _notifications = [];
  bool _showNotifications = false;

  final List<Map<String, dynamic>> workoutItems = [
    {
      'title': 'Beginner Full Body',
      'image': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
    },
    {
      'title': 'HIIT Cardio',
      'image': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b',
    },
    {
      'title': 'Yoga Flow',
      'image': 'https://images.unsplash.com/photo-1545205597-3d9d02c29597',
    },
  ];

  @override
  void initState() {
    super.initState();
    _notifications.addAll([
      {
        'title': 'New Workout Available',
        'message': 'Check out our new HIIT workout routine',
        'time': '10 min ago',
        'read': false,
        'icon': Icons.fitness_center,
      },
      {
        'title': 'Class Reminder',
        'message': 'Your yoga class starts in 30 minutes',
        'time': '1 hour ago',
        'read': false,
        'icon': Icons.access_alarm,
      },
      {
        'title': 'Achievement Unlocked',
        'message': 'You\'ve completed 5 workouts this week!',
        'time': '2 days ago',
        'read': true,
        'icon': Icons.star,
      },
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.black,
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'Workouts'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Trainer'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: Stack(
        children: [
          _buildScreens()[_currentIndex],
          if (_showNotifications) _buildNotificationsPanel(),
        ],
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      _buildHomePage(),
      const Center(
        child: Text("Workout Page", style: TextStyle(color: Colors.white)),
      ),
      const TrainerScreen(),
      const ProfileScreen(), // Updated to use the new ProfileScreen
    ];
  }

  Widget _buildHomePage() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildMetricsSection(),
            const SizedBox(height: 20),
            _buildSectionTitle("Workout Tutorial", () {}),
            _buildHorizontalScrollItems(workoutItems),
            const SizedBox(height: 20),
            _buildSectionTitle("Our Location", () {}),
            _buildLocationCards(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final unreadCount = _notifications.where((n) => !n['read']).length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Hello,",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              Text(
                "Dominic Toretto",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Spacer(),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _showNotifications = !_showNotifications;
                    if (_showNotifications) {
                      for (var notification in _notifications) {
                        notification['read'] = true;
                      }
                    }
                  });
                },
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              'https://randomuser.me/api/portraits/men/1.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[850],
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          hintText: "Search workouts, exercises...",
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Row(
            children: [
              _buildMetricCard(
                "Calories",
                "2500",
                "kcal",
                Icons.local_fire_department,
              ),
              const SizedBox(width: 8),
              _buildMetricCard("Workout", "300", "kcal", Icons.fitness_center),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildMetricCard("Time", "25:25", "mins", Icons.timer),
              const SizedBox(width: 8),
              _buildMetricCard("Water", "2.5", "L", Icons.water_drop),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String unit,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.cyan),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                "$value $unit",
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, VoidCallback onSeeAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: onSeeAll,
            child: const Text("See all", style: TextStyle(color: Colors.cyan)),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalScrollItems(List<Map<String, dynamic>> items) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildItemCard(items[index]['title'], items[index]['image']);
        },
      ),
    );
  }

  Widget _buildItemCard(String title, String imageUrl) {
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildLocationCard("Downtown Gym", "123 Main St, City Center"),
          const SizedBox(height: 12),
          _buildLocationCard("Beach Club", "456 Ocean Ave, Coastal Area"),
          const SizedBox(height: 12),
          _buildLocationCard(
            "Mountain Resort",
            "789 Highland Rd, Mountain View",
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(String title, String address) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.cyan, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsPanel() {
    return Positioned(
      top: 80,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _showNotifications = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.grey, height: 1),
              if (_notifications.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'No new notifications',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      return _buildNotificationItem(notification, index);
                    },
                  ),
                ),
              if (_notifications.isNotEmpty)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _notifications.clear();
                    });
                  },
                  child: const Text(
                    'Clear All',
                    style: TextStyle(color: Colors.cyan),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification, int index) {
    return Dismissible(
      key: Key('notification_$index'),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          _notifications.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification dismissed'),
            backgroundColor: Colors.red,
          ),
        );
      },
      child: ListTile(
        leading: Icon(
          notification['icon'] as IconData,
          color: notification['read'] ? Colors.grey : Colors.cyan,
        ),
        title: Text(
          notification['title'],
          style: TextStyle(
            color: notification['read'] ? Colors.grey[400] : Colors.white,
            fontWeight:
                notification['read'] ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification['message'],
              style: TextStyle(
                color:
                    notification['read'] ? Colors.grey[500] : Colors.grey[300],
              ),
            ),
            Text(
              notification['time'],
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        onTap: () {
          setState(() {
            _notifications[index]['read'] = true;
          });
        },
      ),
    );
  }
}
