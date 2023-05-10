import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorx/services/services.dart';
import 'package:flutter/material.dart';
import 'package:dorx/models/models.dart';
import 'package:dorx/constants/constants.dart';
import 'package:dorx/widgets/widgets.dart';

class DetailedMenuView extends StatefulWidget {
  final String menuID;
  final Menu menu;
  DetailedMenuView({
    Key key,
    @required this.menuID,
    @required this.menu,
  }) : super(key: key);

  @override
  State<DetailedMenuView> createState() => _DetailedMenuViewState();
}

class _DetailedMenuViewState extends State<DetailedMenuView> {
  Gradient menuGradient;

  @override
  Widget build(BuildContext context) {
    return widget.menu != null
        ? body(widget.menu)
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(Menu.DIRECTORY)
                .doc(widget.menuID)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Scaffold(
                  body: LoadingWidget(),
                );
              } else {
                Menu menu = Menu.fromSnapshot(snapshot.data);

                return body(menu);
              }
            },
          );
  }

  body(Menu menu) {
    if (menu.color != null) {
      availableGradients.forEach((key, value) {
        if (key.toLowerCase() == menu.color.toLowerCase()) {
          menuGradient = value;
        }
      });

      menuGradient ??= listColors[0];
    }

    Color menuTextColor = menuGradient != null
        ? Colors.white
        : menu.name.trim().isEmpty
            ? Colors.red
            : null;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: menuGradient == null
                ? null
                : BoxDecoration(
                    gradient: menuGradient,
                  ),
          ),
          if (menuGradient != null)
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(
                0.4,
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BackBar(
                      icon: null,
                      onPressed: null,
                      text: menu.name,
                    ),
                    if (widget.menu.images.isNotEmpty)
                      SizedBox(
                        height: 20,
                      ),
                    if (widget.menu.images.isNotEmpty)
                      SizedBox(
                        height: menu.food.isEmpty
                            ? MediaQuery.of(context).size.height * 0.8
                            : MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: standardBorderRadius,
                          child: Carousel(
                            images: widget.menu.images
                                .map(
                                  (e) => SingleImage(
                                    image: e,
                                    width: double.infinity,
                                  ),
                                )
                                .toList(),
                            showIndicator: true,
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (menu.description != null)
                      Text(
                        menu.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: menuTextColor,
                        ),
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: menu.food
                          .asMap()
                          .entries
                          .map<Widget>(
                            (e) => singleFoodCategory(
                              e.value,
                              menu.theme,
                              e.key + 1,
                              menuTextColor,
                            ),
                          )
                          .toList(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  singleFoodCategory(
    MenuCategory category,
    String style,
    int index,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            style == COMPACT ? category.name : "$index ${category.name}.",
            style: TextStyle(
              fontSize: 16,
              color: color,
            ),
          ),
          Divider(),
          Column(
            children: category.food
                .map(
                  (e) => style == GLAMOROUS
                      ? SingleFood(
                          food: null,
                          selectable: false,
                          list: true,
                          selected: false,
                          foodID: e,
                          onTap: null,
                        )
                      : style == COMPACT
                          ? StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection(FoodModel.DIRECTORY)
                                  .doc(e)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return LoadingWidget();
                                } else {
                                  FoodModel foodModel = FoodModel.fromSnapshot(
                                    snapshot.data,
                                  );

                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            context.pushNamed(
                                              RouteConstants.food,
                                              extra: foodModel,
                                              params: {
                                                "id": e,
                                              },
                                            );
                                          },
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                UIServices().getImageProvider(
                                              foodModel.images.isEmpty
                                                  ? foodPic
                                                  : foodModel.images[0],
                                            ),
                                          ),
                                          title: Text(
                                            foodModel.name == null ||
                                                    foodModel.name
                                                        .trim()
                                                        .isEmpty
                                                ? translation(context).food
                                                : foodModel.name,
                                            style: TextStyle(
                                              color: color,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: (foodModel.description !=
                                                          null &&
                                                      foodModel.description
                                                          .toString()
                                                          .trim()
                                                          .isNotEmpty) ||
                                                  foodModel.variations.isEmpty
                                              ? Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        foodModel.description,
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                          color: color,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "${TextService().putCommas(
                                                        foodModel.price
                                                            .toString(),
                                                      )}UGX",
                                                      style: TextStyle(
                                                        color: color,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : null,
                                        ),
                                        Container(
                                          height: 0.5,
                                          color: color,
                                          width: double.infinity,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              })
                          : SingleFood(
                              food: null,
                              selectable: false,
                              list: true,
                              selected: false,
                              foodID: e,
                              onTap: null,
                            ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
