class Item {
  Item({
    this.id,
    this.audioFile,
    this.title,
    this.subtitle,
    this.active,
  });

  int id;
  String audioFile;
  String title;
  String subtitle;
  int active;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        audioFile: json["audio_file"],
        title: json["title"],
        subtitle: json["subtitle"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "audio_file": audioFile,
        "title": title,
        "subtitle": subtitle,
        "active": active,
      };
}
