import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:parking_system/blocs/car_bloc.dart';
import 'package:parking_system/blocs/parking_lot_bloc.dart';
import 'package:parking_system/common/bottom_button.dart';
import 'package:parking_system/common/list_car_parking.dart';

class IndesScreen extends StatefulWidget {
  const IndesScreen({Key? key}) : super(key: key);

  @override
  State<IndesScreen> createState() => _IndesScreenState();
}

class _IndesScreenState extends State<IndesScreen> {
  late ParkingLotBloc _parkingLotbloc;
  late CarParkingBloc _carParkingBloc;
  @override
  void initState() {
    _parkingLotbloc = ParkingLotBloc();
    _carParkingBloc = CarParkingBloc();
    _parkingLotbloc.getParkingLot();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _parkingLotbloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ParkingLotBloc>(
            create: (BuildContext context) => _parkingLotbloc),
        BlocProvider<CarParkingBloc>(
            create: (BuildContext context) => _carParkingBloc)
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('testing'),
        ),
        body: BlocListener<CarParkingBloc, CarParkingState>(
          listener: (BuildContext context,
              CarParkingState carStateFromListener) async {
            if (carStateFromListener.isErrorWhileAssigningParkingSpace) {
              return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text('Warning'),
                      content: Text('no SLOT FOUND'),
                    );
                  });
            }

            if (carStateFromListener.hasAdded ||
                carStateFromListener.hasRemoved) {
              _parkingLotbloc
                  .updateBayModelList(carStateFromListener.carParking);
            }
          },
          child: BlocBuilder<ParkingLotBloc, ParkingLotState>(
              builder: (BuildContext context, ParkingLotState state) {
            if (state.isLoading || state.isDeleting) {
              return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.black,
                  size: 100,
                ),
              );
            } else if (state.isError) {
              return const Center(child: Text("No Parking Data Available"));
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(state.parkinglot?.name ?? ''),
                    BlocBuilder<CarParkingBloc, CarParkingState>(builder:
                        (BuildContext context,
                            CarParkingState carParkingState) {
                      return ListViewCarPark(carParkingState: carParkingState);
                    }),
                    const BottomButtons(),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
