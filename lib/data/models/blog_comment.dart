class BlogComment {
  int id;
  int blogId;
  int authorId;
  String author;
  String comment;
  DateTime createdAt;

  BlogComment({this.id, this.blogId, this.authorId, this.author, this.comment, this.createdAt});

  factory BlogComment.fromJson(Map<String, dynamic> json) => BlogComment(
        id: json["id"],
        blogId: int.parse(json["blog_id"].toString()),
        authorId: int.parse(json["author_id"].toString()),
        author: json["author"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "blog_d": blogId,
        "author_id": author,
        "author": author,
        "comment": comment,
        "created_at": "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
      };
}
