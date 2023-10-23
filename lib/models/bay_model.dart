import 'package:parking_system/common/enums.dart';

class BayModel {
  BayModel(this.parkingLotId, this.bayId, this.size, this.floorNumber);
  String parkingLotId;
  String bayId;
  ParkingSize size;
  int floorNumber;
}
