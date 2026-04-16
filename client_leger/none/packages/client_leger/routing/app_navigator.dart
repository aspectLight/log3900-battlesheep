import 'navigation_command.dart';

abstract class AppNavigator {
  void request(NavigationCommand command);
}
