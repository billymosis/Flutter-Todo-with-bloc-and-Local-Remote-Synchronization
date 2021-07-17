
# Simple Todo APP with 3 Data Providers

My journey to learn flutter.

Using three Data Provider and one Repository:

- Offline Database with SQLITE / SQFLITE.

- Online Database with API, Laravel + MySQL backend.

- Offline Fake Memory.

Easy switch data provider from drawer menu. 

### CRUD + SYNC

## State Management
This project using flutter bloc version 7.x for managing state and folder structure.
[bloc | Dart Package (pub.dev)](https://pub.dev/packages/bloc)
[flutter_bloc | Flutter Package (pub.dev)](https://pub.dev/packages/flutter_bloc)

## Offline Database
For the offline database using sqflite version 2.x.
Sadly sqflite is not yet compatible with web. So if the platform is web browser will get error from start screen. Changing Data Provider to API or Fake Memory will solve the problem.
[sqflite | Flutter Package (pub.dev)](https://pub.dev/packages/sqflite)

## Additional Package
Internet connection checked with [internet_connection_checker | Dart Package (pub.dev)](https://pub.dev/packages/internet_connection_checker)

## Backend
Backend using Laravel version 8.x and mysql Database. Using Laravel Sanctum for tokenization.

## Synchronization

This application is offline first, so what happen to the client will reflect to the database. I make the client application as dumb as possible. Synchronization is using for backup and get the newest data from last Synchronization. Anything updated or deleted in client will replace existing data on the database. There are 4 Table in client database.
- Todo Table for offline table.
- Todo Updated.
- Todo Created.
- Todo Deleted.

Todo Table, Updated, Created share same Schema id, title, done, created_at, updated_at.
Id is generated on client side using UUID v4 and timestamp using client UTC time.
Todo deleted only store todo id.

There are one cubit and one bloc.
Cubit for checking internet access.
And bloc for todo Logic.


To test the online functionality modify `constant.dart` file. Insert your own API URL and TOKEN.

```dart
const  API_TOKEN = 'YOUR TOKEN';
const  BASE_URL = 'YOUR URL';
const  HTTP_HEADER = {
'Content-Type': 'application/json; charset=UTF-8',
'Accept': 'application/json',
'Authorization': 'Bearer $API_TOKEN',
};
const  LOCAL_DATABASE = 'LOCAL_DATABASE.DB';
```
Not yet tested with IOS device.
Buy me a mac for testing lol 😂.