import 'dart:convert';
import 'dart:io';
import 'package:parking_system/common/common_functions.dart';
import 'package:parking_system/models/car_parking_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class CarParkingRepository {
  static const String baseUrl = "http://192.168.0.178:3000";

  Future<CarParkingModel?> assignCarParking(
      CarParkingDetailsParams params) async {
    var url = Uri.parse(
        '$baseUrl/api/assignParkingSpace?size=${params.size}&parkingId=${params.parkingLotId}');
    var response = await http.post(url);
    try {
      if (response.statusCode == 200) {
        var parsedJson = json.decode(response.body);
        if (parsedJson["success"]) {
          String responseString = parsedJson["response"]["string"];
          List<String> splitString = responseString.split(':');
          String floor = splitString.first;
          String bayId = splitString[1];
          int floorInt = int.tryParse(floor) ?? -1;
          if (floorInt == -1) {
            return null;
          }
          var uuid = parsedJson["response"]['carModel']['carId'];
          var baySize = parsedJson["response"]['carModel']['parkingSize'];
          return CarParkingModel(
            floorInt,
            bayId,
            convertStringToEnum(params.size),
            true,
            uuid,
            params.size,
            baySize,
          );
        }
      }
    } catch (e) {
      return null;
    }
  }

  Future<CarParkingModel?> unAssignCarParking(
      CarParkingUnassignParams params) async {
    try {
      var url = Uri.parse(
          '$baseUrl/api/unAssignParking?parkingLotId=${params.parkingLotId}&bayId=${params.bayId}');
      var response = await http.post(url);

      if (response.statusCode == 200) {
        var parsedJson = json.decode(response.body);
        if (parsedJson["success"]) {
          dynamic carModel = parsedJson["response"];
          return CarParkingModel(
            carModel['floor'],
            carModel['bayId'],
            convertStringToEnum(carModel['carSize']),
            false,
            carModel['carId'],
            carModel['carSize'],
            carModel['baySize'],
          );
        }
      }
      // Future.
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> getUnAssign(String bayId) async {
    final directory = await getApplicationDocumentsDirectory();
    final localDirectory = '${directory.path}/parkingModel.json';
    final file = File(localDirectory);

    final String jsonString = file.readAsStringSync();
    var jsonUser = jsonDecode(jsonString) as Map<String, dynamic>;
    for (var item in jsonUser.entries) {
      if (item.value != null && item.value is List<dynamic>) {
        item.value.forEach((e) => {
              if (e.containsKey('bayId') && e['bayId'] == bayId)
                {e['isfilled'] = false}
            });
      }
    }
    var finalModel = {
      'name': 'temp',
      'parkingId': jsonUser['parkingId'],
      'floors': jsonUser['floors'],
      'smallParking': jsonUser['smallParking'],
      'mediumParking': jsonUser['mediumParking'],
      'largeParking': jsonUser['largeParking'],
      'XlargeParking': jsonUser['XlargeParking']
    };
    String json = jsonEncode(finalModel);
    // Write the file
    await file.writeAsString(json);
    return true;
  }

  Future<String> getRandomResponse(String size) async {
    final directory = await getApplicationDocumentsDirectory();
    final localDirectory = '${directory.path}/parkingModel.json';
    final file = File(localDirectory);

    final String jsonString = file.readAsStringSync();
    var jsonUser = jsonDecode(jsonString) as Map<String, dynamic>;
    List<String> keyForParkingSpace = [
      'smallParking',
      'mediumParking',
      'largeParking',
      'XlargeParking'
    ];
    List<String> keyForParkingSpaceForMedium = [
      'mediumParking',
      'largeParking',
      'XlargeParking'
    ];
    List<String> keyForParkingSpaceForLarge = ['largeParking', 'XlargeParking'];

    Map<String, List<dynamic>> map = {};
    switch (size) {
      case 'small':
        for (var item in jsonUser.entries) {
          if (item.value != null &&
              item.value is List<dynamic> &&
              keyForParkingSpace.contains(item.key)) {
            List<dynamic> list = item.value;
            for (var e in list) {
              {
                if (e.containsKey('isFilled') && !e['isFilled']) {
                  if (map.containsKey(map[item.key])) {
                    map[item.key]!.add(e);
                  } else {
                    map[item.key] = [e];
                  }
                }
              }
            }
          }
        }
        break;
      case 'medium':
        for (var item in jsonUser.entries) {
          if (item.value != null &&
              item.value is List<dynamic> &&
              keyForParkingSpaceForMedium.contains(item.key)) {
            item.value.forEach((e) => {
                  if (e.containsKey('isFilled') && !e['isFilled'])
                    {
                      if (map.containsKey(map[item.key]))
                        {map[item.key]!.add(e)}
                      else
                        {
                          map[item.key] = [e]
                        }
                    }
                });
          }
        }
        break;
      case 'large':
        for (var item in jsonUser.entries) {
          if (item.value != null &&
              item.value is List<dynamic> &&
              keyForParkingSpaceForLarge.contains(item.key)) {
            item.value
                .forEach((e) => {
                      if (e.containsKey('isFilled') && !e['isFilled'])
                        {
                          if (map.containsKey(map[item.key]))
                            {map[item.key]!.add(e)}
                          else
                            {
                              map[item.key] = [e]
                            }
                        }
                    })
                .toList();
          }
        }

        break;
      case 'Xlarge':
        for (var item in jsonUser.entries) {
          if (item.value != null &&
              item.value is List<dynamic> &&
              item.key == 'XlargeParking') {
            item.value.forEach((e) => {
                  if (e.containsKey('isFilled') && !e['isFilled'])
                    {
                      if (map.containsKey(map[item.key]))
                        {map[item.key]!.add(e)}
                      else
                        {
                          map[item.key] = [e]
                        }
                    }
                });
          }
        }
        break;
      default:
    }
    if (map.isEmpty) {
      return 'no SLOT FOUND';
    }
    String? bayId;
    int? floor;
    String? parkingSize;
    for (var item in map.entries) {
      bayId = item.value.first['bayId'];
      floor = item.value.first["floor"];
      parkingSize = item.key;
      break;
    }
    for (var item in map.entries) {
      for (var item in jsonUser.entries) {
        if (item.value != null && item.value is List<dynamic>) {
          item.value.forEach((e) {
            if (e['bayId'] == bayId) {
              e['isFilled'] = true;
            }
          });
        }
      }
    }

    var finalModel = {
      'name': 'temp',
      'parkingId': jsonUser['parkingId'],
      'floors': jsonUser['floors'],
      'smallParking': jsonUser['smallParking'],
      'mediumParking': jsonUser['mediumParking'],
      'largeParking': jsonUser['largeParking'],
      'XlargeParking': jsonUser['XlargeParking']
    };
    String json = jsonEncode(finalModel);
    // Write the file
    await file.writeAsString(json);

    if (bayId != null && floor != null) {
      return "$floor:$bayId";
    }
    return 'no SLOT FOUND';
  }

// { Slot : <Floor>-<Bay-ID> }

  // Future<bool> unAssignCarParking(CarParkingUnassignParams params) async {
  //   var url = Uri.parse('${baseUrl}');

  //   var response = await http.post(
  //     url,
  //     headers: {"Content-Type": "application/json"},
  //     body: json.encode({
  //       params.parkingLotId,
  //       params.bayId,
  //     }),
  //   );
  //   var jsonUser = json.decode(response.body);
  //   if (response.statusCode == 200) {}
  //   return response.statusCode == 200;
  // }
}

class CarParkingDetailsParams {
  CarParkingDetailsParams(this.parkingLotId, this.size);
  String parkingLotId;
  String size;
}

class CarParkingUnassignParams {
  CarParkingUnassignParams(this.parkingLotId, this.bayId);
  String parkingLotId;
  String bayId;
}
