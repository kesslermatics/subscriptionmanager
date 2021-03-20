import 'dart:convert';

import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subscriptionmanager/main.dart';
import 'package:subscriptionmanager/widgets/subcards.dart';

class AddSub extends StatefulWidget {
  @override
  _AddSubState createState() => _AddSubState();
}

class _AddSubState extends State<AddSub> {
  TextEditingController _priceController = new TextEditingController();
  TextEditingController _titleController = new TextEditingController();
  List<dynamic> cardList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Abo hinzufügen"),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: "Titel"),
                          controller: _titleController,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: "Preis/Monat"),
                          keyboardType: TextInputType.number,
                          controller: _priceController,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Transform.scale(
                scale: 1.2,
                child: ElevatedButton(
                  onPressed: () {
                    safeSub().then((value) {
                      if (value) {
                        runApp(
                          MainApp(),
                        );
                        Navigator.pop(context);
                      }
                    });
                  },
                  child: Text("Speichern"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> safeSub() async {
    if (_titleController.text == "" || _priceController.text == "") {
      return false;
    } else {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString("cards") != null) {
        final data = json.decode(prefs.getString("cards"));
        for (Map<String, dynamic> map in data) {
          cardList
              .add(new SubCard(map["title"], map["price"], map["switchValue"]));
        }
      }
      cardList.add(new SubCard(
          _titleController.text, double.parse(_priceController.text), false));
      await prefs.setString("cards", json.encode(cardList)).then((value) {
        return true;
      });
    }
    return true;
  }
}
