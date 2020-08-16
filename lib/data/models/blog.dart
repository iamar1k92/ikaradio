import 'dart:convert';

import 'package:base/data/models/blog_category.dart';
import 'package:base/data/models/blog_comment.dart';

class Blog {
  Blog({this.id, this.cover, this.title, this.categories, this.description, this.slug, this.content, this.comments, this.active, this.createdAt});

  int id;
  String cover;
  String title;
  List<BlogCategory> categories;
  String description;
  String slug;
  String content;
  List<BlogComment> comments;
  int active;
  DateTime createdAt;

  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
        id: json["id"],
        cover: json["cover"],
        title: json["title"],
        categories: List<BlogCategory>.from(json["categories"].map((x) => BlogCategory.fromJson(x))),
        description: json["description"],
        slug: json["slug"],
        content: json["content"],
        comments: List<BlogComment>.from(json["comments"].map((x) => BlogComment.fromJson(x))),
        active: json["active"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cover": cover,
        "title": title,
        "categories": jsonEncode(List<dynamic>.from(categories.map((x) => x.toJson()))),
        "description": description,
        "slug": slug,
        "content": content,
        "comments": jsonEncode(List<dynamic>.from(comments.map((x) => x.toJson()))),
        "active": active,
        "created_at": createdAt.toIso8601String(),
      };

  @override
  String toString() {
    return 'Blog{id: $id, cover: $cover, title: $title, categories: $categories, description: $description, slug: $slug, content: $content, comments: $comments, active: $active, createdAt: $createdAt}';
  }
}
