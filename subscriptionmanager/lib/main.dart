import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subscriptionmanager/pages/addSub.dart';
import "package:subscriptionmanager/pages/loading.dart";
import "package:subscriptionmanager/pages/homepage.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MainApp());
}

Future<List<dynamic>> getSharedPreferences() async {
  var prefs = await SharedPreferences.getInstance();
  if (prefs.getString("cards") != null) {
    return json.decode(prefs.getString("cards"));
  } else
    return null;
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/addSub": (context) => AddSub(),
      },
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: getSharedPreferences(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Homepage(snapshot.data);
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}
