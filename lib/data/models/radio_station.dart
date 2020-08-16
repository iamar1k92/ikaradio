import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:base/core/local/database_helper.dart';
import 'package:base/data/models/category.dart';

class RadioStation {
  int id;
  List<Category> categories;
  String cover;
  String streamUrl;
  String name;
  String slug;
  String description;
  bool isFavorite;

  MediaItem get mediaItem => MediaItem(
        id: streamUrl,
        title: name,
        artUri: cover,
        album: categories.map((e) => e.name).toList().join(',').toString(),
        extras: toJson(),
      );

  static final String table = "favorite_radios";
  static final String _columnID = "id";
  static final String _columnCategory = "categories";
  static final String _columnCover = "cover";
  static final String _columnStreamUrl = "stream_url";
  static final String _columnName = "name";
  static final String _columnSlug = "slug";
  static final String _columnDescription = "description";
  static final String _columnIsFavorite = "is_favorite";

  // Create table SQL query
  static final String createTable = "CREATE TABLE $table ($_columnID INTEGER AUTO_INCREMENT PRIMARY KEY,"
      "$_columnCategory TEXT,"
      "$_columnCover TEXT,"
      "$_columnStreamUrl TEXT,"
      "$_columnName TEXT,"
      "$_columnSlug TEXT,"
      "$_columnDescription TEXT,"
      "$_columnIsFavorite INTEGER)";

  RadioStation({
    this.id,
    this.categories,
    this.cover,
    this.streamUrl,
    this.name,
    this.slug,
    this.description,
    this.isFavorite,
  });

  factory RadioStation.fromJson(Map<String, dynamic> json) => RadioStation(
        id: json["id"],
        categories: json["categories"] == null ? null : (json["categories"] as List).map((category) => Category.fromJson(category)).toList(),
        cover: json["cover"],
        streamUrl: json["stream_url"],
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        isFavorite: json["is_favorite"] == 1,
      );

  Map<String, dynamic> toJson() => {
        "type": "radio",
        "id": id,
        "categories": jsonEncode(categories.map((category) => category.toJson()).toList()),
        "cover": cover,
        "stream_url": streamUrl,
        "name": name,
        "slug": slug,
        "description": description,
        "is_favorite": isFavorite ? 1 : 0,
      };

  Map<String, dynamic> toDatabaseJson() => {
        "id": id,
        "categories": jsonEncode(categories.map((category) => category.toJson()).toList()),
        "cover": cover,
        "stream_url": streamUrl,
        "name": name,
        "slug": slug,
        "description": description,
        "is_favorite": isFavorite ? 1 : 0,
      };

  Future<List<RadioStation>> getList() async {
    var db = await DatabaseHelper().database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT * from $table');
    return x.isNotEmpty
        ? x
            .map((c) => RadioStation(
                  id: c['id'],
                  categories: (jsonDecode(c['categories']) as List).map((category) => Category.fromJson(category)).toList(),
                  cover: c['cover'],
                  streamUrl: c['stream_url'],
                  name: c['name'],
                  slug: c['slug'],
                  description: c['description'],
                  isFavorite: c['is_favorite'] == 1,
                ))
            .toList()
        : [];
  }

  @override
  String toString() {
    return 'RadioStation{id: $id, categories: $categories, cover: $cover, streamUrl: $streamUrl, name: $name, slug: $slug, description: $description, isFavorite: $isFavorite}';
  }
}
