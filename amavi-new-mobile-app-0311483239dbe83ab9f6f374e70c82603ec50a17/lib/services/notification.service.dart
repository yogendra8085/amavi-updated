import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart'
    hide NotificationModel;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.service.dart';
import 'firebase.service.dart';

class NotificationService {
  //
  static const platform = MethodChannel('notifications.manage');

  //
  static initializeAwesomeNotification() async {
    await AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
     'resource://drawable/notification_icon',
      //'resource://assets/images/app_icon.png'
      [
        appNotificationChannel(),
      ],
    );
    //requet notifcation permission if not allowed
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience,
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static Future<void> clearIrrelevantNotificationChannels() async {
    if (!Platform.isAndroid) {
      return;

      
    }
    try {
      // get channels
      final List<dynamic> notificationChannels =
      await platform.invokeMethod('getChannels');

      //confirm is more than the required channels is found
      final notificationChannelNames = notificationChannels
          .map(
            (e) => e.toString().split(" -- ")[1] ?? "",
      )
          .toList();

      //
      final totalFound = notificationChannelNames
          .where(
            (e) =>
        e.toLowerCase() ==
            appNotificationChannel().channelName?.toLowerCase(),
      )
          .toList();

      if (totalFound.length > 1) {
        //delete all app created notifications
        for (final notificationChannel in notificationChannels) {
          //
          final notificationChannelData = "$notificationChannel".split(" -- ");
          final notificationChannelId = notificationChannelData[0];
          final notificationChannelName = notificationChannelData[1];
          final isSystemOwned =
              notificationChannelName.toLowerCase() == "miscellaneous";
          //
          if (!isSystemOwned) {
            //
            await platform.invokeMethod(
              'deleteChannel',
              {"id": notificationChannelId},
            );
          }
        }

        //
        await initializeAwesomeNotification();
      }
    } on PlatformException catch (e) {
      print("Failed to get notificaiton channels: '${e.message}'.");
    }
  }

  static NotificationChannel appNotificationChannel() {
    //firebase fall back channel key
    //fcm_fallback_notification_channel
    return NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel for app',
      importance: NotificationImportance.High,
      soundSource: "resource://raw/alert",
      playSound: true,
    );
  }


  static listenToActions() {
    AwesomeNotifications().actionStream.listen((receivedNotification) async {
      FirebaseService().notificationPayloadData = jsonDecode(receivedNotification.payload!['bodyText']!);
      FirebaseService().selectNotification("");
    });
  }
}
