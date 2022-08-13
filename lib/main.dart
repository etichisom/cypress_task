import 'dart:io';

import 'package:cypress/app/data/local/local_database.dart';
import 'package:cypress/app/data/repository/album_repository.dart';
import 'package:cypress/app/presentation/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Directory appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  await Hive.openBox("album");
  await Hive.openBox("photo");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (_)=>AlbumRepository()),
          RepositoryProvider(create: (_)=>LocalDatabase())
        ],
        child: Home(),
      ),
    );
  }
}
