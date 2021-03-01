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
    print('i have called init state');
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
    listColors[position].positionY += dy;
    print('current position: ${    listColors[position].positionY
    }');
    if (dy < 0) {
      var destination = null;
      var counter = 0;
      for (var card in listColors) {
        if (card.positionY >= listColors[position].positionY - 1
        && card.positionY <= listColors[position].positionY + 1
        && card != listColors[position]){
          destination = counter;
        }
        counter++;
      }
    /*  if (listColors[position - 1].positionY < listColors[position].positionY) {
        listColors[position - 1].positionY -= dy;
        print('i am here');
      }
      if (listColors[position + 1].positionY > fixedList[position].positionY) {
        listColors[position + 1].positionY += dy;
      }*/
      if (destination != null &&
          listColors[position + 1].color != listColors[destination].color) {
        print('my distination: $destination');
      //  listColors[position + 1] = listColors[destination];
        fixedList[destination].positionY =  fixedList[destination].positionY + 40;
        listColors.insert(position + 1, fixedList[destination]);
        print("list colors : ${listColors.length}");
      }
    }
    /*else {
      if(fixedList[position + 1].positionY < (listColors[position + 1].positionY - fixedList[position + 1].positionY / 2))
        listColors[position + 1].positionY -= dy;
      else if(fixedList[position - 1].positionY >=  ((listColors[position - 1].positionY - fixedList[position - 1].positionY / 2)) - 5 ||
          fixedList[position - 1].positionY <=  ((listColors[position - 1].positionY - fixedList[position - 1].positionY / 2)) + 5){
        print('now is equal');
        listColors[position] = fixedList[position + 1];
        listColors[position + 1] = fixedList[position];
      }else
        listColors[position + 1].positionY += dy;*/
    //  }
    setState(() {});
  }
}
