import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  //R = Rook; B = Bishop; SG = Silver General; GG = Golden General; K = King; P = Pawn;
  List<List<String>> gridState = [
    ['R2', 'B2', 'SG2', 'GG2', 'K2'],
    ['', '', '', '', 'P2'],
    ['', '', '', '', ''],
    ['P1', '', '', '', ''],
    ['K1', 'GG1', 'SG1', 'B1', 'R1'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Shogi'),
      ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBoard(),
            ],
          )
        )
    );
  }

  Widget _buildBoard() {
    int gridStateLength = gridState.length;
    return Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              padding: const EdgeInsets.all(2.0),
              margin: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.0)
              ),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridStateLength,
                ),
                itemBuilder: _buildBoardPieces,
                itemCount: gridStateLength * gridStateLength,
              ),
            ),
          ),
        ]);
  }

  Widget _buildBoardPieces(BuildContext context, int index) {
    int gridStateLength = gridState.length;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
      onTap: () => {}, //_gridItemTapped(x, y),
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)
          ),
          child: Center(
            child: _buildPiece(x, y),
          ),
        ),
      ),
    );
  }

  Widget _buildPiece(int x, int y) {
    if(gridState[x][y].toString() != ''){
      //return _pawn('lib/images/' + gridState[x][y].toString() + '.png', Colors.white);
      return _pawn('lib/images/' + gridState[x][y].toString() + '.png', gridState[x][y].toString());
    }
    else return null;
    /*switch(gridState[x][y]) {
      case '':
        break;

      //Pawn
      case 'P1':
        return _pawn('lib/images/' + gridState[x][y] + '.png', Colors.green);

      case 'P2':
        return _pawn('lib/images/' + gridState[x][y] + '.png', Colors.green);

      //King
      case 'K1':
        return _pawn('lib/images/' + gridState[x][y] + '.png', Colors.green);

      case 'K2':
        return _pawn('lib/images/' + gridState[x][y] + '.png', Colors.green);

      default:
        return Text(gridState[x][y].toString());
    }*/
  }

  Draggable _pawn(String image, String piece) {
    return Draggable(
      child: FittedBox (
        child: Image.asset(image),
        fit: BoxFit.fill,
      ),
      feedback: FittedBox (
        child: Image.asset(image),
        fit: BoxFit.fill,
      ),
      childWhenDragging: FittedBox (
      child: Image.asset(image),
    fit: BoxFit.fill,
    ),
      data: piece,
    );
  }


}
