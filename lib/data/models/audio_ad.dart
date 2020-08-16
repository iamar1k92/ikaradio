import 'package:audio_service/audio_service.dart';
import 'package:base/generated/l10n.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AudioAd {
  AudioAd({this.id, this.audioFile, this.title, this.url, this.active, this.createdAt});

  int id;
  String audioFile;
  String title;
  String url;
  int active;
  DateTime createdAt;

  MediaItem get mediaItem => MediaItem(
        id: audioFile,
        title: title,
        artUri: DotEnv().env['BASE_URL'] + "/assets/logo.png",
        album: "Ad",
        extras: toJson(),
      );

  factory AudioAd.fromJson(Map<String, dynamic> json) => AudioAd(
        id: json["id"],
        audioFile: json["audio_file"],
        title: json["title"],
        url: json["url"],
        active: json["active"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "type": "ad",
        "id": id,
        "audio_file": audioFile,
        "title": title,
        "url": url,
        "active": active,
        "created_at": createdAt.toIso8601String(),
      };
}
