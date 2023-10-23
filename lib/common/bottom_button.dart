import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_system/blocs/car_bloc.dart';
import 'package:parking_system/blocs/parking_lot_bloc.dart';
import 'package:parking_system/common/enums.dart';
import 'package:parking_system/repository/car_parking_repo.dart';

class BottomButtons extends StatefulWidget {
  const BottomButtons({Key? key}) : super(key: key);

  @override
  State<BottomButtons> createState() => _BottomButtonsState();
}

class _BottomButtonsState extends State<BottomButtons> {
  late CarParkingBloc _carParkingBloc;
  late ParkingLotBloc _parkingLotbloc;

  @override
  void initState() {
    _carParkingBloc = context.read<CarParkingBloc>();
    _parkingLotbloc = context.read<ParkingLotBloc>();

    super.initState();
  }

  void onAddCarClick(context) {
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
      showDialog(
          context: context,
          builder: (BuildContext context) {
            List<String> list = parkingSize;

            String? selectedValue = list.first;

            return StatefulBuilder(
              builder: (BuildContext context, setState) {
                return Dialog(
                    child: SizedBox(
                  height: 200,
                  width: 400,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Select Car Size'),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              //  color:Colors.white, //background color of dropdown button
                              border: Border.all(
                                  color: Colors.black38,
                                  width: 1), //border of dropdown button
                              borderRadius: BorderRadius.circular(
                                  5), //border raiuds of dropdown button
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 30, right: 30),
                              child: DropdownButton<String>(
                                  value: selectedValue,
                                  isExpanded: true,
                                  items: <String>[...list].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value;
                                    });
                                  }),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _carParkingBloc.assignParkingSpace(
                                  CarParkingDetailsParams(
                                      parkingLotId, selectedValue!));
                              Navigator.pop(context);
                            },
                            child: const Text('add to parking'))
                      ],
                    ),
                  ),
                ));
              },
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              onAddCarClick(context);
            },
            child: const Text('Add Car'),
          ),
        ],
      ),
    );
  }
}
