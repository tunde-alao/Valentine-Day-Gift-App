import 'package:affection_alerts/chat_analyzer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String sender = "Tunde ❤️";
  static const Color textColor = Color(0xFFE42A53);

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  requestPermission() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    nextMessage().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Image.asset("assets/images/bg_leaf.png"),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 150,
                    ),
                    if (currentMessageBody != null) ...[
                      Column(children: [
                        Text(
                          "$currentMessageTimeAgo...",
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lobster',
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                currentMessageBody!,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          sender,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
