import 'package:flutter/material.dart';

import 'constellations/constellations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Art',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  Widget _project({
    required String title,
    required String subtitle,
    required Widget page,
    required BuildContext context,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => page));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Art"),
        centerTitle: false,
        elevation: 2.0,
      ),
      body: ListView(
        children: [
          _project(
            title: "Constellations",
            subtitle: "Constellations like effect",
            page: Constellations(),
            context: context,
          ),
        ],
      ),
    );
  }
}
