import 'package:animate_do/animate_do.dart';
import 'package:dorx/models/models.dart';
import 'package:dorx/views/no_data_found_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dorx/widgets/widgets.dart';

class PaymentHistoryView extends StatefulWidget {
  final String viewerID;
  const PaymentHistoryView({
    Key key,
    @required this.viewerID,
  }) : super(key: key);

  @override
  State<PaymentHistoryView> createState() => _PaymentHistoryViewState();
}

class _PaymentHistoryViewState extends State<PaymentHistoryView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FadeInDown(
      duration: Duration(milliseconds: 500),
      child: PaginateFirestore(
        isLive: true,
        onEmpty: NoDataFound(
          text: translation(context).noDataFound,
        ),
        itemBuilderType: PaginateBuilderType.listView,
        query: FirebaseFirestore.instance
            .collection(Payment.DIRECTORY)
            .where(
              Payment.PARTICIPANTS,
              arrayContains: widget.viewerID,
            )
            .orderBy(Payment.TIME, descending: true),
        itemsPerPage: 3,
        itemBuilder: (
          context,
          snapshot,
          index,
        ) {
          Payment payment = Payment.fromSnapshot(
            snapshot[index],
            widget.viewerID,
          );

          return SinglePayment(
            payment: payment,
            paymentID: payment.id,
            paymentViewerID: widget.viewerID,
          );
        },
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 5,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
