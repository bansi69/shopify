import 'package:flutter/material.dart';
import 'notification/notification.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationSpamTest(),
    );
  }
}

class NotificationSpamTest extends StatefulWidget {
  const NotificationSpamTest({super.key});

  @override
  State<NotificationSpamTest> createState() => _NotificationSpamTestState();
}

class _NotificationSpamTestState extends State<NotificationSpamTest> {
  int _notificationId = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  void _scheduleNotification() {
    final int? delayInSeconds = int.tryParse(_timeController.text);
    if (delayInSeconds == null || delayInSeconds <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number of seconds')),
      );
      return;
    }

    final scheduleTime = DateTime.now().add(Duration(seconds: delayInSeconds));
    final String title = _titleController.text;
    final String body = _bodyController.text;
    final int id = _notificationId++;
    if (title.isNotEmpty && body.isNotEmpty) {
      NotificationService.scheduleNotification(
        id,
        title,
        body,
        scheduleTime,
      );

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //       content:
      //           Text('Notification scheduled in $delayInSeconds seconds!')),
      // );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid title and body")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Notifications')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration:
                  const InputDecoration(labelText: 'Notification Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: 'Notification Body'),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _timeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Time set (Seconds)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scheduleNotification,
              child: const Text('Schedule Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
