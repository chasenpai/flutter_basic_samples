import 'package:flutter/material.dart';
import 'package:scrollable_widgets/layout/main_layout.dart';
import 'package:scrollable_widgets/screen/grid_view_screen.dart';
import 'package:scrollable_widgets/screen/list_view_screen.dart';
import 'package:scrollable_widgets/screen/single_child_scroll_view_screen.dart';

class ScreenModel {
  final WidgetBuilder builder;
  final String name;

  ScreenModel({
    required this.builder,
    required this.name,
  });
}

class HomeScreen extends StatelessWidget {

  final screens = [
    ScreenModel(
      builder: (_) => SingleChildScrollViewScreen(),
      name: 'SingleChildScrollViewScreen',
    ),
    ScreenModel(
      builder: (_) => ListViewScreen(),
      name: 'ListViewScreen',
    ),
    ScreenModel(
      builder: (_) => GridViewScreen(),
      name: 'GridViewScreen',
    ),
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0)
      )
    );

    return MainLayout(
      title: 'Home',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          //버튼 매핑
          children: screens.map((screen) =>
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: screen.builder)
                  );
                },
                style: buttonStyle,
                child: Text(screen.name),
              ),
          ).toList(),
        ),
      ),
    );
  }
}
