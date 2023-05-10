import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorx/views/views.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  TabController tabController;
  ScrollController _controller = ScrollController();
  List modes = [
    "orders",
    "payments",
  ];

  @override
  void initState() {
    tabController = TabController(
      vsync: this,
      length: modes.length,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return OnlyWhenLoggedIn(
      signedInBuilder: (uid) {
        return NestedScrollView(
          headerSliverBuilder: (gh, hg) {
            return [
              CustomSliverAppBar(
                backEnabled: false,
                noLeading: true,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AuthProvider.of(context).auth.getCurrentUser() ==
                                        null ||
                                    AuthProvider.of(context)
                                            .auth
                                            .getCurrentUser()
                                            .displayName ==
                                        null
                                ? "${translation(context).hi} 😃"
                                : "${translation(context).hi} ${AuthProvider.of(context).auth.getCurrentUser().displayName} 😃",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          StatisticText(
                              title: translation(context).yourWalletBalances),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: Stack(
                        children: [
                          PaginateFirestore(
                            isLive: true,
                            scrollController: _controller,
                            scrollDirection: Axis.horizontal,
                            onEmpty: NoDataFound(
                              text: translation(context).noWalletsYet,
                            ),
                            itemBuilderType: PaginateBuilderType.listView,
                            query: FirebaseFirestore.instance
                                .collection(Payment.ACCOUNTBALANCEDIRECTORY)
                                .where(
                                  Payment.PARTICIPANTS,
                                  arrayContains: uid,
                                )
                                .orderBy(Payment.TIME, descending: true),
                            itemBuilder: (
                              context,
                              snapshot,
                              index,
                            ) {
                              EntityBalanceModel payment =
                                  EntityBalanceModel.fromSnapshot(
                                snapshot[index],
                              );

                              return SizedBox(
                                width: 270,
                                child: IndividualBalanceWidget(
                                  balance: payment,
                                  customer: payment.customer,
                                  entity: payment.entity,
                                ),
                              );
                            },
                            padding: EdgeInsets.only(
                              left: 50,
                              right: 50,
                              top: 5,
                            ),
                          ),
                          Positioned(
                            left: 5,
                            top: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () {
                                _controller?.animateTo(
                                  _controller.offset -
                                      (MediaQuery.of(context).size.width * 0.5),
                                  duration: Duration(
                                    milliseconds: 500,
                                  ),
                                  curve: Curves.easeIn,
                                );
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.arrow_left,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 5,
                            top: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () {
                                _controller?.animateTo(
                                  _controller.offset +
                                      (MediaQuery.of(context).size.width * 0.5),
                                  duration: Duration(
                                    milliseconds: 500,
                                  ),
                                  curve: Curves.easeIn,
                                );
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.arrow_right,
                                  size: 30,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: MySliverAppBarDelegate(TabBar(
                  isScrollable: true,
                  controller: tabController,
                  labelColor: getTabColor(context, true),
                  unselectedLabelColor: getTabColor(context, false),
                  tabs: modes
                      .map(
                        (e) => Tab(
                          text: e.toString().toUpperCase(),
                        ),
                      )
                      .toList(),
                )),
              )
            ];
          },
          body: TabBarView(
            controller: tabController,
            children: [
              TransactionHistoryView(
                uid: uid,
              ),
              PaymentHistoryView(
                viewerID: uid,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
