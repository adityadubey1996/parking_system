# parking_system

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


 
flutter Pub get

flutter run


2. Setting UP Back end:
   cd backEnd
   npm i
   npm run dev
   Set up the .env file, provided a sample env file
   for mongo db kindly create a free tier cluster
   note the ip Address in the console after and replace it in the repo/car_parking_repo.dart and repo/parking_repo.dart as base URL.

3. Setting up demo data:
   use api/createCarParking?numberOfFloors=1&numberOfSmall=1&numberOfMedium=1&numberOfLarge=1&numberOfXL=1&parkingName=testing
   and every query parameter is required to create dummy data.


   sample request : 

   var requestOptions = {
  method: 'GET',
  redirect: 'follow'
};

fetch("http://localhost:3000/api/createCarParking?numberOfFloors=1&numberOfSmall=1&numberOfMedium=1&numberOfLarge=1&numberOfXL=1&parkingName=testing", requestOptions)
  .then(response => response.text())
  .then(result => console.log(result))
  .catch(error => console.log('error', error));
