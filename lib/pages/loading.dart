import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  static const String routeName = 'loading';

  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
