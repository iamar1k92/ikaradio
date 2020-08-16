class NotificationMessage {
  String title;
  String message;
  String url;
  String cover;
  DateTime sentAt;

  NotificationMessage({
    this.title,
    this.message,
    this.url,
    this.cover,
    this.sentAt,
  });

  factory NotificationMessage.fromJson(Map<String, dynamic> json) => NotificationMessage(
        title: json["title"],
        message: json["message"],
        url: json["url"],
        cover: json["cover"],
        sentAt: DateTime.parse(json["sent_at"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "message": message,
        "url": url,
        "cover": cover,
        "sent_at": "${sentAt.year.toString().padLeft(4, '0')}-${sentAt.month.toString().padLeft(2, '0')}-${sentAt.day.toString().padLeft(2, '0')}",
      };
}
