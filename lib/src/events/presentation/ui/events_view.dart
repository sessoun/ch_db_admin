import 'package:ch_db_admin/src/events/data/models/event.dart';
import 'package:ch_db_admin/src/events/presentation/controller/event_controller.dart';
import 'package:ch_db_admin/src/events/presentation/ui/add_edit_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/event.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  @override
  void initState() {
    super.initState();
    getAllEvents();
  }

  getAllEvents() async {
    await context.read<EventController>().fetchEvents();
  }

  // Sample event data
  final List<EventModel> events = [
    EventModel(
      title: 'Youth Conference',
      date: DateTime.now(),
      location: 'Church Hall A',
      description: 'A conference for the youth to engage and learn.',
      imageUrl:
          'https://images.pexels.com/photos/28457391/pexels-photo-28457391/free-photo-of-fisherman-in-istanbul-with-city-skyline.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load',
      id: '',
      organizerId: '',
    ),
    EventModel(
      title: 'Community Outreach',
      date: DateTime.now().add(const Duration(days: 3)),
      location: 'Community Center',
      description: 'Outreach event for community service.',
      imageUrl:
          'https://images.pexels.com/photos/28457391/pexels-photo-28457391/free-photo-of-fisherman-in-istanbul-with-city-skyline.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load',
      id: '',
      organizerId: '',
    ),
    // Add more event records as needed
  ];

  String searchText = '';
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Events...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child:
                  Consumer<EventController>(builder: (context, controller, _) {
                final filteredEvents = controller.filterEvents(searchText);
                return isGridView
                    ? _buildGridView(filteredEvents)
                    : _buildListView(filteredEvents);
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddEventView(),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGridView(List<Event> events) {
    return Consumer<EventController>(builder: (context, controller, _) {
      if (events.isEmpty) {
        return const Center(
            child: Text('Events list is empty. Press + to add one.'));
      } else {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3 / 4,
          ),
          itemCount: events.length,
          itemBuilder: (context, index) {
            {
              final event = events[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to event details or perform any action
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          event.imageUrl,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: Theme.of(context).textTheme.bodyLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Location: ${event.location}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Date: ${event.date.toLocal()}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      }
    });
  }

  Widget _buildListView(List<Event> events) {
    if (events.isEmpty) {
      return const Center(
          child: Text('Events list is empty. Press + to add one.'));
    } else {
      return ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Text(
                            event.title,
                            // style: Theme.of(context)
                            //     .textTheme
                            //     .headline6!
                            //     .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Location: ${event.location}',
                            // style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Date: ${event.date.toLocal()}',
                            // style: Theme.of(context).textTheme.bodyText2,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            event.description,
                            // style: Theme.of(context).textTheme.bodyText2,
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AddEventView(
                                    event:
                                        event, // Pass the selected event for editing
                                  ),
                                ));
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Image.network(
                    event.imageUrl,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Location: ${event.location}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Date: ${event.date.toLocal()}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
