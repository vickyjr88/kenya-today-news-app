import 'dart:convert';

import 'package:http/http.dart' as http;

import '../webservice.dart';

class PostModel {
  final int id;
  final String link;
  final String title;
  final String content;
  final String excerpt;

  PostModel({this.id, this.link, this.title, this.content, this.excerpt});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
        id: json['id'],
        link: json['link'],
        title: json['title']['rendered'],
        excerpt: json['excerpt']['rendered'],
        content: json['content']['rendered']);
  }

  static Future<PostModel> fetchPost(var id) async {
    final response = await http.get('https://kenyatoday.news/wp-json/wp/v2/posts/$id');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return PostModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load post');
    }
  }

  static Resource<List<PostModel>> get all {

    return Resource(
        url: Constants.NEWS_URL,
        parse: (response) {
          final result = json.decode(response.body);
          Iterable list = result;
          return list.map((model) => PostModel.fromJson(model)).toList();
        }
    );

  }
}

class Constants {
  static final NEWS_URL = "https://kenyatoday.news/wp-json/wp/v2/posts?_fields=id,excerpt.rendered,title,link,content.rendered";
}
