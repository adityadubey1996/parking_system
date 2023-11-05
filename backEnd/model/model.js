const mongoose = require("mongoose");

// Define the BayModel schema
const bayModelSchema = new mongoose.Schema({
  parkingLotId: String,
  bayId: String,
  size: String, // Assuming ParkingSize is a string type
  floorNumber: Number,
  isFilled: Boolean,
  carId: String,
  carSize: String,
});

// Define the CarParkingModel schema
const carParkingModelSchema = new mongoose.Schema({
  floor: Number,
  bayId: { type: String, required: false },
  parkingSize: {
    type: String,
    enum: ["small", "medium", "large", "none"],
    default: "none",
  },
  isFilled: Boolean,
  carId: { type: String, required: false },
  carSize: { type: String, required: false },
});

// Define the ParkingLot schema
const parkingLotSchema = new mongoose.Schema({
  parkingLotId: String,
  numberOfFloors: Number,
  name: String,
});

// Create models for ParkingLot, BayModel, and CarParkingModel
const ParkingLot = mongoose.model("ParkingLot", parkingLotSchema);
const BayModel = mongoose.model("BayModel", bayModelSchema);
const CarParkingModel = mongoose.model(
  "CarParkingModel",
  carParkingModelSchema
);

module.exports = { ParkingLot, BayModel, CarParkingModel };
