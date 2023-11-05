import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_system/common/common_functions.dart';
import 'package:parking_system/models/bay_model.dart';
import 'package:parking_system/models/car_parking_model.dart';
import 'package:parking_system/models/parking_model.dart';
import 'package:parking_system/repository/parking_repo.dart';

enum ParkingLotEvents { getParkingLot, bayModelList }

class ParkingLotState {
  List<ParkingLot> parkinglot;
  bool isLoading;
  bool isLoaded;
  bool isDeleting;
  bool isDeleted;
  bool isSaved;
  bool hasFailure;
  bool isSaving;
  bool isError;
  String? parkingLotActive;

  ParkingLotState({
    this.parkinglot = const [],
    this.isLoading = false,
    this.isSaved = false,
    this.isDeleting = false,
    this.isDeleted = false,
    this.isSaving = false,
    this.hasFailure = false,
    this.isLoaded = false,
    this.isError = false,
    this.parkingLotActive = null,
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
          List<ParkingLot>? response =
              await _carParkingRepository.getCarParkingModel();
          if (response == null || response.isEmpty) {
            emit(ParkingLotState(
                isLoading: false,
                isLoaded: true,
                isError: true,
                parkinglot: [],
                parkingLotActive: null));
          } else {
            emit(ParkingLotState(
                isLoading: false,
                isLoaded: true,
                isError: false,
                parkinglot: response!,
                parkingLotActive: response.first.parkingLotId));
          }
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

  List<CarParkingModel> getfilledParkingSlot() {
    List<ParkingLot> parkingLotList = state.parkinglot;
    int index = parkingLotList.indexWhere(
        (element) => element.parkingLotId == state.parkingLotActive);
    if (index != -1) {
      ParkingLot parkingLot = state.parkinglot[index];
      List<BayModel> list = parkingLot.listOfBayModel
          .where((element) => element.isFilled)
          .toList();
      List<CarParkingModel> carParkingList = [];
      list.forEach((element) {
        carParkingList.add(CarParkingModel(
            element.floorNumber,
            element.bayId,
            element.size,
            element.isFilled,
            element.bayId,
            element.carSize,
            convertEnumToString(element.size)!));
      });
      return carParkingList;
    }
    return [];
  }

  String? getParkignLotId() {
    return state.parkingLotActive;
  }

  ParkingLot? getActiveParkingLot() {
    int index = state.parkinglot.indexWhere(
        (element) => element.parkingLotId == state.parkingLotActive);
    if (index != -1) {
      return state.parkinglot[index];
    }
    return null;
  }

  void updateBayModelList(List<CarParkingModel> list) {
    int index = state.parkinglot
        .indexWhere((element) => element == state.parkingLotActive);
    if (index != -1) {
      List<BayModel> bayModelList = state.parkinglot![index].listOfBayModel;
      _list = bayModelList;
      add(ParkingLotEvents.bayModelList);
    }
  }

  List<BayModel> getListOfBayModel() {
    int index = state.parkinglot
        .indexWhere((element) => element == state.parkingLotActive);
    if (index != -1) {
      return state.parkinglot[index].listOfBayModel ?? [];
    }
    return [];
  }

  void carParkingRepositoryVariable(ParkingRepo mockRepository) {
    _carParkingRepository = mockRepository;
  }
}
