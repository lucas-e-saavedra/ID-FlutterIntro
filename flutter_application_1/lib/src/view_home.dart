import 'package:flutter/material.dart';
import 'view_tokboxsessioninfo.dart';
import 'view_listapersonajes.dart';
import 'view_counter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.callback})
      : super(key: key);
  final String title;
  final VoidCallback callback;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedTabIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const CounterPage(title: "Home"),
      const CharactersListPage(title: "Characters"),
      const TokboxSessionPage(title: "VideoCall")
    ];
    List<BottomNavigationBarItem> tabs = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      const BottomNavigationBarItem(
          icon: Icon(Icons.group), label: "Characters"),
      const BottomNavigationBarItem(
          icon: Icon(Icons.video_call), label: "VideoCall")
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: widget.callback,
              icon: const Icon(Icons.logout, semanticLabel: 'Log out'))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTabIndex, onTap: _onItemTapped, items: tabs),
      body: Center(child: pages.elementAt(_selectedTabIndex)),
    );
  }
}
