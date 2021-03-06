/* Copyright (C) 2020  Manuel Quarneti
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:lurkmore/4chan/static.dart';
import 'package:lurkmore/types.dart';
import 'package:photo_view/photo_view.dart';
import '4chan/api.dart';

class ThreadPage extends StatelessWidget {
  final String board;
  final String threadSub;
  final int threadNo;

  const ThreadPage(
      {Key key,
      @required this.board,
      @required this.threadSub,
      @required this.threadNo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(parse(threadSub).body.text)),
      body: ThreadView(board: board, threadNo: threadNo),
    );
  }
}

class ThreadView extends StatefulWidget {
  ThreadView({Key key, @required this.board, @required this.threadNo})
      : super(key: key);

  final String board;
  final int threadNo;

  @override
  _ThreadViewState createState() => _ThreadViewState();
}

class _ThreadViewState extends State<ThreadView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Post>>(
        future: fetchThread(widget.board, widget.threadNo),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PostList(board: widget.board, posts: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PostList extends StatefulWidget {
  PostList({Key key, @required this.board, @required this.posts})
      : super(key: key);

  final String board;
  final List<Post> posts;

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.posts.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (BuildContext context, int index) {
        return widget.posts[index].tim != null
            ? ListTile(
                leading: Container(
                  height: 64,
                  width: 64,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoView(
                            imageProvider: getImage(
                              widget.board,
                              widget.posts[index].tim,
                              widget.posts[index].ext,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Image(
                      image: getThumbnail(
                        widget.board,
                        widget.posts[index].tim,
                      ),
                    ),
                  ),
                ),
                title: parseHtmlString(context, widget.posts[index].com))
            : ListTile(
                title: parseHtmlString(context, widget.posts[index].com));
      },
    );
  }
}

String unescapeHtml(String s) {
  return parse(s).text;
}

Widget parseHtmlString(BuildContext context, String htmlString,
    [bool isTitle]) {
  if (htmlString == null) return null;

  final theme = Theme.of(context);
  var html = parse(htmlString).body.nodes;

  var children = <Widget>[];

  for (final dynamic element in html) {
    var style = DefaultTextStyle.of(context).style;

    try {
      switch (element.className) {
        case 'quotelink':
          style = TextStyle(color: theme.cursorColor);
          break;
        case 'quote':
          style = TextStyle(color: theme.accentColor);
          break;
        default:
      }
    } on NoSuchMethodError {}

    if (element.text != '') children.add(Text(element.text, style: style));
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: children,
  );
}
