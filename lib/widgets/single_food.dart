import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorx/constants/constants.dart';
import 'package:dorx/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dorx/models/food.dart';
import 'package:dorx/models/thing_type.dart';
import 'package:dorx/widgets/loading_widget.dart';
import 'package:dorx/widgets/deleted_item.dart';
import 'package:dorx/widgets/favorite_button.dart';
import 'package:dorx/widgets/selector.dart';

class SingleFood extends StatefulWidget {
  final FoodModel food;
  final dynamic subtotal;
  final bool selectable;
  final String foodID;
  final dynamic price;
  final bool horizontal;
  final bool selected;
  final Function onTap;
  final bool list;
  SingleFood({
    Key key,
    @required this.food,
    @required this.selectable,
    @required this.list,
    @required this.foodID,
    this.subtotal,
    this.price,
    @required this.selected,
    @required this.onTap,
    this.horizontal,
  }) : super(key: key);

  @override
  State<SingleFood> createState() => _SingleFoodState();
}

class _SingleFoodState extends State<SingleFood> {
  @override
  Widget build(BuildContext context) {
    return widget.foodID != null
        ? StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(FoodModel.DIRECTORY)
                .doc(widget.foodID)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.data() == null) {
                  return DeletedItem(
                    what: "Food",
                    thingID: widget.foodID,
                  );
                } else {
                  FoodModel model = FoodModel.fromSnapshot(
                    snapshot.data,
                  );

                  return body(model);
                }
              } else {
                return LoadingWidget();
              }
            })
        : body(
            widget.food,
          );
  }

  body(
    FoodModel food,
  ) {
    return Container(
      margin: EdgeInsets.all(4),
      child: Material(
        elevation: 8,
        borderRadius: standardBorderRadius,
        child: GestureDetector(
          onTap: () {
            if (widget.selectable) {
              widget.onTap();
            } else {
              if (widget.onTap != null) {
                widget.onTap();
              } else {
                context.pushNamed(
                  RouteConstants.food,
                  extra: food,
                  params: {
                    "id": food.id,
                  },
                );
              }
            }
          },
          child: ClipRRect(
            borderRadius: standardBorderRadius,
            child: Container(
              width: widget.horizontal != null && widget.horizontal
                  ? kIsWeb
                      ? 300
                      : MediaQuery.of(context).size.width * 0.7
                  : null,
              height: MediaQuery.of(context).size.height * 0.18,
              decoration: BoxDecoration(
                image: UIServices().decorationImage(
                  food.images.isNotEmpty ? food.images[0] : foodPic,
                  true,
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (food.name != null)
                                Text(
                                  food.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              if (widget.price != null ||
                                  (food.price != 0 && food.variations.isEmpty))
                                Text(
                                  widget.price == null
                                      ? "${TextService().putCommas(
                                          food.price.toString(),
                                        )} UGX"
                                      : "${TextService().putCommas(
                                          widget.price.toString(),
                                        )} UGX",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              if (widget.subtotal != null)
                                Text(
                                  "Sub: ${TextService().putCommas(
                                    widget.subtotal.toString(),
                                  )} UGX",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white60,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      top: 2,
                      right: 2,
                      child: Column(
                        children: [
                          FavoriteButton(
                            thingID: food.id,
                            thingType: ThingType.FOOD,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                        ],
                      )),
                  if (widget.selected != null && widget.selected)
                    Positioned(
                      left: 5,
                      child: SelectorThingie(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
