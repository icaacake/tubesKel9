import 'package:flutter/material.dart';

class TrainerScreen extends StatefulWidget {
  const TrainerScreen({super.key});

  @override
  State<TrainerScreen> createState() => _TrainerScreenState();
}

class _TrainerScreenState extends State<TrainerScreen> {
  // State variables
  String selectedLocation = 'All Locations';
  String selectedGender = 'All';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  
  // Data storage
  final Map<String, List<Map<String, dynamic>>> _reservations = {};
  final List<Map<String, dynamic>> _notifications = [];
  
  // Filter options
  final List<String> _genderOptions = ['All', 'Female', 'Male'];
  final List<String> _locationOptions = [
    'All Locations',
    'Downtown Gym',
    'Beach Club',
    'Mountain Resort'
  ];

  // Trainer data
  final List<Map<String, String>> _trainers = [
    {
      'name': 'Raider',
      'specialty': 'Senior Trainer',
      'gender': 'Male',
      'location': 'Downtown Gym',
      'image': 'https://randomuser.me/api/portraits/men/11.jpg',
    },
    {
      'name': 'James',
      'specialty': 'Senior Trainer',
      'gender': 'Male',
      'location': 'Beach Club',
      'image': 'https://randomuser.me/api/portraits/men/12.jpg',
    },
    {
      'name': 'Luke',
      'specialty': 'Personal Trainer',
      'gender': 'Male',
      'location': 'Mountain Resort',
      'image': 'https://randomuser.me/api/portraits/men/13.jpg',
    },
    {
      'name': 'Mate',
      'specialty': 'Trainer',
      'gender': 'Male',
      'location': 'Downtown Gym',
      'image': 'https://randomuser.me/api/portraits/men/14.jpg',
    },
    {
      'name': 'Juke',
      'specialty': 'Trainer',
      'gender': 'Male',
      'location': 'Mountain Resort',
      'image': 'https://randomuser.me/api/portraits/men/15.jpg',
    },
    {
      'name': 'Shyane',
      'specialty': 'Trainer',
      'gender': 'Female',
      'location': 'Beach Club',
      'image': 'https://randomuser.me/api/portraits/women/11.jpg',
    },
    {
      'name': 'Sophia',
      'specialty': 'Personal Trainer',
      'gender': 'Female',
      'location': 'Downtown Gym',
      'image': 'https://randomuser.me/api/portraits/women/12.jpg',
    },
    {
      'name': 'Lainey',
      'specialty': 'Senior Trainer',
      'gender': 'Female',
      'location': 'Mountain Resort',
      'image': 'https://randomuser.me/api/portraits/women/13.jpg',
    },
    {
      'name': 'Serena',
      'specialty': 'Trainer',
      'gender': 'Female',
      'location': 'Beach Club',
      'image': 'https://randomuser.me/api/portraits/women/14.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with sample notifications
    _notifications.addAll([
      {
        'title': 'Welcome!',
        'message': 'Start booking your personal training sessions',
        'time': DateTime.now().subtract(const Duration(hours: 2)),
        'read': false,
        'type': 'system',
      },
      {
        'title': 'New Feature',
        'message': 'Now you can view your training schedule',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'read': false,
        'type': 'system',
      },
    ]);
  }

  // Helper functions for date/time formatting
  String _formatDate(DateTime date) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _formatTimeForNotification(DateTime time) {
    final hour = time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  // Reservation system
  void _makeReservation(Map<String, String> trainer) {
    final now = DateTime.now();
    final reservationDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    
    // Validate reservation time
    if (reservationDateTime.isBefore(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot book session in the past'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check for time conflicts
    final hasConflict = _reservations.values.any((reservationList) =>
        reservationList.any((existingReservation) {
          final existingDateTime = DateTime(
            existingReservation['date'].year,
            existingReservation['date'].month,
            existingReservation['date'].day,
            existingReservation['time'].hour,
            existingReservation['time'].minute,
          );
          return existingDateTime == reservationDateTime;
        }));

    if (hasConflict) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You already have a session at this time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final reservation = {
      'trainer': trainer,
      'date': selectedDate,
      'time': selectedTime,
      'confirmed': false,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    setState(() {
      _reservations.putIfAbsent(trainer['name']!, () => []).add(reservation);
      
      _notifications.insert(0, {
        'title': 'Booking Pending',
        'message': 'Session with ${trainer['name']} on ${_formatDate(selectedDate)} at ${_formatTime(selectedTime)}',
        'time': DateTime.now(),
        'read': false,
        'type': 'booking',
        'reservationId': reservation['id'],
      });
    });

    // Simulate trainer confirmation after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          final reservationIndex = _reservations[trainer['name']]!
              .indexWhere((r) => r['id'] == reservation['id']);
          if (reservationIndex != -1) {
            _reservations[trainer['name']]![reservationIndex]['confirmed'] = true;
            
            _notifications.insert(0, {
              'title': 'Booking Confirmed',
              'message': 'Session with ${trainer['name']} confirmed',
              'time': DateTime.now(),
              'read': false,
              'type': 'confirmation',
              'reservationId': reservation['id'],
            });
          }
        });
      }
    });
  }

  // UI Components
  void _showReservationDialog(BuildContext context, Map<String, String> trainer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text(
                'Book Session with ${trainer['name']}',
                style: const TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Specialty: ${trainer['specialty']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Date:', style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 30)),
                          );
                          if (picked != null && picked != selectedDate) {
                            setState(() => selectedDate = picked);
                          }
                        },
                        child: Text(
                          _formatDate(selectedDate),
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Time:', style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (picked != null && picked != selectedTime) {
                            setState(() => selectedTime = picked);
                          }
                        },
                        child: Text(
                          _formatTime(selectedTime),
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    _makeReservation(trainer);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Session booked with ${trainer['name']} on ${_formatDate(selectedDate)} at ${_formatTime(selectedTime)}'),
                      ),
                    );
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return ListTile(
                    tileColor: notification['read'] ? Colors.transparent : Colors.grey[800],
                    leading: _getNotificationIcon(notification['type']),
                    title: Text(
                      notification['title'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: notification['read'] ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      notification['message'],
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Text(
                      _formatTimeForNotification(notification['time']),
                      style: const TextStyle(color: Colors.white54),
                    ),
                    onTap: () {
                      setState(() => _notifications[index]['read'] = true);
                      if (notification['reservationId'] != null) {
                        Navigator.pop(context);
                        _showSchedule(context);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Icon _getNotificationIcon(String type) {
    switch (type) {
      case 'confirmation':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'cancellation':
        return const Icon(Icons.cancel, color: Colors.red);
      case 'booking':
        return const Icon(Icons.schedule, color: Colors.blue);
      default:
        return const Icon(Icons.notifications, color: Colors.white);
    }
  }

  void _showSchedule(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your Training Schedule',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _reservations.isEmpty
                    ? const Center(
                        child: Text(
                          'No sessions booked yet',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView(
                        children: [
                          for (final trainerName in _reservations.keys)
                            for (final reservation in _reservations[trainerName]!)
                              _buildReservationCard(reservation),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReservationCard(Map<String, dynamic> reservation) {
    return Dismissible(
      key: Key(reservation['id']),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text('Cancel Session', style: TextStyle(color: Colors.white)),
            content: Text(
              'Are you sure you want to cancel your session with ${reservation['trainer']['name']}?',
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) => _cancelReservation(reservation),
      child: Card(
        color: Colors.grey[850],
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(reservation['trainer']['image']),
          ),
          title: Text(
            reservation['trainer']['name'],
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${reservation['trainer']['specialty']} at ${reservation['trainer']['location']}',
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                '${_formatDate(reservation['date'])} at ${_formatTime(reservation['time'])}',
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                reservation['confirmed'] ? 'Confirmed' : 'Pending Confirmation',
                style: TextStyle(
                  color: reservation['confirmed'] ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _cancelReservation(Map<String, dynamic> reservation) {
    setState(() {
      _reservations[reservation['trainer']['name']]!
          .removeWhere((r) => r['id'] == reservation['id']);
      
      if (_reservations[reservation['trainer']['name']]!.isEmpty) {
        _reservations.remove(reservation['trainer']['name']);
      }
      
      _notifications.insert(0, {
        'title': 'Booking Cancelled',
        'message': 'Session with ${reservation['trainer']['name']} cancelled',
        'time': DateTime.now(),
        'read': false,
        'type': 'cancellation',
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session cancelled successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTrainers = _trainers.where((t) {
      final matchesGender = selectedGender == 'All' || t['gender'] == selectedGender;
      final matchesLocation = selectedLocation == 'All Locations' || t['location'] == selectedLocation;
      return matchesGender && matchesLocation;
    }).toList()
      ..sort((a, b) => a['specialty']!.compareTo(b['specialty']!));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Personal Trainer', style: TextStyle(color: Colors.white)),
        actions: [
          _buildNotificationButton(),
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () => _showSchedule(context),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening profile...')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildLocationDropdown(),
            const SizedBox(height: 16),
            _buildGenderFilter(),
            const SizedBox(height: 16),
            _buildTrainerGrid(filteredTrainers),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    final unreadCount = _notifications.where((n) => !n['read']).length;
    
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            _showNotifications(context);
            setState(() {
              for (var notification in _notifications) {
                notification['read'] = true;
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
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                '$unreadCount',
                style: const TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLocationDropdown() {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.grey[900],
      value: selectedLocation,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[850],
        hintText: 'Choose fitness location',
        hintStyle: const TextStyle(color: Colors.white54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      items: _locationOptions.map((location) {
        return DropdownMenuItem(
          value: location,
          child: Text(location, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: (value) => setState(() => selectedLocation = value!),
    );
  }

  Widget _buildGenderFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Filter by Gender', style: TextStyle(color: Colors.white70)),
        DropdownButton<String>(
          dropdownColor: Colors.grey[900],
          value: selectedGender,
          underline: Container(),
          style: const TextStyle(color: Colors.white),
          items: _genderOptions.map((gender) {
            return DropdownMenuItem(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
          onChanged: (value) => setState(() => selectedGender = value!),
        ),
      ],
    );
  }

  Widget _buildTrainerGrid(List<Map<String, String>> trainers) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: trainers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          final trainer = trainers[index];
          return GestureDetector(
            onTap: () => _showReservationDialog(context, trainer),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(trainer['image']!),
                    radius: 30,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    trainer['name']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    trainer['specialty']!,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
