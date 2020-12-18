import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  List<List<String>> gridState = new List<List<String>>();
  final _firestore = Firestore.instance;
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  bool _gameStarted = false;

  Future<void> _setInitialBoardPositions() async {
    if(!_gameStarted){
      try {
        //Get the 5 rows of the board
        if(gridState.length < 5) {
          _gameStarted = true;
          DocumentSnapshot doc = await _firestore.collection("appData").document("games").collection("dobotsu").document("initialPosition").get();
          doc.data.forEach((key, value) {
            gridState.add(value.cast<String>());
          });
        }
      } catch(e) {
        gridState = e;
      }
    }
    return gridState;
  }

  _fetchInitialBoardPositions() {
    return this._memoizer.runOnce(() async {
      return _setInitialBoardPositions();
    });
  }

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
                    future: _fetchInitialBoardPositions(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.done) {
                        return _buildBoard();
                      } else {
                        return CircularProgressIndicator();
                      }
                    })
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

    return DragTarget(
      builder: (context, candidateData, rejectedData) {
        return GridTile(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5)
            ),
            child: Center(
                child: _buildPieces(x, y)
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
          gridState[_oldPosition[0]][_oldPosition[1]] = '';
          gridState[x][y] = data[0];
        });
      },
    );
  }

  Widget _buildPieces(int x, int y) {
    List<int> _curPosition = [x, y];

    if(gridState[x][y].toString() != ''){
      return _piece('lib/images/' + gridState[x][y].toString() + '.png', gridState[x][y].toString(), _curPosition);
    }
    else return null;
  }

  Draggable _piece(String image, String piece, List<int> piecePosition) {
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