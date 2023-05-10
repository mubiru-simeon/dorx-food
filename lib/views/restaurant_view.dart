import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorx/constants/basic.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../constants/images.dart';
import '../constants/ui.dart';
import '../widgets/widgets.dart';

class RestaurantView extends StatefulWidget {
  final String restaurantID;
  final Restaurant restaurant;
  RestaurantView({
    Key key,
    @required this.restaurant,
    @required this.restaurantID,
  }) : super(key: key);

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView>
    with TickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: tabs.length,
      vsync: this,
    );
  }

  List<String> tabs = [
    "food",
    "about",
  ];

  @override
  Widget build(BuildContext context) {
    return widget.restaurant == null ||
            (AuthProvider.of(context).auth.isSignedIn() &&
                (widget.restaurant.owner ==
                    AuthProvider.of(context).auth.getCurrentUID()))
        ? StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(Restaurant.DIRECTORY)
                .doc(widget.restaurantID)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LoadingWidget();
              } else {
                Restaurant restaurant = Restaurant.fromSnapshot(
                  snapshot.data,
                );

                return body(restaurant);
              }
            })
        : body(widget.restaurant);
  }

  body(Restaurant restaurant) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (fg, gh) {
          return [
            SliverAppBar(
              pinned: true,
              floating: true,
              snap: false,
              leading: GestureDetector(
                onTap: () {
                  if (context.canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    context.pushReplacementNamed(
                      RouteConstants.home,
                    );
                  }
                },
                child: Icon(
                  Icons.arrow_back_ios,
                ),
              ),
              expandedHeight: 150,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  restaurant.name,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                background: SingleImage(
                  image: restaurant.wallPaper ?? foodPic,
                  darken: true,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(
                    height: 170,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            translation(context).menus,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Expanded(
                            child: PaginateFirestore(
                          scrollDirection: Axis.horizontal,
                          itemBuilderType: PaginateBuilderType.listView,
                          query: FirebaseFirestore.instance
                              .collection(Menu.DIRECTORY)
                              .where(
                                Menu.RESTAURANT,
                                isEqualTo: widget.restaurantID,
                              )
                              .orderBy(
                                Menu.DATEADDED,
                                descending: true,
                              ),
                          isLive: true,
                          itemBuilder: (context, snapshot, index) {
                            Menu menu = Menu.fromSnapshot(snapshot[index]);
                            return SingleMenu(
                              menu: menu,
                              horizontal: true,
                              menuID: menu.id,
                            );
                          },
                        ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: MySliverAppBarDelegate(
                TabBar(
                  isScrollable: true,
                  controller: tabController,
                  labelColor: getTabColor(context, true),
                  labelPadding: EdgeInsets.symmetric(horizontal: 20),
                  unselectedLabelColor: getTabColor(context, false),
                  tabs: tabs
                      .map((e) => Tab(
                            text: e.toUpperCase(),
                          ))
                      .toList(),
                ),
              ),
            )
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: [
            RestaurantFood(
              restaurantID: restaurant.id,
            ),
            RestaurantHome(
              restaurant: restaurant,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          UIServices().showDatSheet(
            OnlyTextBottomSheet(
              category: UserFeedback.FEATURE,
              entity: true,
              entityID: widget.restaurantID,
            ),
            true,
            context,
          );
        },
        label: Text("Submit some feedback"),
        icon: Icon(
          Icons.inbox,
        ),
      ),
    );
  }
}

class RestaurantHome extends StatefulWidget {
  final Restaurant restaurant;
  RestaurantHome({
    Key key,
    @required this.restaurant,
  }) : super(key: key);

  @override
  State<RestaurantHome> createState() => _RestaurantHomeState();
}

class _RestaurantHomeState extends State<RestaurantHome>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.restaurant.images.isNotEmpty)
              Stack(
                children: [
                  AutoScrollShowcaser(
                    images: widget.restaurant.images,
                    placeholderText: capitalizedAppName,
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        context.pushNamed(
                          RouteConstants.image,
                          extra: widget.restaurant.images,
                        );
                      },
                      child: Text(translation(context).seeAll),
                    ),
                  )
                ],
              ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          ClipOval(
                            child: widget.restaurant.displayPic == null
                                ? Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage(defaultUserPic))
                                : SingleImage(
                                    height:
                                        MediaQuery.of(context).size.width * 0.2,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    image: widget.restaurant.displayPic,
                                  ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.restaurant.name != null)
                        Text(
                          widget.restaurant.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialogBox(
                                  showSignInButton: false,
                                  bodyText: widget.restaurant.description,
                                  buttonText: null,
                                  onButtonTap: null,
                                  showOtherButton: false,
                                );
                              });
                        },
                        child: Text(
                          widget.restaurant.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            if (widget.restaurant.phoneNumber != null &&
                widget.restaurant.phoneNumber.trim().isNotEmpty)
              GestureDetector(
                onTap: () {
                  StorageServices().launchTheThing(
                    "tel:${widget.restaurant.phoneNumber}",
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.phone),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        widget.restaurant.phoneNumber,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.restaurant.phoneNumber != null &&
                widget.restaurant.phoneNumber.trim().isNotEmpty)
              SizedBox(
                height: 5,
              ),
            if (widget.restaurant.facebookLink != null &&
                widget.restaurant.facebookLink.trim().isNotEmpty)
              GestureDetector(
                onTap: () {
                  _openUrl(widget.restaurant.facebookLink);
                },
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.facebook),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      " ${widget.restaurant.facebookLink}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.restaurant.facebookLink != null &&
                widget.restaurant.facebookLink.trim().isNotEmpty)
              SizedBox(
                height: 5,
              ),
            if (widget.restaurant.twitterLink != null &&
                widget.restaurant.twitterLink.trim().isNotEmpty)
              GestureDetector(
                onTap: () {
                  _openUrl(widget.restaurant.twitterLink);
                },
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.twitter,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      " ${widget.restaurant.twitterLink}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.restaurant.twitterLink != null &&
                widget.restaurant.twitterLink.trim().isNotEmpty)
              SizedBox(
                height: 5,
              ),
            if (widget.restaurant.instagramLink != null &&
                widget.restaurant.instagramLink.trim().isNotEmpty)
              GestureDetector(
                onTap: () {
                  _openUrl(widget.restaurant.instagramLink);
                },
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.instagram,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      " ${widget.restaurant.instagramLink}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.restaurant.instagramLink != null &&
                widget.restaurant.instagramLink.trim().isNotEmpty)
              SizedBox(
                height: 5,
              ),
            if (widget.restaurant.email != null &&
                widget.restaurant.email.trim().isNotEmpty)
              SizedBox(
                height: 10,
              ),
            if (widget.restaurant.email != null &&
                widget.restaurant.email.trim().isNotEmpty)
              GestureDetector(
                onTap: () {
                  _openUrl(
                    "mailto:${widget.restaurant.email}?subject=Hi&body=Hello",
                  );
                },
                child: Text(
                  "Email: ${widget.restaurant.email}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (widget.restaurant.email != null &&
                widget.restaurant.email.trim().isNotEmpty)
              SizedBox(
                height: 5,
              ),
            if (widget.restaurant.lat != null)
              SizedBox(
                height: 20,
              ),
            if (widget.restaurant.lat != null)
              Text(
                translation(context).location,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            if (widget.restaurant.lat != null)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    LocationService().openInGoogleMaps(
                      widget.restaurant.lat,
                      widget.restaurant.long,
                    );
                  },
                  child: ClipRRect(
                    borderRadius: standardBorderRadius,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Image(
                              image: AssetImage(
                                mapPic,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Column(
                            children: [
                              Spacer(),
                              Expanded(
                                child: Container(
                                  color: primaryColor,
                                  child: Center(
                                    child: Text(
                                      widget.restaurant.address,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _openUrl(String url) {
    StorageServices().launchTheThing(url);
  }

  @override
  bool get wantKeepAlive => true;
}

class RestaurantFood extends StatefulWidget {
  final String restaurantID;
  RestaurantFood({
    Key key,
    @required this.restaurantID,
  }) : super(key: key);

  @override
  State<RestaurantFood> createState() => _RestaurantFoodState();
}

class _RestaurantFoodState extends State<RestaurantFood>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PaginateFirestore(
      isLive: true,
      itemsPerPage: 3,
      query: FirebaseFirestore.instance
          .collection(FoodModel.DIRECTORY)
          .where(FoodModel.RESTAURANT, isEqualTo: widget.restaurantID),
      itemBuilderType: PaginateBuilderType.listView,
      itemBuilder: (
        context,
        snapshot,
        index,
      ) {
        FoodModel food = FoodModel.fromSnapshot(
          snapshot[index],
        );

        return SingleFood(
          food: food,
          selectable: false,
          foodID: food.id,
          list: true,
          selected: false,
          onTap: null,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
