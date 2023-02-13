// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
//     as bg;
// import 'notification_service.dart';
//
// class LocationBasedNotification {
//   late double _examLatitude;
//   late double _examLongitude;
//
//   // this is called when user selects new address from the Google PlacesAutoComplete widget
//   Future<void> setParams(double lat, double lon) async {
//     if (lon != null && lat != null) {
//       // update the state and update the values in shared preferences for persistence
//       _examLatitude = lat;
//       _examLongitude = lon;
//
//       // update the geofence
//       _addGeofence();
//
//       await init();
//     }
//   }
//
//
//   // add background geolocation geofence - will get overwritten everytime this is called since we are using a single identifier
//   // this is the desired behavior for now, since they can only set one home location and we want the user to get notifications
//   // for only that location
//   void _addGeofence() {
//     bg.BackgroundGeolocation.addGeofence(bg.Geofence(
//       identifier: 'LOCATION',
//       radius: 150,
//       latitude: _examLatitude,
//       longitude: _examLongitude,
//       notifyOnEntry: true,
//       // only notify on entry
//       notifyOnExit: false,
//       notifyOnDwell: false,
//       loiteringDelay: 30000, // 30 seconds
//     )).then((bool success) {
//       print('[addGeofence] success with $_examLatitude and $_examLongitude');
//     }).catchError((error) {
//       print('[addGeofence] FAILURE: $error');
//     });
//   }
//
//   // background geolocation event handlers
//   // triggered whenever a geofence event is detected - in this case when you
//   // ENTER a geofence that was added on the app home page
//   void _onGeofence(bg.GeofenceEvent event) {
//     print('onGeofence $event');
//
//     NotificationApi.showNotification(
//       title: 'Exam Management App',
//       body: 'You arrived at your exam' 's location',
//     ).then((result) {}).catchError((onError) {
//       print('[flutterLocalNotificationsPlugin.show] ERROR: $onError');
//     });
//   }
//
//   Future init({bool initScheduled = false}) async {
//     // add geofence if coordinates are set
//     if (_examLatitude != null && _examLongitude != null) {
//       _addGeofence();
//     }
//
//     // set background geolocation events
//     bg.BackgroundGeolocation.onGeofence(_onGeofence);
//
//     // Configure the plugin and call ready
//     bg.BackgroundGeolocation.ready(bg.Config(
//             desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
//             distanceFilter: 10.0,
//             stopOnTerminate: false,
//             startOnBoot: true,
//             debug: false,
//             // true
//             logLevel: bg.Config.LOG_LEVEL_OFF // bg.Config.LOG_LEVEL_VERBOSE
//             ))
//         .then((bg.State state) {
//       if (!state.enabled) {
//         // start the plugin
//         // bg.BackgroundGeolocation.start();
//
//         // start geofences only
//         bg.BackgroundGeolocation.startGeofences();
//       }
//     });
//   }
// }
