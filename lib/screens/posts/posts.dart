import 'package:flutter/material.dart';
import 'package:kenya_today_news/screens/posts/post.dart';

class Posts extends StatelessWidget {
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
  Future<Post> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = Post.fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Post"),
        ),
        body: Container(
          child: FutureBuilder<Post>(
            future: futurePost,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: <Widget>[
                  Text(snapshot.data.title),
                  Text(snapshot.data.excerpt),
                ]);
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
