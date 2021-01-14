import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:kenya_today_news/models/postmodel.dart';
import 'package:kenya_today_news/screens/posts/post.dart';

import '../../webservice.dart';

class NewsListState extends State<NewsList> {
  List<PostModel> _newsArticles = List<PostModel>();

  viewPost(id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Post(id)));
  }

  @override
  void initState() {
    super.initState();
    _populateNewsArticles();
  }

  void _populateNewsArticles() {
    Webservice().load(PostModel.all).then((newsArticles) => {
          setState(() => {_newsArticles = newsArticles})
        });
  }

  ListTile _buildItemsForListView(BuildContext context, int index) {
    return ListTile(
      title: Text(_newsArticles[index].title, style: TextStyle(fontSize: 18)),
      subtitle: Html(data: cleanUp(_newsArticles[index].excerpt)),
      onTap: () => viewPost(_newsArticles[index].id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Kenya Today News'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => debugPrint('Search...'),
            )
          ],
        ),
        body: ListView.builder(
          itemCount: _newsArticles.length,
          itemBuilder: _buildItemsForListView,
        ));
  }

  cleanUp(dynamic excerpt) {
    var doc = parse(excerpt);
    doc.getElementsByTagName('a').forEach((element) {
      element.remove();
    });
    doc.getElementsByClassName('sharedaddy').forEach((element) {
      element.remove();
    });
    return doc.getElementsByTagName('p')[0].outerHtml;
  }
}

class NewsList extends StatefulWidget {
  @override
  createState() => NewsListState();
}

class NewsListSceen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Kenya Today News',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new NewsList(),
    );
  }
}
