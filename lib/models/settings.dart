class DorxSettings {
  static const DORXBOXNAME = "dorxBox";
  static const SETTINGSMAP = "settingsMap";
  static const FINISHEDONBOARDING = "finishedOnboarding";
  static const EMAILNOTIFICATIONS = "emailNotifications";

  bool _emailNotifications;

  bool get emailNotifications => _emailNotifications ?? true;

  DorxSettings.fromMap(dynamic restaurantMap, dynamic userMap) {
    if (userMap != null) {
      _emailNotifications = userMap[EMAILNOTIFICATIONS] ?? false;
    }
  }
}
