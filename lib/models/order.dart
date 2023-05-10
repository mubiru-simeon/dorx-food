import 'package:cloud_firestore/cloud_firestore.dart';

class DorxOrder {
  static const DIRECTORY = 'orders';

  static const MODEL = "model";
  static const PRICE = "price";
  static const QUANTITY = "quantity";
  static const PRODUCTS = "products";
  static const VARIATION = "variation";
  static const PRODUCTNAME = "productName";

  static const CUSTOMERS = "customers";
  static const DATE = "date";
  static const FOODSTOCK = "foodStock";
  static const STOCKMANAGED = "stockManaged";
  static const THINGID = "thingID";
  static const ENTITYCOMMENT = "entityComment";
  static const CUSTOMERMAP = "customerMap";
  static const FOODSTOCKID = "foodStockID";
  static const CUSTOMERAMOUNTS = "customerAmounts";
  static const CUSTOMERTYPE = "customerType";
  static const THINGTYPE = "thingType";
  static const ADDER = "adder";

  dynamic _customerMap;
  String _id;
  int _date;
  String _customerType;
  dynamic _total;
  dynamic _customerAMounts;
  List _customers;
  String _thingID;
  dynamic _food;
  String _thingType;

  dynamic get customerMap => _customerMap;
  List get customers => _customers;
  dynamic get food => _food;
  int get date => _date;
  String get customerType => _customerType;
  dynamic get customerAmounts => _customerAMounts;
  String get thingID => _thingID;
  String get thingType => _thingType;
  dynamic get total => _total;
  String get id => _id;

  DorxOrder.fromSnapshot(DocumentSnapshot snapshot) {
    Map pp = snapshot.data() as Map;

    _id = snapshot.id;
    _thingID = pp[THINGID];
    _customerAMounts = pp[CUSTOMERAMOUNTS] ?? {};
    _customers = pp[CUSTOMERS] ?? [];
    _thingType = pp[THINGTYPE];
    _food = pp[PRODUCTS] ?? [];
    _date = pp[DATE];
    _customerMap = pp[CUSTOMERMAP];
    _customerType = pp[CUSTOMERTYPE];

    dynamic tt = 0;
    _food.forEach((v) {
      tt = tt + (v[QUANTITY] ?? 0) * (v[PRICE] ?? 0);
    });

    _total = tt;
  }
}

const SYSTEMCUSTOMER = "systemCustomer";
const WALKINCUSTOMER = "walkInCustomer";
