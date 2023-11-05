import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:parking_system/common/common_functions.dart';
import 'package:parking_system/common/create_parking_model.dart';
import 'package:parking_system/models/bay_model.dart';

import 'package:parking_system/models/parking_model.dart';

import 'package:path_provider/path_provider.dart';

class ParkingRepo {
  static const String baseUrl = "http://192.168.0.178:3000";

  Future<List<ParkingLot>?> getCarParkingModel() async {
    // var response = await http.get(url);
    // var file = File('assets/data/parkingModel.json');
    // print(file.readAsStringSync());
    try {
      final directory = await getApplicationDocumentsDirectory();
      final localDirectory = '${directory.path}/parkingModel.json';
      final file = File(localDirectory);
      // if (!file.existsSync()) {
      // }
      var url = Uri.parse('${baseUrl}/api/getParkingLot');

      var response = await http.get(url);
      if (response.statusCode == 200) {
        var parsedJson = json.decode(response.body);
        if (parsedJson["success"]) {
          List<dynamic> parkingModel = parsedJson["response"];
          List<BayModel> list = [];
          List<ParkingLot> parkingList = [];
          for (var parking in parkingModel) {
            List<BayModel> listForParking = [];
            parking["listOfBayModel"].forEach((e) => listForParking.add(
                BayModel(
                    parking["parkingLotId"],
                    e['bayId'],
                    convertStringToEnum(e['size']),
                    e['floorNumber'],
                    e['isFilled'],
                    e['carId'],
                    e['carSize'])));
            list.addAll(listForParking);
            parkingList.add(ParkingLot('testing', parking["parkingLotId"],
                parking["numberOfFloors"], listForParking));
          }
          return parkingList;
        }
        return null;
      }
      return null;
    } catch (e) {
      print('error $e');
      return null;
    }
  }

  Future<bool> unAssignCarParking(CarParkingUnassignParams params) async {
    var url = Uri.parse(baseUrl);

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        params.parkingLotId,
        params.slotId,
      }),
    );
    var jsonUser = json.decode(response.body);
    if (response.statusCode == 200) {}
    return response.statusCode == 200;
  }
}

class CarParkingDetailsParams {
  CarParkingDetailsParams(this.parkingLotId, this.size);
  String parkingLotId;
  String size;
}

class CarParkingUnassignParams {
  CarParkingUnassignParams(this.parkingLotId, this.slotId);
  String parkingLotId;
  String slotId;
}
