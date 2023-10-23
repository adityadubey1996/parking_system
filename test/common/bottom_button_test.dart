import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parking_system/blocs/car_bloc.dart';
import 'package:parking_system/blocs/parking_lot_bloc.dart';
import 'package:parking_system/common/bottom_button.dart';
import 'bottom_button_test.mocks.dart';

@GenerateMocks([CarParkingBloc, ParkingLotBloc])
void main() {
  group('BottomButtons', () {
    MockCarParkingBloc mockCarParkingBloc;
    MockParkingLotBloc mockParkingLotBloc;

    setUp(() {
      mockCarParkingBloc = MockCarParkingBloc();
      mockParkingLotBloc = MockParkingLotBloc();
    });

    testWidgets('onAddCarClick shows dialog with parking lot',
        (WidgetTester tester) async {
      mockCarParkingBloc = MockCarParkingBloc();
      mockParkingLotBloc = MockParkingLotBloc();
      // Mock the context and state management
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BottomButtons(),
          ),
        ),
      );

      when(mockParkingLotBloc.getParkignLotId()).thenReturn('parkingLotId');

      await tester.tap(find.text('Add Car'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Select Car Size'), findsOneWidget);

      when(mockCarParkingBloc.assignParkingSpace(any)).thenAnswer((_) async {});

      await tester.tap(find.text('add to parking'));
      await tester.pumpAndSettle();

      verify(mockCarParkingBloc.assignParkingSpace(any)).called(1);
    });

    testWidgets('onAddCarClick shows dialog without parking lot',
        (WidgetTester tester) async {
      mockCarParkingBloc = MockCarParkingBloc();
      mockParkingLotBloc = MockParkingLotBloc();
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BottomButtons(),
          ),
        ),
      );

      when(mockParkingLotBloc.getParkignLotId()).thenReturn(null);

      await tester.tap(find.text('Add Car'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('No Parking Lot Found'), findsOneWidget);
    });
  });
}
