const uuid = require("uuid");
const { ParkingLot, BayModel } = require("../model/model");

const createParkingModel = (req) => {
  const { success } = validateParkingParameters(req);
  if (success) {
    const numberOfFloors = req.query.numberOfFloors;
    const numberOfSmall = req.query.numberOfSmall;
    const numberOfMedium = req.query.numberOfMedium;
    const numberOfLarge = req.query.numberOfLarge;
    const numberOfXL = req.query.numberOfXL;
    const nameOfParkingLot = req.query.parkingName;

    const parkingModel = {
      nameOfParkingLot: nameOfParkingLot,
      noOfFloor: numberOfFloors,
      noIfSmallParkingEachFloor: numberOfSmall,
      noIfMediumParkingEachFloor: numberOfMedium,
      noIflargeParkingEachFloor: numberOfLarge,
      noIfXlargeParkingEachFloor: numberOfXL,
    };
    return parkingModel;
  } else {
    return null;
  }
};

const saveParkingModelIntoDb = async (parkingModel) => {
  if (parkingModel) {
    try {
      if (
        parkingModel.noOfFloor &&
        parkingModel.noIfSmallParkingEachFloor !== null
      ) {
        const parkingID = uuid.v4();
        const listOfSmallParking = [];
        const noIfMediumParkingEachFloor = [];
        const noIflargeParkingEachFloor = [];
        const noIfXlargeParkingEachFloor = [];
        const numberOfFLoors = parkingModel.noOfFloor;

        for (let i = 1; i <= parkingModel.noOfFloor; i++) {
          if (parkingModel.noIfSmallParkingEachFloor) {
            for (let j = 0; j < parkingModel.noIfSmallParkingEachFloor; j++) {
              const bayId = uuid.v4();

              listOfSmallParking.push({
                bayId: bayId,
                size: "small",
                floor: i,
                isFilled: false,
              });
            }
          }
          if (parkingModel.noIfMediumParkingEachFloor) {
            for (let j = 0; j < parkingModel.noIfMediumParkingEachFloor; j++) {
              const bayId = uuid.v4();

              noIfMediumParkingEachFloor.push({
                bayId: bayId,
                size: "medium",
                floor: i,
                isFilled: false,
              });
            }
          }
          if (parkingModel.noIflargeParkingEachFloor) {
            for (let j = 0; j < parkingModel.noIflargeParkingEachFloor; j++) {
              const bayId = uuid.v4();

              noIflargeParkingEachFloor.push({
                bayId: bayId,
                size: "large",
                floor: i,
                isFilled: false,
              });
            }
          }
          if (parkingModel.noIfXlargeParkingEachFloor) {
            for (let j = 0; j < parkingModel.noIfXlargeParkingEachFloor; j++) {
              const bayId = uuid.v4();

              noIfXlargeParkingEachFloor.push({
                bayId: bayId,
                size: "Xlarge",
                floor: i,
                isFilled: false,
              });
            }
          }
        }

        // Create a new ParkingLot document and save it
        const parkingLot = new ParkingLot({
          numberOfFloors: numberOfFLoors,
          listOfBayModel: [],
          name: parkingModel.name,
          parkingLotId: uuid.v4(),
        });
        let listOfBayModel = [];
        [
          ...listOfSmallParking,
          ...noIfMediumParkingEachFloor,
          ...noIflargeParkingEachFloor,
          ...noIfXlargeParkingEachFloor,
        ].forEach((e) => {
          listOfBayModel.push(e);
        });

        const bayModelList = listOfBayModel.map((e) => {
          console.log("e", e);
          return new BayModel({
            parkingLotId: parkingLot.parkingLotId,
            bayId: e.bayId,
            size: e.size,
            isFilled: e.isFilled,
            floorNumber: e.floor,
          });
        });
        parkingLot.listOfBayModel = bayModelList;

        await parkingLot.save();
        await BayModel.insertMany(bayModelList);

        return parkingLot;
      } else {
        throw new Error("Missing required fields in the parking model");
      }
    } catch (error) {
      console.error(error);
      throw error;
    }
  }
};

const getParkingModelFromId = async (id) => {
  try {
    const parkingModel = await ParkingLot.findOne({ parkingId: parkingId });

    if (parkingModel) {
      return res.json(parkingModel);
    } else {
      return res.status(404).json({ message: "Parking model not found" });
    }
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: "Internal server error" });
  }
};

function validateParkingParameters(req) {
  const requiredParams = [
    "numberOfFloors",
    "numberOfSmall",
    "numberOfMedium",
    "numberOfLarge",
    "numberOfXL",
    "parkingName",
  ];
  const missingParams = [];

  for (const param of requiredParams) {
    if (!req.query[param]) {
      missingParams.push(param);
    }
  }

  if (missingParams.length === 0) {
    return {
      success: true,
      message: "All required parameters are present.",
    };
  } else {
    return {
      success: false,
      message: `Missing required parameters: ${missingParams.join(", ")}`,
    };
  }
}
const getParkingLots = async () => {
  let listOfParkingLost = await ParkingLot.find({}).lean();
  let returnList = [];
  for (let parking of listOfParkingLost) {
    let updatedParking = {};
    let listOfBayModel = await BayModel.find({
      parkingLotId: parking.parkingLotId,
    }).lean();
    parking = { ...parking, listOfBayModel: listOfBayModel };
    returnList.push(parking);
  }

  return returnList;
};

module.exports = {
  createParkingModel,
  saveParkingModelIntoDb,
  getParkingModelFromId,
  getParkingLots,
};
