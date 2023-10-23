import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_system/models/bay_model.dart';
import 'package:parking_system/models/car_parking_model.dart';
import 'package:parking_system/models/parking_model.dart';
import 'package:parking_system/repository/parking_repo.dart';

enum ParkingLotEvents { getParkingLot, bayModelList }

class ParkingLotState {
  ParkingLot? parkinglot;
  bool isLoading;
  bool isLoaded;
  bool isDeleting;
  bool isDeleted;
  bool isSaved;
  bool hasFailure;
  bool isSaving;
  bool isError;

  ParkingLotState({
    this.parkinglot,
    this.isLoading = false,
    this.isSaved = false,
    this.isDeleting = false,
    this.isDeleted = false,
    this.isSaving = false,
    this.hasFailure = false,
    this.isLoaded = false,
    this.isError = false,
  });
  @override
  factory ParkingLotState.initail() {
    return ParkingLotState();
  }
}

class ParkingLotBloc extends Bloc<ParkingLotEvents, ParkingLotState> {
  ParkingRepo _carParkingRepository = ParkingRepo();

  ParkingLotBloc() : super(ParkingLotState.initail()) {
    on<ParkingLotEvents>((event, emit) async {
      print('event from ParkingLotBloc $event');
      switch (event) {
        case ParkingLotEvents.getParkingLot:
          emit(ParkingLotState(isLoading: true, isLoaded: false));
          // CarParkingDetailsParams params = CarParkingDetailsParams();
          ParkingLot? response =
              await _carParkingRepository.getCarParkingModel();
          if (response == null) {
            emit(ParkingLotState(
                isLoading: false, isLoaded: true, isError: true));
          }
          emit(ParkingLotState(
              isLoading: false,
              isLoaded: true,
              isError: false,
              parkinglot: response));
          break;

        case ParkingLotEvents.bayModelList:
        // emit()
      }
    });
  }
  late List<BayModel> _list;
  void getParkingLot() {
    add(ParkingLotEvents.getParkingLot);
  }

  String? getParkignLotId() {
    return state.parkinglot?.parkingLotId;
  }

  void updateBayModelList(List<CarParkingModel> list) {
    List<BayModel> bayModelList = state.parkinglot!.listOfBayModel;
    _list = bayModelList;
    add(ParkingLotEvents.bayModelList);
  }

  List<BayModel> getListOfBayModel() {
    return state.parkinglot?.listOfBayModel ?? [];
  }

  void carParkingRepositoryVariable(ParkingRepo mockRepository) {
    _carParkingRepository = mockRepository;
  }
}
