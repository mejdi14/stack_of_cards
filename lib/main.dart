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
  var listColors = [MyCard(20, Colors.red), MyCard(50, Colors.yellow), MyCard(70, Colors.green)];
  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Stack(
      alignment: Alignment.center,
      children:
                <Widget>[..._buildCards()]
      ,
    )));
  }

  _buildCards(){
    List<Widget> list = [];
    var elevation = 10.0;
    for(var i = 0; i < listColors.length; i++){
      list.add(  Positioned(
        top: listColors[i].positionY,
        child: GestureDetector(
          onVerticalDragUpdate:
              (DragUpdateDetails dragUpdateDetails) {
              _updateCardsPosition(dragUpdateDetails.delta.dy, listColors[i], listColors[i - 1], listColors[i + 1]);
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
      elevation += 40;
    }
    return list;
  }

  void _updateCardsPosition(double dy, MyCard myCard, MyCard previousCard, MyCard nextCard) {
    myCard.positionY += dy;
    if(dy < 0){

      previousCard.positionY -= dy;
    }
    else{

      nextCard.positionY -= dy;
    }
    setState(() {

    });
  }
}
