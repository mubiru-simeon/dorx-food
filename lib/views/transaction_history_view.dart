import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorx/models/models.dart';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class TransactionHistoryView extends StatefulWidget {
  final String uid;
  const TransactionHistoryView({
    Key key,
    @required this.uid,
  }) : super(key: key);

  @override
  State<TransactionHistoryView> createState() => _TransactionHistoryViewState();
}

class _TransactionHistoryViewState extends State<TransactionHistoryView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return PaginateFirestore(
      itemBuilderType: PaginateBuilderType.listView,
      itemBuilder: (context, snapshot, index) {
        DorxOrder daOrder = DorxOrder.fromSnapshot(snapshot[index]);

        return SingleOrder(order: daOrder);
      },
      query: FirebaseFirestore.instance
          .collection(DorxOrder.DIRECTORY)
          .where(
            DorxOrder.CUSTOMERS,
            arrayContains: widget.uid,
          )
          .orderBy(
            DorxOrder.DATE,
            descending: true,
          ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
