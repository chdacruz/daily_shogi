import 'package:flutter/material.dart';

import '../services/boardService.dart';

class MiniShogiScreen extends StatefulWidget {
  @override
  _MiniShogiScreenState createState() => _MiniShogiScreenState();
}

class _MiniShogiScreenState extends State<MiniShogiScreen> {
  //R = Rook; B = Bishop; SG = Silver General; GG = Golden General; K = King; P = Pawn;
  /*List<List<String>> gridState = [
    ['R2', 'B2', 'SG2', 'GG2', 'K2'],
    ['', '', '', '', 'P2'],
    ['', '', '', '', ''],
    ['P1', '', '', '', ''],
    ['K1', 'GG1', 'SG1', 'B1', 'R1'],
  ];*/

  List<List<String>> _gridState;

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
                FutureBuilder(
                    future: fetchInitialBoardPositions(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.done) {
                        return buildBoard();
                      } else {
                        return CircularProgressIndicator();
                      }
                    })
              ],
            )
        )
    );
  }

  /*
    The widgets bellow must be later moved to boardWidgets.dart
    However, due to setState() on buildBoardPieces(), ValueListenableBuilder or VoidCallback must be used
   */
  Widget buildBoard() {
    _gridState = getGridState();
    int gridStateLength = _gridState.length;

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
                itemBuilder: buildBoardPieces,
                itemCount: gridStateLength * gridStateLength,
              ),
            ),
          ),
        ]);
  }

  Widget buildBoardPieces(BuildContext context, int index) {
    int gridStateLength = _gridState.length;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);

    return DragTarget(
      builder: (context, candidateData, rejectedData) {
        return GridTile(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5)
            ),
            child: Center(
                child: buildPieces(x, y)
            ),
          ),
        );
      },
      onWillAccept: (data) {
        return true;
      },
      onAccept: (data) {
        setState(() {
          List<int> _oldPosition = data[1];
          _gridState[_oldPosition[0]][_oldPosition[1]] = '';
          _gridState[x][y] = data[0];
        });
      },
    );
  }

  Widget buildPieces(int x, int y) {
    List<int> _curPosition = [x, y];

    if(_gridState[x][y].toString() != ''){
      return piece('assets/dobotsu/pieces/' + _gridState[x][y].toString() + '.png', _gridState[x][y].toString(), _curPosition);
    }
    else return null;
  }

  Draggable piece(String image, String piece, List<int> piecePosition) {
    return Draggable(
      child: FittedBox (
          fit: BoxFit.fill,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 1, minHeight: 1),
            child: Image.asset(image),
          )
      ),
      feedback: FittedBox (
        child: Image.asset(image),
        fit: BoxFit.fill,
      ),
      childWhenDragging: FittedBox (
        fit: BoxFit.fill,
      ),
      onDragCompleted: () {

      },
      data: [
        piece,
        piecePosition
      ],
    );
  }

}