import 'package:parking_system/common/enums.dart';

String? convertEnumToString(ParkingSize parkingSize) {
  switch (parkingSize) {
    case ParkingSize.small:
      return 'small';
    case ParkingSize.medium:
      return 'medium';
    case ParkingSize.large:
      return 'large';
    case ParkingSize.xLarge:
      return 'xLarge';
    default:
      return null;
  }
}

ParkingSize convertStringToEnum(String parkingSize) {
  switch (parkingSize) {
    case 'small':
      return ParkingSize.small;
    case 'medium':
      return ParkingSize.medium;
    case 'large':
      return ParkingSize.large;
    case 'xLarge':
      return ParkingSize.xLarge;
    default:
      return ParkingSize.none;
  }
}
