import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorx/services/services.dart';
import 'package:flutter/material.dart';
import '../constants/images.dart';
import '../constants/ui.dart';
import '../models/models.dart';
import 'widgets.dart';

class SingleRestaurant extends StatefulWidget {
  final String restaurantID;
  final bool list;
  final bool simple;
  final bool fullWidth;
  final bool selectable;
  final Restaurant restaurant;
  final String searchedText;
  final bool selected;
  final Function onTap;
  final bool dontShowBar;
  SingleRestaurant({
    Key key,
    @required this.restaurantID,
    @required this.restaurant,
    this.simple = false,
    this.list,
    @required this.selectable,
    @required this.searchedText,
    @required this.selected,
    @required this.onTap,
    this.dontShowBar,
    this.fullWidth,
  }) : super(key: key);

  @override
  State<SingleRestaurant> createState() => _SingleRestaurantState();
}

class _SingleRestaurantState extends State<SingleRestaurant> {
  @override
  Widget build(BuildContext context) {
    DateTime pp = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    StorageServices().increaseAnalytics(
      widget.restaurantID,
      pp.millisecondsSinceEpoch.toString(),
      ThingType.RESTAURANT,
      Analytics.COUNT,
    );

    return widget.restaurant != null
        ? body(
            widget.restaurant,
          )
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(Restaurant.DIRECTORY)
                .doc(widget.restaurantID)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LoadingWidget();
              } else {
                if (snapshot.data == null) {
                  return DeletedItem(
                    thingID: widget.restaurantID,
                    what: "Restaurant",
                  );
                }
                Restaurant store = Restaurant.fromSnapshot(
                  snapshot.data,
                );

                return body(
                  store,
                );
              }
            },
          );
  }

  body(Restaurant restaurant) {
    return Container(
      margin: EdgeInsets.all(6),
      child: GestureDetector(
        onTap: () {
          if (widget.selectable) {
            widget.onTap();
          } else {
            if (widget.onTap != null) {
              widget.onTap();
            } else {
              context.pushNamed(
                RouteConstants.restaurant,
                extra: restaurant,
                params: {
                  "id": restaurant.id,
                },
              );
            }
          }
        },
        child: Stack(
          children: [
            Container(
              width: widget.fullWidth != null && widget.fullWidth
                  ? double.infinity
                  : widget.list != null && widget.list
                      ? MediaQuery.of(context).size.width * 0.9
                      : MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: standardBorderRadius,
                border: Border.all(
                  width: 1,
                ),
              ),
              padding: EdgeInsets.all(3),
              child: Column(
                children: [
                  mainContent(
                    restaurant,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            if (widget.selectable && widget.selected)
              Positioned(
                right: 5,
                top: 5,
                child: SelectorThingie(),
              )
          ],
        ),
      ),
    );
  }

  mainContent(Restaurant restaurant) {
    return Material(
      elevation: standardElevation,
      borderRadius: standardBorderRadius,
      child: ClipRRect(
        borderRadius: standardBorderRadius,
        child: Container(
            height: widget.simple ? 60 : 200,
            decoration: BoxDecoration(
              borderRadius: standardBorderRadius,
            ),
            child: paddedBody(
              restaurant,
            )),
      ),
    );
  }

  paddedBody(
    Restaurant restaurant,
  ) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: UIServices()
                    .getImageProvider(restaurant.displayPic ?? defaultUserPic),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!widget.simple)
                      SizedBox(
                        height: 5,
                      ),
                    Text(
                      restaurant.name,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!widget.simple)
                      SizedBox(
                        height: 5,
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          if (!widget.simple)
            Expanded(
              child: ClipRRect(
                borderRadius: standardBorderRadius,
                child: Stack(
                  children: [
                    SingleImage(
                      image: restaurant.wallPaper ?? foodPic,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
