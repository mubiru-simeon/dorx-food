import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

class OrderDetails extends StatefulWidget {
  final DorxOrder order;
  final String orderID;
  OrderDetails({
    Key key,
    @required this.order,
    @required this.orderID,
  }) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  String spID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.order == null
          ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(DorxOrder.DIRECTORY)
                  .doc(widget.orderID)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return LoadingWidget();
                } else {
                  if (snapshot.data == null) {
                    return DeletedItem(
                      what: translation(context).order,
                      thingID: widget.orderID,
                    );
                  } else {
                    DorxOrder order = DorxOrder.fromSnapshot(snapshot.data);

                    return body(order);
                  }
                }
              })
          : body(widget.order),
    );
  }

  body(DorxOrder order) {
    return SafeArea(
      child: Column(
        children: [
          BackBar(
            icon: null,
            onPressed: null,
            text: translation(context).orders,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatisticText(
                      title: "${translation(context).order} ID",
                    ),
                    CopiableIDThing(
                      id: order.id,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    StatisticText(
                      title: translation(context).date,
                    ),
                    Text(
                      DateService().dateFromMilliseconds(
                        order.date,
                      ),
                      style: greyTitle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    StatisticText(
                      title: order.customers.isEmpty
                          ? translation(context).customer
                          : translation(context).customers,
                    ),
                    order.customers.isNotEmpty
                        ? Column(
                            children: order.customers
                                .map(
                                  (e) => Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: standardBorderRadius,
                                    ),
                                    child: Column(
                                      children: [
                                        SingleUser(
                                          user: null,
                                          onTap: () {},
                                          userID: e,
                                        ),
                                        if (order.customers.length != 1)
                                          Text(
                                            "${translation(context).subTotal}: ${TextService().putCommas(
                                              order.customerAmounts[e]
                                                  .toString(),
                                            )} UGX",
                                            style: titleStyle,
                                          ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${translation(context).firstName}: ${order.customerMap[UserModel.USERNAME]}",
                                style: greyTitle,
                              ),
                              if (order.customerMap[UserModel.PHONENUMBER] !=
                                  null)
                                Text(
                                  "${translation(context).phoneNumber}: ${order.customerMap[UserModel.PHONENUMBER]}",
                                  style: greyTitle,
                                ),
                              if (order.customerMap[UserModel.EMAIL] != null)
                                Text(
                                  "${translation(context).email}: ${order.customerMap[UserModel.EMAIL]}",
                                  style: greyTitle,
                                ),
                            ],
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    StatisticText(
                      title: translation(context).food,
                    ),
                    Column(
                      children: order.food.map<Widget>((e) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: standardBorderRadius,
                            border: Border.all(),
                          ),
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SingleFood(
                                      food: e[DorxOrder.MODEL],
                                      selectable: false,
                                      list: true,
                                      foodID: e[DorxOrder.PRODUCTS],
                                      selected: false,
                                      onTap: null,
                                    ),
                                    if (e[DorxOrder.PRICE] != null)
                                      Text(
                                        "${translation(context).pricePerPlate}: ${e[DorxOrder.PRICE]} UGX",
                                        style: titleStyle,
                                      ),
                                    if (e[DorxOrder.QUANTITY] != null &&
                                        e[DorxOrder.PRICE] != null)
                                      Text(
                                        "${translation(context).subTotal}: ${TextService().putCommas(((e[DorxOrder.PRICE] ?? 0) * e[DorxOrder.QUANTITY]).toString())} UGX",
                                        style: titleStyle,
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: standardBorderRadius),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            TextService().putCommas(
                                              e[DorxOrder.QUANTITY].toString(),
                                            ),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            translation(context).servings,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 20,
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
}
