class Event {
  final String id;                   
  final String title;
  final String imageUrl;                
  final String description;          
  final DateTime date;               
  final String location;             
  final String organizerId;          

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.location,
    required this.organizerId,
  });
}
