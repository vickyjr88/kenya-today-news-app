import 'dart:convert';

import 'package:http/http.dart' as http;

class Post {
  final int id;
  final String link;
  final String title;
  final String excerpt;

  Post({this.id, this.link, this.title, this.excerpt});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        link: json['link'],
        title: json['title']['rendered'],
        excerpt: json['excerpt']['rendered']);
  }

  static Future<Post> fetchPost() async {
    final response = await http.get('https://kenyatoday.news/wp-json/wp/v2/posts/42387');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Post.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load post');
    }
  }
}
