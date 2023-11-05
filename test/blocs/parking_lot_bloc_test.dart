import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parking_system/blocs/parking_lot_bloc.dart';

import 'package:parking_system/models/parking_model.dart';
import 'package:parking_system/repository/parking_repo.dart';

import 'parking_lot_bloc_test.mocks.dart';

@GenerateMocks([ParkingRepo])
void main() {
  group('ParkingLotBloc', () {
    ParkingLotBloc parkingLotBloc;
    MockParkingRepo mockRepository;

    setUp(() {
      mockRepository = MockParkingRepo();
      parkingLotBloc = ParkingLotBloc();
      parkingLotBloc.carParkingRepositoryVariable(mockRepository);
    });

    test('getParkingLot returns a ParkingLot model', () async {
      mockRepository = MockParkingRepo();
      parkingLotBloc = ParkingLotBloc();

      // Mock the repository's method to return a ParkingLot model
      when(mockRepository.getCarParkingModel()).thenAnswer((_) async => [
            ParkingLot('temp', "lot123", 1, []
                // Add other properties based on your model
                )
          ]);

      parkingLotBloc.getParkingLot();

      // Use the `expectLater` function to test the state changes and emits
      expectLater(
        parkingLotBloc,
        emitsInOrder([
          isA<ParkingLotState>()
              .having((state) => state.isLoading, 'isLoading', true),
          isA<ParkingLotState>()
              .having((state) => state.isLoading, 'isLoading', false),
          isA<ParkingLotState>()
              .having((state) => state.isError, 'isError', false),
          isA<ParkingLotState>()
              .having((state) => state.isLoaded, 'isLoaded', true),
        ]),
      );
    });
  });
}
