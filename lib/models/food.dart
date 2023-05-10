import 'package:cloud_firestore/cloud_firestore.dart';

class FoodModel {
  static const DIRECTORY = "food";
  static const ADDONS = "addons";

  static const TIME = "time";

  static const DESCRIPTION = "description";
  static const PRICE = 'price';
  static const NAME = "name";
  static const IMAGES = 'images';
  static const FREQUENCY = 'buyFrequency';
  static const CATEGORY = "category";
  static const DATEOFADDING = "dateOfAdding";

  static const OWNER = "owner";
  static const RESTAURANT = "restaurant";
  static const INGREDIENTS = "ingredients";
  static const DATEOFSELLOUT = "dateOfSellout";

  static const VARIATIONIMAGES = "images";
  static const VARIATIONNAME = "name";
  static const VARIATIONPRICE = "price";

  static const VARIATIONS = "variations";

  //new Stuff
  String _name;
  String _id;
  dynamic _variations;
  String _owner;
  String _description;
  dynamic _price;
  int _dateOfAdding;
  int _dateOfSellout;
  List<dynamic> _images;
  int _frequency;
  String _category;
  String _restaurant;
  dynamic _ingredients;
  dynamic _addons;

//  getters
  String get name => _name;
  dynamic get addons => _addons;
  dynamic get price => _price;
  String get category => _category;
  String get owner => _owner;
  int get dateOfAdding => _dateOfAdding;
  int get frequency => _frequency;
  dynamic get variations => _variations;
  String get description => _description;
  String get id => _id;
  List<dynamic> get images => _images;
  int get dateOfSellout => _dateOfSellout;
  String get restaurant => _restaurant;
  dynamic get ingredients => _ingredients;

  FoodModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map pp = snapshot.data() as Map;

    _description = pp[DESCRIPTION] ?? "";
    _frequency = pp[FREQUENCY] ?? 0;
    _price = pp[PRICE] ?? 0;
    _dateOfAdding = pp[DATEOFADDING];
    _addons = pp[ADDONS] ?? {};
    _variations = pp[VARIATIONS] ?? {};
    _images = pp[IMAGES] ?? [];
    _category = pp[CATEGORY];
    _owner = pp[OWNER];
    _id = snapshot.id;

    _name = pp[NAME];
    _dateOfSellout = pp[DATEOFSELLOUT];

    _ingredients = pp[INGREDIENTS] ?? {};
    _restaurant = pp[RESTAURANT];
  }
}
