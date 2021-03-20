import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subscriptionmanager/main.dart';

class SubCard extends StatefulWidget {
  String _title;
  double _price;
  bool _switchValue;

  SubCard(this._title, this._price, this._switchValue);

  Map toJson() => {
        'title': _title,
        'price': _price,
        'switchValue': _switchValue,
      };

  double getPrice() {
    return _price;
  }

  bool getOnOff() {
    return _switchValue;
  }

  @override
  _SubCardState createState() => _SubCardState();
}

class _SubCardState extends State<SubCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                widget._title,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                widget._price.toString() + "€/Monat",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Expanded(
              flex: 2,
              child: FlutterSwitch(
                  height: 30,
                  width: 50,
                  value: widget._switchValue,
                  onToggle: (value) {
                    setState(() {
                      updateSwitch().then((voidValue) {
                        widget._switchValue = value;
                        runApp(MainApp());
                      });
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateSwitch() async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.decode(prefs.getString("cards"));
    List<SubCard> cardList = [];
    for (Map<String, dynamic> map in data) {
      if (map["title"] == widget._title) {
        cardList
            .add(new SubCard(map["title"], map["price"], !widget._switchValue));
      } else {
        cardList
            .add(new SubCard(map["title"], map["price"], map["switchValue"]));
      }
    }
    await prefs.setString("cards", json.encode(cardList));
  }
}
