import 'package:flutter/material.dart';

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
  var listColors = [Colors.red, Colors.yellow, Colors.green];
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
    for(var i in listColors){
      list.add(  GestureDetector(
        onVerticalDragUpdate:
            (DragUpdateDetails dragUpdateDetails) {

            _updateCardsPosition(dragUpdateDetails.delta.dy, i);

        },
        child: Positioned(
          top: elevation,
          child: Card(
            elevation: elevation,
            color: i,
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

  void _updateCardsPosition(double dy, MaterialColor i) {
    print('index is $i');
  }
}
