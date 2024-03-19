import 'package:flutter/material.dart';
import 'package:tab_bar/const/tabs.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() => _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> with TickerProviderStateMixin{

  late final TabController tabController;
  int selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: TABS.length,
      vsync: this,
    );
    tabController.addListener(() {
      setState(() {
        selectedIndex = tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bottom Navigation Bar'),
      ),
      body: TabBarView(
        controller: tabController,
        children: TABS.map((e) =>
          Center(
            child: Icon(e.icon),
          ),
        ).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        // currentIndex: tabController.index,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.shifting, //탭하면 확대
        onTap: (index) {
          tabController.animateTo(index);
        },
        items: TABS.map((e) =>
          BottomNavigationBarItem(
            icon: Icon(e.icon),
            label: e.label,
          ),
        ).toList(),
      ),
    );
  }
}
