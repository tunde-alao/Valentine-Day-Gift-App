// ignore_for_file: avoid_print

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:affection_alerts/env/envied.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

String? currentMessageBody;
String? currentMessageTimeAgo;

Future nextMessage() async {
  // Cancel all scheduled notifications
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.cancel(0);
  tz.initializeTimeZones();

  String chatMessages = await rootBundle.loadString('assets/whatsapp_chat.txt');

  String prompt = """
    Given the following list of messages and their send dates, identify messages sent by [name] that are very cute and heart warming and provide the send date for each cute message:
    $chatMessages
    Focus only on messages from ${Env.partnerName}. Please format your response as follows: "<Message Content>~<Send Date>\n"
    """;

  OpenAIChatCompletionModel completion = await OpenAI.instance.chat.create(
    model: "gpt-4",
    messages: [
      OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            prompt,
          ),
        ],
        role: OpenAIChatMessageRole.user,
      )
    ],
  );

  OpenAIChatCompletionChoiceMessageContentItemModel content =
      completion.choices.first.message.content!.first;

  List<String> resultList = content.text!.split('\n');

  int currentId = 1;

  for (var element in resultList) {
    List<String> bodyDate = element.split('~');

    print('Scheduling $element $currentId');

    await flutterLocalNotificationsPlugin.zonedSchedule(
      currentId, // ID of the notification
      timeago.format(convertToDate(bodyDate[1])), // Title
      bodyDate[0], // Body
      tz.TZDateTime.now(tz.local)
          .add(Duration(days: 7 * currentId)), // Scheduled time
      const NotificationDetails(
          iOS: DarwinNotificationDetails(
        sound: 'default',
        badgeNumber: 1,
        // other properties
      )),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    currentId += 1;
  }

  String selectedResult = resultList[0];

  List<String> selectedResultComponent = selectedResult.split('~');

  print(resultList);
  print(selectedResult);
  print(selectedResultComponent);
  print(convertToDate(selectedResultComponent[1]));

  currentMessageBody = selectedResultComponent[0];
  currentMessageTimeAgo = timeago.format(
    convertToDate(selectedResultComponent[1]),
  );
}

DateTime convertToDate(String dateString) {
  // Define the format of the input date string
  DateFormat format = DateFormat('MM/dd/yy, HH:mm:ss');
  // Use the format to parse the input string into a DateTime object
  DateTime dateTime = format.parse(dateString);
  return dateTime;
}
