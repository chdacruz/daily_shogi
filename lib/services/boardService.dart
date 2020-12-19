import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<List<String>> _gridState = new List<List<String>>();
final AsyncMemoizer _memoizer = AsyncMemoizer();
final _firestore = Firestore.instance;

Future<void> getInitialBoardPositions() async {
  try {
    //Get the 5 rows of the board
    if(_gridState.length < 5) {
      DocumentSnapshot doc = await _firestore.collection("appData").document("games").collection("dobotsu").document("initialPosition").get();
      doc.data.forEach((key, value) {
        _gridState.add(value.cast<String>());
      });
    }
  } catch(e) {
    _gridState = e;
  }
  return _gridState;
}

fetchInitialBoardPositions() {
  //return this.memoizer.runOnce(() async {
  return _memoizer.runOnce(() async {

    return getInitialBoardPositions();
  });
}

List<List<String>> getGridState() {
  return _gridState;
}