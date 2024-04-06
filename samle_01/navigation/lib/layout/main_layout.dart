import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {

  final String title;
  final List<Widget> children; //위젯을 파라미터로 받을 수 있다

  const MainLayout({required this.title, required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.blue[200],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        )
    );
  }
}
