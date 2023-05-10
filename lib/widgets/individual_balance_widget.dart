import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorx/constants/constants.dart';
import 'package:dorx/models/models.dart';
import 'package:dorx/widgets/loading_widget.dart';
import 'package:dorx/widgets/single_previous_item.dart';
import 'package:flutter/material.dart';

import '../services/services.dart';

class IndividualBalanceWidget extends StatefulWidget {
  final EntityBalanceModel balance;
  final String customer;
  final String entity;

  const IndividualBalanceWidget({
    Key key,
    @required this.balance,
    @required this.customer,
    @required this.entity,
  }) : super(key: key);

  @override
  State<IndividualBalanceWidget> createState() =>
      _IndividualBalanceWidgetState();
}

class _IndividualBalanceWidgetState extends State<IndividualBalanceWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.balance == null
          ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(Payment.ACCOUNTBALANCEDIRECTORY)
                  .where(Payment.ENTITY, isEqualTo: widget.entity)
                  .where(ThingType.USER, isEqualTo: widget.customer)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return LoadingWidget();
                } else {
                  List pp = [];
                  snapshot.data.docs.forEach((v) {
                    pp.add(v);
                  });

                  return Column(
                    children: pp.map<Widget>((e) {
                      EntityBalanceModel entityBalanceModel =
                          EntityBalanceModel.fromSnapshot(e);

                      return body(
                        entityBalanceModel.balance,
                        entityBalanceModel.entity,
                        entityBalanceModel.entityType,
                      );
                    }).toList(),
                  );
                }
              })
          : body(
              widget.balance.balance,
              widget.balance.entity,
              widget.balance.entityType,
            ),
    );
  }

  body(
    dynamic balance,
    String entity,
    String entityType,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 5,
      ),
      child: Material(
        elevation: standardElevation,
        color: balance < 0
            ? (Colors.red).withOpacity(0.5)
            : Theme.of(context).canvasColor,
        borderRadius: standardBorderRadius,
        child: Column(
          children: [
            Spacer(),
            Text(
              "Balance: ${TextService().putCommas(balance.toString())} UGX",
              style: balance < 0
                  ? TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )
                  : titleStyle,
            ),
            Spacer(),
            SinglePreviousItem(
              sized: true,
              usableThingID: entity,
              simple: true,
              type: entityType,
            ),
          ],
        ),
      ),
    );
  }
}
