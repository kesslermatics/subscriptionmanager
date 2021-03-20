import 'dart:convert';

import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subscriptionmanager/main.dart';
import 'package:subscriptionmanager/widgets/subcards.dart';

class Homepage extends StatefulWidget {
  List<dynamic> _data;

  Homepage(this._data);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<SubCard> cardList = [];
  List<dynamic> data;

  @override
  Widget build(BuildContext context) {
    cardList.clear();
    data = widget._data;
    if (data != null) {
      for (Map<String, dynamic> map in data) {
        cardList
            .add(new SubCard(map["title"], map["price"], map["switchValue"]));
      }
    }
    if (cardList == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Subscription Manager"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 5,
          child: Text(
            "+",
            style: TextStyle(fontSize: 30),
          ),
          onPressed: () {
            setState(() {
              Navigator.pushNamed(context, "/addSub");
            });
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Subscription Manager"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 10,
                child: Container(
                  child: ListView.builder(
                      itemCount: cardList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: cardList[index],
                          onLongPress: () {
                            removeCard(index).then((value) {
                              runApp(MainApp());
                            });
                          },
                        );
                      }),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Preis pro Monat: ',
                              style: TextStyle(color: Colors.blue)),
                          TextSpan(
                              text: double.parse(
                                      getTotalPrice().toStringAsFixed(2))
                                  .toString()),
                          TextSpan(
                            text: "€",
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          elevation: 5,
          child: Text(
            "+",
            style: TextStyle(fontSize: 30),
          ),
          onPressed: () {
            setState(() {
              Navigator.pushNamed(context, "/addSub");
            });
          },
        ),
      );
    }
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (SubCard card in cardList) {
      if (card.getOnOff()) totalPrice += card.getPrice();
    }
    return totalPrice;
  }

  Future<void> removeCard(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.decode(prefs.getString("cards"));
    List<SubCard> cardList = [];
    int cnt = 0;
    for (Map<String, dynamic> map in data) {
      if (index != cnt) {
        cardList
            .add(new SubCard(map["title"], map["price"], map["switchValue"]));
      }
      cnt++;
    }
    await prefs.setString("cards", json.encode(cardList)).then((value) {
      return;
    });
  }
}
