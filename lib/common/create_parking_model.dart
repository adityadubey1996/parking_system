import 'dart:convert';
import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

Future<void> addDummyData() async {
  int noOfFloor = 2;
  int noIfSmallParkingEachFloor = 0;
  int noIfMediumParkingEachFloor = 1;
  int noIflargeParkingEachFloor = 0;
  int noIfXlargeParkingEachFloor = 1;
  var parkingModel = {
    "noOfFloor": noOfFloor,
    "noIfSmallParkingEachFloor": noIfSmallParkingEachFloor,
    "noIfMediumParkingEachFloor": noIfMediumParkingEachFloor,
    "noIflargeParkingEachFloor": noIflargeParkingEachFloor,
    "noIfXlargeParkingEachFloor": noIfXlargeParkingEachFloor,
  };
  var finalModel = {};
  var uuid = const Uuid();
  if (parkingModel.containsKey('noOfFloor') &&
      parkingModel['noOfFloor'] != null) {
    var parkingID = uuid.v4();
    var listOfSmallParking = [];
    var noIfMediumParkingEachFloor = [];
    var noIflargeParkingEachFloor = [];
    var noIfXlargeParkingEachFloor = [];
    var numberOfFLoors = parkingModel['noOfFloor'];
    for (var i = 1; i <= parkingModel['noOfFloor']!; i++) {
      if (parkingModel.containsKey('noIfSmallParkingEachFloor') &&
          parkingModel['noIfSmallParkingEachFloor'] != null) {
        for (var j = 0; j < parkingModel['noIfSmallParkingEachFloor']!; j++) {
          var bayId = uuid.v4();

          listOfSmallParking.add(
              {'bayId': bayId, 'size': 'small', 'floor': i, 'isFilled': false});
        }
      }
      if (parkingModel.containsKey('noIfMediumParkingEachFloor') &&
          parkingModel['noIfMediumParkingEachFloor'] != null) {
        for (var j = 0; j < parkingModel['noIfMediumParkingEachFloor']!; j++) {
          var bayId = uuid.v4();

          noIfMediumParkingEachFloor.add({
            'bayId': bayId,
            'size': 'medium',
            'floor': i,
            'isFilled': false
          });
        }
      }
      if (parkingModel.containsKey('noIflargeParkingEachFloor') &&
          parkingModel['noIflargeParkingEachFloor'] != null) {
        for (var j = 0; j < parkingModel['noIflargeParkingEachFloor']!; j++) {
          var bayId = uuid.v4();

          noIflargeParkingEachFloor.add(
              {'bayId': bayId, 'size': 'large', 'floor': i, 'isFilled': false});
        }
      }
      if (parkingModel.containsKey('noIfXlargeParkingEachFloor') &&
          parkingModel['noIfXlargeParkingEachFloor'] != null) {
        for (var j = 0; j < parkingModel['noIfXlargeParkingEachFloor']!; j++) {
          var bayId = uuid.v4();

          noIfXlargeParkingEachFloor.add({
            'bayId': bayId,
            'size': 'Xlarge',
            'floor': i,
            'isFilled': false
          });
        }
      }
    }
    finalModel = {
      'name': 'temp',
      'parkingId': parkingID,
      'floors': numberOfFLoors,
      'smallParking': listOfSmallParking,
      'mediumParking': noIfMediumParkingEachFloor,
      'largeParking': noIflargeParkingEachFloor,
      'XlargeParking': noIfXlargeParkingEachFloor
    };
    String json = jsonEncode(finalModel);
    // print(json);
    final directory = await getApplicationDocumentsDirectory();
    final localDirectory = '${directory.path}/parkingModel.json';
    final file = File(localDirectory);
    file.createSync(recursive: true);
    file.writeAsStringSync(json);
  }
}
