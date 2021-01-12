import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kenya_today_news/models/postmodel.dart';

import '../../webservice.dart';

class NewsListState extends State<NewsList> {
  List<PostModel> _newsArticles = List<PostModel>();

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
      // title: _newsArticles[index].urlToImage == null ? Image.asset(Constants.NEWS_URL) : Image.network(_newsArticles[index].urlToImage),
      title: Text(_newsArticles[index].title, style: TextStyle(fontSize: 18)),
      subtitle: Html(data: _newsArticles[index].excerpt),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('News'),
        ),
        body: ListView.builder(
          itemCount: _newsArticles.length,
          itemBuilder: _buildItemsForListView,
        ));
  }
}

class NewsList extends StatefulWidget {
  @override
  createState() => NewsListState();
}
