import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  static const DIRECTORY = "users";

  static const HIVEBOXNAME = "userInfoBox";
  static const USERSBYTYPE = "usersByType";

  static const ACCOUNTTYPES = "accountTypes";
  static const LASTLOGINTIME = "lastLogin";
  static const LASTLOGOUTTIME = "lastLogout";
   static const CREATEUSER = "createUser";
  static const PERMISSIONUPDATES = "permissionUpdates";
  static const PASSWORD = "password";
  static const FCMTOKENS = "userFCMTokens";

  static const USERNAME = "userName";
  static const EMAIL = "email";
  static const PHONENUMBER = "phoneNumber";
  static const PROFILEPIC = "profilePic";
  static const IMAGES = "images";
  static const WHATSAPPNUMBER = "whatsappNumber";
  static const GENDER = "gender";
  static const ADDRESS = "address";
  static const SETTINGSMAP = "settingsMap";
  static const REGISTERER = "registerer";
  static const TIMEOFJOINING = "time";
  static const TYPE = "type";
  static const ADDING = "adding";
  static const AFFILIATION = "affiliation";
  static const REMOVING = "removing";
  static const MODE = "mode";

  String _id;
  String _email;
  String _userName;
  String _profilePic;
  String _phoneNumber;
  Map _permissionUpdate;
  dynamic _settingsMap;
  String _adder;
  int _date;
  List _images;
  List _affiliation;
  String _type;
  String _address;
  String _whatsappNumber;
  String _gender;

  String get gender => _gender;
  Map get permissionUpdates => _permissionUpdate;
  String get adder => _adder;
  int get date => _date;
  String get address => _address;
  String get whatsappNumber => _whatsappNumber;
  String get email => _email;
  String get id => _id;
  List get affiliation => _affiliation;
  dynamic get settingsMAp => _settingsMap;
  String get userName => _userName;
  String get type => _type;
  String get profilePic => _profilePic;
  List get images => _images;
  String get phoneNumber => _phoneNumber;

  UserModel.fromSnapshot(
    DocumentSnapshot snapshot,
  ) {
    Map pp = snapshot.data() as Map;

    _phoneNumber = pp[PHONENUMBER];
    _userName = pp[USERNAME];
    _profilePic = pp[PROFILEPIC];
    _permissionUpdate = pp[PERMISSIONUPDATES] ?? {};
    _email = pp[EMAIL];
    _affiliation = pp[AFFILIATION];
    _settingsMap = pp[SETTINGSMAP] ?? {};
    _images = pp[IMAGES];
    _whatsappNumber = pp[WHATSAPPNUMBER];
    _adder = pp[REGISTERER];
    _date = pp[TIMEOFJOINING];
    _address = pp[ADDRESS] ?? "Kampala";
    _images = pp[IMAGES] ?? [];
    _gender = pp[GENDER] ?? "male";
    _id = snapshot.id;
  }

  UserModel.fromData({
    @required String phoneNumber,
    @required String username,
    @required String profilePic,
    @required String email,
    @required List images,
  }) {
    _phoneNumber = phoneNumber;
    _userName = username;
    _profilePic = profilePic;
    _email = email;
    _images = images;
  }
}
