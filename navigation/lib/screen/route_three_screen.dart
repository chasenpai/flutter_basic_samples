import 'package:flutter/material.dart';

import '../layout/main_layout.dart';

class RouteThreeScreen extends StatelessWidget {
  const RouteThreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    return MainLayout(
        title: 'RouteThree',
        children: [
          Text(
            'named route arguments : ${arguments.toString()}',
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Pop'),
          )
        ]
    );
  }
}
