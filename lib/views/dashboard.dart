import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorx/models/models.dart';
import 'package:dorx/services/services.dart';
import 'package:dorx/views/home_screen.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../widgets/widgets.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  List<Widget> pages;
  int _currentPage = 0;
  bool processing = false;
  PageController _controller;
  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    return UIServices().showDatSheet(
      ExitAppBottomSheet(),
      true,
      context,
      height: MediaQuery.of(context).size.height * 0.7,
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: _currentPage,
    );

    pages = [
      HomeScreen(),
      Container(),
    ];

    PushNotificationService().registerNotification(context);
    PushNotificationService().checkForInitialMessage(context);
    PushNotificationService().onMessageAppListen(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              onPageChanged: (v) {
                setState(() {
                  _currentPage = v;
                });
              },
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              children: pages,
            ),
            Positioned(
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          if (AuthProvider.of(context).auth.isSignedIn()) {
                            setState(() {
                              processing = true;
                            });

                            FirebaseFirestore.instance
                                .collection(UserModel.DIRECTORY)
                                .doc(AuthProvider.of(context)
                                    .auth
                                    .getCurrentUID())
                                .get()
                                .then((value) {
                              UserModel userModel =
                                  UserModel.fromSnapshot(value);

                              setState(() {
                                processing = false;
                              });

                              if (userModel.affiliation.isEmpty) {
                                StorageServices().launchTheThing(
                                  "tel:$dorxPhoneNumber",
                                );
                              } else {
                                UIServices().showDatSheet(
                                  CallUsOptionsBottomSheet(
                                    affiliations: userModel.affiliation,
                                  ),
                                  true,
                                  context,
                                );
                              }
                            });
                          } else {
                            StorageServices().launchTheThing(
                              "tel:$dorxPhoneNumber",
                            );
                          }
                        },
                        child: processing
                            ? LoadingWidget(
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.phone,
                              ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  NavBottomBar(
                    bottomRadius: 50,
                    bottomBarHeight: 60,
                    showBigButton: false,
                    backgroundColor: primaryColor,
                    bigIcon: Icons.add,
                    currentIndex: _currentPage,
                    buttonPosition: ButtonPosition.end,
                    children: [
                      NavIcon(
                        icon: Icons.home,
                        onTap: () {
                          selectTab(0);
                        },
                      ),
                      NavIcon(
                        icon: Icons.menu,
                        onTap: () {
                          selectTab(1);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  selectTab(int index) async {
    if (index == 1) {
      UIServices().showDatSheet(
        MenuBottomSheet(),
        true,
        context,
      );
    } else {
      _controller.jumpToPage(index);
    }
  }
}

class CallUsOptionsBottomSheet extends StatefulWidget {
  final List affiliations;
  const CallUsOptionsBottomSheet({
    Key key,
    @required this.affiliations,
  }) : super(key: key);

  @override
  State<CallUsOptionsBottomSheet> createState() =>
      _CallUsOptionsBottomSheetState();
}

class _CallUsOptionsBottomSheetState extends State<CallUsOptionsBottomSheet> {
  Map<String, bool> processings = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BackBar(
          icon: null,
          onPressed: null,
          text: "Who do you want to call?",
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: widget.affiliations
                  .map<Widget>(
                (e) => processings[e] == true
                    ? Column(
                        children: [
                          SingleSelectTile(
                            onTap: null,
                            processing: true,
                            text: "Loading",
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      )
                    : SingleRestaurant(
                        restaurantID: e,
                        restaurant: null,
                        selectable: false,
                        searchedText: "]",
                        selected: false,
                        onTap: () {
                          launchIt(
                            e,
                            false,
                          );
                        },
                      ),
              )
                  .followedBy([
                SizedBox(
                  height: 10,
                ),
                SingleSelectTile(
                  onTap: () {
                    launchIt(
                      null,
                      true,
                    );
                  },
                  text: "Call the Dorx Team",
                ),
                SizedBox(
                  height: 10,
                ),
              ]).toList(),
            ),
          ),
        )
      ],
    );
  }

  launchIt(
    String id,
    bool us,
  ) {
    if (us) {
      StorageServices().launchTheThing("tel:$dorxPhoneNumber");
    } else {
      setState(() {
        processings.addAll({
          id: true,
        });
      });

      FirebaseFirestore.instance
          .collection(Restaurant.DIRECTORY)
          .doc(id)
          .get()
          .then((value) {
        setState(() {
          processings.addAll({
            id: false,
          });
        });

        if (value.exists) {
          Restaurant restaurant = Restaurant.fromSnapshot(value);

          if (restaurant.phoneNumber != null &&
              restaurant.phoneNumber.trim().isNotEmpty) {
            StorageServices().launchTheThing(
              "tel:${restaurant.phoneNumber}",
            );
          } else {
            StorageServices().launchTheThing(
              "tel:$dorxPhoneNumber",
            );
          }
        } else {
          StorageServices().launchTheThing(
            "tel:$dorxPhoneNumber",
          );
        }
      });
    }
  }
}
