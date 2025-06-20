import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/screens/create_event_screen.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  final List<Map<String, String>> events = const [
    {
      'name': 'Tech Conference 2025',
      'description': 'Explore the future of AI, Blockchain, and Flutter.',
      'place': 'Delhi Convention Center',
      'image': 'https://images.unsplash.com/photo-1581092334894-7aa9c3db1a6b'
    },
    {
      'name': 'Startup Meetup',
      'description': 'Network with founders and investors.',
      'place': 'Bangalore Hub',
      'image': 'https://images.unsplash.com/photo-1551836022-d5d88e9218df'
    },
    {
      'name': 'Flutter Festival',
      'description': 'Hands-on workshops and talks on Flutter.',
      'place': 'Mumbai Expo Center',
      'image': 'https://images.unsplash.com/photo-1521737604893-d14cc237f11d'
    },
    {
      'name': 'AI in Education',
      'description': 'Panel discussion on AI in the classroom.',
      'place': 'Hyderabad Knowledge Park',
      'image': 'https://images.unsplash.com/photo-1559757175-5700dde67548'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming Events"),
        backgroundColor: const Color(0xFF2193b0),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2193b0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateEventScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return EventCard(
              name: event['name']!,
              description: event['description']!,
              place: event['place']!,
              imageUrl: event['image']!,
            );
          },
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String name;
  final String description;
  final String place;
  final String imageUrl;

  const EventCard({
    super.key,
    required this.name,
    required this.description,
    required this.place,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Event Image
          Image.network(
            imageUrl,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          // Event Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2193b0),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey, size: 18),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        place,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
