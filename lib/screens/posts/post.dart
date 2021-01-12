import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kenya_today_news/models/postmodel.dart';

class Post extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyPost();
  }
}

class MyPost extends StatefulWidget {
  @override
  _MyPostState createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  Future<PostModel> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = PostModel.fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Post"),
        ),
        body: Container(
          child: FutureBuilder<PostModel>(
            future: futurePost,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                    child: Column(children: <Widget>[
                  Text(snapshot.data.title),
                  Html(
                      data: snapshot.data.content,
                      onLinkTap: (String url) {
                        // launch(url);
                      }),
                ]));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ));
  }
}
