import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_system/blocs/car_bloc.dart';
import 'package:parking_system/blocs/parking_lot_bloc.dart';
import 'package:parking_system/models/car_parking_model.dart';
import 'package:parking_system/repository/car_parking_repo.dart';

class ListViewCarPark extends StatefulWidget {
  const ListViewCarPark({Key? key, required this.carParkingState})
      : super(key: key);
  final CarParkingState carParkingState;

  @override
  State<ListViewCarPark> createState() => _ListViewCarParkState();
}

class _ListViewCarParkState extends State<ListViewCarPark> {
  late CarParkingBloc _carParkingBloc;
  late ParkingLotBloc _parkingLotbloc;
  @override
  void initState() {
    _carParkingBloc = context.read<CarParkingBloc>();
    _parkingLotbloc = context.read<ParkingLotBloc>();

    super.initState();
  }

  void onRemoveCarClick(context, CarParkingModel parkingmodel) {
    String? parkingLotId = _parkingLotbloc.getParkignLotId();
    if (parkingLotId == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Warning"),
              content: const Text("No Parking Lot Found"),
              actions: [
                TextButton(
                    onPressed: () {
                      _parkingLotbloc.getParkingLot();
                    },
                    child: const Text('Create Dummy Data')),
                TextButton(onPressed: () {}, child: const Text('Cancel'))
              ],
            );
          });
    } else {
      _carParkingBloc.deleteParkingSpace(
          CarParkingUnassignParams(parkingLotId, parkingmodel.bayId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (_, int index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'parkingSize: ${widget.carParkingState.carParking[index].baySize} ',
                                  textAlign: TextAlign.start),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Car Size: ${widget.carParkingState.carParking[index].carSize} ',
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              onRemoveCarClick(context,
                                  widget.carParkingState.carParking[index]);
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.blue,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        itemCount: widget.carParkingState.carParking.length,
      ),
    );
  }
}
