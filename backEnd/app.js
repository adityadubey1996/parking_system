const express = require("express");
const mongoose = require("mongoose");
const bodyParser = require("body-parser");
require("dotenv").config();
const app = express();
const cors = require("cors");
const {
  createParkingModel,
  saveParkingModelIntoDb,
  getParkingLots,
} = require("./controllers/parking_controller");
var ip = require("ip");
const { BayModel, CarParkingModel } = require("./model/model");
const uuid = require("uuid");
const e = require("express");

// MongoDB Connection
mongoose.connect(
process.env.MONGODB_URL,
  {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  }
);
mongoose.connection.on("connection", (err) => {
  console.log("connected to mongoDb");
});
mongoose.connection.on("error", (err) => {
  console.error("MongoDB connection error:", err);
});

app.use(cors());
// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.get("/", (req, res) => {
  res.status(200).json({ success: true, response: "car Parking API working" });
});
app.get("/api", async (req, res) => {
  await setTimeout(() => {
    res.status(200).json({ success: true, response: "testing" });
  }, 2000);
  console.log("request", req);
});
// Routes
app.get("/api/createCarParking/", async (req, res) => {
  try {
    console.log("testing");
    console.log(req.query);

    console.log(createParkingModel(req));
    const parkingModel = createParkingModel(req);
    if (parkingModel) {
      await saveParkingModelIntoDb(parkingModel);
      res.status(200).json({ success: true, response: parkingModel });
    } else {
      res.status(400).json({ success: false, response: parkingModel });
    }
  } catch (e) {
    res.status(500).json({ success: false, error: e });
  }
});

app.get("/api/getParkingLot", async (req, res) => {
  try {
    res.status(200).json({ success: true, response: await getParkingLots() });
  } catch (e) {
    res.status(500).json({ success: false, error: e });
  }
});

app.get("/api/getParkingData/:parkingId", async (req, res) => {
  const { parkingId } = req.params;
  if (parkingId) {
    return await getParkingModelFromId(parkingId);
  } else {
    res.status(400).json({ success: false, error: "parking not found" });
  }
});

async function getBayResponse(size, parkingId) {
  const bays = await BayModel.find({
    $and: [{ isFilled: false }, { parkingLotId: parkingId }, { size: size }],
  });
  console.log("bays", bays);
  if (bays.length === 0) {
    return null;
  } else if (bays.length !== 0) {
    let bayModel = bays[0];

    bayModel.isFilled = true;

    return bayModel;
  } else {
    return "no SLOT FOUND";
  }
}

async function searchValidBay(keyForParkingSpace, parkingId) {
  let returnValue = { success: false, response: "Something went wrong" };
  for (let i = 0; i < keyForParkingSpace.length; i++) {
    let response = await getBayResponse(keyForParkingSpace[i], parkingId);
    if (!response) {
      continue;
    }
    returnValue = { success: true, response: response };
    break;
  }
  return returnValue;
}

async function createAndSaveCarParkingMode(_response, size) {
  const { response } = _response;
  try {
    const carParkingModelSchema = new CarParkingModel({
      floor: response.floorNumber,
      bayId: response.bayId,
      parkingSize: response.size,
      isFilled: true,
      carId: uuid.v4(),
      carSize: size,
    });
    await carParkingModelSchema.save();
    return carParkingModelSchema;
  } catch (e) {
    const bayModel = BayModel.find({ bayId: reponse.bayId });
    bayModel.isFilled = false;
    await bayModel.save();
    return null;
  }
}

app.post("/api/assignParkingSpace", async (req, res) => {
  try {
    const { size, parkingId } = req.query;
    if (size && parkingId) {
      let keyForParkingSpace = ["small", "medium", "large", "Xlarge"];
      let keyForParkingSpaceForMedium = ["medium", "large", "Xlarge"];
      let keyForParkingSpaceForLarge = ["large", "Xlarge"];
      let response;
      switch (size.toLowerCase()) {
        case "small":
          response = await searchValidBay(keyForParkingSpace, parkingId);
          if (response.success) {
            let carParkingModel = await createAndSaveCarParkingMode(
              response,
              size
            );
            if (carParkingModel) {
              const bayModel = response.response;
              bayModel.carId = carParkingModel.carId;
              bayModel.carSize = carParkingModel.carSize;
              bayModel.save();
              response.response = {
                string: `${bayModel.floorNumber}:${bayModel.bayId}`,
                carModel: carParkingModel,
              };
              res.status(200).json(response);
            } else {
              res.status(400).json(response);
            }
          } else {
            res.status(400).json(response);
          }

          break;

        case "medium":
          response = await searchValidBay(
            keyForParkingSpaceForMedium,
            parkingId
          );
          if (response.success) {
            let carParkingModel = await createAndSaveCarParkingMode(
              response,
              size
            );
            if (carParkingModel) {
              const bayModel = response.response;
              bayModel.carId = carParkingModel.carId;
              bayModel.carSize = carParkingModel.carSize;

              bayModel.save();

              response.response = {
                string: `${bayModel.floorNumber}:${bayModel.bayId}`,
                carModel: carParkingModel,
              };
              res.status(200).json(response);
            } else {
              res.status(400).json(response);
            }
          } else {
            res.status(400).json(response);
          }
          break;
        case "large":
          response = await searchValidBay(
            keyForParkingSpaceForLarge,
            parkingId
          );
          if (response.success) {
            let carParkingModel = await createAndSaveCarParkingMode(
              response,
              size
            );
            if (carParkingModel) {
              const bayModel = response.response;
              bayModel.carId = carParkingModel.carId;
              bayModel.carSize = carParkingModel.carSize;

              bayModel.save();
              response.response = {
                string: `${bayModel.floorNumber}:${bayModel.bayId}`,
                carModel: carParkingModel,
              };
              res.status(200).json(response);
            } else {
              res.status(400).json(response);
            }
          } else {
            res.status(400).json(response);
          }
          break;
        case "Xlarge":
          response = await searchValidBay(["Xlarge"], parkingId);
          if (response.success) {
            let carParkingModel = await createAndSaveCarParkingMode(
              response,
              size
            );
            if (carParkingModel) {
              const bayModel = response.response;
              bayModel.carId = carParkingModel.carId;
              bayModel.carSize = carParkingModel.carSize;

              bayModel.save();
              response.response = {
                string: `${bayModel.floorNumber}:${bayModel.bayId}`,
                carModel: carParkingModel,
              };
              res.status(200).json(response);
            } else {
              res.status(400).json(response);
            }
          } else {
            res.status(400).json(response);
          }
          break;
        default:
          break;
      }
    } else {
      res
        .status(400)
        .json({
          success: false,
          error: `car size ${size}, parkingId ${parkingId}`,
        });
    }
  } catch (e) {
    res
      .status(500)
      .json({ success: false, error: `something went wrong with error ${e}` });
  }
});

app.post("/api/unAssignParking", async (req, res) => {
  try {
    const { parkingLotId, bayId } = req.query;
    if (parkingLotId && bayId) {
      filter = { $and: [{ bayId: bayId }] };
      update = { isFilled: false };
      await CarParkingModel.findOneAndUpdate(filter, update).lean();
      const carParkingModel = await CarParkingModel.findOne(filter);

      if (carParkingModel) {
        try {
          let bayModel = BayModel.findOne({ bayId: carParkingModel.bayId });
          carParkingModel.baySize = bayModel.size;
          res.status(200).json({ success: true, response: carParkingModel });
        } catch (e) {
          carParkingModel.isFilled = true;
          await carParkingModel.save();
          res
            .status(400)
            .json({ success: false, response: "bayModel not found" });
          return;
        }
      }
      res
        .status(400)
        .json({ success: false, response: "carParkingModel not found" });
    } else {
      res
        .status(400)
        .json({
          success: false,
          response: `parkingLotId  is ${parkingLotId} && bayId is ${bayId}`,
        });
    }
  } catch (e) {
    res
      .status(500)
      .json({ success: false, error: `something went wrong with error ${e}` });
  }
});
// Start the server
const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(
    `Server is running on port ${port} public URL -> ${ip.address()}:${port}`
  );
});
