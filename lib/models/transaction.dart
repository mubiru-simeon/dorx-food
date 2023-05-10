import 'package:cloud_firestore/cloud_firestore.dart';

class MaishaTransaction {
  static const DIRECTORY = "transactions";

  static const PRODUCTS = "products";
  static const QUANTITY = "quantity";
  static const PRICE = "price";
  static const DATEOFTRANSACTION = "dateOfTransaction";
  static const CUSTOMER = "customer";
  static const DOCUMENTS = "documents";
  static const DATE = "date";
  static const ADDER = "adder";
  static const MODE = "mode";

  String _id;
  dynamic _total;
  int _date;
  Map _products;
  String _mode;
  String _customer;
  int _dateOfTransaction;

  String get customer => _customer;
  Map get products => _products;
  String get mode => _mode;
  dynamic get total => _total;
  int get dateOfTransaction => _dateOfTransaction;
  int get date => _date;
  String get id => _id;

  MaishaTransaction.fromSnapshot(DocumentSnapshot snapshot) {
    Map pp = snapshot.data() as Map;

    _products = pp[PRODUCTS] ?? [];
    _customer = pp[CUSTOMER];
    _date = pp[DATE];
    _mode = pp[MODE] ?? MONEYOUT;
    _dateOfTransaction = pp[DATEOFTRANSACTION];

    dynamic tt = 0;
    _products.forEach((key, value) {
      tt = tt + value[QUANTITY] * value[PRICE];
    });

    _total = tt;
  }
}

const MONEYIN = "money in";
const MONEYOUT = "money out";
