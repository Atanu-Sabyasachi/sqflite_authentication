import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_authentication/bloc/customer/customer_bloc.dart';
import 'package:sqflite_authentication/customer_list.dart';
import 'package:sqflite_authentication/signin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: Colors.pinkAccent,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
        home: const Signin(),
      ),
    );
  }
}
