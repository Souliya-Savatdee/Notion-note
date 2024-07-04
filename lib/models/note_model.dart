class Note {
  final int id;
  final String title;
  final String description;
  final String remind;
  final String date;
  final String priority;
  String trash;


  bool isSelected;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.remind,
    required this.date,
    required this.priority,
    required this.trash,


    this.isSelected = false,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'],
      description: json['description'],
      remind: json['remind'],
      date: json['datetime'],
      priority: json['priority'],
      trash: json['trash'],
      isSelected: json['isSelected'] ?? false,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'remind': remind,
      'date': date,
      'priority': priority,
      'trash': trash,

    };
  }
}
