class Slider {
  Slider({this.id, this.cover, this.title, this.startDate, this.endDate, this.active, this.createdAt});

  int id;
  String cover;
  String title;
  DateTime startDate;
  DateTime endDate;
  int active;
  DateTime createdAt;

  factory Slider.fromJson(Map<String, dynamic> json) => Slider(
        id: json["id"],
        cover: json["cover"],
        title: json["title"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        active: json["active"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cover": cover,
        "title": title,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "active": active,
        "created_at": createdAt.toIso8601String(),
      };

  @override
  String toString() {
    return 'Slider{id: $id, cover: $cover, title: $title, startDate: $startDate, endDate: $endDate, active: $active, createdAt: $createdAt}';
  }
}
