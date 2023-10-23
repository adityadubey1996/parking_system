import 'package:parking_system/models/bay_model.dart';

class ParkingLot {
  ParkingLot(
      this.name, this.parkingLotId, this.numberOfFloors, this.listOfBayModel);

  String parkingLotId;
  int numberOfFloors;
  List<BayModel> listOfBayModel;
  String name;
}
