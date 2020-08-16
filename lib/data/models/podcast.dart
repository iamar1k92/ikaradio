import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:base/core/local/database_helper.dart';
import 'package:base/data/models/item.dart';
import 'package:base/data/models/podcast_category.dart';

class Podcast {
  int id;
  String cover;
  List<PodcastCategory> categories;
  String title;
  String slug;
  String description;
  int featured;
  List<Item> items;
  bool isFavorite;

  static final String table = "favorite_podcasts";
  static final String _columnID = "id";
  static final String _columnCover = "cover";
  static final String _columnCategory = "categories";
  static final String _columnTitle = "title";
  static final String _columnSlug = "slug";
  static final String _columnDescription = "description";
  static final String _columnIsFavorite = "is_favorite";
  static final String _columnItems = "items";

  // Create table SQL query
  static final String createTable = "CREATE TABLE $table ($_columnID INTEGER AUTO_INCREMENT PRIMARY KEY,"
      "$_columnCover TEXT,"
      "$_columnCategory TEXT,"
      "$_columnTitle TEXT,"
      "$_columnSlug TEXT,"
      "$_columnDescription TEXT,"
      "$_columnIsFavorite INTEGER,"
      "$_columnItems TEXT)";

  Podcast({this.id, this.cover, this.categories, this.title, this.slug, this.description, this.featured, this.items, this.isFavorite});

  MediaItem get mediaItem => MediaItem(
        id: items.first.audioFile,
        album: title,
        title: items.first.title,
        artUri: cover,
        genre: categories.map((e) => e.name).toList().join(',').toString(),
        extras: toJson(),
      );

  List<MediaItem> get queue => items
      .map((item) => MediaItem(
            id: item.audioFile,
            album: title,
            title: item.title,
            artUri: cover,
            genre: categories.map((e) => e.name).toList().join(',').toString(),
            extras: toJson(),
          ))
      .toList();

  factory Podcast.fromJson(Map<String, dynamic> json) => Podcast(
        id: json["id"],
        cover: json["cover"],
        categories: List<PodcastCategory>.from(json["categories"].map((x) => PodcastCategory.fromJson(x))),
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
        featured: json["featured"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        isFavorite: json["is_favorite"] == 1,
      );

  Map<String, dynamic> toJson() => {
        "type": "podcast",
        "id": id,
        "cover": cover,
        "categories": jsonEncode(List<dynamic>.from(categories.map((x) => x.toJson()))),
        "title": title,
        "slug": slug,
        "description": description,
        "items": jsonEncode(List<dynamic>.from(items.map((x) => x.toJson()))),
        "is_favorite": isFavorite ? 1 : 0,
      };

  Map<String, dynamic> toDatabaseJson() => {
        "id": id,
        "cover": cover,
        "categories": jsonEncode(List<dynamic>.from(categories.map((x) => x.toJson()))),
        "title": title,
        "slug": slug,
        "description": description,
        "items": jsonEncode(List<dynamic>.from(items.map((x) => x.toJson()))),
        "is_favorite": isFavorite ? 1 : 0,
      };
  Future<List<Podcast>> getList() async {
    var db = await DatabaseHelper().database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT * from $table');
    return x.isNotEmpty
        ? x
            .map((c) => Podcast(
                  id: c['id'],
                  categories: (jsonDecode(c['categories']) as List).map((category) => PodcastCategory.fromJson(category)).toList(),
                  cover: c['cover'],
                  title: c['title'],
                  slug: c['slug'],
                  description: c['description'],
                  items: (jsonDecode(c['items']) as List).map((item) => Item.fromJson(item)).toList(),
                  isFavorite: c['is_favorite'] == 1,
                ))
            .toList()
        : [];
  }

  @override
  String toString() {
    return 'Podcast{id: $id, cover: $cover, categories: $categories, title: $title, slug: $slug, description: $description, featured: $featured, items: $items, isFavorite: $isFavorite}';
  }
}
