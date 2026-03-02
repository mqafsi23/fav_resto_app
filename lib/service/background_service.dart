import 'package:workmanager/workmanager.dart';
import 'notification_helper.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await NotificationHelper().showNotification();
    return Future.value(true);
  });
}
