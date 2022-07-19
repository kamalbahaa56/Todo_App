import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/shared/cubit/mybloc_oserver.dart';

import 'pages/home_screen.dart';

void main() {
 BlocOverrides.runZoned( 
    () {
      // Use cubits...
    },
    blocObserver: MyBlocObserver(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  HomeScreen(),
    );
  }
}

