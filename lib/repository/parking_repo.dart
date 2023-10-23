import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:parking_system/common/common_functions.dart';
import 'package:parking_system/common/create_parking_model.dart';
import 'package:parking_system/models/bay_model.dart';

import 'package:parking_system/models/parking_model.dart';

import 'package:path_provider/path_provider.dart';

class ParkingRepo {
  static const String baseUrl = "http://parkingservice.com";
  static const String apiKey = "apiKey=<PLACE_API_KEY_HERE>";

  Future<ParkingLot?> getCarParkingModel() async {
    var url = Uri.parse(baseUrl);
    // var response = await http.get(url);
    // var file = File('assets/data/parkingModel.json');
    // print(file.readAsStringSync());
    try {
      final directory = await getApplicationDocumentsDirectory();
      final localDirectory = '${directory.path}/parkingModel.json';
      final file = File(localDirectory);
      // if (!file.existsSync()) {
      await addDummyData();
      // }
      final String jsonString = file.readAsStringSync();

      var jsonUser = json.decode(jsonString) as Map<String, dynamic>;
      if (jsonUser.containsKey('parkingId') && jsonUser['parkingId'] != null) {
        List<BayModel> list = [];
        String name = jsonUser['name'];
        var parkingModel = jsonUser;
        var parkingId = parkingModel['parkingId'];
        int floors = parkingModel['floors'];
        if (floors == -1) {
          throw ('error while converting floors');
        }
        for (var item in parkingModel.entries) {
          if (item.value != null && item.value is List<dynamic>) {
            var ListofBays = item.value
                .map((e) => BayModel(parkingId, e['bayId'],
                    convertStringToEnum(e['size']), e['floor']))
                .toList();
            list.addAll([...ListofBays]);
          }
        }
        return ParkingLot(name, parkingId, floors, list);
      }
    } catch (e) {
      print('error $e');
      return null;
    }
    return null;
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
