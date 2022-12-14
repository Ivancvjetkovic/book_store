import 'package:flutter/material.dart';

class BookPosts {
  late final String title;
  late final String author;
  late final String description;
  late final String isbn;
  late final String image;
  late final String publisher;
  late final String published;
  late final String genre;
  BookPosts({
    required this.title,
    required this.author,
    required this.description,
    required this.isbn,
    required this.image,
    required this.publisher,
    required this.published,
    required this.genre,
  });
  factory BookPosts.fromJson(Map<String, dynamic> json) {
    return BookPosts(
      title: json['title'],
      author: json['author'],
      description: json['description'],
      isbn: json['isbn'],
      image: json['image'],
      publisher: json['publisher'],
      published: json['published'],
      genre: json['genre'],
    );
  }
}
