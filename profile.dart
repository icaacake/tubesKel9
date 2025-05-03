import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 30),
              _buildStatsSection(),
              const SizedBox(height: 30),
              _buildMenuItems(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dominic Toretto',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'toretto89@gmail.com',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem('3h Earn', 'Total time'),
          _buildStatItem('8500 cal', 'Ramed'),
          _buildStatItem('13 Days', 'Personal'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.cyan,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems() {
    final List<Map<String, dynamic>> menuItems = [
      {'title': 'Membership', 'icon': Icons.card_membership, 'color': Colors.cyan},
      {'title': 'Transaction', 'icon': Icons.receipt, 'color': Colors.cyan},
      {'title': 'General', 'icon': Icons.settings, 'color': Colors.cyan},
      {'title': 'Help', 'icon': Icons.help_outline, 'color': Colors.cyan},
      {'title': 'Contact Us', 'icon': Icons.mail_outline, 'color': Colors.cyan},
      {'title': 'Log out', 'icon': Icons.logout, 'color': Colors.red},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: menuItems.map((item) {
          return Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
                item['icon'] as IconData,
                color: item['color'] as Color,
              ),
              title: Text(
                item['title'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                if (item['title'] == 'Log out') {
                  // Add logout logic here
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
