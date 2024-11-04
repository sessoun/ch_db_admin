class Attendance {
  final String memberId;         
  final DateTime date;           
  final bool isPresent;         
  final String notes;           

  Attendance({
    required this.memberId,
    required this.date,
    required this.isPresent,
    this.notes = '',
  });
}
