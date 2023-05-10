import 'package:flutter/material.dart';
import 'package:flutter_note/providers/notes.dart';
import 'package:flutter_note/screens/add_or_detail_screen.dart';
import 'package:flutter_note/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Notes(),
      child: MaterialApp(
        routes: {
          AddOrDetailScreen.routeName: (ctx) => AddOrDetailScreen(),
        },
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.grey),
        home: HomeScreen(),
      ),
    );
  }
}
