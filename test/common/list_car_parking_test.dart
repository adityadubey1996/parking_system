import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:parking_system/blocs/car_bloc.dart';
import 'package:parking_system/common/enums.dart';
import 'package:parking_system/common/list_car_parking.dart';
import 'package:parking_system/models/car_parking_model.dart';

import 'bottom_button_test.mocks.dart';

void main() {
  group('ListViewCarPark', () {
    MockCarParkingBloc mockCarParkingBloc;
    MockParkingLotBloc mockParkingLotBloc;
    CarParkingState carParkingState;

    setUp(() {
      mockCarParkingBloc = MockCarParkingBloc();
      mockParkingLotBloc = MockParkingLotBloc();
      carParkingState = CarParkingState(
        carParking: [
          CarParkingModel(1, 'B1', ParkingSize.small, true, 'Car1', 'Small'),
          CarParkingModel(2, 'B2', ParkingSize.medium, true, 'Car2', 'Medium'),
        ],
      );
    });

    testWidgets('onRemoveCarClick removes car parking',
        (WidgetTester tester) async {
      mockCarParkingBloc = MockCarParkingBloc();
      mockParkingLotBloc = MockParkingLotBloc();
      carParkingState = CarParkingState(
        carParking: [
          CarParkingModel(1, 'B1', ParkingSize.small, true, 'Car1', 'Small'),
          CarParkingModel(2, 'B2', ParkingSize.medium, true, 'Car2', 'Medium'),
        ],
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListViewCarPark(carParkingState: carParkingState),
          ),
        ),
      );

      when(mockParkingLotBloc.getParkignLotId()).thenReturn('parkingLotId');

      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      verify(mockCarParkingBloc.deleteParkingSpace(any)).called(1);
    });

    testWidgets('onRemoveCarClick shows warning dialog without parking lot',
        (WidgetTester tester) async {
      mockCarParkingBloc = MockCarParkingBloc();
      mockParkingLotBloc = MockParkingLotBloc();
      carParkingState = CarParkingState(
        carParking: [
          CarParkingModel(1, 'B1', ParkingSize.small, true, 'Car1', 'Small'),
          CarParkingModel(2, 'B2', ParkingSize.medium, true, 'Car2', 'Medium'),
        ],
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListViewCarPark(carParkingState: carParkingState),
          ),
        ),
      );

      when(mockParkingLotBloc.getParkignLotId()).thenReturn(null);

      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('No Parking Lot Found'), findsOneWidget);
    });
  });
}
