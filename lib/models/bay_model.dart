import 'package:parking_system/common/enums.dart';

class BayModel {
  BayModel(this.parkingLotId, this.bayId, this.size, this.floorNumber,
      this.isFilled, this.carId, this.carSize);
  String parkingLotId;
  String bayId;
  ParkingSize size;
  int floorNumber;
  bool isFilled;
  String? carId;
  String? carSize;
}
