import 'package:dorx/models/models.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/services.dart';
import '../constants/ui.dart';
import '../widgets/widgets.dart';

class FoodDetails extends StatefulWidget {
  final FoodModel food;
  final String foodID;
  FoodDetails({
    Key key,
    @required this.food,
    @required this.foodID,
  }) : super(key: key);

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  var top = 0.0;
  int count = 1;

  @override
  Widget build(BuildContext context) {
    return widget.food == null ||
            (AuthProvider.of(context).auth.isSignedIn() &&
                AuthProvider.of(context).auth.getCurrentUID() ==
                    widget.food.owner)
        ? StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(FoodModel.DIRECTORY)
                .doc(widget.foodID)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LoadingWidget();
              } else {
                if (snapshot == null ||
                    snapshot.data == null ||
                    snapshot.data.data() == null) {
                  return Scaffold(
                    body: Center(
                      child: DeletedItem(
                        what: translation(context).food,
                        thingID: widget.foodID,
                      ),
                    ),
                  );
                } else {
                  FoodModel food = FoodModel.fromSnapshot(
                    snapshot.data,
                  );

                  return body(food);
                }
              }
            })
        : body(widget.food);
  }

  body(FoodModel foodModel) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: () {
                  context.pushNamed(
                    RouteConstants.image,
                    extra: foodModel.images,
                  );
                },
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Hero(
                    tag: foodModel.id,
                    child:  Carousel(
                      images: foodModel.images
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
              ),
            ),
            pinned: true,
            floating: true,
            snap: false,
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleNeumorphicButton(
                onTap: () {
                  if (context.canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    context.pushReplacementNamed(
                      RouteConstants.home,
                    );
                  }
                },
                radius: 30,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
            actions: [],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: standardBorderRadius,
                              ),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (foodModel.name != null)
                                      Text(
                                        foodModel.name.capitalizeFirstOfEach,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      foodModel.description,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FavoriteButton(
                            thingID: foodModel.id,
                            thingType: ThingType.FOOD,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDivider(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        translation(context).youMayAlsoLikeThese,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(
                    height: 150,
                    child: PaginateFirestore(
                      itemBuilder: (
                        context,
                        snapshot,
                        index,
                      ) {
                        FoodModel mod = FoodModel.fromSnapshot(
                          snapshot[index],
                        );

                        return SingleFood(
                          food: mod,
                          foodID: mod.id,
                          horizontal: true,
                          selectable: false,
                          list: true,
                          selected: false,
                          onTap: null,
                        );
                      },
                      query: FirebaseFirestore.instance
                          .collection(FoodModel.DIRECTORY)
                          .where(FoodModel.CATEGORY,
                              isEqualTo: foodModel.category),
                      onEmpty: InformationalBox(
                        onClose: null,
                        visible: true,
                        message: translation(context).ohCwap,
                      ),
                      initialLoader: LoadingWidget(),
                      scrollDirection: Axis.horizontal,
                      itemBuilderType: PaginateBuilderType.listView,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    translation(context).moreFromThisRestaurant,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: PaginateFirestore(
                      itemBuilder: (
                        context,
                        snapshot,
                        index,
                      ) {
                        FoodModel mod = FoodModel.fromSnapshot(
                          snapshot[index],
                        );

                        return SingleFood(
                          food: mod,
                          foodID: mod.id,
                          horizontal: true,
                          selectable: false,
                          list: true,
                          selected: false,
                          onTap: null,
                        );
                      },
                      query: FirebaseFirestore.instance
                          .collection(FoodModel.DIRECTORY)
                          .where(
                            FoodModel.RESTAURANT,
                            isEqualTo: foodModel.restaurant,
                          ),
                      onEmpty: InformationalBox(
                        onClose: null,
                        visible: true,
                        message: translation(context).ohCwap,
                      ),
                      initialLoader: LoadingWidget(),
                      scrollDirection: Axis.horizontal,
                      itemBuilderType: PaginateBuilderType.listView,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomDivider(),
                  ListTile(
                    title: Text(
                      translation(context).ifYouNeedHelp,
                    ),
                    onTap: () {
                      context.pushNamed(
                        RouteConstants.aboutUs,
                      );
                    },
                  ),
                  CustomDivider()
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: StatefulBuilder(
        builder: (context, setIt) {
          return Container(
            color: Colors.blue.withOpacity(0.5),
            width: MediaQuery.of(context).size.width,
            height: 50,
            padding: EdgeInsets.only(
              top: 4,
              bottom: 4,
              left: 8,
              right: 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "${TextService().putCommas(foodModel.price.toString())} UGX",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
