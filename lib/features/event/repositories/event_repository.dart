import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/failures.dart';
import '../../../core/network/network_info.dart';
import '../../../core/util/constants.dart';
import '../models/event.dart';
import '../models/typed_image.dart';

abstract class EventRepository {
  Future<Either<Failure, List<Event>>> getEvents();
  Future<Either<Failure, bool>> saveEvent(Event event);
  Future<Either<Failure, bool>> updateEvent(Event event);
  Future<Either<Failure, bool>> deleteNotification(Event event);
  Future<Either<Failure, File>> pickImageFromGallery();
  Future<Either<Failure, List<TypedImage>>> getImages();
  Future<Either<Failure, bool>> deleteEvent(Event event);
  Future<int> generateId();
}

const EVENTS = "EVENTS";
const NETWORK_IMAGES = "NETWORK_IMAGES";
const API_URL = "https://run.mocky.io/v3/10884ce8-5f5f-4de2-a2e2-3d7033b532ff";

class EventRepositoryImpl implements EventRepository {
  final SharedPreferences sharedPreferences;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final ImagePicker imagePicker;
  final NetworkInfo networkInfo;
  final http.Client client;

  EventRepositoryImpl({
    @required this.sharedPreferences,
    @required this.flutterLocalNotificationsPlugin,
    @required this.imagePicker,
    @required this.networkInfo,
    @required this.client,
  });

  @override
  Future<Either<Failure, List<Event>>> getEvents() async {
    try {
      final eventsString = sharedPreferences.getString(EVENTS);

      if (eventsString != null) {
        final eventsMap =
            (json.decode(eventsString) as List).cast<Map<String, dynamic>>();

        final events = eventsMap
            .map((Map<String, dynamic> eventMap) => Event.fromJson(eventMap))
            .toList();
        final now = DateTime.now();

        events.sort((a, b) => DateTime.parse(a.dateString)
            .compareTo(DateTime.parse(b.dateString)));

        return Right(events
            .where(
                (event) => DateTime.parse(event.dateString).compareTo(now) > 0)
            .toList());
      } else {
        return Right(<Event>[]);
      }
    } on Exception {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveEvent(Event event) async {
    try {
      final events = await _getOldEventsMap();
      events.add(event.toJson());

      final encodedEvents = json.encode(events);

      final saveResult =
          await sharedPreferences.setString(EVENTS, encodedEvents);

      if (saveResult == true && event.notify) {
        _createNotification(event);
      }

      return Right(saveResult);
    } on Exception {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateEvent(Event event) async {
    final events = await _getOldEventsMap();
    final eventToUpdateIndex =
        events.indexWhere((element) => element["id"] == event.id);

    if (eventToUpdateIndex != -1) {
      events[eventToUpdateIndex] = event.toJson();

      final encodedEvents = json.encode(events);

      return Right(
        await sharedPreferences.setString(
          EVENTS,
          encodedEvents,
        ),
      );
    } else {
      return await saveEvent(event);
    }
  }

  @override
  Future<Either<Failure, bool>> deleteEvent(Event event) async {
    try {
      final eventsOrFailure = await getEvents();

      if (eventsOrFailure.isLeft()) {
        return Left(DeleteFailure());
      }

      final events = eventsOrFailure.getOrElse(() => null);
      events.removeWhere((element) => element.id == event.id);

      await sharedPreferences.setString(
          EVENTS, json.encode(events.map((event) => event.toJson())));

      await deleteNotification(event);

      return Right(true);
    } on Exception {
      return Left(DeleteFailure());
    }
  }

  Future<List<Map<String, dynamic>>> _getOldEventsMap() async {
    try {
      final oldEvents = sharedPreferences.getString(EVENTS);

      if (oldEvents != null) {
        return json.decode(oldEvents).cast<Map<String, dynamic>>();
      } else {
        return [].cast<Map<String, dynamic>>();
      }
    } on Exception {
      return [].cast<Map<String, dynamic>>();
    }
  }

  Future<Either<Failure, bool>> _createNotification(Event event) async {
    if (event.repeat.value == RepeatValue.never) {
      return await _scheduleNotification(event);
    }

    return await _setCronNotification(event);
  }

  Future<Either<Failure, bool>> _setCronNotification(Event event) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'upcoming_event',
      'Upcoming Event',
      '1 day left to an event',
    );

    final iOSPlatformChannelSpecifics = IOSNotificationDetails();

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );

    final dateOfNotification = DateTime.parse(event.dateString);

    final day = Day(
        dateOfNotification.weekday == 1 ? 7 : dateOfNotification.weekday - 1);

    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
      event.id,
      "It's the day of week for..",
      event.title,
      day,
      Time(0, 10, 0),
      platformChannelSpecifics,
    );

    return Right(true);
  }

  Future<Either<Failure, bool>> _scheduleNotification(Event event) async {
    final now = DateTime.now();
    final dateOfNotification =
        DateTime.parse(event.dateString).subtract(Duration(days: 1));

    if (now.compareTo(dateOfNotification) < 0) {
      final notificationId = event.id;

      final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'upcoming_event',
        'Upcoming Event',
        '1 day left to an event',
      );

      final iOSPlatformChannelSpecifics = IOSNotificationDetails();

      NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics,
        iOSPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.schedule(
        notificationId,
        "Upcoming Event!",
        '1 day until ${event.title}',
        dateOfNotification,
        platformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.schedule(
        notificationId + 1,
        "The day is today",
        '${event.title} has arrived.',
        dateOfNotification.add(Duration(days: 1)),
        platformChannelSpecifics,
      );

      return Right(true);
    }

    return Left(NotificationFailure());
  }

  @override
  Future<Either<Failure, bool>> deleteNotification(Event event) async {
    try {
      final notificationId = event.id * 2;

      await flutterLocalNotificationsPlugin.cancel(notificationId);
      await flutterLocalNotificationsPlugin.cancel(notificationId + 1);

      return Right(true);
    } on Exception {
      return Left(NotificationFailure());
    }
  }

  @override
  Future<Either<Failure, File>> pickImageFromGallery() async {
    try {
      final pickedImage =
          await imagePicker.getImage(source: ImageSource.gallery);

      if (pickedImage != null) return Right(File(pickedImage.path));

      return Left(GalleryImagePickFailure());
    } on Exception {
      return Left(GalleryImagePickFailure());
    }
  }

  @override
  Future<Either<Failure, List<TypedImage>>> getImages() async {
    try {
      final List<TypedImage> images = [];

      images.addAll(await _getNetworkImages());

      return Right(images..addAll(allImages));
    } on Exception {
      return Left(ServerFailure());
    }
  }

  Future<List<TypedImage>> _getNetworkImages() async {
    if (await networkInfo.isConnected) {
      final response = await client.get(API_URL);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return await _getSavedNetworkImages();
      }

      final body = response.body;

      await sharedPreferences.setString(NETWORK_IMAGES, body);
      final decodedResponse = json.decode(body).cast<String>();

      return (decodedResponse as List)
          .map(
            (url) => TypedImage(
              path: url,
              type: ImageSourceType.network,
            ),
          )
          .toList();
    }

    return await _getSavedNetworkImages();
  }

  Future<List<TypedImage>> _getSavedNetworkImages() async {
    final savedImages = sharedPreferences.getString(NETWORK_IMAGES);

    if (savedImages == null) {
      return [].cast<TypedImage>();
    }

    final decodedSavedImages = json.decode(savedImages);

    return (decodedSavedImages as List<String>)
        .map(
          (url) => TypedImage(
            path: url,
            type: ImageSourceType.network,
          ),
        )
        .toList();
  }

  @override
  Future<int> generateId() async {
    final eventsString = sharedPreferences.getString(EVENTS);

    if (eventsString == null) return 0;

    final eventsMap = (json.decode(eventsString) as List);

    return (eventsMap.length) * 2;
  }
}
