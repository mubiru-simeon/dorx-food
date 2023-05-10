import '../models/models.dart';

class MapGeneration {
  generateUserMap(UserModel user) {
    return {
      UserModel.PHONENUMBER: user.phoneNumber,
      UserModel.TIMEOFJOINING: DateTime.now().millisecondsSinceEpoch,
      UserModel.USERNAME: user.userName,
      UserModel.PROFILEPIC: user.profilePic,
      UserModel.EMAIL: user.email,
    };
  }

  generateNotificationMap(NotificationModel not) {
    return {
      NotificationModel.TITLE: not.title,
      NotificationModel.BODY: not.body,
      NotificationModel.TIME: not.time,
      NotificationModel.THINGID: not.primaryId,
      NotificationModel.THINGTYPE: not.thingType,
    };
  }
}
