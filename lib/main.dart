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
  bool ableToDrag = true;
  bool endAnimation = false;
  List<int> purgeList = [];
  int positionSwitch;
  MyCard backwordAnimation;
  var movingPosition;
  var listColors = [
    MyCard(60, Colors.red, "red"),
    MyCard(120, Colors.yellow, "yellow"),
    MyCard(180, Colors.purple, "purple"),
    MyCard(240, Colors.orange, "orange"),
    MyCard(300, Colors.green, "green"),
    MyCard(360, Colors.blue, "blue"),
  ];
  List<MyCard> fixedList = [
    MyCard(60, Colors.red, "red"),
    MyCard(120, Colors.yellow, "yellow"),
    MyCard(180, Colors.purple, "purple"),
    MyCard(240, Colors.orange, "orange"),
    MyCard(300, Colors.green, "green"),
    MyCard(360, Colors.blue, "blue"),
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
      padding: const EdgeInsets.only(top: 298.0),
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
            if (ableToDrag) {
              _updateCardsPosition(dragUpdateDetails.delta.dy, listColors[i],
                  listColors[i - 1], listColors[i + 1], i);
            }
          },
          onVerticalDragEnd: (DragEndDetails dragEndDetails) {
            if (elasticPosition != null) {
              print('end drag details: $dragEndDetails');
              startElasticPositioning(i);
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
            listColors[listColors.length - 1]
                .positionY) if (positionSwitch != null &&
        positionSwitch != position) position = positionSwitch;
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
        movePreviousCardWithAnimation((position + 1), 40, destination);
      }
    }
    ////////////////////// down drag animation//////////////////////////////////
    else {
      var destination;
      var counter = 0;
      bool alreadyFound = false;
      for (var card in listColors) {
        if (card.positionY >= listColors[position].positionY - 10 &&
            card.positionY <= listColors[position].positionY + 10 &&
            card.name != listColors[position].name &&
            (backwordAnimation == null || backwordAnimation != card)) {
          if (!alreadyFound) {
            alreadyFound = true;
            destination = counter;
            backwordAnimation = card;
          }
        }
        counter++;
      }
      print('destination: $destination');
      if (destination != null &&
          listColors[position - 1].color != listColors[destination].color) {
        print('enter here');
        movingPosition = position;
        animateCardDown(position, 60, destination);

        //elasticPosition = listColors[destination].positionY;

        print('all the list${listColors}');
        /*movingPosition = position - 1;
        print('all the list${listColors}');
        print('the list after: ${listColors}');*/
        // moveNextCardWithAnimation((position), 60, destination);
      }
    }
    setState(() {});
  }

  void movePreviousCardWithAnimation(
      int position, int currentY, int destination) {
    Timer timer;
    var goal = listColors[position].positionY - 40;
    timer = Timer.periodic(Duration(milliseconds: 5), (Timer t) {
      if (listColors[position].positionY > goal) {
        listColors[position].positionY -= 2;
      } else {
        timer?.cancel();
      }
    });
  }

  Future<void> startElasticPositioning(int position) async {
    Timer timer;
    bool positive = elasticPosition > listColors[position].positionY;
    ableToDrag = false;
    timer = await Timer.periodic(Duration(milliseconds: 5), (Timer t) {
      if (positive) {
        if (listColors[position].positionY < elasticPosition) {
          listColors[position].positionY += 2;
        } else {
          timer?.cancel();
          startPurgingTheList();
        }
      } else {
        if (listColors[position].positionY > elasticPosition) {
          listColors[position].positionY -= 2;
        } else {
          timer?.cancel();
          startPurgingTheList();
        }
      }
      setState(() {});
    });
  }

  void moveNextCardWithAnimation(int position, int currentY, int destination) {
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

  void startPurgingTheList() {
    print('initial list: $listColors');
    resetColorsList();
    purgeList = [];
    fixedList = listColors;
    elasticPosition = null;
    currentDragPosition = null;
    ableToDrag = true;
    print('after modification list: ${listColors.length}');
  }

  void resetColorsList() {
    if (purgeList.length > 0) {
      for (var index in purgeList) {
        if (index >= 0 && index < listColors.length) {
          listColors.removeAt(index);
        }
      }
    }
  }

  void animateCardDown(int position, int currentY, int destination) {
    Timer timer;
    var goal = listColors[destination].positionY + 60;
    timer = Timer.periodic(Duration(milliseconds: 5), (Timer t) {
      if (listColors[destination].positionY < goal) {
        listColors[destination].positionY += 2;
      } else {
        timer?.cancel();
        fixedList[destination].positionY =
            fixedList[destination].positionY ;
        listColors.insert(position, fixedList[destination]);
        backwordAnimation = fixedList[destination];
        listColors.removeAt(position + 2);
        positionSwitch = position + 1;
        moveNextCardWithAnimation((position), 60, destination);
        setState(() {});
        return;
        fixedList[destination].positionY =
            fixedList[destination].positionY - 60;
        print('new card : ${fixedList[destination]}');
        listColors.insert(position, fixedList[destination]);
      }
    });
  }
}
