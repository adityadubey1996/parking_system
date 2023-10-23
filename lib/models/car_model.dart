import 'package:parking_system/common/enums.dart';

class CarModel {
  CarModel(this.slot, this.carSize, this.bayId);
  String slot;
  ParkingSize carSize;
  String bayId;
}
