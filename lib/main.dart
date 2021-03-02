import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var elasticPosition;
  var currentDragPosition;
  List<int> purgeList = [];
  var listColors = [
    MyCard(60, Colors.red),
    MyCard(120, Colors.yellow),
    MyCard(180, Colors.purple),
    MyCard(240, Colors.orange),
    MyCard(300, Colors.green),
    MyCard(360, Colors.blue),
  ];
  List<MyCard> fixedList = [
    MyCard(60, Colors.red),
    MyCard(120, Colors.yellow),
    MyCard(180, Colors.purple),
    MyCard(240, Colors.orange),
    MyCard(300, Colors.green),
    MyCard(360, Colors.blue),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
      padding: const EdgeInsets.only(top: 118.0),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[..._buildCards()],
      ),
    )));
  }

  _buildCards() {
    List<Widget> list = [];
    var elevation = 10.0;
    for (var i = 0; i < listColors.length; i++) {
      list.add(Positioned(
        top: listColors[i].positionY,
        child: GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails dragUpdateDetails) {
            _updateCardsPosition(dragUpdateDetails.delta.dy, listColors[i],
                listColors[i - 1], listColors[i + 1], i);
          },
          onVerticalDragEnd: (DragEndDetails dragEndDetails) {
            if (elasticPosition != null) {
              print('end drag details: $dragEndDetails');
              startElasticPositionning(i);
            }
          },
          child: Card(
            elevation: elevation,
            color: listColors[i].color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              height: 200,
              width: 300,
            ),
          ),
        ),
      ));
      // elevation += 40;
    }
    return list;
  }

  void _updateCardsPosition(double dy, MyCard myCard, MyCard previousCard,
      MyCard nextCard, int position) {
    if ((listColors[position].positionY + dy) > listColors[0].positionY &&
        (listColors[position].positionY + dy) <
            listColors[listColors.length - 1].positionY)
      listColors[position].positionY += dy;
   ////////////////////////////// up drag animation/////////////////////////////
    if (dy < 0) {
      var destination;
      var counter = 0;
      for (var card in listColors) {
        if (card.positionY >= listColors[position].positionY - 10 &&
            card.positionY <= listColors[position].positionY + 10 &&
            card != listColors[position]) {
          destination = counter;
        }
        counter++;
      }
      print('destination result : $destination');
      if (destination != null &&
          listColors[position + 1].color != listColors[destination].color) {
        elasticPosition = listColors[destination].positionY;
        //  listColors[position + 1] = listColors[destination];
        fixedList[destination].positionY =
            fixedList[destination].positionY + 100;
        purgeList.add(destination);
        listColors.insert(position + 1, fixedList[destination]);
        //listColors[destination].color = Colors.transparent;
        movePreviousCardWithAnimation((position + 1), 60, destination);
      }
    }
    ////////////////////// down drag animation//////////////////////////////////
    else {
      var destination;
      var counter = 0;
      for (var card in listColors) {
        if (card.positionY >= listColors[position].positionY + 10 &&
            card.positionY <= listColors[position].positionY - 10 &&
            card != listColors[position]) {
          destination = counter;
        }
        counter++;
      }
      print('destination result : $destination');
      if (destination != null &&
          listColors[position - 1].color != listColors[destination].color) {
        print('we got here also $destination');
        elasticPosition = listColors[destination].positionY;
        fixedList[destination].positionY =
            fixedList[destination].positionY + 100;
        listColors.insert(position - 1, fixedList[destination]);
        moveNextCardWithAnimation((position - 1), 60, destination);
      }
    }
    setState(() {});
  }

  void movePreviousCardWithAnimation(
      int position, int currentY, int destination) {
    Timer timer;
    var goal = listColors[position].positionY - 60;
    timer = Timer.periodic(Duration(milliseconds: 5), (Timer t) {
      if (listColors[position].positionY > goal) {
        listColors[position].positionY -= 2;
      } else {
        timer?.cancel();
      }
    });
  }

  Future<void> startElasticPositionning(int position) async {
    Timer timer;
    bool positive = elasticPosition > listColors[position].positionY;
    timer = Timer.periodic(Duration(milliseconds: 5), (Timer t) {
      if (positive) {
        if (listColors[position].positionY < elasticPosition) {
          listColors[position].positionY += 2;
        } else {
          timer?.cancel();
        }
      } else {
        if (listColors[position].positionY > elasticPosition) {
          listColors[position].positionY -= 2;
        } else {
          timer?.cancel();
          elasticPosition = null;
        }
      }
      setState(() {});
    });
    if (purgeList.length > 0) {
      for(var index in purgeList)
            listColors.removeAt(index);
    }
    print('the elastic position: $elasticPosition');
    print('the final list size: ${listColors.length}');
  }

  void moveNextCardWithAnimation(int position, int currentY, int destination) {
    print('we are entered here: ${position}');
    Timer timer;
    var goal = listColors[position].positionY + 60;
    timer = Timer.periodic(Duration(milliseconds: 5), (Timer t) {
      if (listColors[position].positionY < goal) {
        listColors[position].positionY += 2;
      } else {
        timer?.cancel();
      }
    });
  }
}
