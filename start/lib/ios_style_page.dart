import 'package:flutter/cupertino.dart';

class IosStylePage extends StatefulWidget {
  const IosStylePage({super.key});

  @override
  State<IosStylePage> createState() => _IosStylePageState();
}

class _IosStylePageState extends State<IosStylePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            'Cupertino App',
          ),
        ),
        child: Center(
          child: Text(
            'Cupertino App',
          ),
        ),
      ),
    );
  }
}
