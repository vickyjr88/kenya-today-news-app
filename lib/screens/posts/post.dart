import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:kenya_today_news/models/postmodel.dart';

class Post extends StatelessWidget {
  var id;

  Post(this.id);

  @override
  Widget build(BuildContext context) {
    return MyPost(id);
  }
}

class MyPost extends StatefulWidget {
  var id;

  MyPost(this.id);

  @override
  _MyPostState createState() => _MyPostState(id);
}

class _MyPostState extends State<MyPost> {
  var id;

  _MyPostState(this.id);

  Future<PostModel> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = PostModel.fetchPost(id);
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
                      data: cleanUp(snapshot.data.content),
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

  cleanUp(dynamic excerpt) {
    var doc = parse(excerpt);
    doc.getElementsByClassName('sharedaddy').forEach((element) {
      element.remove();
    });
    return doc.outerHtml;
  }
}
