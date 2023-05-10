import 'package:dorx/services/ui_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/constants.dart';
import '../models/models.dart';
import '../services/communications.dart';
import '../services/date_service.dart';
import '../services/text_service.dart';
import 'widgets.dart';

class SinglePayment extends StatefulWidget {
  final Payment payment;
  final String paymentID;
  final bool simple;
  final String paymentViewerID;
  SinglePayment({
    Key key,
    @required this.payment,
    @required this.paymentID,
    this.simple = true,
    @required this.paymentViewerID,
  }) : super(key: key);

  @override
  State<SinglePayment> createState() => _SinglePaymentState();
}

class _SinglePaymentState extends State<SinglePayment> {
  @override
  Widget build(BuildContext context) {
    return widget.payment == null
        ? StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(Payment.DIRECTORY)
                .doc(widget.paymentID)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.data() == null) {
                  return DeletedItem(
                    what: "Payment",
                    thingID: widget.paymentID,
                  );
                } else {
                  Payment model = Payment.fromSnapshot(
                    snapshot.data,
                    widget.paymentViewerID,
                  );

                  return body(model);
                }
              } else {
                return LoadingWidget();
              }
            })
        : body(
            widget.payment,
          );
  }

  body(
    Payment payment,
  ) {
    return identityBuilder(payment);
  }

  identityBuilder(Payment payment) {
    return payment.partner == ThingType.ADMIN
        ? paymentBody(
            payment,
            recepient: payment.recepient,
            withdrawal: payment.withdrawal,
            image: dorxLogo,
            amount: payment.amount,
            date: payment.time,
            type: payment.thingType,
            senderName: payment.partner,
            recepientName: payment.partner,
            paymentID: payment.id,
            partnerName: capitalizedAppName,
            prePartnerWord:
                payment.sender == widget.paymentViewerID ? "To" : "From",
            paymentReason: payment.paymentReason,
          )
        : payment.partnerType == ThingType.USER
            ? StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(UserModel.DIRECTORY)
                    .doc(payment.partner)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserModel user = UserModel.fromSnapshot(
                      snapshot.data,
                    );

                    return paymentBody(
                      payment,
                      recepient: payment.recepient,
                      withdrawal: payment.withdrawal,
                      image: user.profilePic ?? defaultUserPic,
                      amount: payment.amount,
                      date: payment.time,
                      type: payment.thingType,
                      senderName: payment.partner,
                      recepientName: payment.partner,
                      paymentID: payment.id,
                      partnerName: user.userName,
                      prePartnerWord: payment.sender == widget.paymentViewerID
                          ? "To"
                          : "From",
                      paymentReason: payment.paymentReason,
                    );
                  } else {
                    return LoadingWidget();
                  }
                },
              )
            : payment.partnerType == ThingType.RESTAURANT
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection(Restaurant.DIRECTORY)
                        .doc(payment.partner)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Restaurant serviceProvider = Restaurant.fromSnapshot(
                          snapshot.data,
                        );

                        return paymentBody(
                          payment,
                          recepient: payment.recepient,
                          withdrawal: payment.withdrawal,
                          image: serviceProvider.displayPic ?? foodPic,
                          amount: payment.amount,
                          date: payment.time,
                          type: payment.thingType,
                          senderName: payment.partner,
                          recepientName: payment.partner,
                          paymentID: payment.id,
                          partnerName: serviceProvider.name,
                          prePartnerWord:
                              payment.sender == widget.paymentViewerID
                                  ? "To"
                                  : "From",
                          paymentReason: payment.paymentReason,
                        );
                      } else {
                        return LoadingWidget();
                      }
                    },
                  )
                : Text(
                    "recepient type is ${payment.partnerType}",
                  );
  }

  senderIdentityBuilder(Payment payment) {
    return payment.senderType == ThingType.ADMIN
        ? recepientIdentityBuilder(
            payment,
            capitalizedAppName,
          )
        : payment.senderType == ThingType.USER
            ? StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(UserModel.DIRECTORY)
                    .doc(payment.sender)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserModel user = UserModel.fromSnapshot(
                      snapshot.data,
                    );

                    return recepientIdentityBuilder(
                      payment,
                      user.userName,
                    );
                  } else {
                    return LoadingWidget();
                  }
                },
              )
            : payment.senderType == ThingType.RESTAURANT
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection(Restaurant.DIRECTORY)
                        .doc(payment.sender)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Restaurant user = Restaurant.fromSnapshot(
                          snapshot.data,
                        );

                        return recepientIdentityBuilder(
                          payment,
                          user.name,
                        );
                      } else {
                        return LoadingWidget();
                      }
                    },
                  )
                : Text(
                    "sender type is ${payment.senderType}",
                  );
  }

  recepientIdentityBuilder(
    Payment payment,
    String senderName,
  ) {
    return payment.recepientType == ThingType.ADMIN
        ? paymentBody(
            payment,
            prePartnerWord: null,
            paymentReason: payment.paymentReason,
            partnerName: null,
            recepient: payment.recepient,
            withdrawal: payment.withdrawal,
            image: dorxLogo,
            amount: payment.amount,
            date: payment.time,
            type: payment.thingType,
            senderName: senderName,
            recepientName: ThingType.ADMIN,
            paymentID: payment.id,
          )
        : payment.recepientType == ThingType.USER
            ? StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(UserModel.DIRECTORY)
                    .doc(payment.recepient)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null && snapshot.data.data() != null) {
                      UserModel user = UserModel.fromSnapshot(
                        snapshot.data,
                      );

                      return paymentBody(
                        payment,
                        prePartnerWord: null,
                        paymentReason: payment.paymentReason,
                        partnerName: null,
                        recepient: payment.recepient,
                        withdrawal: payment.withdrawal,
                        image: user.profilePic ?? defaultUserPic,
                        amount: payment.amount,
                        date: payment.time,
                        type: payment.thingType,
                        senderName: senderName,
                        recepientName: user.userName,
                        paymentID: payment.id,
                      );
                    } else {
                      return Text(payment.partner);
                    }
                  } else {
                    return LoadingWidget();
                  }
                },
              )
            : payment.recepientType == ThingType.RESTAURANT
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection(Restaurant.DIRECTORY)
                        .doc(payment.recepient)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Restaurant user = Restaurant.fromSnapshot(
                          snapshot.data,
                        );

                        return paymentBody(
                          payment,
                          prePartnerWord: null,
                          paymentReason: payment.paymentReason,
                          partnerName: null,
                          recepient: payment.recepient,
                          withdrawal: payment.withdrawal,
                          image: user.displayPic ?? defaultUserPic,
                          amount: payment.amount,
                          date: payment.time,
                          type: payment.thingType,
                          senderName: senderName,
                          recepientName: user.name,
                          paymentID: payment.id,
                        );
                      } else {
                        return LoadingWidget();
                      }
                    })
                : Text("recepient type is ${payment.recepientType}");
  }

  paymentBody(
    Payment payment, {
    String recepient,
    bool withdrawal,
    String image,
    dynamic amount,
    int date,
    String type,
    String senderName,
    String recepientName,
    String paymentID,
    @required String partnerName,
    @required String prePartnerWord,
    @required String paymentReason,
  }) {
    return widget.simple
        ? GestureDetector(
            onTap: () {
              UIServices().showDatSheet(
                PaymentDetailsBottomSheet(
                  payment: payment,
                  paymentID: paymentID,
                  paymentViewerID: widget.paymentViewerID,
                ),
                true,
                context,
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: getNeededColor(
                  itsMe(
                    recepient,
                    withdrawal,
                  ),
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        imageCircleAvatar(image),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                withdrawal
                                    ? "Withdrawal"
                                    : paymentReason == Payment.COMMISSION
                                        ? "Commission"
                                        : paymentReason ==
                                                Payment.TICKETPURCHASE
                                            ? "Payment for a $type ticket purchase"
                                            : paymentReason ==
                                                    Payment.COMMISSIONPAYMENT
                                                ? "Payment of Commission"
                                                : paymentReason ??
                                                    "Payment for a service",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "$prePartnerWord $partnerName"
                                    .capitalizeFirstOfEach,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "Paid Via ${payment.mode == FLUTTERWAVE ? "Mobile / Bank" : payment.mode}"
                                    .capitalizeFirstOfEach,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                DateService().getCoolTime(date),
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    TextService().putCommas(amount.toStringAsFixed(0)),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.all(
              10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${TextService().putCommas(amount.toString())} UGX",
                  style: titleStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Payment Reason: ${withdrawal ? "Withdrawal" : type == Payment.COMMISSION ? "Plot It Charges" : paymentReason == Payment.TICKETPURCHASE ? "Payment for a $type ticket purchase" : paymentReason == Payment.COMMISSIONPAYMENT ? "Payment of Commission" : paymentReason ?? "Payment for a service"}",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "$prePartnerWord $partnerName".capitalizeFirstOfEach,
                ),
                payment.partnerType == ThingType.USER
                    ? SingleUser(user: null, userID: payment.partner)
                    : SingleRestaurant(
                        selected: false,
                        selectable: false,
                        onTap: null,
                        searchedText: "]",
                        restaurant: null,
                        restaurantID: payment.partner,
                      ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Paid Via ${payment.mode == FLUTTERWAVE ? "Mobile / Bank" : payment.mode}"
                      .capitalizeFirstOfEach,
                ),
                Text(
                  DateService().getCoolTime(date),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: paymentID),
                    ).then((value) {
                      CommunicationServices().showToast(
                        "Payment ID has been copied",
                        Colors.blue,
                      );
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.copy,
                        size: 15,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          "ID: $paymentID",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  imageCircleAvatar(String image) {
    return ClipRRect(
      borderRadius: standardBorderRadius,
      child: SingleImage(
        image: image,
        width: 50,
        height: 50,
      ),
    );
  }

  Color getNeededColor(PaymentType type) {
    return type == PaymentType.withdrawal
        ? altColor.withOpacity(0.5)
        : type == PaymentType.deposit
            ? Colors.green.withOpacity(0.5)
            : Theme.of(context).canvasColor;
  }

  PaymentType itsMe(
    String uid,
    bool withdrawal,
  ) {
    return withdrawal
        ? PaymentType.withdrawal
        : uid == widget.paymentViewerID
            ? PaymentType.deposit
            : PaymentType.credit;
  }
}

enum PaymentType {
  deposit,
  credit,
  withdrawal,
}
