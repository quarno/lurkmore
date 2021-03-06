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
import 'package:lurkmore/saved_boards.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'lurkmore',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: '4Chan'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final _navigation = [
    SavedBoardsPage(),
    Center(child: Text('TODO Saved threads')),
    Center(child: Text('TODO settings')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navigation[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.list), title: Text('boards')),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border), title: Text('saved threads')),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('settings')),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
