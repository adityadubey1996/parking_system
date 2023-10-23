import 'package:parking_system/common/enums.dart';

class CarParkingModel {
  CarParkingModel(
    this.floor,
    this.bayId,
    this.parkingSize,
    this.isFilled,
    this.carId,
    this.carSize,
  );
  int floor;
  String? bayId;
  ParkingSize parkingSize = ParkingSize.none;
  bool isFilled = false;
  String? carId;
  String? carSize;
}
