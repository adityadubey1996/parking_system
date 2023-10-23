import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_system/models/car_parking_model.dart';
import 'package:parking_system/models/parking_model.dart';
import 'package:parking_system/repository/car_parking_repo.dart';

enum CarParkingEvent {
  assignParkingSpace,
  unAssignParkingSpace,
}

class CarParkingState {
  List<CarParkingModel> carParking;
  bool isLoading;
  bool isLoaded;
  bool isDeleting;
  bool isDeleted;

  bool hasFailure;
  bool isSaving;
  bool isErrorWhileAssigningParkingSpace;
  bool isErrorWhileUnAssigningParkingSpace;
  bool hasAdded;
  bool hasRemoved;
  CarParkingState({
    this.carParking = const [],
    this.isLoading = false,
    this.isDeleting = false,
    this.isDeleted = false,
    this.isSaving = false,
    this.hasFailure = false,
    this.isLoaded = false,
    this.hasAdded = false,
    this.hasRemoved = false,
    this.isErrorWhileAssigningParkingSpace = false,
    this.isErrorWhileUnAssigningParkingSpace = false,
  });
}

class CarParkingBloc extends Bloc<CarParkingEvent, CarParkingState> {
  CarParkingDetailsParams? _assignParams;
  CarParkingUnassignParams? _unAssignparams;
  CarParkingRepository _carParkingRepository = CarParkingRepository();

  CarParkingBloc() : super(CarParkingState()) {
    on<CarParkingEvent>((event, emit) async {
      switch (event) {
        case CarParkingEvent.assignParkingSpace:
          emit(CarParkingState(
            isLoading: true,
            isLoaded: false,
            carParking: state.carParking,
            hasAdded: true,
          ));
          CarParkingDetailsParams params = _assignParams!;
          CarParkingModel? user =
              await _carParkingRepository.assignCarParking(params);

          if (user == null) {
            emit(CarParkingState(
                isLoading: false,
                isLoaded: true,
                isErrorWhileAssigningParkingSpace: true,
                carParking: state.carParking));
          } else {
            if (state.carParking.isEmpty) {
              emit(CarParkingState(
                isLoading: false,
                isLoaded: true,
                isErrorWhileAssigningParkingSpace: false,
                carParking: [user],
                hasAdded: true,
              ));
            } else {
              List<CarParkingModel> carParking = [...state.carParking, user];
              emit(CarParkingState(
                isLoading: false,
                isLoaded: true,
                isErrorWhileAssigningParkingSpace: false,
                carParking: carParking,
                hasAdded: true,
              ));
            }
            List<CarParkingModel> list = state.carParking;
            emit(CarParkingState(
              isLoading: false,
              isLoaded: true,
              isErrorWhileAssigningParkingSpace: false,
              carParking: list,
              hasAdded: false,
            ));
          }
          break;

        case CarParkingEvent.unAssignParkingSpace:
          emit(CarParkingState(isLoaded: false, isLoading: true));
          CarParkingUnassignParams params = _unAssignparams!;

          bool isSuccessful =
              await _carParkingRepository.unAssignCarParking(params);
          if (isSuccessful) {
            int index = state.carParking
                .indexWhere((element) => element.bayId == params.bayId);
            if (index == -1) {
              emit(CarParkingState(
                  isLoading: true,
                  isLoaded: false,
                  isErrorWhileUnAssigningParkingSpace: true));
            } else {
              CarParkingModel updatedCarModel = state.carParking[index];

              updatedCarModel.isFilled = false;
              state.carParking.removeAt(index);
              List<CarParkingModel> updateList = [...state.carParking];
              emit(CarParkingState(
                  isLoading: false,
                  isLoaded: true,
                  carParking: updateList,
                  isErrorWhileUnAssigningParkingSpace: true));
            }
          }
          emit(CarParkingState(isLoading: false, isLoaded: true));
          break;
      }
    });
  }

  @override
  CarParkingState get initialState => CarParkingState();

  void assignParkingSpace(CarParkingDetailsParams params) {
    _assignParams = params;
    add(CarParkingEvent.assignParkingSpace);
  }

  void deleteParkingSpace(CarParkingUnassignParams params) {
    _unAssignparams = params;
    add(CarParkingEvent.unAssignParkingSpace);
  }

  void assignCarparkingSpace(ParkingLot parkingLot) {}

  void carParkingRepositoryVariable(CarParkingRepository mockRepository) {
    _carParkingRepository = mockRepository;
  }
}
