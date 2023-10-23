
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parking_system/blocs/car_bloc.dart';
import 'package:parking_system/common/enums.dart';
import 'package:parking_system/models/car_parking_model.dart';
import 'package:parking_system/repository/car_parking_repo.dart';
import 'car_bloc_test.mocks.dart';

@GenerateMocks([CarParkingRepository])
void main() {
  group('CarParkingBloc', () {
    CarParkingBloc carParkingBloc;
    MockCarParkingRepository mockRepository;

    setUp(() {
      mockRepository = MockCarParkingRepository();
      carParkingBloc = CarParkingBloc();
      carParkingBloc.carParkingRepositoryVariable(mockRepository);
    });

    test('assignCarParking returns a CarParkingModel', () async {
      mockRepository = MockCarParkingRepository();
      CarParkingBloc carParkingBloc;
      final params = CarParkingDetailsParams("parkingLotId", "small");

      // Mock the HTTP response
      when(mockRepository.assignCarParking(params)).thenAnswer((_) async =>
          CarParkingModel(1, 'A1', ParkingSize.small, true, 'test', 'small'));

      final carParkingModel = await mockRepository.assignCarParking(params);

      // Verify that the method returned the expected model
      expect(carParkingModel, isNotNull);
      expect(carParkingModel!.floor, 1);
      expect(carParkingModel.bayId, "A1");
      expect(carParkingModel.parkingSize, ParkingSize.small);
      expect(carParkingModel.isFilled, true);
      // Add more assertions based on your model properties
    });

    test('getUnAssign returns true', () async {
      mockRepository = MockCarParkingRepository();
      final params = CarParkingUnassignParams("parkingLotId", "A1");

      // Mock the HTTP response
      when(mockRepository.unAssignCarParking(params))
          .thenAnswer((_) async => true);

      final result = await mockRepository.unAssignCarParking(params);

      // Verify that the method returned true
      expect(result, true);
    });

    test('getUnAssign returns false', () async {
      mockRepository = MockCarParkingRepository();
      final params = CarParkingUnassignParams("parkingLotId", "A1");

      // Mock the HTTP response
      when(mockRepository.unAssignCarParking(params))
          .thenAnswer((_) async => false);

      final result = await mockRepository.unAssignCarParking(params);

      // Verify that the method returned true
      expect(result, false);
    });
  });
}
